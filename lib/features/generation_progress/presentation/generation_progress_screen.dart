import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/job.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';
import '../../../core/widgets/watermark_badge.dart';

class GenerationProgressScreen extends ConsumerWidget {
  final String jobId;

  const GenerationProgressScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final jobAsync = ref.watch(jobStreamProvider(jobId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Synthesis Pipeline'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rendering in background. You will receive a notification when ready!'),
                  backgroundColor: AppColors.primary,
                ),
              );
              context.go('/');
            },
            icon: const Icon(Icons.notifications_active_rounded, size: 16),
            label: const Text('Run in Background', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      body: jobAsync.when(
        data: (job) => _buildProgressBody(context, ref, job, l10n),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting to generation stream...'),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text('Pipeline error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBody(
    BuildContext context,
    WidgetRef ref,
    GenerationJob job,
    AppLocalizations l10n,
  ) {
    final isDone = job.isCompleted;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Top Teacher & Target Dialect Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              AvatarCircle(avatar: job.avatar, radius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${job.avatar.name} • ',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.saffronContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            job.language.nativeName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const AiGeneratedBadge(compact: true),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Overall Progress Radial / Bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDone ? 'Explainer Video Ready!' : 'Rendering Explainer...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isDone
                            ? 'All 4 pipeline stages finalized'
                            : '${l10n.estimatedTime}: ~${job.estimatedSecondsRemaining}s',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${(job.overallProgress * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.saffronLight,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: job.overallProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(AppColors.saffron),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: Colors.white70),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.stageMessage,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Pipeline Stages Flow (Mandatory 4 stages)
        const Text(
          'Video Generation Architecture Stages:',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 14),

        _buildStageCard(
          stageNum: 1,
          title: 'Voice Cloner',
          subtitle: 'Acoustic waveform synthesis in ${job.language.nativeName} with regional inflection',
          icon: Icons.graphic_eq_rounded,
          color: const Color(0xFF3B82F6),
          isCurrent: job.currentStage == PipelineStage.voice,
          isCompleted: job.currentStage.index > PipelineStage.voice.index,
        ),
        _buildStageCard(
          stageNum: 2,
          title: 'Face Swapper',
          subtitle: 'Photo landmark mapping onto 3D teacher body avatar template',
          icon: Icons.face_retouching_natural_rounded,
          color: const Color(0xFF10B981),
          isCurrent: job.currentStage == PipelineStage.face,
          isCompleted: job.currentStage.index > PipelineStage.face.index,
        ),
        _buildStageCard(
          stageNum: 3,
          title: 'Cinematic Lip-Sync Engine',
          subtitle: 'Phoneme-to-viseme temporal alignment at 60 frames per second',
          icon: Icons.record_voice_over_rounded,
          color: const Color(0xFF8B5CF6),
          isCurrent: job.currentStage == PipelineStage.lipsync,
          isCompleted: job.currentStage.index > PipelineStage.lipsync.index,
        ),
        _buildStageCard(
          stageNum: 4,
          title: 'Composite Engine',
          subtitle: 'Audio/video multi-track merge, watermark stamping & subtitle track injection',
          icon: Icons.layers_rounded,
          color: AppColors.saffron,
          isCurrent: job.currentStage == PipelineStage.compositing,
          isCompleted: isDone,
        ),

        const SizedBox(height: 24),

        // Completed CTA Button
        if (isDone && job.completedLesson != null)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add to repository
                ref.read(lessonsProvider.notifier).addLesson(job.completedLesson!);
                context.push('/video/${job.completedLesson!.id}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: const Text(
                'Watch Explainer Video Now',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

        const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStageCard({
    required int stageNum,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isCurrent,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withOpacity(0.08)
            : (isCompleted ? Colors.white : Colors.grey.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? color
              : (isCompleted ? AppColors.emerald.withOpacity(0.4) : AppColors.borderLight),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.emerald
                  : (isCurrent ? color : Colors.grey.withOpacity(0.2)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                  : (isCurrent
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          '$stageNum',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        )),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Stage $stageNum: $title',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isCurrent ? color : (isCompleted ? AppColors.textPrimaryLight : Colors.grey[700]),
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.emerald),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
