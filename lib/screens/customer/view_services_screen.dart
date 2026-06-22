import 'package:flutter/material.dart';
import '../../models/service.dart';
import '../../services/supabase_service.dart';

class ViewServicesScreen extends StatefulWidget {
  const ViewServicesScreen({super.key});

  @override
  State<ViewServicesScreen> createState() => _ViewServicesScreenState();
}

class _ViewServicesScreenState extends State<ViewServicesScreen> {
  List<CareService> _services = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final response = await SupabaseService.client
          .from('services')
          .select()
          .eq('available', true)
          .order('name');
      
      setState(() {
        _services = (response as List)
            .map((json) => CareService.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading services: $e')),
        );
      }
    }
  }

  List<CareService> get _filteredServices {
    if (_selectedCategory == 'all') return _services;
    return _services.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category Filter
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('all', 'All Services'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('medical', 'Medical'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('recreational', 'Recreational'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('personal care', 'Personal Care'),
                      ],
                    ),
                  ),
                ),
                
                // Services List
                Expanded(
                  child: _filteredServices.isEmpty
                      ? const Center(child: Text('No services available'))
                      : RefreshIndicator(
                          onRefresh: _loadServices,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = _filteredServices[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getCategoryColor(service.category),
                                    child: const Icon(
                                      Icons.medical_services,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    service.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    service.category,
                                    style: TextStyle(
                                      color: _getCategoryColor(service.category),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Text(
                                    '\$${service.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Description:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(service.description),
                                          const SizedBox(height: 16),
                                          Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                _showContactDialog(service);
                                              },
                                              icon: const Icon(Icons.phone),
                                              label: const Text('Inquire About Service'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.teal,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'medical':
        return Colors.red;
      case 'recreational':
        return Colors.orange;
      case 'personal care':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  void _showContactDialog(CareService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(service.name),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('For inquiries about this service, please contact:'),
            SizedBox(height: 16),
            Text(
              '+1 (555) 123-4567',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Text('info@eldercare.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
