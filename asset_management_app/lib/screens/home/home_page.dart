import 'package:asset_management_app/screens/asset/asset_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> assets = [
    {
      'name': 'MacBook Pro 16"',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Dell Ultrasharp Monitor',
      'image':
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Ergonomic Office Chair',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Mechanical Keyboard',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Wireless Mouse',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'HP Laser Printer',
      'image':
          'https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Noise-Cancelling Headphones',
      'image':
          'https://images.unsplash.com/photo-1593642532973-d31b6557fa68?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Projector',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Server Rack',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'WiFi Router',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    },
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call backend here in future
    _loadAssets();
  }

  // Simulate API call
  Future<void> _loadAssets() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate delay

    // When backend is ready, fetch real data here
    // final response = await Dio().get("${ApiConfig.baseUrl}/assets");
    // assets = response.data;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        // title: const Text("Assets"),
        backgroundColor: Colors.transparent,
        // elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadAssets,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
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
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8, // adjust card height
                ),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return _AssetCard(
                    name: asset['name']!,
                    image: asset['image']!,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A5CFF),
        onPressed: () {
          // TODO: navigate to Add Asset screen
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _AssetCard extends StatefulWidget {
  final String name;
  final String image;

  const _AssetCard({required this.name, required this.image, super.key});

  @override
  State<_AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<_AssetCard> {
  bool isSaved = false; // track save state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AssetPage(name: widget.name, image: widget.image),
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
              blurRadius: 12,
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
                  // Asset image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Save icon
                  Positioned(
                    top: 8,
                    right: 0,
                    child: Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.black.withOpacity(0.5),
                      //   shape: BoxShape.circle,
                      // ),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved
                              ? const Color.fromARGB(255, 238, 4, 4)
                              : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isSaved = !isSaved;
                          });
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
