import '../domain/question_models.dart';

class IeltsMarkdownParser {
  static final RegExp _topicPattern = RegExp(r'^\s*##\s+(.+?)\s*$');
  static final RegExp _questionPattern = RegExp(
    r'^\s*(?:#{1,6}\s*)?(?:q|Q)\s*(\d{1,3})\s*[:：\-.]?\s*(.+?)\s*$',
  );

  QuestionBank parse(String markdown, {required String contentHash}) {
    final lines = markdown.split('\n');
    final builtTopics = <QuestionTopic>[];

    String currentTopic = 'General';
    var currentQuestions = <QuestionItem>[];
    String? currentPrompt;
    var currentOrdinal = 0;
    final currentAnswerLines = <String>[];

    void flushQuestion() {
      if (currentPrompt == null) {
        return;
      }
      currentOrdinal += 1;
      final normalizedAnswer = _normalizeAnswer(currentAnswerLines);
      final answerText = normalizedAnswer.isEmpty
          ? '(No prepared answer yet.)'
          : normalizedAnswer;
      currentQuestions = [
        ...currentQuestions,
        QuestionItem(
          id: '${_slugify(currentTopic)}-$currentOrdinal',
          ordinal: currentOrdinal,
          prompt: currentPrompt!.trim(),
          answer: answerText,
        ),
      ];
      currentPrompt = null;
      currentAnswerLines.clear();
    }

    void flushTopic() {
      flushQuestion();
      if (currentQuestions.isEmpty) {
        return;
      }
      builtTopics
          .add(QuestionTopic(title: currentTopic, questions: currentQuestions));
      currentQuestions = <QuestionItem>[];
      currentOrdinal = 0;
    }

    for (final line in lines) {
      final topicMatch = _topicPattern.firstMatch(line);
      if (topicMatch != null) {
        flushTopic();
        currentTopic = topicMatch.group(1)!.trim();
        continue;
      }

      final questionMatch = _questionPattern.firstMatch(line);
      if (questionMatch != null) {
        flushQuestion();
        currentPrompt = questionMatch.group(2)!.trim();
        continue;
      }

      if (currentPrompt != null) {
        currentAnswerLines.add(line);
      }
    }

    flushTopic();

    return QuestionBank(topics: builtTopics, contentHash: contentHash);
  }

  String _normalizeAnswer(List<String> lines) {
    if (lines.isEmpty) {
      return '';
    }

    var start = 0;
    var end = lines.length - 1;

    while (start <= end && lines[start].trim().isEmpty) {
      start += 1;
    }

    while (end >= start && lines[end].trim().isEmpty) {
      end -= 1;
    }

    if (start > end) {
      return '';
    }

    final trimmed = lines.sublist(start, end + 1);
    final normalized = <String>[];

    for (final line in trimmed) {
      final content = line.trimRight();
      if (content.trim().isEmpty) {
        if (normalized.isNotEmpty && normalized.last.isNotEmpty) {
          normalized.add('');
        }
      } else {
        normalized.add(content);
      }
    }

    return normalized.join('\n').trim();
  }

  String _slugify(String text) {
    final lowercase = text.toLowerCase();
    final cleaned = lowercase.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return cleaned.replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
