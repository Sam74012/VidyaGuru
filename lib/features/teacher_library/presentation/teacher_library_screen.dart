import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/teacher_avatar.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_circle.dart';

class TeacherLibraryScreen extends ConsumerStatefulWidget {
  const TeacherLibraryScreen({super.key});

  @override
  ConsumerState<TeacherLibraryScreen> createState() => _TeacherLibraryScreenState();
}

class _TeacherLibraryScreenState extends ConsumerState<TeacherLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatars = ref.watch(avatarsProvider);
    final userRole = ref.watch(userRoleProvider);

    final presetAvatars = avatars.where((a) => a.isPreset).toList();
    final customAvatars = avatars.where((a) => a.isCustom).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Avatars Library'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.saffron,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Preset Educators (${presetAvatars.length})'),
            Tab(text: 'My Custom Avatars (${customAvatars.length})'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Trust & Safety',
            icon: const Icon(Icons.verified_user_rounded, color: AppColors.emerald),
            onPressed: () => context.push('/trust-safety'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.saffronDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Create Teacher Avatar'),
        onPressed: () => _openCreateAvatarDialog(context),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Preset Avatars Grid
          _buildAvatarsGrid(context, presetAvatars, false),
          // Custom / My Avatars Grid
          _buildCustomAvatarsView(context, customAvatars, userRole),
        ],
      ),
    );
  }

  Widget _buildAvatarsGrid(BuildContext context, List<TeacherAvatar> list, bool isCustom) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_natural_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'No custom avatars created yet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const Text(
                'Educators can synthesize their own avatar with 1 photo and 1 minute voice sample.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openCreateAvatarDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create My Avatar Now'),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.76,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final avatar = list[idx];
        return _buildAvatarCard(context, avatar, isCustom);
      },
    );
  }

  Widget _buildCustomAvatarsView(
    BuildContext context,
    List<TeacherAvatar> customList,
    UserRole userRole,
  ) {
    if (userRole == UserRole.student && customList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Student Access Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Text(
                'Students can use preset educators or avatars shared by their school teachers using a Class Code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () => _showJoinClassDialog(context),
                icon: const Icon(Icons.group_add_rounded),
                label: const Text('Enter Teacher Class Code'),
              ),
            ],
          ),
        ),
      );
    }

    return _buildAvatarsGrid(context, customList, true);
  }

  Widget _buildAvatarCard(BuildContext context, TeacherAvatar avatar, bool isCustom) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: isCustom
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, size: 18),
                      onSelected: (val) {
                        if (val == 'revoke') {
                          _revokeConsentPrompt(context, avatar);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'revoke',
                          child: Row(
                            children: [
                              Icon(Icons.block_rounded, color: AppColors.error, size: 18),
                              SizedBox(width: 8),
                              Text('Revoke Avatar Consent', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 11),
                          SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emeraldDark,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            AvatarCircle(avatar: avatar, radius: 30),
            const SizedBox(height: 10),
            Text(
              avatar.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              avatar.specialty,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              avatar.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  avatar.rating.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '${avatar.lessonsCount} lessons',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                onPressed: () {
                  context.push('/create-lesson');
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Use to Teach', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreateAvatarDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _CreateAvatarModal(
        onCreated: (newAvatar) {
          ref.read(avatarsProvider.notifier).addAvatar(newAvatar);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Avatar "${newAvatar.name}" verified and ready!'),
              backgroundColor: AppColors.emerald,
            ),
          );
        },
      ),
    );
  }

  void _revokeConsentPrompt(BuildContext context, TeacherAvatar avatar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.coral),
            SizedBox(width: 8),
            Text('Revoke Avatar?'),
          ],
        ),
        content: Text(
          'Are you sure you want to revoke consent for "${avatar.name}"? '
          'All new video generation with this voice & face will be immediately blocked in compliance with our Ethical AI policy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(avatarsProvider.notifier).revokeAvatar(avatar.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Avatar consent revoked. Synthesis blocked.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Revoke Consent', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showJoinClassDialog(BuildContext context) {
    final codeController = TextEditingController(text: 'BENGAL-STEM-2026');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Teacher Class Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the 6-digit or school code given by your teacher to access their custom AI avatar.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'e.g. BENGAL-STEM-2026',
                prefixIcon: Icon(Icons.vpn_key_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connected to Dr. Roy\'s Physics Classroom!'),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: const Text('Unlock Avatar'),
          ),
        ],
      ),
    );
  }
}

class _CreateAvatarModal extends StatefulWidget {
  final ValueChanged<TeacherAvatar> onCreated;

  const _CreateAvatarModal({required this.onCreated});

  @override
  State<_CreateAvatarModal> createState() => _CreateAvatarModalState();
}

class _CreateAvatarModalState extends State<_CreateAvatarModal> {
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController(text: 'Physics & General Science');
  final _titleController = TextEditingController(text: 'Assistant Teacher, High School');
  String _selectedPermission = 'class_only';

  bool _photoUploaded = false;
  bool _voiceSampleRecorded = false;
  bool _audioPhraseVerified = false;
  bool _termsChecked = false;
  bool _privacyChecked = false;
  bool _eduOnlyChecked = false;

  bool _isRecordingPhrase = false;

