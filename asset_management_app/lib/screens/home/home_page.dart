import 'package:asset_management_app/screens/asset/add_asset_pasge.dart';
import 'package:asset_management_app/screens/asset/asset_page.dart';
import 'package:asset_management_app/services/asset_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> assets = [];
  final AssetService assetService = AssetService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  Future<void> loadAssets() async {
    setState(() => isLoading = true);

    final data = await assetService.fetchAssets();

    setState(() {
      assets = data;
      isLoading = false;
    });
  }

  Future<void> confirmDelete(int index) async {
    final asset = assets[index];
    final int id = asset['id'];
    final bool newStatus = !asset['isActive'];

    final success = await assetService.assetDeleteToggle(
      id: id,
      isActive: newStatus,
    );

    if (success) {
      await loadAssets();
      setState(() {
        assets[index]['isActive'] = newStatus;
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

  Future<void> saveToggle(int index) async {
    final category = assets[index];
    final int id = category['id'];
    final bool newStatus = !category['isSaved'];

    final success = await assetService.assetSaveToggle(
      id: id,
      isSaved: newStatus,
    );

    if (success) {
      setState(() {
        assets[index]['isSaved'] = newStatus;
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
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = assetService.baseUrl;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: loadAssets,
          icon: const Icon(Icons.refresh),
          tooltip: 'Reload',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddAssetPage()),
              ).then((_) {
                loadAssets();
              });
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Asset',
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return _AssetCard(
                    id: asset['id'],
                    name: asset['name'] ?? "Unknown",
                    imageUrl: asset['imageUrl'],
                    isSaved: asset['isSaved'],
                    description: asset['description'],
                    baseUrl: baseUrl,
                    onDelete: (id) => confirmDelete(index),
                    onSave: (id, newStatus) => saveToggle(index),
                  );
                },
              ),
            ),
    );
  }
}

class _AssetCard extends StatefulWidget {
  final int id;
  final String name;
  final String? imageUrl;
  final String baseUrl;
  final bool isSaved;
  final String description;
  final Function(int id) onDelete;
  final Function(int id, bool newStatus) onSave;

  const _AssetCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.baseUrl,
    required this.isSaved,
    required this.onDelete,
    required this.onSave,
    required this.description,
    super.key,
  });

  @override
  State<_AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<_AssetCard> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
  }

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
            colors: [Color(0xFF1B254A), Color(0xFF2A3F7A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
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

                  // DELETE BUTTON
                  Positioned(
                    top: 8,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onDelete(widget.id),
                    ),
                  ),

                  // SAVE BUTTON
                  Positioned(
                    top: 8,
                    right: 0,
                    child: GestureDetector(
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark_border : Icons.bookmark,
                          color: isSaved ? Colors.white : Colors.red,
                        ),
                        onPressed: () {
                          final newStatus = !isSaved;
                          setState(() => isSaved = newStatus);
                          widget.onSave(widget.id, newStatus);
                        },
                      ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
