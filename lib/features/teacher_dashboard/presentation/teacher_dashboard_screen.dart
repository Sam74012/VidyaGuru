import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/teacher_avatar.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(repositoryProvider);
    final allLessons = ref.watch(lessonsProvider);
    final avatars = ref.watch(avatarsProvider);

    final teacherAvatar = avatars.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.teacherDashboard),
        actions: [
          IconButton(
            tooltip: 'Trust & Legal Consent',
            icon: const Icon(Icons.shield_outlined, color: AppColors.emerald),
            onPressed: () => context.push('/trust-safety'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Teacher Profile & Consent Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  teacherAvatar.themeColor,
                  AppColors.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                AvatarCircle(avatar: teacherAvatar, radius: 30, isSelected: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            teacherAvatar.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.emeraldLight),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        teacherAvatar.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Consent Status: Active & Authorized',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Key Stats Grid (Student Views, Lessons Created, Time Saved)
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildStatCard(
                context,
                title: 'Student Views',
                value: '4,890',
                icon: Icons.visibility_rounded,
                color: AppColors.primary,
              ),
              _buildStatCard(
                context,
                title: 'Lessons Made',
                value: '${allLessons.length}',
                icon: Icons.video_collection_rounded,
                color: AppColors.saffron,
              ),
              _buildStatCard(
                context,
                title: 'Hours Saved',
                value: '142 hrs',
                icon: Icons.hourglass_bottom_rounded,
                color: AppColors.emerald,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Classroom Code Sharing Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.saffronContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.saffron.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.saffron,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Class Access Code for Students',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        repo.activeClassCode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: AppColors.onSaffronContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Class code "${repo.activeClassCode}" copied to share on WhatsApp!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffronDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Share Code'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Avatar Permissions & Revocation Management
          const Text(
            'Avatar Governance & Privacy Controls:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_person_rounded, color: AppColors.primary),
                  title: const Text('Access Permission Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('Currently: Class Only (verified students with school code)', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.block_rounded, color: AppColors.error),
                  title: const Text('Revoke Likeness & Timbre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error)),
                  subtitle: const Text('Instantly ceases all new AI video generations', style: TextStyle(fontSize: 11)),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                    onPressed: () {
                      _showRevokeConfirm(context, ref, teacherAvatar);
                    },
                    child: const Text('Revoke', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Recent Student Doubt Inquiries
          const Text(
            'Recent Student Doubt Submissions:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final questions = [
                'কেন নিউটনের ৩য় সূত্র মহাশূন্যে রকেটকে এগিয়ে নিয়ে যায়?',
                'বন্দুকের রিকয়েল ভরবেগ সমীকরণের ঋণাত্মক চিহ্নের তাৎপর্য কী?',
              ];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.help_outline_rounded, color: AppColors.saffronDark, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        questions[idx],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'AI Answered',
                        style: TextStyle(fontSize: 10, color: AppColors.emeraldDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showRevokeConfirm(BuildContext context, WidgetRef ref, TeacherAvatar avatar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Avatar Authorization?'),
        content: const Text(
          'In accordance with India Digital Personal Data Protection standards, revoking consent will immediately lock your AI avatar from generating any future student lessons.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(avatarsProvider.notifier).revokeAvatar(avatar.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Avatar consent revoked successfully.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Confirm Revocation', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
