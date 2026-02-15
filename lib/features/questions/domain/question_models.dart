class QuestionItem {
  const QuestionItem({
    required this.id,
    required this.ordinal,
    required this.prompt,
    required this.answer,
  });

  final String id;
  final int ordinal;
  final String prompt;
  final String answer;
}

class QuestionTopic {
  const QuestionTopic({
    required this.title,
    required this.questions,
  });

  final String title;
  final List<QuestionItem> questions;

  int get questionCount => questions.length;
}

class QuestionBank {
  const QuestionBank({
    required this.topics,
    required this.contentHash,
  });

  final List<QuestionTopic> topics;
  final String contentHash;

  int get totalQuestions =>
      topics.fold<int>(0, (sum, topic) => sum + topic.questions.length);
}
