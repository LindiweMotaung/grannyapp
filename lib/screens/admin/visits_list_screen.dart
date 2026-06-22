import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import 'package:intl/intl.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  State<VisitsListScreen> createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  List<Map<String, dynamic>> _allVisits = [];
  List<Map<String, dynamic>> _filteredVisits = [];
  bool _isLoading = true;
  String _selectedTab = 'All Visits';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVisits();
    _searchController.addListener(_filterVisits);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVisits() async {
    setState(() => _isLoading = true);
    try {
      final response = await SupabaseService.client
          .from('visits')
          .select('*, residents(name, room_number)')
          .order('scheduled_at', ascending: false);
      
      setState(() {
        _allVisits = List<Map<String, dynamic>>.from(response as List);
        _filterVisits();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading visits: $e')),
        );
      }
    }
  }

  void _filterVisits() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVisits = _allVisits.where((visit) {
        final matchesSearch = query.isEmpty ||
            (visit['visitor_name']?.toString().toLowerCase().contains(query) ?? false) ||
            (visit['residents']?['name']?.toString().toLowerCase().contains(query) ?? false) ||
            (visit['purpose']?.toString().toLowerCase().contains(query) ?? false);
        
        final matchesTab = _selectedTab == 'All Visits' ||
            (_selectedTab == 'Pending' && visit['status'] == 'pending') ||
            (_selectedTab == 'Approved' && visit['status'] == 'approved');

        return matchesSearch && matchesTab;
      }).toList();
    });
  }

  int get _allCount => _allVisits.length;
  int get _pendingCount => _allVisits.where((v) => v['status'] == 'pending').length;
  int get _approvedCount => _allVisits.where((v) => v['status'] == 'approved').length;

  Future<void> _updateVisitStatus(String id, String status) async {
    try {
      await SupabaseService.client
          .from('visits')
          .update({'status': status})
          .eq('id', id);
      
      _loadVisits();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == 'approved' ? 'Visit approved' : 'Visit rejected'),
            backgroundColor: status == 'approved' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating visit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Visits'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tab Selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTabChip('All Visits', _allCount, const Color(0xFF00ACC1)),
                const SizedBox(width: 8),
                _buildTabChip('Pending', _pendingCount, Colors.orange),
                const SizedBox(width: 8),
                _buildTabChip('Approved', _approvedCount, Colors.green),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search visits...',
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

          const SizedBox(height: 16),

          // Visits List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredVisits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No visit requests',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Visit requests will appear here automatically',
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadVisits,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredVisits.length,
                          itemBuilder: (context, index) {
                            final visit = _filteredVisits[index];
                            return _buildVisitCard(visit);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, int count, Color color) {
    final isSelected = _selectedTab == label;
    return Expanded(
      child: ChoiceChip(
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.3) : color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedTab = label);
          _filterVisits();
        },
        selectedColor: color,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> visit) {
    final residentData = visit['residents'] as Map<String, dynamic>?;
    final residentName = residentData?['name'] ?? 'Unknown Resident';
    final roomNumber = residentData?['room_number'] ?? 'N/A';
    final visitorName = visit['visitor_name'] ?? 'Unknown Visitor';
    final visitorContact = visit['visitor_contact'] ?? '';
    final purpose = visit['purpose'] ?? 'Family Visit';
    final status = visit['status'] ?? 'pending';
    final scheduledAt = DateTime.parse(visit['scheduled_at']);
    
    // Get initials for avatar
    final initials = visitorName.split(' ').map((word) => word[0]).take(2).join().toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with visitor info and status
            Row(
              children: [
                // Visitor Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB47BC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Visitor name and label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Visitor',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: status == 'pending'
                        ? Colors.orange.withValues(alpha: 0.15)
                        : Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == 'pending' ? Icons.access_time : Icons.check_circle,
                        size: 16,
                        color: status == 'pending' ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status == 'pending' ? 'Pending' : 'Approved',
                        style: TextStyle(
                          color: status == 'pending' ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Visiting resident info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Color(0xFF00ACC1)),
                  const SizedBox(width: 8),
                  Text(
                    'Visiting: $residentName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Room number
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                'Room $roomNumber',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Date & Time and Contact
            Row(
              children: [
                // Date & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd').format(scheduledAt),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('h:mm a').format(scheduledAt),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              visitorContact.isNotEmpty ? visitorContact : 'N/A',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Purpose
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purpose',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  purpose,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // Action Buttons (only show for pending visits)
            if (status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateVisitStatus(visit['id'], 'approved'),
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      label: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.green),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        backgroundColor: Colors.green.withValues(alpha: 0.05),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateVisitStatus(visit['id'], 'rejected'),
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        backgroundColor: Colors.red.withValues(alpha: 0.05),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
