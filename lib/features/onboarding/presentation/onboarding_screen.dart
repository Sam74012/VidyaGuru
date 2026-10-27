import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentRole = ref.watch(userRoleProvider);
    final currentLang = ref.watch(currentLanguageProvider);

    final slides = [
      _OnboardingSlideData(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: Icons.auto_stories_rounded,
        accentColor: AppColors.primary,
        badgeText: 'AI Pedagogy Engine',
      ),
      _OnboardingSlideData(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: Icons.translate_rounded,
        accentColor: AppColors.saffron,
        badgeText: '10 Indic Languages',
      ),
      _OnboardingSlideData(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        icon: Icons.face_retouching_natural_rounded,
        accentColor: AppColors.emerald,
        badgeText: 'Ethical Face & Voice Clone',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with App Title and Initiative Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: AppColors.saffron,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConfig.appName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                              ),
                              Text(
                                AppConfig.appNameIndic,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Impact Mission Link
                      TextButton.icon(
                        onPressed: () => context.push('/impact'),
                        icon: const Icon(Icons.bolt_rounded, size: 16, color: AppColors.saffron),
                        label: const Text(
                          'Mission Impact',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.saffronDark,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.saffronContainer,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Slide Carousel
                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated Hero Icon Card
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: slide.accentColor.withOpacity(0.12),
                                border: Border.all(
                                  color: slide.accentColor.withOpacity(0.35),
                                  width: 2.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  slide.icon,
                                  size: 40,
                                  color: slide.accentColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: slide.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                slide.badgeText,
                                style: TextStyle(
                                  color: slide.accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              slide.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[650],
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Select Role Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.selectRole,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Switch in Settings',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: UserRole.values.map((role) {
                              final isSelected = currentRole == role;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: InkWell(
                                    onTap: () {
                                      ref.read(userRoleProvider.notifier).setRole(role);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryContainer
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.borderLight,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            role.icon,
                                            size: 16,
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey[700],
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              role.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: isSelected
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Language Selector Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => _showLanguageModal(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language_rounded, size: 20, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Regional Language / আঞ্চলিক ভাষা',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              Text(
                                '${currentLang.nativeName} (${currentLang.englishName})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Primary Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.getStarted,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final current = ref.watch(currentLanguageProvider);
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.translate_rounded, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            'Choose Regional Language (10 Indic Scripts)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: AppLanguages.all.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final lang = AppLanguages.all[idx];
                          final isSelected = lang.code == current.code;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : AppColors.primaryContainer,
                              child: Text(
                                lang.nativeName.substring(0, 1),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              lang.nativeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              '${lang.englishName} • ${lang.sampleGreeting}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald)
                                : null,
                            onTap: () {
                              ref.read(currentLanguageProvider.notifier).setLanguage(lang);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String badgeText;

  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.badgeText,
  });
}
