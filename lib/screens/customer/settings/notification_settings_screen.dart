import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _healthReminders = true;
  bool _medicationReminders = true;
  bool _visitNotifications = true;
  bool _activityReminders = true;
  bool _mealReminders = true;
  bool _emergencyAlerts = true;
  bool _generalAnnouncements = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _healthReminders = prefs.getBool('notif_health') ?? true;
      _medicationReminders = prefs.getBool('notif_medication') ?? true;
      _visitNotifications = prefs.getBool('notif_visits') ?? true;
      _activityReminders = prefs.getBool('notif_activities') ?? true;
      _mealReminders = prefs.getBool('notif_meals') ?? true;
      _emergencyAlerts = prefs.getBool('notif_emergency') ?? true;
      _generalAnnouncements = prefs.getBool('notif_announcements') ?? true;
      _soundEnabled = prefs.getBool('notif_sound') ?? true;
      _vibrationEnabled = prefs.getBool('notif_vibration') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_health', _healthReminders);
    await prefs.setBool('notif_medication', _medicationReminders);
    await prefs.setBool('notif_visits', _visitNotifications);
    await prefs.setBool('notif_activities', _activityReminders);
    await prefs.setBool('notif_meals', _mealReminders);
    await prefs.setBool('notif_emergency', _emergencyAlerts);
    await prefs.setBool('notif_announcements', _generalAnnouncements);
    await prefs.setBool('notif_sound', _soundEnabled);
    await prefs.setBool('notif_vibration', _vibrationEnabled);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.amber.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Choose what notifications you want to receive. Emergency alerts are always enabled for your safety.',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Care & Health Section
                _buildSectionTitle('Care & Health'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Health Reminders',
                    subtitle: 'Check-ups and vital signs monitoring',
                    icon: Icons.favorite,
                    value: _healthReminders,
                    onChanged: (val) => setState(() => _healthReminders = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Medication Reminders',
                    subtitle: 'Time to take your medications',
                    icon: Icons.medication,
                    value: _medicationReminders,
                    onChanged: (val) => setState(() => _medicationReminders = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Meal Reminders',
                    subtitle: 'Breakfast, lunch, and dinner times',
                    icon: Icons.restaurant,
                    value: _mealReminders,
                    onChanged: (val) => setState(() => _mealReminders = val),
                  ),
                ]),
                const SizedBox(height: 24),

                // Activities & Visits Section
                _buildSectionTitle('Activities & Visits'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Activity Reminders',
                    subtitle: 'Daily activities and exercise',
                    icon: Icons.directions_walk,
                    value: _activityReminders,
                    onChanged: (val) => setState(() => _activityReminders = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Visit Notifications',
                    subtitle: 'When family or friends visit',
                    icon: Icons.people,
                    value: _visitNotifications,
                    onChanged: (val) => setState(() => _visitNotifications = val),
                  ),
                ]),
                const SizedBox(height: 24),

                // Important Section
                _buildSectionTitle('Important'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Emergency Alerts',
                    subtitle: 'Critical health alerts (always on)',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                    value: _emergencyAlerts,
                    onChanged: null, // Always enabled
                    enabled: false,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'General Announcements',
                    subtitle: 'Updates and important information',
                    icon: Icons.campaign,
                    value: _generalAnnouncements,
                    onChanged: (val) => setState(() => _generalAnnouncements = val),
                  ),
                ]),
                const SizedBox(height: 24),

                // Alert Settings Section
                _buildSectionTitle('Alert Settings'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Sound',
                    subtitle: 'Play sound for notifications',
                    icon: Icons.volume_up,
                    value: _soundEnabled,
                    onChanged: (val) => setState(() => _soundEnabled = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Vibration',
                    subtitle: 'Vibrate for notifications',
                    icon: Icons.vibration,
                    value: _vibrationEnabled,
                    onChanged: (val) => setState(() => _vibrationEnabled = val),
                  ),
                ]),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Save Preferences',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FC8DB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? iconColor,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? const Color(0xFF1FC8DB)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xFF1FC8DB),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.black87 : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeThumbColor: const Color(0xFF1FC8DB),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }
}
