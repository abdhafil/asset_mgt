import 'dart:io';
import 'package:asset_management_app/services/asset_service.dart';
import 'package:asset_management_app/services/category_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int? _selectedCategoryId;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final CategoryServices _categoryServices = CategoryServices();
  final AssetService _assetService = AssetService();

  List<Map<String, dynamic>> _categories = [];

  Future<void> loadCategories() async {
    final data = await _categoryServices.fetchActiveCategory();
    setState(() {
      _categories = data;
    });
  }

  Future<void> _addAsset() async {
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty ||
        location.isEmpty ||
        description.isEmpty ||
        _selectedCategoryId == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields & pick an image")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await _assetService.addAsset(
      name: name,
      location: location,
      description: description,
      categoryId: _selectedCategoryId!,
      imageFile: _selectedImage!,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asset added successfully!")),
      );

      // Clear inputs
      _nameController.clear();
      _locationController.clear();
      _descriptionController.clear();

      setState(() {
        _selectedCategoryId = null;
        _selectedImage = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add Asset")));
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

 
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        title: const Text("Add Asset", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1B254A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Asset",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              // Name
              _buildTextField("Asset Name", _nameController),
              const SizedBox(height: 12),

              // Location
              _buildTextField("Location", _locationController),
              const SizedBox(height: 12),

              // 🖼️ Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3F7A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, color: Colors.white54, size: 40),
                            SizedBox(height: 8),
                            Text(
                              "Browse Image",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              _buildTextField(
                "Description",
                _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                dropdownColor: const Color(0xFF2A3F7A),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A3F7A),
                  hintText: "Select Category",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['id'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5CFF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addAsset,
                  child: const Text(
                    "Add Asset",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable TextField
  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: const Color(0xFF2A3F7A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
