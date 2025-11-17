import 'package:asset_management_app/screens/asset/asset_page.dart';
import 'package:asset_management_app/services/asset_service.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final AssetService assetService = AssetService();
  bool isLoading = false;

  List<Map<String, dynamic>> savedAssets = [];

  @override
  void initState() {
    super.initState();
    loadSavedAssets();
  }

  Future<void> loadSavedAssets() async {
    setState(() => isLoading = true);
    final data = await assetService.fetchSavedAssets();
    setState(() {
      savedAssets = data;
      isLoading = false;
    });
  }

  Future<void> confirmDelete(int index) async {
    final asset = savedAssets[index];
    final int id = asset['id'];
    final bool newStatus = !asset['isActive'];

    final success = await assetService.assetDeleteToggle(
      id: id,
      isActive: newStatus,
    );

    if (success) {
      await loadSavedAssets();
      setState(() {
        savedAssets[index]['isActive'] = newStatus;
      });

      final status = newStatus ? "activated" : "deactivated";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('asset "${asset['name']}" $status')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update category")),
      );
    }
  }

  Future<void> removeSaved(int index) async {
    final category = savedAssets[index];
    final int id = category['id'];
    final bool newStatus = !category['isSaved'];

    final success = await assetService.assetSaveToggle(
      id: id,
      isSaved: newStatus,
    );

    if (success) {
      setState(() {
        savedAssets[index]['isSaved'] = newStatus;
      });

      final status = newStatus ? "Unsaved" : "Saved";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category "${category['name']}" $status')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add asset to saved")),
      );
    }
    loadSavedAssets();
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = assetService.baseUrl;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        title: const Text(
          "Saved Assets",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: savedAssets.isEmpty
          ? const Center(
              child: Text(
                "No saved assets yet.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: savedAssets.length,
                itemBuilder: (context, index) {
                  final asset = savedAssets[index];
                  return _SavedAssetCard(
                    id: asset['id'],
                    name: asset['name'] ?? "Unknown",
                    imageUrl: asset['imageUrl'],
                    isSaved: asset['isSaved'],
                    description: asset['description'],
                    baseUrl: baseUrl,
                    onDelete: (id) => confirmDelete(index),
                    onRemove: (id) => removeSaved(index),
                    onReload: () => loadSavedAssets(),
                  );
                },
              ),
            ),
    );
  }
}

class _SavedAssetCard extends StatefulWidget {
  final int id;
  final String name;
  final String? imageUrl;
  final String baseUrl;
  final bool isSaved;
  final String description;
  final Function(int id) onDelete;
  final Function(int id) onRemove;
  final Function() onReload;

  const _SavedAssetCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.baseUrl,
    required this.isSaved,
    required this.onDelete,
    required this.onRemove,
    required this.onReload,
    required this.description,
    super.key,
  });

  @override
  State<_SavedAssetCard> createState() => _SavedAssetCardState();
}

class _SavedAssetCardState extends State<_SavedAssetCard> {
  @override
  Widget build(BuildContext context) {
    final String? imageUrl = widget.imageUrl;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AssetPage(
              name: widget.name,
              image: widget.imageUrl ?? "",
              description: widget.description,
              baseUrl: widget.baseUrl,
              assetId: widget.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B254A), Color(0xFF2A3F7A)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // Asset Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: (imageUrl == null || imageUrl.isEmpty)
                        ? Image.asset(
                            "assets/images/insert-picture-icon.png",
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "${widget.baseUrl}$imageUrl",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),

                  Positioned(
                    top: 8,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onDelete(widget.id),
                    ),
                  ),

                  // Remove Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.red),
                      onPressed: () => widget.onRemove(widget.id),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
