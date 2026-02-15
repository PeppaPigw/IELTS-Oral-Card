import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ielts_oral_reviser/features/questions/domain/question_models.dart';
import 'package:ielts_oral_reviser/features/questions/presentation/widgets/question_panel.dart';

void main() {
  testWidgets('tapping toggle button reveals and hides the answer',
      (WidgetTester tester) async {
    const question = QuestionItem(
      id: 'apps-1',
      ordinal: 1,
      prompt: 'What is the most popular app in your country?',
      answer: 'The most popular app is TikTok.',
    );

    var answerVisible = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: QuestionPanel(
                  question: question,
                  index: 0,
                  total: 1,
                  answerVisible: answerVisible,
                  onToggleAnswer: () {
                    setState(() {
                      answerVisible = !answerVisible;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(
        find.text('Answer hidden. Tap to reveal and practice speaking first.'),
        findsOneWidget);
    expect(find.text(question.answer), findsNothing);

    await tester.tap(find.byKey(const Key('toggle-answer')));
    await tester.pumpAndSettle();

    expect(find.text(question.answer), findsOneWidget);

    await tester.tap(find.byKey(const Key('toggle-answer')));
    await tester.pumpAndSettle();

    expect(find.text(question.answer), findsNothing);
  });
}
