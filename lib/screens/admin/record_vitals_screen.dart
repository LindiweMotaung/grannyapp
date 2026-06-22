import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';

class RecordVitalsScreen extends StatefulWidget {
  const RecordVitalsScreen({super.key});

  @override
  State<RecordVitalsScreen> createState() => _RecordVitalsScreenState();
}

class _RecordVitalsScreenState extends State<RecordVitalsScreen> {
  List<Resident> _residents = [];
  List<Map<String, dynamic>> _todayVitals = [];
  bool _isLoading = true;
  int _vitalsToday = 0;
  int _needsAttention = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load residents
      final residentsResponse = await SupabaseService.client
          .from('residents')
          .select()
          .eq('status', 'active')
          .order('name');
      _residents = (residentsResponse as List)
          .map((json) => Resident.fromJson(json))
          .toList();

      // Load today's vitals
      final today = DateTime.now().toIso8601String().split('T')[0];
      final vitalsResponse = await SupabaseService.client
          .from('health_vitals')
          .select('*, residents(name, room_number)')
          .gte('recorded_at', '$today 00:00:00')
          .lte('recorded_at', '$today 23:59:59')
          .order('recorded_at', ascending: false);

      _todayVitals = List<Map<String, dynamic>>.from(vitalsResponse as List);
      _vitalsToday = _todayVitals.length;

      // Count vitals needing attention (abnormal values)
      _needsAttention = _todayVitals.where((vital) {
        final systolic = int.tryParse(vital['blood_pressure'].toString().split('/')[0]) ?? 120;
        final heartRate = vital['heart_rate'] as int;
        final temp = (vital['temperature'] as num).toDouble();
        final oxygen = vital['oxygen_level'] as int;
        
        return systolic > 140 || systolic < 90 || 
               heartRate > 100 || heartRate < 60 ||
               temp > 38.0 || temp < 36.0 ||
               oxygen < 95;
      }).length;

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _showAddVitalsDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddVitalsDialog(
        residents: _residents,
        onVitalAdded: _loadData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Vitals'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary Cards
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1FC8DB), Color(0xFF2CB5A8)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Vitals Recorded Today',
                          _vitalsToday.toString(),
                          Icons.favorite,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Needs Attention',
                          _needsAttention.toString(),
                          Icons.warning,
                          _needsAttention > 0 ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Today's Vitals List
                Expanded(
                  child: _todayVitals.isEmpty
                      ? const Center(
                          child: Text(
                            'No vitals recorded today',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _todayVitals.length,
                          itemBuilder: (context, index) {
                            final vital = _todayVitals[index];
                            final residentName = vital['residents']?['name'] ?? 'Unknown';
                            final roomNumber = vital['residents']?['room_number'] ?? '-';
                            return _buildVitalCard(vital, residentName, roomNumber);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVitalsDialog,
        backgroundColor: const Color(0xFF2CB5A8),
        icon: const Icon(Icons.add),
        label: const Text('Add Vitals'),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(Map<String, dynamic> vital, String name, String room) {
    final bp = vital['blood_pressure'];
    final hr = vital['heart_rate'];
    final oxygen = vital['oxygen_level'];
    final time = DateTime.parse(vital['recorded_at']).toLocal();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1FC8DB),
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Room $room • ${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('BP: $bp', style: const TextStyle(fontSize: 12)),
            Text('HR: $hr | O₂: $oxygen%', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _AddVitalsDialog extends StatefulWidget {
  final List<Resident> residents;
  final VoidCallback onVitalAdded;

  const _AddVitalsDialog({
    required this.residents,
    required this.onVitalAdded,
  });

  @override
  State<_AddVitalsDialog> createState() => _AddVitalsDialogState();
}

class _AddVitalsDialogState extends State<_AddVitalsDialog> {
  final _formKey = GlobalKey<FormState>();
  Resident? _selectedResident;
  String _systolic = '120';
  String _diastolic = '80';
  String _heartRate = '75';
  String _temperature = '36.5';
  String _oxygenLevel = '98';
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1FC8DB), Color(0xFF2CB5A8)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Record Vital Signs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Resident Selection
                      DropdownButtonFormField<Resident>(
                        initialValue: _selectedResident,
                        decoration: const InputDecoration(
                          labelText: 'Select Resident',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: widget.residents.map((resident) {
                          return DropdownMenuItem(
                            value: resident,
                            child: Text('${resident.name} - Room ${resident.roomNumber}'),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedResident = value),
                        validator: (value) => value == null ? 'Please select a resident' : null,
                      ),
                      const SizedBox(height: 20),

                      // Blood Pressure
                      const Text(
                        'Blood Pressure (mmHg)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _systolic,
                              decoration: const InputDecoration(
                                labelText: 'Systolic',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(81, (i) => (90 + i).toString())
                                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                                  .toList(),
                              onChanged: (value) => setState(() => _systolic = value!),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('/', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _diastolic,
                              decoration: const InputDecoration(
                                labelText: 'Diastolic',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(61, (i) => (60 + i).toString())
                                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                                  .toList(),
                              onChanged: (value) => setState(() => _diastolic = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Heart Rate
                      DropdownButtonFormField<String>(
                        initialValue: _heartRate,
                        decoration: const InputDecoration(
                          labelText: 'Heart Rate (bpm)',
                          prefixIcon: Icon(Icons.favorite),
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(141, (i) => (40 + i).toString())
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (value) => setState(() => _heartRate = value!),
                      ),
                      const SizedBox(height: 16),

                      // Temperature
                      DropdownButtonFormField<String>(
                        initialValue: _temperature,
                        decoration: const InputDecoration(
                          labelText: 'Temperature (°C)',
                          prefixIcon: Icon(Icons.thermostat),
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(61, (i) => (35.0 + (i * 0.1)).toStringAsFixed(1))
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (value) => setState(() => _temperature = value!),
                      ),
                      const SizedBox(height: 16),

                      // Oxygen Level
                      DropdownButtonFormField<String>(
                        initialValue: _oxygenLevel,
                        decoration: const InputDecoration(
                          labelText: 'Oxygen Level (%)',
                          prefixIcon: Icon(Icons.air),
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(26, (i) => (75 + i).toString())
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (value) => setState(() => _oxygenLevel = value!),
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveVital,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2CB5A8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Vitals'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveVital() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await SupabaseService.client.from('health_vitals').insert({
        'resident_id': _selectedResident!.id,
        'blood_pressure': '$_systolic/$_diastolic',
        'heart_rate': int.parse(_heartRate),
        'temperature': double.parse(_temperature),
        'oxygen_level': int.parse(_oxygenLevel),
        'notes': _notesController.text.trim(),
        'recorded_by': 'Dr. Lindiwe Motaung',
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vital signs recorded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onVitalAdded();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
