import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:untitled2/auth/widgets/form_helpers.dart'; // Using the reusable styled widgets
import 'package:untitled2/utils/snackbar_helper.dart';   // Using the reusable styled snackbar

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

=======
import 'package:untitled2/auth/widgets/form_helpers.dart'; // Use the styled widgets
import 'package:untitled2/utils/snackbar_helper.dart';   // Use the styled snackbar

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});
>>>>>>> upstream/main
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
<<<<<<< HEAD
  // Controllers for text input
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  // State variables for dropdown and toggles
  final List<String> _categories = ['Appetizer', 'Main Course', 'Sides', 'Dessert', 'Beverages'];
  String? _selectedCategory;
  bool _isVegetarian = false; // Default to non-vegetarian
  bool _isLoading = false;
  
  // Placeholder for the image file. In a real app, this would be a File object.
  var _imageFile;

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Placeholder function for the UI task. The logic developer will implement this.
  void _pickImage() {
    setState(() {
      _imageFile = 'dummy_path/image.jpg'; // Simulate picking an image
    });
    showCustomSnackBar(context, message: 'Image selected (UI only)');
    print('UI: "Pick image from gallery" button pressed.');
  }

  // Placeholder function for the UI task. The logic developer will implement this.
  void _saveMenuItem() {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();

    // Basic validation
    if (name.isEmpty || price.isEmpty || _selectedCategory == null) {
      showCustomSnackBar(context, message: 'Please fill out all required fields.', isError: true);
=======
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  final List<String> _categories = ['Appetizers', 'Main Course', 'Sides', 'Desserts', 'Beverages'];
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  var _imageFile; // Using 'var' for now as a placeholder

void _pickImage() {
  // This is a placeholder. The other dev will implement this.
  setState(() {
    _imageFile = 'dummy_path/image.jpg'; // Simulate picking an image
  });
  print('UI: Pick image from gallery pressed.');
}

  void _saveMenuItem() {
    // Placeholder logic for UI task. The other dev will add Firebase logic.
    final name = _nameController.text;
    if (name.isEmpty || _selectedCategory == null) {
      showCustomSnackBar(context, message: 'Please enter a name and select a category.', isError: true);
>>>>>>> upstream/main
      return;
    }

    setState(() => _isLoading = true);
<<<<<<< HEAD
    // Simulate a network call to make the loading indicator visible
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // This print statement is for the logic developer to see what data is available
        print('--- UI Handoff: Saving Menu Item ---');
        print('Name: $name');
        print('Description: ${_descriptionController.text.trim()}');
        print('Price: $price');
        print('Category: $_selectedCategory');
        print('Is Vegetarian: $_isVegetarian');
        print('Image File Path (Placeholder): $_imageFile');
        print('------------------------------------');

        showCustomSnackBar(context, message: '"$name" created (UI only)');
=======
    // Simulate a network call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        print('UI: "Save Menu Item" button pressed for item: $name');
        showCustomSnackBar(context, message: '$name created (UI only)');
>>>>>>> upstream/main
        Navigator.of(context).pop();
      }
    });
  }
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Menu Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Section ---
            Text('Display Image', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _imageFile == null
                    ? const Text('No image selected.')
                    // In a real app, this would use Image.file() to show a preview
                    : const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose from Gallery'),
              onPressed: _pickImage,
            ),
            const Divider(height: 32, thickness: 1),

            // --- Details Section ---
            Text('Dish Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
=======
  

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Add New Menu Item')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 9. NEW IMAGE UPLOAD SECTION ---
          const Text('Display Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _imageFile == null
                  ? const Text('No image selected.')
                  // In a real app, you'd use Image.file(_imageFile)
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Upload from Gallery'),
            onPressed: _pickImage,
          ),
          const Divider(height: 32, thickness: 1),

          const Text('Dish Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
            
            // Use the styled MyTextField from form_helpers.dart
>>>>>>> upstream/main
            MyTextField(controller: _nameController, hintText: 'Dish Name (e.g., "Classic Burger")', obscureText: false),
            const SizedBox(height: 16),
            MyTextField(controller: _descriptionController, hintText: 'A short, tasty description', obscureText: false),
            const SizedBox(height: 16),
<<<<<<< HEAD
            MyTextField(controller: _priceController, hintText: 'Price (e.g., 899.00)', obscureText: false, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 16),
=======
            MyTextField(controller: _priceController, hintText: 'Price (e.g., 10.99)', obscureText: false, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 20),

            Text('Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Use a styled DropdownButton
>>>>>>> upstream/main
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('Select a Category'),
              items: _categories.map((String category) {
<<<<<<< HEAD
                return DropdownMenuItem<String>(value: category, child: Text(category));
=======
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
>>>>>>> upstream/main
              }).toList(),
              onChanged: (String? newValue) => setState(() => _selectedCategory = newValue),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
<<<<<<< HEAD
            const SizedBox(height: 16),
            
            // --- Vegetarian Toggle ---
            SwitchListTile(
              title: const Text('Is this a vegetarian dish?'),
              secondary: Icon(Icons.eco_rounded, color: _isVegetarian ? Colors.green : Colors.grey),
              value: _isVegetarian,
              onChanged: (bool value) => setState(() => _isVegetarian = value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.green, 
            ),
            
            const SizedBox(height: 32),
            
            // --- Save Button ---
=======
            const SizedBox(height: 20),

            Text('Display Image', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            MyTextField(controller: _imageUrlController, hintText: 'Image URL (optional)', obscureText: false),
            
            const SizedBox(height: 32),
            
            // Use the styled MyButton which handles the loading state
>>>>>>> upstream/main
            MyButton(
              onTap: _saveMenuItem,
              text: 'Save Menu Item',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}