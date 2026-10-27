# VidyaGuru (विद्यागुरु / বিদ্যাগুরু) 🎓🇮🇳

**Personal AI Regional Explainer & Digital Tutor for Bharat**


---

## 🌟 Overview

**VidyaGuru** turns any study material (PDF, textbook photo, voice query, or video clip) into a short, personalized explainer video featuring a verified teacher's face, voice, and speaking style in Indian regional languages (*Bengali, Hindi, Tamil, Telugu, Marathi, Gujarati, Kannada, Malayalam, Punjabi, and English*).

VidyaGuru is built with **Flutter**, **Riverpod**, and **GoRouter**, designed for low-cost Android smartphones in rural areas as well as iOS, Web, Windows, and macOS.

---

## 🛠️ Complete End-to-End Demo Path

To showcase the full capability during live judge evaluation, follow this demo path:

1. **Launch App**: App opens on the **Home Screen** (pre-set to Bengali for the Innovation Challenge showcase).
2. **Create New Lesson**: Tap **"নতুন পাঠ তৈরি করুন" (Create New Lesson)** on the Home Screen.
3. **Upload Material**: Select **Upload PDF / Doc** (or tap **Snap Page** / paste custom notes). Tap **"Extract Concepts with AI Parser"**.
4. **Choose Teacher**: Select preset avatar **Dr. Ananya Roy** (*Senior Physics Faculty*).
5. **Language & Tone**: Select **বাংলা (Bengali)** and **Warm Teacher** style.
6. **AI Script Studio**: Preview and edit the AI-generated script with key exam points highlighted. Tap **"Approve Script & Start Video Pipeline"**.
7. **Watch Generation Progress**: Observe the live, animated 4-stage pipeline updates:
   - **Stage 1: Voice Cloner** (Acoustic waveform synthesis)
   - **Stage 2: Face Swapper** (3D mesh landmark alignment)
   - **Stage 3: Cinematic Lip-Sync Engine** (Phoneme-to-viseme alignment at 60fps)
   - **Stage 4: Composite Engine** (Multi-track merge, persistent watermark, subtitles)
8. **Play Explainer Video**: Tap **"Watch Explainer Video Now"** to view the final video with persistent AI watermark, regional subtitles, speed control, chapter markers, and transcript tab.
9. **Ask a Doubt**: Tap **"Ask a Doubt"**, submit a question (or tap microphone/camera), and get an instant video answer from Dr. Roy.
10. **Take Quiz**: Tap **"Take Quiz"** to answer auto-generated MCQs based on the lesson and receive a weak-topic summary.

---

## 🏗️ Architecture & Folder Structure

VidyaGuru follows a **Feature-First Clean Architecture**:

```
lib/
├── core/
│   ├── config/              # AppConfig, RegionalLanguage, TeachingStyle, UserRole
│   ├── localization/        # AppLocalizations (English, Hindi, Bengali, 10 Indic scripts)
│   ├── mocks/               # Mock implementations for offline simulation
│   │   ├── mock_content_parser_service.dart
│   │   ├── mock_teacher_brain_service.dart
│   │   ├── mock_pipeline_services.dart  (Voice, Face, LipSync, Composite)
│   │   ├── mock_consent_service.dart
│   │   └── mock_repository.dart
│   ├── models/              # Lesson, TeacherAvatar, Job, Consent, Quiz
│   ├── providers/           # Riverpod state providers
│   ├── router/              # GoRouter navigation setup
│   ├── services/            # Abstract service interfaces
│   │   ├── content_parser_service.dart
│   │   ├── teacher_brain_service.dart
│   │   ├── voice_clone_service.dart
│   │   ├── face_swap_service.dart
│   │   ├── lip_sync_service.dart
│   │   ├── composite_service.dart
│   │   └── consent_service.dart
│   ├── theme/               # Material 3 Custom Palette (Indigo, Saffron, Emerald)
│   └── widgets/             # AvatarCircle, AiVideoWatermarkOverlay, SkeletonLoader, MainScaffold
├── features/
│   ├── onboarding/          # 3-slide introduction, role & language picker
│   ├── home/                # Subject filters, create lesson CTA, continue watching
│   ├── create_lesson/       # Stepper: Upload -> Teacher -> Language & Style -> Review
│   ├── teacher_library/     # Presets grid, custom avatars, mandatory read-aloud consent modal
│   ├── script_editor/       # AI script studio with high-yield exam points & tone switcher
│   ├── generation_progress/ # Live animated 4-stage pipeline progress stream
│   ├── video_player/        # Video canvas, AI watermark overlay, subtitles, chapters, doubts, quiz
│   ├── doubt_solver/        # Voice/photo/text question solver with video response
│   ├── quiz/                # Auto-generated MCQs, score & weak-topic summary
│   ├── library/             # Offline downloads, storage meter, low-bandwidth mode
│   ├── teacher_dashboard/   # Student view stats, class code sharing, avatar revocation
│   ├── settings/            # Role switch, language, data saver, dark mode
│   ├── impact/              # Challenge infographics (rural reach, mother tongue, time saved)
│   └── trust/               # Ethics, zero-tolerance deepfake policy, DPDP compliance
└── main.dart                # App entry point with ProviderScope
```

