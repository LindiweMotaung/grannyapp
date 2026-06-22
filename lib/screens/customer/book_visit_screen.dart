import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';
import 'package:intl/intl.dart';

class BookVisitScreen extends StatefulWidget {
  const BookVisitScreen({super.key});

  @override
  State<BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<BookVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Resident> _residents = [];
  Resident? _selectedResident;
  final _visitorNameController = TextEditingController();
  final _visitorPhoneController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  bool _isLoadingResidents = true;

  @override
  void initState() {
    super.initState();
    _loadResidents();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = SupabaseService.currentUser;
    if (user != null) {
      _visitorNameController.text = user.userMetadata?['full_name'] ?? '';
      _visitorPhoneController.text = user.userMetadata?['phone'] ?? '';
    }
  }

  Future<void> _loadResidents() async {
    try {
      final response = await SupabaseService.client
          .from('residents')
          .select()
          .eq('status', 'active')
          .order('name');
      
      setState(() {
        _residents = (response as List)
            .map((json) => Resident.fromJson(json))
            .toList();
        _isLoadingResidents = false;
      });
    } catch (e) {
      setState(() => _isLoadingResidents = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading residents: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookVisit() async {
    if (!_formKey.currentState!.validate() || _selectedResident == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a resident')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'resident_id': _selectedResident!.id,
        'resident_name': _selectedResident!.name,
        'visitor_name': _visitorNameController.text,
        'visitor_phone': _visitorPhoneController.text,
        'visit_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'visit_time': '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        'purpose': _purposeController.text,
        'status': 'pending',
      };

      await SupabaseService.client.from('visits').insert(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visit booked successfully! Awaiting approval.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking visit: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Visit'),
      ),
      body: _isLoadingResidents
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Schedule Your Visit',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Select Resident
                        DropdownButtonFormField<Resident>(
                          initialValue: _selectedResident,
                      decoration: const InputDecoration(
                        labelText: 'Select Resident',
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: _residents.map((resident) {
                        return DropdownMenuItem(
                          value: resident,
                          child: Text('${resident.name} - Room ${resident.roomNumber}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedResident = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a resident';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Visitor Name
                    TextFormField(
                      controller: _visitorNameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Visitor Phone
                    TextFormField(
                      controller: _visitorPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Your Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Date Picker
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Visit Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Time Picker
                    InkWell(
                      onTap: _selectTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Visit Time',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Purpose
                    TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose of Visit',
                        prefixIcon: Icon(Icons.notes),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the purpose of visit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Book Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _bookVisit,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          _isLoading ? 'Booking...' : 'Book Visit',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Info Card
                    Card(
                      color: Colors.blue.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your visit request will be reviewed by our staff. You will receive confirmation shortly.',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _visitorNameController.dispose();
    _visitorPhoneController.dispose();
    _purposeController.dispose();
    super.dispose();
  }
}
