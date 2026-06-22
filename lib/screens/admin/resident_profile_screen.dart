import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';

class ResidentProfileScreen extends StatefulWidget {
  final Resident resident;
  final VoidCallback onUpdate;

  const ResidentProfileScreen({
    super.key,
    required this.resident,
    required this.onUpdate,
  });

  @override
  State<ResidentProfileScreen> createState() => _ResidentProfileScreenState();
}

class _ResidentProfileScreenState extends State<ResidentProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _roomController;
  late TextEditingController _medicalController;
  late TextEditingController _allergiesController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _admissionDateController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.resident.name);
    _ageController = TextEditingController(
      text: widget.resident.age.toString(),
    );
    _genderController = TextEditingController(text: widget.resident.gender);
    _bloodGroupController = TextEditingController(text: widget.resident.bloodGroup ?? '');
    _roomController = TextEditingController(text: widget.resident.roomNumber);
    _medicalController = TextEditingController(
      text: widget.resident.medicalConditions,
    );
    _allergiesController = TextEditingController(text: widget.resident.allergies ?? '');
    _emergencyContactController = TextEditingController(
      text: widget.resident.emergencyContact,
    );
    _emergencyPhoneController = TextEditingController(
      text: widget.resident.emergencyPhone,
    );
    _admissionDateController = TextEditingController(
      text: widget.resident.admissionDate,
    );
    _statusController = TextEditingController(text: widget.resident.status);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await SupabaseService.client
          .from('residents')
          .update({
            'name': _nameController.text.trim(),
            'age': int.tryParse(_ageController.text) ?? 0,
            'gender': _genderController.text.trim(),
            'blood_group': _bloodGroupController.text.trim().isEmpty ? null : _bloodGroupController.text.trim(),
            'room_number': _roomController.text.trim(),
            'medical_conditions': _medicalController.text.trim(),
            'allergies': _allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim(),
            'emergency_contact': _emergencyContactController.text.trim(),
            'emergency_phone': _emergencyPhoneController.text.trim(),
            'admission_date': _admissionDateController.text.trim(),
            'status': _statusController.text.trim(),
          })
          .eq('id', widget.resident.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resident updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
        });
        widget.onUpdate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating resident: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteResident() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resident'),
        content: Text(
          'Are you sure you want to delete ${widget.resident.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SupabaseService.client
            .from('residents')
            .delete()
            .eq('id', widget.resident.id);

        if (mounted) {
          widget.onUpdate();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resident deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting resident: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Resident' : 'Resident Profile'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit',
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteResident,
              tooltip: 'Delete',
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
              tooltip: 'Cancel',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card with Avatar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1FC8DB), Color(0xFF2CB5A8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.resident.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1FC8DB),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.resident.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.resident.status == 'active'
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.resident.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),

                    // Age
                    _buildTextField(
                      label: 'Age',
                      controller: _ageController,
                      icon: Icons.cake,
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    // Gender
                    _buildTextField(
                      label: 'Gender',
                      controller: _genderController,
                      icon: Icons.wc,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter gender';
                        }
                        return null;
                      },
                    ),

                    // Blood Group
                    _buildTextField(
                      label: 'Blood Group (Optional)',
                      controller: _bloodGroupController,
                      icon: Icons.bloodtype,
                      enabled: _isEditing,
                      helperText: 'e.g., A+, O-, AB+',
                    ),

                    // Room Number
                    _buildTextField(
                      label: 'Room Number',
                      controller: _roomController,
                      icon: Icons.door_front_door,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter room number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Medical Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medical Conditions
                    _buildTextField(
                      label: 'Medical Conditions (Optional)',
                      controller: _medicalController,
                      icon: Icons.medical_services,
                      enabled: _isEditing,
                      maxLines: 3,
                      helperText: 'List any medical conditions or diagnoses',
                    ),

                    // Allergies
                    _buildTextField(
                      label: 'Allergies (Optional)',
                      controller: _allergiesController,
                      icon: Icons.warning_amber,
                      enabled: _isEditing,
                      maxLines: 2,
                      helperText: 'List any known allergies',
                    ),

                    // Admission Date
                    _buildTextField(
                      label: 'Admission Date',
                      controller: _admissionDateController,
                      icon: Icons.calendar_today,
                      enabled: _isEditing,
                      helperText: 'Format: YYYY-MM-DD',
                      onTap: _isEditing ? () => _selectDate(context) : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter admission date';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact Name
                    _buildTextField(
                      label: 'Emergency Contact Name',
                      controller: _emergencyContactController,
                      icon: Icons.contact_emergency,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter emergency contact';
                        }
                        return null;
                      },
                    ),

                    // Emergency Phone
                    _buildTextField(
                      label: 'Emergency Phone',
                      controller: _emergencyPhoneController,
                      icon: Icons.phone,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter emergency phone';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status
                    _isEditing
                        ? DropdownButtonFormField<String>(
                            initialValue: _statusController.text,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              prefixIcon: const Icon(Icons.info),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'active',
                                child: Text('Active'),
                              ),
                              DropdownMenuItem(
                                value: 'inactive',
                                child: Text('Inactive'),
                              ),
                              DropdownMenuItem(
                                value: 'discharged',
                                child: Text('Discharged'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _statusController.text = value);
                              }
                            },
                          )
                        : _buildTextField(
                            label: 'Status',
                            controller: _statusController,
                            icon: Icons.info,
                            enabled: false,
                          ),

                    if (_isEditing) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2CB5A8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? helperText,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        readOnly: onTap != null,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey.shade100,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        style: TextStyle(color: enabled ? Colors.black87 : Colors.black54),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _admissionDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _roomController.dispose();
    _medicalController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _admissionDateController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