---

## 🔌 Plugging in the Real AI Backend

A single configuration flag in `lib/core/config/app_config.dart` toggles between offline mock simulation and live production endpoints:

```dart
class AppConfig {
  /// Set to false when connecting to live AI microservices
  static const bool useMockServices = true;
}
```

To plug in real backend microservices, implement the abstract interfaces in `lib/core/services/`:

1. **`ContentParserService`**: Connect to OCR / Speech-to-Text APIs (e.g. Google Cloud Vision / Whisper API / Bhashini).
2. **`TeacherBrainService`**: Connect to LLM endpoint (e.g. Gemini 1.5 Pro / Llama 3) prompt-tuned for Indic pedagogy.
3. **`VoiceCloneService`**: Connect to Voice Cloning API (e.g. ElevenLabs / Murf AI / Bhashini TTS).
4. **`FaceSwapService`**: Connect to 3D facial mesh alignment service (e.g. LivePortrait / DeepFaceLab).
5. **`LipSyncService`**: Connect to Wav2Lip / SadTalker / SyncNet pipeline.
6. **`CompositeService`**: Connect to FFmpeg video compositing & subtitle embedding service.
7. **`ConsentService`**: Connect to a blockchain or encrypted vault for DPDP-compliant consent records.

Then override the providers in `lib/core/providers/app_providers.dart`:

```dart
final teacherBrainServiceProvider = Provider<TeacherBrainService>((ref) {
  return AppConfig.useMockServices
      ? MockTeacherBrainService()
      : LiveTeacherBrainService(); // Replace with live implementation
});
```

---

## ⚡ Setup & Running

### Requirements
- **Flutter SDK**: `^3.13.0` or higher
- **Dart SDK**: `^3.13.0`

### Commands

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run static analyzer (0 issues guaranteed)
flutter analyze

# 3. Run unit and widget test suite
flutter test

# 4. Launch on Android emulator or connected device
flutter run
```

---

## 🛡️ Trust & Ethical AI Safeguards

- **Mandatory Read-Aloud Consent**: Custom avatar creation requires an explicit checkbox flow plus a live recorded verification phrase matching phonemes.
- **Persistent AI Watermark**: Every generated video carries an indelible `AI SYNTHESIZED` overlay to eliminate misinformation.
- **Sovereign Avatar Ownership**: Teachers can revoke their avatar consent at any time from the Teacher Dashboard, instantly locking future synthesis.
- **Misuse Reporting**: Every video player screen includes a direct "Report Misuse" action.

---

## 📜 License & Acknowledgments

Developed for the **Government Innovation Challenge (Education & Skill Development)**.
Built with Flutter & Google Fonts (Noto Sans family for Indic scripts).
