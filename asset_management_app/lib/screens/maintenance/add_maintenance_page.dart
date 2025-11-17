import 'package:asset_management_app/services/maintenance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMaintenancePage extends StatefulWidget {
  final int assetId;
  const AddMaintenancePage({super.key, required this.assetId});

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _performedByController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _maintenanceTypeController =
      TextEditingController();

  DateTime? _selectedDate;
  bool isLoading = false;

  final MaintenanceService maintenanceService = MaintenanceService();

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a date")));
      return;
    }

    final performed_by = _performedByController.text.trim();
    final notes = _notesController.text.trim();
    final maintenance_type = _maintenanceTypeController.text.trim();
    final date = _selectedDate!;
    final id = widget.assetId;

    setState(() => isLoading = true);

    final success = await maintenanceService.addMaintenance(
      maintenance_type: maintenance_type,
      performed_by: performed_by,
      notes: notes,
      date: date,
      assetId: id,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maintenance added successfully!")),
      );

      _performedByController.clear();
      _notesController.clear();
      _maintenanceTypeController.clear();

      setState(() {
        _selectedDate = null;
        isLoading = false;
      });
      return;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add Maintenance")));
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6A5CFF),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
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
        title: const Text(
          "Add Maintenance",
          style: TextStyle(
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Maintenance Type ---
              _buildInputField(
                label: "Maintenance Type",
                hint: "e.g. Oil Change",
                controller: _maintenanceTypeController,
              ),
              const SizedBox(height: 20),

              // --- Performed By ---
              _buildInputField(
                label: "Performed By",
                hint: "Enter technician name",
                controller: _performedByController,
              ),
              const SizedBox(height: 20),

              // --- Notes ---
              _buildInputField(
                label: "Notes",
                hint: "Enter maintenance details",
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // --- Date Picker ---
              const Text(
                "Maintenance Date",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2556),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? "Select Date"
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Submit Button ---
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5CFF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    shadowColor: Colors.blueAccent.withOpacity(0.4),
                  ),
                  onPressed: submitForm,
                  child: const Text(
                    "Save Maintenance",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Custom styled input widget
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter $label" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF1E2556),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF6A5CFF), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
