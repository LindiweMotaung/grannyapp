import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    
    try {
      // Get counts from all tables using simple select and length
      final residentsData = await SupabaseService.client
          .from('residents')
          .select('id');
      
      final visitsData = await SupabaseService.client
          .from('visits')
          .select('id');
      
      final servicesData = await SupabaseService.client
          .from('services')
          .select('id');
      
      final staffData = await SupabaseService.client
          .from('staff')
          .select('id');

      // Get visit status breakdown
      final pendingVisitsData = await SupabaseService.client
          .from('visits')
          .select('id')
          .eq('status', 'pending');
      
      final approvedVisitsData = await SupabaseService.client
          .from('visits')
          .select('id')
          .eq('status', 'approved');
      
      final completedVisitsData = await SupabaseService.client
          .from('visits')
          .select('id')
          .eq('status', 'completed');

      // Get active residents
      final activeResidentsData = await SupabaseService.client
          .from('residents')
          .select('id')
          .eq('status', 'active');

      setState(() {
        _stats = {
          'totalResidents': (residentsData as List).length,
          'activeResidents': (activeResidentsData as List).length,
          'totalVisits': (visitsData as List).length,
          'pendingVisits': (pendingVisitsData as List).length,
          'approvedVisits': (approvedVisitsData as List).length,
          'completedVisits': (completedVisitsData as List).length,
          'totalServices': (servicesData as List).length,
          'totalStaff': (staffData as List).length,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading statistics: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Real-time statistics from your facility',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Statistics Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          'Total Residents',
                          _stats['totalResidents']?.toString() ?? '0',
                          Icons.people,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Active Residents',
                          _stats['activeResidents']?.toString() ?? '0',
                          Icons.how_to_reg,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Total Visits',
                          _stats['totalVisits']?.toString() ?? '0',
                          Icons.event,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Total Staff',
                          _stats['totalStaff']?.toString() ?? '0',
                          Icons.badge,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Visit Status Section
                    const Text(
                      'Visit Status Breakdown',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildVisitStatusCard(
                      'Pending Approval',
                      _stats['pendingVisits']?.toString() ?? '0',
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                    const SizedBox(height: 12),
                    _buildVisitStatusCard(
                      'Approved',
                      _stats['approvedVisits']?.toString() ?? '0',
                      Colors.blue,
                      Icons.check_circle,
                    ),
                    const SizedBox(height: 12),
                    _buildVisitStatusCard(
                      'Completed',
                      _stats['completedVisits']?.toString() ?? '0',
                      Colors.green,
                      Icons.done_all,
                    ),
                    const SizedBox(height: 24),

                    // Services Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.medical_services,
                              size: 40,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _stats['totalServices']?.toString() ?? '0',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const Text(
                              'Care Services Available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade400, Colors.teal.shade700],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'All Data Synced with Supabase',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'View detailed records in Supabase Dashboard\nsupabase.com → Your Project',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
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
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitStatusCard(String title, String count, Color color, IconData icon) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
