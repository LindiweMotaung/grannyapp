import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _shareHealthData = true;
  bool _showActivityStatus = true;
  bool _allowFamilyAccess = true;
  bool _shareLocationWithStaff = true;
  bool _twoFactorAuth = false;
  bool _biometricAuth = false;
  bool _dataBackup = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareHealthData = prefs.getBool('privacy_share_health') ?? true;
      _showActivityStatus = prefs.getBool('privacy_show_activity') ?? true;
      _allowFamilyAccess = prefs.getBool('privacy_family_access') ?? true;
      _shareLocationWithStaff = prefs.getBool('privacy_location_staff') ?? true;
      _twoFactorAuth = prefs.getBool('security_2fa') ?? false;
      _biometricAuth = prefs.getBool('security_biometric') ?? false;
      _dataBackup = prefs.getBool('privacy_data_backup') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_share_health', _shareHealthData);
    await prefs.setBool('privacy_show_activity', _showActivityStatus);
    await prefs.setBool('privacy_family_access', _allowFamilyAccess);
    await prefs.setBool('privacy_location_staff', _shareLocationWithStaff);
    await prefs.setBool('security_2fa', _twoFactorAuth);
    await prefs.setBool('security_biometric', _biometricAuth);
    await prefs.setBool('privacy_data_backup', _dataBackup);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Privacy & Security settings saved!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Control who can see your information and how your data is protected.',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Privacy Settings Section
                _buildSectionTitle('Privacy Settings'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Share Health Data',
                    subtitle: 'Allow staff to view your health records',
                    icon: Icons.favorite,
                    value: _shareHealthData,
                    onChanged: (val) {
                      if (!val) {
                        _showInfoDialog(
                          'Important',
                          'Disabling this may affect the quality of care you receive. Medical staff needs access to your health data for proper treatment.',
                        );
                      }
                      setState(() => _shareHealthData = val);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Show Activity Status',
                    subtitle: 'Let others see when you\'re active',
                    icon: Icons.circle,
                    value: _showActivityStatus,
                    onChanged: (val) => setState(() => _showActivityStatus = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Allow Family Access',
                    subtitle: 'Family members can view your schedule',
                    icon: Icons.family_restroom,
                    value: _allowFamilyAccess,
                    onChanged: (val) => setState(() => _allowFamilyAccess = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Share Location with Staff',
                    subtitle: 'Help staff find you in emergencies',
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    value: _shareLocationWithStaff,
                    onChanged: (val) {
                      if (!val) {
                        _showInfoDialog(
                          'Safety Notice',
                          'Location sharing helps staff respond quickly in emergencies. Are you sure you want to disable this?',
                        );
                      }
                      setState(() => _shareLocationWithStaff = val);
                    },
                  ),
                ]),
                const SizedBox(height: 24),

                // Security Settings Section
                _buildSectionTitle('Security Settings'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Extra security for your account',
                    icon: Icons.lock,
                    iconColor: Colors.orange,
                    value: _twoFactorAuth,
                    onChanged: (val) {
                      if (val) {
                        _showInfoDialog(
                          'Enhanced Security',
                          'Two-factor authentication adds an extra layer of security. You\'ll need your password and a verification code to log in.',
                        );
                      }
                      setState(() => _twoFactorAuth = val);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Biometric Login',
                    subtitle: 'Use fingerprint or face recognition',
                    icon: Icons.fingerprint,
                    iconColor: Colors.purple,
                    value: _biometricAuth,
                    onChanged: (val) => setState(() => _biometricAuth = val),
                  ),
                ]),
                const SizedBox(height: 24),

                // Data Management Section
                _buildSectionTitle('Data Management'),
                const SizedBox(height: 12),
                _buildCard([
                  _buildSwitchTile(
                    title: 'Automatic Data Backup',
                    subtitle: 'Keep your data safe with backups',
                    icon: Icons.backup,
                    iconColor: Colors.green,
                    value: _dataBackup,
                    onChanged: (val) => setState(() => _dataBackup = val),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.download, color: Colors.red, size: 20),
                    ),
                    title: const Text(
                      'Download My Data',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Get a copy of all your information',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preparing your data... You\'ll receive an email shortly.'),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently delete your account',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account?'),
                          content: const Text(
                            'This action cannot be undone. All your data will be permanently deleted. Please contact the administrator if you wish to proceed.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please contact administrator to delete account'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Contact Admin'),
                            ),
                          ],
                        ),
                      );
                    },
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
    required ValueChanged<bool> onChanged,
    Color? iconColor,
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
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF1FC8DB),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }
}
