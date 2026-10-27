import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/teacher_avatar.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/content_parser_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';

class CreateLessonScreen extends ConsumerStatefulWidget {
  const CreateLessonScreen({super.key});

  @override
  ConsumerState<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends ConsumerState<CreateLessonScreen> {
  int _currentStep = 0;

  // Form State
  InputContentType _selectedInputType = InputContentType.pdf;
  String _uploadedFileName = 'NCERT_Class11_Physics_LawsOfMotion.pdf';
  bool _isParsing = false;
  ParsedContent? _parsedContent;

  late TeacherAvatar _selectedAvatar;
  late RegionalLanguage _selectedLanguage;
  TeachingStyle _selectedStyle = TeachingStyle.warmTeacher;

  final TextEditingController _customNotesController = TextEditingController(
    text: 'Newton\'s Laws of Motion: Law of Inertia, F=ma, Action-Reaction, Conservation of Momentum and Gun Recoil.',
  );

  @override
  void initState() {
    super.initState();
    final avatars = ref.read(repositoryProvider).allAvatars;
    _selectedAvatar = avatars.first;
    _selectedLanguage = ref.read(currentLanguageProvider);
  }

  @override
  void dispose() {
    _customNotesController.dispose();
    super.dispose();
  }

  Future<void> _simulateParse() async {
    setState(() => _isParsing = true);
    final parser = ref.read(contentParserServiceProvider);
    final result = await parser.parseInput(
      type: _selectedInputType,
      rawText: _customNotesController.text,
      languageHint: _selectedLanguage.code,
    );
    if (mounted) {
      setState(() {
        _parsedContent = result;
        _isParsing = false;
        _currentStep = 1; // Advance to Teacher & Style
      });
    }
  }

  Future<void> _generateLessonVideo() async {
    // Generate script via TeacherBrainService
    final brain = ref.read(teacherBrainServiceProvider);
    final orchestrator = ref.read(pipelineOrchestratorProvider);

    final parsed = _parsedContent ??
        ParsedContent(
          title: 'Newton\'s Laws of Motion & Momentum',
          subject: 'Physics',
          grade: 'Class 11 / CBSE & State Board',
          extractedText: _customNotesController.text,
          extractedKeyTerms: ['Inertia', 'Momentum', 'Impulse'],
          detectedFormulasOrConcepts: ['F = ma', 'p = mv'],
          sourceContentType: _selectedInputType,
          sourceFileName: _uploadedFileName,
          pageOrDurationCount: 4,
        );

    final script = await brain.generateScript(
      content: parsed,
      language: _selectedLanguage,
      style: _selectedStyle,
      avatar: _selectedAvatar,
    );

    // Launch async generation job
    final job = await orchestrator.startJob(
      title: parsed.title,
      subject: parsed.subject,
      inputSourceName: _uploadedFileName,
      inputSnippet: parsed.extractedText.substring(0, parsed.extractedText.length > 120 ? 120 : parsed.extractedText.length),
      avatar: _selectedAvatar,
      language: _selectedLanguage,
      teachingStyle: _selectedStyle,
      script: script,
    );

    if (mounted) {
      context.push('/generation-progress/${job.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final avatars = ref.watch(avatarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createNewLesson),
        actions: [
          TextButton(
            onPressed: () => context.push('/script-editor'),
            child: const Row(
              children: [
                Icon(Icons.edit_note_rounded, size: 18, color: AppColors.primary),
                SizedBox(width: 4),
                Text('Open Script Studio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) {
          if (step <= _currentStep || _parsedContent != null) {
            setState(() => _currentStep = step);
          }
        },
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: [
          Step(
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text('Input', style: TextStyle(fontSize: 12)),
            content: _buildInputStep(context, l10n),
          ),
          Step(
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text('Teacher', style: TextStyle(fontSize: 12)),
            content: _buildTeacherStep(context, avatars, l10n),
          ),
          Step(
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.indexed : StepState.indexed,
            title: const Text('Language & Tone', style: TextStyle(fontSize: 12)),
            content: _buildLanguageAndStyleStep(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildInputStep(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Choose Source Study Material',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          'Upload textbooks, lecture notes, snaps or audio to extract concepts.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 16),

        // Input Modality Grid (PDF, Photo, Voice, Video)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildInputOption(
              type: InputContentType.pdf,
              title: 'Upload PDF / Doc',
              subtitle: 'NCERT or coaching notes',
              icon: Icons.picture_as_pdf_rounded,
            ),
            _buildInputOption(
              type: InputContentType.photo,
              title: 'Snap Page',
              subtitle: 'Textbook page photo',
              icon: Icons.camera_alt_rounded,
            ),
            _buildInputOption(
              type: InputContentType.voice,
              title: 'Record Voice Note',
              subtitle: 'Speak your query',
              icon: Icons.mic_rounded,
            ),
            _buildInputOption(
              type: InputContentType.video,
              title: 'Video Clip',
              subtitle: 'Teacher lecture clip',
              icon: Icons.videocam_rounded,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Selected Source Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _uploadedFileName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Ready for OCR & pedagogical concept extraction',
                      style: TextStyle(fontSize: 11, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _uploadedFileName = 'Class10_Biology_Chapter6_LifeProcesses.pdf';
                  });
                },
                child: const Text('Change', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Direct Text / Study Notes Field
        const Text(
          'Or paste chapter notes / custom topic summary:',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _customNotesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g., Newton\'s laws of motion, inertia, momentum...',
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),

        const SizedBox(height: 24),

        // Parse Action Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isParsing ? null : _simulateParse,
            child: _isParsing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Extracting Concepts & Diagrams...'),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Extract Concepts with AI Parser'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputOption({
    required InputContentType type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedInputType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedInputType = type;
          if (type == InputContentType.photo) {
            _uploadedFileName = 'Textbook_Page_Photo_IMG_821.jpg';
          } else if (type == InputContentType.voice) {
            _uploadedFileName = 'Student_Recorded_Voice_Query.m4a';
          } else if (type == InputContentType.video) {
            _uploadedFileName = 'Classroom_Board_Clip.mp4';
          } else {
            _uploadedFileName = 'NCERT_Class11_Physics_LawsOfMotion.pdf';
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.grey[700], size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherStep(
    BuildContext context,
    List<TeacherAvatar> avatars,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '2. Select Teacher Avatar',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: () => context.push('/teachers'),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
              label: const Text('Create New Avatar', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Text(
          'Choose a verified educator whose face, voice and pedagogy will explain your lesson.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 16),

        // Teacher Avatar Grid
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: avatars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            final isSelected = _selectedAvatar.id == avatar.id;

            return InkWell(
              onTap: () {
                setState(() => _selectedAvatar = avatar);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.saffronContainer.withOpacity(0.5) : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.saffron : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    AvatarCircle(avatar: avatar, radius: 24, isSelected: isSelected),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                avatar.name,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                              const SizedBox(width: 6),
                              if (avatar.consentVerified)
                                const Icon(Icons.verified_rounded, size: 15, color: AppColors.emerald),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            avatar.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: avatar.supportedLanguages.map((code) {
                              final lang = AppLanguages.getByCode(code);
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  lang.nativeName,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: avatar.id,
                      groupValue: _selectedAvatar.id,
                      activeColor: AppColors.saffronDark,
                      onChanged: (val) {
                        setState(() => _selectedAvatar = avatar);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: const Text('Back to Input'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 2),
                child: const Text('Next: Language & Style'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageAndStyleStep(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Select Regional Language & Teaching Style',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          'The AI synthesizes the lesson in this Indic dialect with authentic regional cadence.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 14),

        // Language Dropdown / Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RegionalLanguage>(
              isExpanded: true,
              value: _selectedLanguage,
              items: AppLanguages.all.map((lang) {
                return DropdownMenuItem<RegionalLanguage>(
                  value: lang,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lang.nativeName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${lang.englishName} (${lang.nativeName})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLanguage = val);
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Teacher\'s Speaking Style (Tone & Pedagogy):',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 10),

        // Teaching Style Cards
        ...TeachingStyle.values.map((style) {
          final isSelected = _selectedStyle == style;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => setState(() => _selectedStyle = style),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? style.badgeColor.withOpacity(0.12)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? style.badgeColor : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: style.badgeColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(style.iconData, color: style.badgeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                style.label,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${style.indicLabel}',
                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            style.description,
                            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Radio<TeachingStyle>(
                      value: style,
                      groupValue: _selectedStyle,
                      activeColor: style.badgeColor,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStyle = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Action Buttons: Review Script & Generate
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/script-editor'),
                child: const Text('Preview Script First'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _generateLessonVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffronDark,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Generate Video'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
