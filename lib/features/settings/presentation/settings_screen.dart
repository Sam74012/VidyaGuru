import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userRole = ref.watch(userRoleProvider);
    final currentLang = ref.watch(currentLanguageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final lowDataMode = ref.watch(lowDataModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Rebranding / System Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded, color: AppColors.saffron, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConfig.appName,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      Text(
                        AppConfig.appTagline,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Backend: Mock Service Simulation Mode (${AppConfig.appVersion})',
                        style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // User Role Switcher
          _buildSectionHeader('Role & Profile'),
          Card(
            child: ListTile(
              leading: Icon(userRole.icon, color: AppColors.primary),
              title: Text('Current Role: ${userRole.title}'),
              subtitle: Text(userRole.subtitle, style: const TextStyle(fontSize: 11)),
              trailing: OutlinedButton(
                onPressed: () {
                  final nextRole = userRole == UserRole.student
                      ? UserRole.teacher
                      : UserRole.student;
                  ref.read(userRoleProvider.notifier).setRole(nextRole);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${nextRole.title} mode'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: const Text('Switch', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Regional Language Setting
          _buildSectionHeader('Language & Localization'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate_rounded, color: AppColors.saffronDark),
              title: const Text('App & Explainer Language'),
              subtitle: Text('${currentLang.nativeName} (${currentLang.englishName})'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _openLanguagePicker(context, ref),
            ),
          ),

          const SizedBox(height: 16),

          // Network & Bandwidth Optimizations
          _buildSectionHeader('Data Saver & Bandwidth'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.data_saver_on_rounded, color: AppColors.emerald),
                  title: const Text('Low-Bandwidth Mode (Rural Optimisation)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Lowers video resolution to 480p and reduces image weights', style: TextStyle(fontSize: 11)),
                  value: lowDataMode,
                  activeColor: AppColors.saffronDark,
                  onChanged: (val) {
                    ref.read(lowDataModeProvider.notifier).toggle();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.hd_rounded, color: AppColors.primary),
                  title: const Text('Preferred Video Streaming Resolution', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Adaptive Auto (720p HD on WiFi, 480p on 4G)', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Theme & Appearance
          _buildSectionHeader('Theme & Accessibility'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.primary),
                  title: const Text('Dark Mode', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Comfortable night studying mode', style: TextStyle(fontSize: 11)),
                  value: themeMode == ThemeMode.dark,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_size_rounded, color: AppColors.primary),
                  title: const Text('Large Typography Scale', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Optimized for small-screen Android devices', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Ethics, Trust & Safety
          _buildSectionHeader('Ethics, Consent & Transparency'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.security_rounded, color: AppColors.emerald),
                  title: const Text('Trust & Safety Policy', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Mandatory consent, watermarking and anti-deepfake safeguards', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/trust-safety'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.insights_rounded, color: AppColors.saffronDark),
                  title: const Text('Why This Matters (Challenge Impact)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Innovation mission for Education & Skill Development', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/impact'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.grey),
      ),
    );
  }

  void _openLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: AppLanguages.all.map((lang) {
            return ListTile(
              leading: Text(
                lang.nativeName.substring(0, 1),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              title: Text(lang.nativeName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(lang.englishName),
              onTap: () {
                ref.read(currentLanguageProvider.notifier).setLanguage(lang);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
