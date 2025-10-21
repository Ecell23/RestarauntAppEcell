import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart' as app_user;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  /// Sends or resends an OTP. Throws a FirebaseAuthException on failure.
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    int? forceResendingToken, // <-- ADD THIS OPTIONAL PARAMETER
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken, // <-- USE THE PARAMETER HERE
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      // IMPORTANT: The callback signature is updated
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Verifies the OTP. Completes successfully or throws a FirebaseAuthException on failure.
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
    // REMOVED: required BuildContext context,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _createUserDocumentIfNotExists(userCredential.user!);
        // NEW LOGIC: No need to return true. If it gets here, it succeeded.
      } else {
        // NEW LOGIC: Throw an error if the user is somehow null after sign-in.
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'The signed-in user could not be found.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // NEW LOGIC: Re-throw the exception so the UI layer can catch it.
      throw e;
    }
  }

  /// Helper function to create a user document in Firestore after first sign-in.
  Future<void> _createUserDocumentIfNotExists(User user) async {
    final userDocRef = _firestore.collection('admins').doc(user.uid);
    final doc = await userDocRef.get();

    if (!doc.exists) {
      final newUser = app_user.UserModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber!,
        createdAt: firestore.Timestamp.now(),
      );
      await userDocRef.set(newUser.toMap());
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Gets the current authenticated user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}