import 'package:flutter_test/flutter_test.dart';
import 'package:ielts_oral_reviser/features/questions/data/ielts_markdown_parser.dart';

void main() {
  group('IeltsMarkdownParser', () {
    test('parses topics, questions, and multi-paragraph answers', () {
      const markdown = '''
# Part 1

## Apps
q1 What's your favorite app?
I like learning apps.

They help me practice daily.

###### q2 Do old people use apps?
Yes, many do.

## Animals
q1 Which animal do you like most?
I like horses the most.
''';

      final parser = IeltsMarkdownParser();
      final bank = parser.parse(markdown, contentHash: 'abc123');

      expect(bank.contentHash, 'abc123');
      expect(bank.topics.length, 2);
      expect(bank.totalQuestions, 3);

      final apps = bank.topics.first;
      expect(apps.title, 'Apps');
      expect(apps.questions.length, 2);
      expect(
        apps.questions.first.answer,
        'I like learning apps.\n\nThey help me practice daily.',
      );

      final animals = bank.topics.last;
      expect(animals.title, 'Animals');
      expect(animals.questions.single.prompt, 'Which animal do you like most?');
    });

    test('uses placeholder answer if no answer text follows a question', () {
      const markdown = '''
## Age
q1 Do you like your current age?
q2 Why?
Because I feel energetic.
''';

      final parser = IeltsMarkdownParser();
      final bank = parser.parse(markdown, contentHash: 'hash');

      expect(bank.topics.single.questions.length, 2);
      expect(
        bank.topics.single.questions.first.answer,
        '(No prepared answer yet.)',
      );
    });
  });
}
