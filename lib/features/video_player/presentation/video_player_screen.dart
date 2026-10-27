import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/lesson.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';
import '../../../core/widgets/watermark_badge.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const VideoPlayerScreen({super.key, required this.lessonId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isPlaying = true;
  double _currentPositionSeconds = 0;
  double _playbackSpeed = 1.0;
  bool _showSubtitles = true;
  Timer? _playbackTimer;

  final List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startPlaybackSimulation();
  }

  void _startPlaybackSimulation() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isPlaying) {
        setState(() {
          final lesson = _getLesson();
          if (lesson != null) {
            _currentPositionSeconds += 0.5 * _playbackSpeed;
            if (_currentPositionSeconds >= lesson.durationSeconds) {
              _currentPositionSeconds = 0; // loop
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Lesson? _getLesson() {
    final lessons = ref.read(lessonsProvider);
    try {
      return lessons.firstWhere((l) => l.id == widget.lessonId);
    } catch (_) {
      return lessons.isNotEmpty ? lessons.first : null;
    }
  }

  String _formatTime(double seconds) {
    final s = seconds.toInt();
    final m = s ~/ 60;
    final rem = s % 60;
    return '${m.toString().padLeft(2, '0')}:${rem.toString().padLeft(2, '0')}';
  }

  String _getCurrentSubtitle(Lesson lesson) {
    for (final sub in lesson.subtitles) {
      if (_currentPositionSeconds >= sub.startSeconds &&
          _currentPositionSeconds <= sub.endSeconds) {
        return sub.text;
      }
    }
    return lesson.subtitles.isNotEmpty ? lesson.subtitles.first.text : '';
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _getLesson();
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final activeSubtitle = _getCurrentSubtitle(lesson);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lesson.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Share Lesson',
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lesson link copied! Share with your classmates: vidyaguru.gov.in/watch/${lesson.id}'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Report Misuse',
            icon: const Icon(Icons.flag_outlined, color: AppColors.coral),
            onPressed: () => _showReportMisuseDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Simulated 60fps Video Player Canvas with Lip-Sync Avatar & Persistent Watermark
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Animated Stage Background & Teacher Avatar Canvas
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.9,
                        colors: [
                          lesson.teacherAvatar.themeColor.withOpacity(0.95),
                          Colors.black87,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AvatarCircle(
                            avatar: lesson.teacherAvatar,
                            radius: 40,
                            isSelected: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            lesson.teacherAvatar.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Synthesized in ${lesson.languageName} • ${lesson.teachingStyle.label}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Persistent Watermark Overlay (MANDATORY REQUIREMENT)
                  AiVideoWatermarkOverlay(
                    teacherName: lesson.teacherAvatar.name,
                    languageName: lesson.languageName,
                  ),

                  // Subtitles Rendering Overlay (in selected language)
                  if (_showSubtitles && activeSubtitle.isNotEmpty)
                    Positioned(
                      bottom: 48,
                      left: 16,
                      right: 16,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            activeSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Bottom Media Controls Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Seek slider
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                              trackHeight: 3,
                              activeTrackColor: AppColors.saffron,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.saffron,
                            ),
                            child: Slider(
                              value: _currentPositionSeconds.clamp(0, lesson.durationSeconds.toDouble()),
                              min: 0,
                              max: lesson.durationSeconds.toDouble(),
                              onChanged: (val) {
                                setState(() => _currentPositionSeconds = val);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() => _isPlaying = !_isPlaying);
                                },
                              ),
                              Text(
                                '${_formatTime(_currentPositionSeconds)} / ${_formatTime(lesson.durationSeconds.toDouble())}',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                              const Spacer(),
                              // Speed selector
                              PopupMenuButton<double>(
                                initialValue: _playbackSpeed,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white38),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${_playbackSpeed}x',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onSelected: (speed) {
                                  setState(() => _playbackSpeed = speed);
                                },
                                itemBuilder: (context) => _speeds.map((s) {
                                  return PopupMenuItem<double>(
                                    value: s,
                                    child: Text('${s}x'),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 8),
                              // Subtitles toggle
                              IconButton(
                                icon: Icon(
                                  _showSubtitles ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                                  color: _showSubtitles ? AppColors.saffron : Colors.white60,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() => _showSubtitles = !_showSubtitles);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Primary Interactive Actions: Ask a Doubt & Take Quiz
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/doubt-solver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                    icon: const Icon(Icons.psychology_alt_rounded, size: 18),
                    label: const Text('Ask a Doubt', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/quiz/${lesson.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffronDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: const Text('Take Quiz', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: lesson.isDownloaded ? 'Downloaded Offline' : 'Download for Offline',
                  icon: Icon(
                    lesson.isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                    color: lesson.isDownloaded ? AppColors.emerald : AppColors.primary,
                  ),
                  onPressed: () {
                    ref.read(lessonsProvider.notifier).toggleDownload(lesson.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lesson.isDownloaded
                              ? 'Removed from offline storage'
                              : 'Saved offline for low-data revision!',
                        ),
                        backgroundColor: AppColors.emerald,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Tabs: Key Points, Chapters, Transcript
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'Key Points'),
              Tab(text: 'Chapters'),
              Tab(text: 'Transcript'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Key Exam Points
                _buildKeyPointsTab(lesson),
                // 2. Chapters Markers
                _buildChaptersTab(lesson),
                // 3. Transcript
                _buildTranscriptTab(lesson),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPointsTab(Lesson lesson) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: lesson.keyPoints.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.saffronContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, size: 16, color: AppColors.saffronDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lesson.keyPoints[idx],
                  style: const TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChaptersTab(Lesson lesson) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: lesson.chapters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final chapter = lesson.chapters[idx];
        final isCurrent = _currentPositionSeconds >= chapter.timestampSeconds &&
            (idx == lesson.chapters.length - 1 ||
                _currentPositionSeconds < lesson.chapters[idx + 1].timestampSeconds);

        return InkWell(
          onTap: () {
            setState(() {
              _currentPositionSeconds = chapter.timestampSeconds.toDouble();
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.primaryContainer : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCurrent ? AppColors.primary : AppColors.borderLight,
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    chapter.formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        chapter.summary,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isCurrent ? Icons.volume_up_rounded : Icons.play_arrow_outlined,
                  size: 18,
                  color: isCurrent ? AppColors.primary : Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranscriptTab(Lesson lesson) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Full Indic Transcript (${lesson.languageName})',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const AiGeneratedBadge(compact: true),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lesson.scriptText,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  void _showReportMisuseDialog(BuildContext context) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.report_problem_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Report Inaccuracy or Misuse'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VidyaGuru maintains strict ethical education standards. '
              'Please specify if this video contains conceptual errors, unauthorized likeness, or inappropriate language.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe issue with timestamp...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report logged. Trust & Safety committee will review this generation.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Submit Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
