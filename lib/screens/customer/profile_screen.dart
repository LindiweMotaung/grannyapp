import 'package:flutter/material.dart';
import 'customer_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/istockphoto-1209869189-612x612.webp'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'John Anderson',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('john.anderson@email.com', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('+1 (555) 123-4567', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _ProfileStat(label: 'Bookings', value: '2'),
                      _ProfileStat(label: 'Saved', value: '5'),
                      _ProfileStat(label: 'Rating', value: '4.9'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Settings List
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
            child: Column(
              children: const [
                _ProfileSetting(icon: Icons.settings, label: 'Account Settings'),
                _ProfileSetting(icon: Icons.notifications, label: 'Notifications'),
                _ProfileSetting(icon: Icons.payment, label: 'Payment Methods'),
                _ProfileSetting(icon: Icons.history, label: 'Booking History'),
                _ProfileSetting(icon: Icons.privacy_tip, label: 'Privacy & Security'),
                _ProfileSetting(icon: Icons.help_outline, label: 'Help & Support'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomerNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          // Navigation handled by CustomerNavBar component
        },
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2CB5A8))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _ProfileSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProfileSetting({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2CB5A8)),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
