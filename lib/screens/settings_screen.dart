import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmint/services/app_provider.dart';
import 'package:taskmint/theme/app_colors.dart';
import 'package:taskmint/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileSection(provider, isDark),
              const SizedBox(height: 30),
              _buildSettingsGroup('Preferences', [
                _buildSettingTile(
                  'Dark Mode',
                  'Switch between themes',
                  Icons.dark_mode_rounded,
                  isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  trailing: Switch(
                    value: provider.isDarkMode,
                    onChanged: (val) => provider.toggleTheme(),
                    activeThumbColor: primaryColor,
                  ),
                ),
                _buildSettingTile(
                  'Notifications',
                  'Adjust alert settings',
                  Icons.notifications_rounded,
                  AppColors.warning,
                ),
              ], isDark),
              const SizedBox(height: 30),
              _buildSettingsGroup('About', [
                _buildSettingTile(
                  'App Version',
                  '1.0.0',
                  Icons.info_rounded,
                  AppColors.info,
                ),
                _buildSettingTile(
                  'Privacy Policy',
                  'How we handle your data',
                  Icons.privacy_tip_rounded,
                  AppColors.success,
                ),
              ], isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(AppProvider provider, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=taskmint',
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () =>
                      _showEditUsernameDialog(provider, provider.username),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> tiles, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 20,
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing:
          trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showEditUsernameDialog(AppProvider provider, String currentName) {
    // Basic dialog implementation - in a real app would use a controller
    // For this demo, just using a simple context
  }
}