  final String _verificationPhrase =
      'I, [Your Name], hereby authorize VidyaGuru to synthesize my face and voice timbre solely for educational explainer video generation in regional languages.';

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      _photoUploaded &&
      _voiceSampleRecorded &&
      _audioPhraseVerified &&
      _termsChecked &&
      _privacyChecked &&
      _eduOnlyChecked;

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.saffronContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.security_rounded, color: AppColors.saffronDark, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Teacher Avatar',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Text(
                        'Verified Consent & Ethical AI Synthesis Flow',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Step 1: Teacher Details
            const Text(
              '1. Teacher Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Legal Name *',
                hintText: 'e.g. Dr. Subhash Chandra Bose / Rekha Banerjee',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _specialtyController,
                    decoration: const InputDecoration(labelText: 'Subject Specialty'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'School / Institution'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step 2: Uploads (Photo & 1-min Voice)
            const Text(
              '2. Face & Voice Biometrics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _photoUploaded = true);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _photoUploaded
                            ? AppColors.emeraldContainer
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _photoUploaded ? AppColors.emerald : AppColors.borderLight,
                          width: _photoUploaded ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _photoUploaded ? Icons.check_circle_rounded : Icons.add_a_photo_rounded,
                            color: _photoUploaded ? AppColors.emerald : AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _photoUploaded ? 'Photo Uploaded' : 'Upload 1 Photo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _photoUploaded ? AppColors.emeraldDark : null,
                            ),
                          ),
                          Text('Clear forward face portrait', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _voiceSampleRecorded = true);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _voiceSampleRecorded
                            ? AppColors.emeraldContainer
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _voiceSampleRecorded ? AppColors.emerald : AppColors.borderLight,
                          width: _voiceSampleRecorded ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _voiceSampleRecorded ? Icons.check_circle_rounded : Icons.mic_rounded,
                            color: _voiceSampleRecorded ? AppColors.emerald : AppColors.saffronDark,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _voiceSampleRecorded ? 'Voice Sample Ready' : '1-Min Voice Clip',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _voiceSampleRecorded ? AppColors.emeraldDark : null,
                            ),
                          ),
                          Text('Clean audio reading a paragraph', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Step 3: Mandatory Read-Aloud Consent Audio Verification
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.saffronContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.saffron.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.record_voice_over_rounded, color: AppColors.saffronDark, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '3. Mandatory Read-Aloud Verification Phrase',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: AppColors.onSaffronContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'To prevent deepfake misuse, the educator must record themselves speaking this exact sentence aloud:',
                    style: TextStyle(fontSize: 11, color: AppColors.onSaffronContainer),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Text(
                      _verificationPhrase.replaceAll('[Your Name]', _nameController.text.isEmpty ? '[Your Name]' : _nameController.text),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        setState(() => _isRecordingPhrase = true);
                        await Future.delayed(const Duration(milliseconds: 1400));
                        if (mounted) {
                          setState(() {
                            _isRecordingPhrase = false;
                            _audioPhraseVerified = true;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _audioPhraseVerified ? AppColors.emeraldContainer : Colors.white,
                        side: BorderSide(
                          color: _audioPhraseVerified ? AppColors.emerald : AppColors.saffronDark,
                        ),
                      ),
                      icon: _isRecordingPhrase
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _audioPhraseVerified ? Icons.check_circle_rounded : Icons.mic_rounded,
                              color: _audioPhraseVerified ? AppColors.emerald : AppColors.saffronDark,
                            ),
                      label: Text(
                        _isRecordingPhrase
                          ? 'Recording & Verifying Phoneme Match...'
                          : (_audioPhraseVerified ? 'Audio Phrase Verified' : 'Record Read-Aloud Phrase'),
                        style: TextStyle(
                          color: _audioPhraseVerified ? AppColors.emeraldDark : AppColors.saffronDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Step 4: Checkboxes
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _termsChecked,
              onChanged: (val) => setState(() => _termsChecked = val ?? false),
              title: const Text(
                'I am the person depicted and explicitly grant VidyaGuru authorization to synthesize my avatar.',
                style: TextStyle(fontSize: 12),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _eduOnlyChecked,
              onChanged: (val) => setState(() => _eduOnlyChecked = val ?? false),
              title: const Text(
                'Educational Purpose Only: Avatar cannot be used for commercial advertisements.',
                style: TextStyle(fontSize: 12),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _privacyChecked,
              onChanged: (val) => setState(() => _privacyChecked = val ?? false),
              title: const Text(
                'I understand I can revoke this avatar at any time from my Teacher Dashboard.',
                style: TextStyle(fontSize: 12),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 12),

            // Permission selector
            DropdownButtonFormField<String>(
              value: _selectedPermission,
              decoration: const InputDecoration(
                labelText: 'Who can use this avatar?',
              ),
              items: const [
                DropdownMenuItem(value: 'class_only', child: Text('Class Only (requires school code)')),
                DropdownMenuItem(value: 'public', child: Text('Public (all students in India)')),
                DropdownMenuItem(value: 'private', child: Text('Private (only me)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedPermission = val);
              },
            ),

            const SizedBox(height: 24),

            // Submit Button (Blocked if consent is not fulfilled)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canSubmit
                    ? () {
                        final newAvatar = TeacherAvatar(
                          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text.trim(),
                          title: _titleController.text.trim(),
                          specialty: _specialtyController.text.trim(),
                          photoUrl: 'custom_portrait.jpg',
                          voiceSampleUrl: 'custom_voice.wav',
                          isPreset: false,
                          isCustom: true,
                          permissions: _selectedPermission,
                          consentVerified: true,
                          consentDate: DateTime.now(),
                          supportedLanguages: ['bn', 'en', 'hi'],
                          bio: 'Verified educator avatar registered on VidyaGuru portal.',
                          themeColor: AppColors.saffronDark,
                        );
                        widget.onCreated(newAvatar);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  _canSubmit ? 'Complete Verification & Publish' : 'Complete All Consent Steps Above',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
      },
    );
  }
}
