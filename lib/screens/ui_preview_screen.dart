import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'auth/admin_login_screen.dart';
import 'auth/customer_login_screen.dart';
import 'auth/customer_register_screen.dart';
import 'admin/admin_dashboard.dart';
import 'admin/residents_list_screen.dart';
import 'admin/staff_list_screen.dart';
import 'admin/services_list_screen.dart';
import 'admin/visits_list_screen.dart';
import 'admin/admin_analytics_screen.dart';
import 'customer/customer_dashboard.dart';
import 'customer/view_residents_screen.dart';
import 'customer/view_services_screen.dart';
import 'customer/book_visit_screen.dart';
import 'customer/my_visits_screen.dart';

class UIPreviewScreen extends StatelessWidget {
  const UIPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 UI Preview - Design Mode'),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'UI Design Preview\nClick any screen to see its design',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          
          // App Flow Screens
          _buildSectionHeader('App Flow'),
          _buildScreenButton(
            context,
            '🌟 Splash Screen',
            const SplashScreen(),
          ),
          _buildScreenButton(
            context,
            '� Welcome Screen',
            const WelcomeScreen(),
          ),
          
          const Divider(height: 32),
          
          // Auth Screens
          _buildSectionHeader('Authentication Screens'),
          _buildScreenButton(
            context,
            '🔐 Admin Login',
            const AdminLoginScreen(),
          ),
          _buildScreenButton(
            context,
            '🔐 Customer Login',
            const CustomerLoginScreen(),
          ),
          _buildScreenButton(
            context,
            '📝 Customer Register',
            const CustomerRegisterScreen(),
          ),
          
          const Divider(height: 32),
          
          // Admin Screens
          _buildSectionHeader('Admin Screens'),
          _buildScreenButton(
            context,
            '📊 Admin Dashboard',
            const AdminDashboard(),
          ),
          _buildScreenButton(
            context,
            '👵 Residents List',
            const ResidentsListScreen(),
          ),
          _buildScreenButton(
            context,
            '👨‍⚕️ Staff List',
            const StaffListScreen(),
          ),
          _buildScreenButton(
            context,
            '🏥 Services List',
            const ServicesListScreen(),
          ),
          _buildScreenButton(
            context,
            '📅 Visits List',
            const VisitsListScreen(),
          ),
          _buildScreenButton(
            context,
            '📈 Analytics',
            const AdminAnalyticsScreen(),
          ),
          
          const Divider(height: 32),
          
          // Customer Screens
          _buildSectionHeader('Customer Screens'),
          _buildScreenButton(
            context,
            '🏠 Customer Dashboard',
            const CustomerDashboard(),
          ),
          _buildScreenButton(
            context,
            '👵 View Residents',
            const ViewResidentsScreen(),
          ),
          _buildScreenButton(
            context,
            '🏥 View Services',
            const ViewServicesScreen(),
          ),
          _buildScreenButton(
            context,
            '📅 Book Visit',
            const BookVisitScreen(),
          ),
          _buildScreenButton(
            context,
            '📋 My Visits',
            const MyVisitsScreen(),
          ),
          
          const SizedBox(height: 32),
          const Text(
            '💡 Tip: This preview mode is for UI design only.\nRemove this when ready for production!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildScreenButton(BuildContext context, String title, Widget screen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
