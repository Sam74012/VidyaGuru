import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/content_parser_service.dart';
import '../../../core/services/teacher_brain_service.dart';
import '../../../core/theme/app_colors.dart';

class ScriptEditorScreen extends ConsumerStatefulWidget {
  const ScriptEditorScreen({super.key});

  @override
  ConsumerState<ScriptEditorScreen> createState() => _ScriptEditorScreenState();
}

class _ScriptEditorScreenState extends ConsumerState<ScriptEditorScreen> {
  GeneratedScript? _script;
  bool _isLoading = true;
  bool _isRefining = false;
  TeachingStyle _selectedStyle = TeachingStyle.warmTeacher;
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadScript();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _loadScript() async {
    setState(() => _isLoading = true);
    final brain = ref.read(teacherBrainServiceProvider);
    final parser = ref.read(contentParserServiceProvider);
    final lang = ref.read(currentLanguageProvider);
    final avatar = ref.read(repositoryProvider).allAvatars.first;

    final parsed = await parser.parseInput(
      type: InputContentType.pdf,
      languageHint: lang.code,
    );

    final generated = await brain.generateScript(
      content: parsed,
      language: lang,
      style: _selectedStyle,
      avatar: avatar,
    );

    if (mounted) {
      setState(() {
        _script = generated;
        _isLoading = false;
      });
    }
  }

  Future<void> _changeStyle(TeachingStyle newStyle) async {
    if (_script == null) return;
    setState(() {
      _selectedStyle = newStyle;
      _isLoading = true;
    });

    final brain = ref.read(teacherBrainServiceProvider);
    final parser = ref.read(contentParserServiceProvider);
    final lang = ref.read(currentLanguageProvider);
    final avatar = ref.read(repositoryProvider).allAvatars.first;

    final parsed = await parser.parseInput(
      type: InputContentType.pdf,
      languageHint: lang.code,
    );

    final updated = await brain.generateScript(
      content: parsed,
      language: lang,
      style: newStyle,
      avatar: avatar,
    );

    if (mounted) {
      setState(() {
        _script = updated;
        _isLoading = false;
      });
    }
  }

  Future<void> _refineWithPrompt() async {
    if (_script == null || _promptController.text.trim().isEmpty) return;
    setState(() => _isRefining = true);

    final brain = ref.read(teacherBrainServiceProvider);
    final refined = await brain.refineScript(
      currentScript: _script!,
      prompt: _promptController.text.trim(),
      targetStyle: _selectedStyle,
    );

    if (mounted) {
      setState(() {
        _script = refined;
        _isRefining = false;
        _promptController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Script adapted to your revision request!'),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  Future<void> _launchVideoPipeline() async {
    if (_script == null) return;
    final orchestrator = ref.read(pipelineOrchestratorProvider);
    final avatar = ref.read(repositoryProvider).allAvatars.first;
    final lang = ref.read(currentLanguageProvider);

    final job = await orchestrator.startJob(
      title: _script!.title,
      subject: 'Physics',
      inputSourceName: 'NCERT_Physics_LawsOfMotion.pdf',
      inputSnippet: _script!.sections.first.scriptText,
      avatar: avatar,
      language: lang,
      teachingStyle: _selectedStyle,
      script: _script!,
    );

    if (mounted) {
      context.push('/generation-progress/${job.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(currentLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Script Studio ("Teacher\'s Brain")'),
        actions: [
          IconButton(
            tooltip: 'Regenerate script',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _loadScript,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: (_isLoading || _script == null) ? null : _launchVideoPipeline,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffronDark,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.videocam_rounded),
            label: const Text(
              'Approve Script & Start Video Pipeline',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Teacher\'s Brain synthesizing pedagogical script...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Script Meta Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${lang.nativeName} (${lang.englishName})',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedStyle.badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedStyle.label,
                        style: TextStyle(
                          color: _selectedStyle.badgeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '~${_script?.totalEstimatedDurationSeconds ?? 160} sec',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  _script?.title ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                // Tone Switcher Chips
                const Text(
                  'Switch Tone & Pedagogy:',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: TeachingStyle.values.map((style) {
                    final isSelected = _selectedStyle == style;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Text(style.label),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      selectedColor: style.badgeColor,
                      avatar: Icon(style.iconData, size: 16, color: isSelected ? Colors.white : style.badgeColor),
                      onSelected: (val) {
                        if (val) _changeStyle(style);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // High Yield Exam Pointers Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.saffronContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.saffron.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.stars_rounded, color: AppColors.saffronDark, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Key High-Yield Exam Points Identified by AI:',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: AppColors.onSaffronContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...?_script?.highYieldExamPointers.map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(point, style: const TextStyle(fontSize: 12, height: 1.3)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Script Sections with Visual Cues
                const Text(
                  'Lesson Breakdown (Editable Timed Chapters):',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 10),

                ...?_script?.sections.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final sec = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  sec.title,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '~${sec.estimatedSeconds}s',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: sec.scriptText,
                            maxLines: null,
                            style: const TextStyle(fontSize: 14, height: 1.45),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            onChanged: (text) {
                              _script!.sections[idx] = sec.copyWith(scriptText: text);
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.art_track_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Visual Cue: ${sec.visualCue}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Prompt Refinement Bar
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Refine with AI Instruction:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promptController,
                              decoration: const InputDecoration(
                                hintText: 'e.g., make it simpler, add more rocket examples...',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _isRefining ? null : _refineWithPrompt,
                            child: _isRefining
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Refine'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
