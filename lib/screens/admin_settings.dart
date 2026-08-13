import 'package:flutter/material.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your account preferences and system configurations.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader('Profile Settings'),
                _buildSettingsTile(
                  Icons.person_outline,
                  'Edit Profile',
                  'Update your personal information and display picture.',
                ),
                _buildSettingsTile(
                  Icons.lock_outline,
                  'Change Password',
                  'Update your login credentials.',
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Notifications'),
                _buildSwitchTile(
                  Icons.email_outlined,
                  'Email Notifications',
                  'Receive daily summaries of new requests.',
                  true,
                ),
                _buildSwitchTile(
                  Icons.notifications_active_outlined,
                  'Push Notifications',
                  'Real-time alerts for incoming appointments.',
                  false,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('System Data'),
                _buildSettingsTile(
                  Icons.backup_outlined,
                  'Database Backup',
                  'Export all records to a CSV file.',
                ),
                _buildSettingsTile(
                  Icons.color_lens_outlined,
                  'Theme Customization',
                  'Switch between Light and Dark mode.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB71C1C),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF333333)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool initialValue,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF333333)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Switch(
        value: initialValue,
        onChanged: (val) {},
        activeColor: const Color(0xFFB71C1C),
      ),
    );
  }
}
