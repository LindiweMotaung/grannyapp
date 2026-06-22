import 'package:flutter/material.dart';
import '../../models/visit.dart';
import '../../services/supabase_service.dart';
import 'package:intl/intl.dart';

class MyVisitsScreen extends StatefulWidget {
  const MyVisitsScreen({super.key});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> {
  List<Visit> _visits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyVisits();
  }

  Future<void> _loadMyVisits() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;
      
      final response = await SupabaseService.client
          .from('visits')
          .select('*, residents!inner(name)')
          .eq('visitor_id', user.id)
          .order('scheduled_at', ascending: false);
      
      setState(() {
        _visits = (response as List)
            .map((json) => Visit.fromJson(json))
            .toList();
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

  Future<void> _cancelVisit(Visit visit) async {
    try {
      await SupabaseService.client
          .from('visits')
          .update({'status': 'cancelled'})
          .eq('id', visit.id);
      
      _loadMyVisits();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit cancelled successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cancelling visit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Visits'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visits.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No visits scheduled',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyVisits,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _visits.length,
                    itemBuilder: (context, index) {
                      final visit = _visits[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(visit.status),
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            DateFormat('MMMM dd, yyyy').format(visit.scheduledAt),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'At ${DateFormat('hh:mm a').format(visit.scheduledAt)}',
                          ),
                          trailing: Chip(
                            label: Text(
                              visit.status.toUpperCase(),
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: _getStatusColor(visit.status).withAlpha(51),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('Date', DateFormat('MMMM dd, yyyy').format(visit.scheduledAt)),
                                  _buildInfoRow('Time', DateFormat('hh:mm a').format(visit.scheduledAt)),
                                  _buildInfoRow('Purpose', visit.purpose ?? 'General visit'),
                                  _buildInfoRow('Status', visit.status),
                                  const SizedBox(height: 16),
                                  
                                  if (visit.status == 'scheduled')
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _confirmCancel(visit),
                                        icon: const Icon(Icons.cancel),
                                        label: const Text('Cancel Visit'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                  
                                  if (visit.status == 'cancelled')
                                    const Center(
                                      child: Text(
                                        'This visit has been cancelled',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  
                                  if (visit.status == 'completed')
                                    const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green),
                                          SizedBox(width: 8),
                                          Text(
                                            'Visit completed',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmCancel(Visit visit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Visit'),
        content: const Text('Are you sure you want to cancel this visit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelVisit(visit);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
