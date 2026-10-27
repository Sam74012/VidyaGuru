import '../services/content_parser_service.dart';

class MockContentParserService implements ContentParserService {
  @override
  Future<ParsedContent> parseInput({
    required InputContentType type,
    String? filePath,
    String? rawText,
    String? languageHint,
  }) async {
    // Simulate real document OCR and speech-to-text tokenization delay
    await Future.delayed(const Duration(milliseconds: 1400));

    if (rawText != null && rawText.trim().isNotEmpty) {
      return ParsedContent(
        title: _deriveTitle(rawText),
        subject: 'General Science',
        grade: 'Class 10 / 11 NCERT',
        extractedText: rawText,
        extractedKeyTerms: ['Concept Definitions', 'Core Mechanics', 'Exam Formulations'],
        detectedFormulasOrConcepts: ['F = ma', 'p = mv', 'Conservation Law'],
        sourceContentType: type,
        sourceFileName: 'Student_Notes_Input.txt',
        pageOrDurationCount: 1,
      );
    }

    // Default rich sample parsed from PDF / Textbook image / Voice note
    return const ParsedContent(
      title: 'Newton\'s Laws of Motion & Conservation of Momentum',
      subject: 'Physics',
      grade: 'Class 11 (NCERT & State Board)',
      extractedText:
          'Isaac Newton formulated three fundamental laws of motion in Principia Mathematica (1687). '
          '1. Law of Inertia: An object remains at rest or in uniform motion unless acted upon by a net external force. '
          '2. F = dp/dt = ma: The rate of change of momentum is proportional to the applied unbalanced force. '
          '3. Action and Reaction: For every action, there is an equal and opposite reaction acting on different bodies. '
          'Conservation of Linear Momentum: In an isolated system with no external net force, total initial momentum equals total final momentum (m1u1 + m2u2 = m1v1 + m2v2). '
          'High frequency exam application: Recoil of gun, rocket propulsion, elastic vs inelastic collisions.',
      extractedKeyTerms: [
        'Inertia (জড়তা / जड़त्व)',
        'Momentum (ভরবেগ / संवेग)',
        'External Force (বাহ্যিক বল / बाह्य बल)',
        'Impulse (বলের ঘাত / आवेग)',
        'Elastic Collisions'
      ],
      detectedFormulasOrConcepts: [
        r'F_{net} = \frac{dp}{dt} = m \cdot a',
        r'p = m \cdot v \quad [kg \cdot m/s]',
        r'm_1 u_1 + m_2 u_2 = m_1 v_1 + m_2 v_2',
        r'J = \int F \, dt = \Delta p'
      ],
      sourceContentType: InputContentType.pdf,
      sourceFileName: 'NCERT_Class11_Physics_Chapter5_LawsOfMotion.pdf',
      pageOrDurationCount: 6,
    );
  }

  String _deriveTitle(String text) {
    final firstLine = text.split('\n').first.trim();
    if (firstLine.length > 5 && firstLine.length < 50) return firstLine;
    return 'Custom Explainer Notes';
  }
}
