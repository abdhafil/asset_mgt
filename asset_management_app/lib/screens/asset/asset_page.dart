import 'package:asset_management_app/screens/maintenance/add_maintenance_page.dart';
import 'package:flutter/material.dart';

class AssetPage extends StatefulWidget {
  final String name;
  final String image;

  const AssetPage({super.key, required this.name, required this.image});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  List<Map<String, String>> maintenanceList = [
    {
      'maintenance_type': 'Oil Change',
      'date': '2025-10-20',
      'performed_by': 'Hafil',
      'notes': 'Performed oil change and basic service check.',
    },
    {
      'maintenance_type': 'Tire Replacement',
      'date': '2025-10-21',
      'performed_by': 'Hafil',
      'notes': 'Replaced both rear tires and checked alignment.',
    },
    {
      'maintenance_type': 'Battery Check',
      'date': '2025-10-22',
      'performed_by': 'Hafil',
      'notes': 'Battery condition good; terminals cleaned.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1227),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ✅ Scrollable body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Asset Image ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B254A), Color(0xFF2A3F7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 3,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(widget.image, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 24),

            // --- Description ---
            const Text(
              "Description",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2556),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "The LR01 uses the same design as the most iconic lines from PEUGEOT Cycles’ 130-year history and combines it with agile, dynamic performance. "
                "It’s ideal for city use, with a lightweight aluminum frame and a 16-speed Shimano Claris drivetrain.",
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- Maintenance Details ---
            const Text(
              "Maintenance Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            maintenanceList.isEmpty
                ? const Center(
                    child: Text(
                      "No maintenance records available.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : Column(
                    children: maintenanceList.map((item) {
                      int index = maintenanceList.indexOf(item);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2556),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['maintenance_type']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Date: ${item['date']!}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "Performed by: ${item['performed_by']!}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "Notes: ${item['notes']!}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  maintenanceList.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${item['maintenance_type']} deleted",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 100), // spacing so button doesn't overlap
          ],
        ),
      ),

      // ✅ Floating button stays fixed
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6A5CFF),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMaintenancePage()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Maintenance",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
