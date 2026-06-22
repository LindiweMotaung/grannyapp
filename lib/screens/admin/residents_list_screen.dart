import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';
import 'resident_profile_screen.dart';

class ResidentsListScreen extends StatefulWidget {
  const ResidentsListScreen({super.key});

  @override
  State<ResidentsListScreen> createState() => _ResidentsListScreenState();
}

class _ResidentsListScreenState extends State<ResidentsListScreen> {
  List<Resident> _residents = [];
  List<Resident> _filteredResidents = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResidents();
    _searchController.addListener(_filterResidents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterResidents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredResidents = _residents;
      } else {
        _filteredResidents = _residents.where((resident) {
          return resident.name.toLowerCase().contains(query) ||
                 resident.roomNumber.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadResidents() async {
    setState(() => _isLoading = true);
    try {
      final response = await SupabaseService.client
          .from('residents')
          .select()
          .order('name');
      
      setState(() {
        _residents = (response as List)
            .map((json) => Resident.fromJson(json))
            .toList();
        _filteredResidents = _residents;
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
        title: const Text('Residents Management'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search residents, rooms...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Residents List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredResidents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty 
                                  ? 'No residents found.\nAdd one to get started!'
                                  : 'No residents match your search.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadResidents,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredResidents.length,
                          itemBuilder: (context, index) {
                            final resident = _filteredResidents[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF1FC8DB),
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
                                  'Room ${resident.roomNumber} • Age ${resident.age} • ${resident.gender}',
                                ),
                                trailing: ElevatedButton.icon(
                                  onPressed: () => _showResidentProfile(resident),
                                  icon: const Icon(Icons.visibility, size: 18),
                                  label: const Text('View Profile'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1FC8DB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showResidentProfile(Resident resident) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResidentProfileScreen(
          resident: resident,
          onUpdate: _loadResidents,
        ),
      ),
    );
  }
}
