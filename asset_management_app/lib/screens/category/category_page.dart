import 'package:asset_management_app/services/category_services.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _categoryController = TextEditingController();

  final CategoryServices _categoryServices = CategoryServices();
  bool _isLoading = false;

  List<Map<String, dynamic>> _categories = [];

  Future<void> _addCategory() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    final success = await _categoryServices.addCategory(name: name);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Category added successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add category")));
    }
  }

  Future<void> loadCategories() async {
    final data = await _categoryServices.fetchAllCategory();
    setState(() {
      _categories = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> _toggleCategory(int index) async {
    final category = _categories[index];
    final int id = category['id'];
    final bool newStatus = !category['isActive'];

    // 👉 Update backend first
    final success = await _categoryServices.categoryToggle(
      id: id,
      isActive: newStatus,
    );

    if (success) {
      // 👉 Update UI only if backend succeeds
      setState(() {
        _categories[index]['isActive'] = newStatus;
      });

      final status = newStatus ? "activated" : "deactivated";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category "${category['name']}" $status')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update category")),
      );
    }
  }

  Future<void> _confirmDelete(int index) async {
    final category = _categories[index];
    final int id = category['id'];

    final success = await _categoryServices.categoryDelete(id: id);

    if (success) {
      setState(() {
        _categories.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "${category['name']}" deleted successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete category")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        title: const Text("Categories", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Category Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B254A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add Category",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _categoryController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter category name",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2A3F7A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5CFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _addCategory,
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // View All Categories
            const Text(
              "All Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _categories.isEmpty
                  ? const Center(
                      child: Text(
                        "No categories added yet.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final bool isActive = category['isActive'];

                        return Card(
                          color: const Color(0xFF1B254A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              category['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Delete button
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),

                                  onPressed: () => _confirmDelete(index),
                                ),
                                Switch(
                                  activeColor: const Color(0xFF6A5CFF),
                                  inactiveThumbColor: Colors.grey,
                                  value: isActive,
                                  onChanged: (value) => _toggleCategory(index),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                color: isActive
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
