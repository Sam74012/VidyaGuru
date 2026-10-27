import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/teacher_avatar.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/teacher_brain_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';
import '../../../core/widgets/watermark_badge.dart';

class DoubtSolverScreen extends ConsumerStatefulWidget {
  const DoubtSolverScreen({super.key});

  @override
  ConsumerState<DoubtSolverScreen> createState() => _DoubtSolverScreenState();
}

class _DoubtSolverScreenState extends ConsumerState<DoubtSolverScreen> {
  final TextEditingController _queryController = TextEditingController(
    text: 'ক্রিয়া এবং প্রতিক্রিয়া বল কেন একে অপরকে কাটাকাটি (cancel) করে না?',
  );

  bool _isGeneratingAnswer = false;
  DoubtResponse? _doubtAnswer;
  late TeacherAvatar _activeTeacher;

  @override
  void initState() {
    super.initState();
    _activeTeacher = ref.read(repositoryProvider).allAvatars.first;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _submitDoubt() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isGeneratingAnswer = true);
    final brain = ref.read(teacherBrainServiceProvider);
    final lang = ref.read(currentLanguageProvider);

    final response = await brain.solveDoubt(
      lessonId: 'newton_doubt',
      doubtQuery: query,
      avatar: _activeTeacher,
      languageCode: lang.code,
      style: TeachingStyle.warmTeacher,
    );

    if (mounted) {
      setState(() {
        _doubtAnswer = response;
        _isGeneratingAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(currentLanguageProvider);
    final avatars = ref.watch(avatarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Instant Doubt Solver'),
        actions: [
          // Teacher Selector Chip
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<TeacherAvatar>(
              child: Chip(
                avatar: AvatarCircle(avatar: _activeTeacher, radius: 12, showVerifiedBadge: false),
                label: Text(_activeTeacher.name, style: const TextStyle(fontSize: 11)),
              ),
              onSelected: (avatar) {
                setState(() => _activeTeacher = avatar);
              },
              itemBuilder: (context) => avatars.map((a) {
                return PopupMenuItem(
                  value: a,
                  child: Row(
                    children: [
                      AvatarCircle(avatar: a, radius: 14, showVerifiedBadge: false),
                      const SizedBox(width: 8),
                      Text(a.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Input Card: Type, Speak, Snap
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'What concept is confusing you?',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      const Spacer(),
                      Text(
                        lang.nativeName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffronDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _queryController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type your doubt here in any language or Hinglish...',
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Voice Query Button
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _queryController.text = 'ক্রিকেট বল ধরার সময় হাত কেন পেছনের দিকে টানা হয়?';
                          });
                        },
                        icon: const Icon(Icons.mic_rounded, size: 16),
                        label: const Text('Speak', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      // Photo Doubt Button
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _queryController.text = 'বন্দুকের রিকয়েল বেগের সূত্রের গাণিতিক প্রমাণ বুঝিয়ে দিন।';
                          });
                        },
                        icon: const Icon(Icons.camera_alt_rounded, size: 16),
                        label: const Text('Snap Photo', style: TextStyle(fontSize: 12)),
                      ),
                      const Spacer(),
                      // Ask Teacher CTA
                      ElevatedButton(
                        onPressed: _isGeneratingAnswer ? null : _submitDoubt,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.saffronDark,
                          foregroundColor: Colors.white,
                        ),
                        child: _isGeneratingAnswer
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Ask Teacher'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Generating State
          if (_isGeneratingAnswer)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '${_activeTeacher.name} is preparing a short video answer...',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Synthesizing explanation in ${lang.nativeName} with lip-sync',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

          // Answer Result Card
          if (_doubtAnswer != null && !_isGeneratingAnswer) ...[
            // Video Answer Canvas
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _activeTeacher.themeColor,
                              Colors.black87,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AvatarCircle(avatar: _activeTeacher, radius: 32, isSelected: true),
                              const SizedBox(height: 8),
                              Text(
                                '${_activeTeacher.name} • 45s Doubt Response',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: AiVideoWatermarkOverlay(
                          teacherName: _activeTeacher.name,
                          languageName: lang.nativeName,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Teacher\'s Answer Summary:',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _doubtAnswer!.answerSummary,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Detailed Conceptual Explanation:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _doubtAnswer!.fullExplanation,
                          style: const TextStyle(fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 6,
                          children: _doubtAnswer!.relatedConcepts.map((tag) {
                            return Chip(
                              label: Text(tag, style: const TextStyle(fontSize: 10)),
                              backgroundColor: AppColors.primaryContainer.withOpacity(0.5),
                              side: BorderSide.none,
                              padding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
