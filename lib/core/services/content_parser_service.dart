enum InputContentType {
  pdf,
  photo,
  voice,
  video,
  rawText,
}

class ParsedContent {
  final String title;
  final String subject;
  final String grade;
  final String extractedText;
  final List<String> extractedKeyTerms;
  final List<String> detectedFormulasOrConcepts;
  final InputContentType sourceContentType;
  final String sourceFileName;
  final int pageOrDurationCount;

  const ParsedContent({
    required this.title,
    required this.subject,
    required this.grade,
    required this.extractedText,
    required this.extractedKeyTerms,
    required this.detectedFormulasOrConcepts,
    required this.sourceContentType,
    required this.sourceFileName,
    required this.pageOrDurationCount,
  });
}

abstract class ContentParserService {
  Future<ParsedContent> parseInput({
    required InputContentType type,
    String? filePath,
    String? rawText,
    String? languageHint,
  });
}
