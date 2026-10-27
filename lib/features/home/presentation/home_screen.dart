import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/lesson.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';
import '../../../core/widgets/watermark_badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedSubject = 'All';

  final List<String> _subjects = [
    'All',
    'Physics',
    'Chemistry',
    'Mathematics',
    'Biology',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userRole = ref.watch(userRoleProvider);
    final currentLang = ref.watch(currentLanguageProvider);
    final allLessons = ref.watch(lessonsProvider);

    final filteredLessons = _selectedSubject == 'All'
        ? allLessons
        : allLessons.where((l) => l.subject == _selectedSubject).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school_rounded, color: AppColors.saffron, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppConfig.appName,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentLang.nativeName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffronDark,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  userRole == UserRole.teacher
                      ? 'Teacher Workspace'
                      : 'Digital Learning Mission',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Quick Doubt Floating Action
          IconButton(
            tooltip: 'Ask a Doubt',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.saffronContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_alt_rounded, color: AppColors.saffronDark, size: 20),
            ),
            onPressed: () => context.push('/doubt-solver'),
          ),
          // Impact Infographic
          IconButton(
            tooltip: 'Innovation Impact',
            icon: const Icon(Icons.insights_rounded, color: AppColors.primary),
            onPressed: () => context.push('/impact'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(lessonsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Student Welcome & Motivation Banner
            _buildGreetingCard(context, l10n, currentLang),

            const SizedBox(height: 16),

            // Primary Hero Action: Create New Lesson
            _buildCreateLessonHero(context, l10n),

            const SizedBox(height: 20),

            // Subject Filter Chips
            _buildSubjectChips(),

            const SizedBox(height: 20),

            // Continue Watching Section (Active Lesson)
            if (allLessons.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                title: l10n.continueWatching,
                icon: Icons.play_circle_fill_rounded,
                actionText: 'View All',
                onAction: () => context.push('/library'),
              ),
              const SizedBox(height: 10),
              _buildContinueWatchingCard(context, allLessons.first),
              const SizedBox(height: 22),
            ],

            // Recent Explainer Lessons Grid / List
            _buildSectionHeader(
              context,
              title: l10n.recentLessons,
              icon: Icons.video_collection_rounded,
              badgeCount: filteredLessons.length,
            ),
            const SizedBox(height: 10),

            if (filteredLessons.isEmpty)
              _buildEmptyState(context)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildLessonCard(context, filteredLessons[index]);
                },
              ),

            const SizedBox(height: 24),

            // Quick Doubt Banner Callout
            _buildDoubtCallout(context, l10n),

            const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard(
    BuildContext context,
    AppLocalizations l10n,
    RegionalLanguage lang,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang.sampleGreeting,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.homeGreeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeSubtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.saffronLight,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateLessonHero(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      onTap: () => context.push('/create-lesson'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.saffron, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.saffron.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.saffron, AppColors.saffronDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_to_photos_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.createNewLesson,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'AI Instant',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.emeraldDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upload PDF, textbook snapshot or voice query',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.saffronDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final subj = _subjects[idx];
          final isSelected = _selectedSubject == subj;
          return FilterChip(
            selected: isSelected,
            label: Text(subj),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textPrimaryLight,
            ),
            selectedColor: AppColors.primary,
            backgroundColor: Theme.of(context).cardColor,
            checkmarkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
              ),
            ),
            onSelected: (val) {
              setState(() => _selectedSubject = subj);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    int? badgeCount,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (badgeCount != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContinueWatchingCard(BuildContext context, Lesson lesson) {
    return InkWell(
      onTap: () => context.push('/video/${lesson.id}'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // Video thumbnail placeholder with teacher
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lesson.teacherAvatar.themeColor.withOpacity(0.85),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarCircle(avatar: lesson.teacherAvatar, radius: 26),
                        const SizedBox(height: 8),
                        Text(
                          lesson.teacherAvatar.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // AI Badge overlay
                const Positioned(
                  top: 10,
                  left: 10,
                  child: AiGeneratedBadge(compact: true),
                ),
                // Duration chip
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lesson.formattedDuration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Play Button Center Overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Progress bar
            LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(AppColors.saffron),
              minHeight: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${lesson.subject} • ${lesson.languageName} • Resuming at chapter 2',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    return InkWell(
      onTap: () => context.push('/video/${lesson.id}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teacher Avatar Display
            AvatarCircle(avatar: lesson.teacherAvatar, radius: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lesson.subject,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.saffronContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lesson.languageName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.saffronDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.teacherAvatar.name} • ${lesson.formattedDuration}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoubtCallout(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.saffronContainer.withOpacity(0.6),
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
            child: const Icon(Icons.question_answer_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stuck on a tricky concept?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.onSaffronContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ask any question and your AI Teacher explains it back in video',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSaffronContainer.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/doubt-solver'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffronDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ask', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Icon(Icons.video_library_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No lessons in this subject yet',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => context.push('/create-lesson'),
              child: const Text('Create the first one now'),
            ),
          ],
        ),
      ),
    );
  }
}
