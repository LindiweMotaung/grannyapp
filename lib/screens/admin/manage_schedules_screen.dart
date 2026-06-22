import 'package:flutter/material.dart';
import '../../models/resident.dart';
import '../../services/supabase_service.dart';

class ManageSchedulesScreen extends StatefulWidget {
  const ManageSchedulesScreen({super.key});

  @override
  State<ManageSchedulesScreen> createState() => _ManageSchedulesScreenState();
}

class _ManageSchedulesScreenState extends State<ManageSchedulesScreen> {
  String _selectedDay = 'Monday';
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> _filteredActivities = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.calendar_today},
    {'name': 'Meds', 'icon': Icons.medication},
    {'name': 'Meals', 'icon': Icons.restaurant},
    {'name': 'Therapy', 'icon': Icons.spa},
    {'name': 'Social', 'icon': Icons.people},
  ];

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _searchController.addListener(_filterActivities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    try {
      final response = await SupabaseService.client
          .from('daily_activities')
          .select('*, residents(name, room_number)')
          .eq('day_of_week', _selectedDay)
          .order('scheduled_time');

      setState(() {
        _activities = List<Map<String, dynamic>>.from(response as List);
        _filterActivities();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading activities: $e')),
        );
      }
    }
  }

  void _filterActivities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredActivities = _activities.where((activity) {
        final matchesSearch = query.isEmpty ||
            activity['activity_name'].toString().toLowerCase().contains(query) ||
            (activity['residents']?['name'] ?? '').toString().toLowerCase().contains(query);
        
        final matchesCategory = _selectedCategory == 'All' ||
            activity['activity_type'] == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  int get _totalActivities => _filteredActivities.length;
  int get _completedActivities =>
      _filteredActivities.where((a) => a['status'] == 'completed').length;
  int get _pendingActivities =>
      _filteredActivities.where((a) => a['status'] == 'pending').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Schedules'),
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
                hintText: 'Search residents, visitors...',
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

          // Day Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(day.substring(0, 3)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedDay = day);
                      _loadActivities();
                    },
                    selectedColor: const Color(0xFF1FC8DB),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Category Tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category['name'] == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(
                      category['icon'] as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : const Color(0xFF1FC8DB),
                    ),
                    label: Text(category['name'] as String),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category['name'] as String);
                      _filterActivities();
                    },
                    selectedColor: const Color(0xFF1FC8DB),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _totalActivities, Colors.blue),
                _buildStatCard('Completed', _completedActivities, Colors.green),
                _buildStatCard('Pending', _pendingActivities, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Activities List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredActivities.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No activities scheduled for $_selectedDay',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add an activity',
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadActivities,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredActivities.length,
                          itemBuilder: (context, index) {
                            final activity = _filteredActivities[index];
                            return _buildActivityCard(activity);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivityDialog,
        backgroundColor: const Color(0xFF1FC8DB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final residentData = activity['residents'] as Map<String, dynamic>?;
    final residentName = residentData?['name'] ?? 'Unknown Resident';
    final roomNumber = residentData?['room_number'] ?? 'N/A';
    final isCompleted = activity['status'] == 'completed';

    IconData activityIcon;
    Color activityColor;
    switch (activity['activity_type']) {
      case 'Meds':
        activityIcon = Icons.medication;
        activityColor = const Color(0xFFAB47BC);
        break;
      case 'Meals':
        activityIcon = Icons.restaurant;
        activityColor = const Color(0xFFFF9800);
        break;
      case 'Therapy':
        activityIcon = Icons.spa;
        activityColor = const Color(0xFF2196F3);
        break;
      case 'Social':
        activityIcon = Icons.people;
        activityColor = const Color(0xFF4CAF50);
        break;
      default:
        activityIcon = Icons.event;
        activityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Activity Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: activityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(activityIcon, color: activityColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Activity Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['activity_name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        activity['scheduled_time'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        residentName,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Room $roomNumber',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  if (activity['notes'] != null && activity['notes'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Notes: ${activity['notes']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (isCompleted)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Status Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: isCompleted ? Colors.green : Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddActivityDialog() async {
    // Load residents first
    final residentsResponse = await SupabaseService.client
        .from('residents')
        .select()
        .order('name');
    
    final residents = (residentsResponse as List)
        .map((json) => Resident.fromJson(json))
        .toList();

    if (residents.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No residents found. Please add residents first.'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    String? selectedResidentId = residents.first.id;
    String selectedActivityType = 'Meds';
    final activityNameController = TextEditingController();
    String selectedTime = '09:00 AM';
    String selectedDay = _selectedDay;
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Activity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resident Dropdown
                const Text('Select Resident', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedResidentId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: residents.map((resident) {
                    return DropdownMenuItem(
                      value: resident.id,
                      child: Text('${resident.name} - Room ${resident.roomNumber}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedResidentId = value);
                  },
                ),
                const SizedBox(height: 16),

                // Activity Type Dropdown
                const Text('Activity Type', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedActivityType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Meds', child: Text('Medication')),
                    DropdownMenuItem(value: 'Meals', child: Text('Meals')),
                    DropdownMenuItem(value: 'Therapy', child: Text('Therapy')),
                    DropdownMenuItem(value: 'Social', child: Text('Social Activity')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedActivityType = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Activity Name
                const Text('Activity Name', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: activityNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                    hintText: 'e.g., Morning Medication',
                  ),
                ),
                const SizedBox(height: 16),

                // Day Dropdown
                const Text('Day of Week', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedDay,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: _days.map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedDay = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Time Dropdown
                const Text('Scheduled Time', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedTime,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  items: _generateTimeSlots(),
                  onChanged: (value) {
                    setDialogState(() => selectedTime = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                const Text('Notes (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                    hintText: 'Additional notes...',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (activityNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter activity name')),
                  );
                  return;
                }

                try {
                  await SupabaseService.client.from('daily_activities').insert({
                    'resident_id': selectedResidentId,
                    'activity_type': selectedActivityType,
                    'activity_name': activityNameController.text,
                    'scheduled_time': selectedTime,
                    'day_of_week': selectedDay,
                    'status': 'pending',
                    'notes': notesController.text.isEmpty ? null : notesController.text,
                  });

                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1FC8DB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Activity'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      _loadActivities();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity added successfully')),
        );
      }
    }
  }

  List<DropdownMenuItem<String>> _generateTimeSlots() {
    final slots = <DropdownMenuItem<String>>[];
    for (int hour = 6; hour <= 22; hour++) {
      for (int minute in [0, 30]) {
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final amPm = hour >= 12 ? 'PM' : 'AM';
        final time12 = '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm';
        
        slots.add(DropdownMenuItem(value: time12, child: Text(time12)));
      }
    }
    return slots;
  }
}
