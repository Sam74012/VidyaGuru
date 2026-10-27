import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/lesson.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final allLessons = ref.watch(lessonsProvider);
    final lowDataMode = ref.watch(lowDataModeProvider);

    final downloadedLessons = allLessons.where((l) => l.isDownloaded).toList();
    final totalStorageMb = downloadedLessons.fold<double>(0, (sum, l) => sum + l.sizeMb);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myLibrary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Storage & Low Bandwidth Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Offline Storage Used',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalStorageMb.toStringAsFixed(1)} MB',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${downloadedLessons.length} offline lessons',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (totalStorageMb / 500.0).clamp(0.02, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(),
                // Low Data Mode Toggle (MANDATORY REQUIREMENT)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Low-Bandwidth Mode (Rural Optimisation)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: const Text(
                    'Smaller thumbnails, low bitrate audio, no auto-play video',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: lowDataMode,
                  activeColor: AppColors.saffronDark,
                  onChanged: (val) {
                    ref.read(lowDataModeProvider.notifier).toggle();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Offline Lessons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Downloaded Explainer Videos',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              if (downloadedLessons.isNotEmpty)
                TextButton(
                  onPressed: () {
                    for (final l in downloadedLessons) {
                      ref.read(lessonsProvider.notifier).toggleDownload(l.id);
                    }
                  },
                  child: const Text('Clear All', style: TextStyle(color: AppColors.error, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 10),

          if (downloadedLessons.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.cloud_download_outlined, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    const Text(
                      'No offline videos saved yet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Download lessons to study without active mobile internet.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloadedLessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final lesson = downloadedLessons[idx];
                return _buildDownloadedCard(context, ref, lesson);
              },
            ),

          const SizedBox(height: 24),

          // All Lessons History
          const Text(
            'All Generated Lessons History',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allLessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final lesson = allLessons[idx];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                tileColor: Theme.of(context).cardColor,
                leading: AvatarCircle(avatar: lesson.teacherAvatar, radius: 20),
                title: Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  '${lesson.subject} • ${lesson.languageName} • ${lesson.formattedDuration}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () => context.push('/video/${lesson.id}'),
              );
            },
          ),

          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadedCard(BuildContext context, WidgetRef ref, Lesson lesson) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          AvatarCircle(avatar: lesson.teacherAvatar, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  '${lesson.languageName} • ${lesson.sizeMb} MB • Ready Offline',
                  style: const TextStyle(fontSize: 11, color: AppColors.emeraldDark, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 28),
            onPressed: () => context.push('/video/${lesson.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 20),
            onPressed: () {
              ref.read(lessonsProvider.notifier).toggleDownload(lesson.id);
            },
          ),
        ],
      ),
    );
  }
}
