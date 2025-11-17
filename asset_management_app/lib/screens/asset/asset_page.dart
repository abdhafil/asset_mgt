import 'package:asset_management_app/main.dart';
import 'package:asset_management_app/screens/maintenance/add_maintenance_page.dart';
import 'package:asset_management_app/services/maintenance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetPage extends StatefulWidget {
  final int assetId;
  final String name;
  final String image;
  final String description;
  final String baseUrl;

  const AssetPage({
    super.key,
    required this.assetId,
    required this.name,
    required this.description,
    required this.image,
    required this.baseUrl,
  });

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final MaintenanceService maintenanceService = MaintenanceService();
  List<Map<String, dynamic>> maintenanceList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadMaintenance();
  }

  Future<void> loadMaintenance() async {
    setState(() => isLoading = true);

    final data = await maintenanceService.fetchMaintenance(
      assetId: widget.assetId,
    );

    setState(() {
      maintenanceList = data;
      isLoading = false;
    });
  }

  Future<void> deleteManitenance(int index) async {
    final maintenance = maintenanceList[index];
    final int id = maintenance['id'];
    final bool newStatus = !maintenance['isActive'];

    final success = await maintenanceService.maintenanceDeleteToggle(
      id: id,
      isActive: newStatus,
    );

    if (success) {
      await loadMaintenance();
      setState(() {
        maintenanceList[index]['isActive'] = newStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ' Maintenance:-"${maintenance['maintenance_type']}" is deleted',
          ),
        ),
      );
    }
  }

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
                child: Image.network(
                  "${widget.baseUrl}${widget.image}",
                  fit: BoxFit.contain,
                ),
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
              child: Text(
                widget.description,
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
                                    "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date']))}",
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
                                deleteManitenance(index);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6A5CFF),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMaintenancePage(assetId: widget.assetId),
            ),
          ).then((_) {
            loadMaintenance();
          });
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
