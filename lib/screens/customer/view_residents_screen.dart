import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';

class ViewResidentsScreen extends StatefulWidget {
  const ViewResidentsScreen({super.key});

  @override
  State<ViewResidentsScreen> createState() => _ViewResidentsScreenState();
}

class _ViewResidentsScreenState extends State<ViewResidentsScreen> {
  List<Resident> _residents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading residents: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Residents'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _residents.isEmpty
              ? const Center(child: Text('No residents currently'))
              : RefreshIndicator(
                  onRefresh: _loadResidents,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _residents.length,
                    itemBuilder: (context, index) {
                      final resident = _residents[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text(
                              resident.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            resident.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Room ${resident.roomNumber} • Age ${resident.age}',
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('Gender', resident.gender),
                                  _buildInfoRow('Room', resident.roomNumber),
                                  _buildInfoRow('Age', '${resident.age} years'),
                                  _buildInfoRow('Emergency Contact', resident.emergencyContact),
                                  _buildInfoRow('Emergency Phone', resident.emergencyPhone),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Medical Conditions:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(resident.medicalConditions),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
