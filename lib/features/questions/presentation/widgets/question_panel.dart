import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_models.dart';

class QuestionPanel extends StatelessWidget {
  const QuestionPanel({
    required this.question,
    required this.index,
    required this.total,
    required this.answerVisible,
    required this.onToggleAnswer,
    super.key,
  });

  final QuestionItem question;
  final int index;
  final int total;
  final bool answerVisible;
  final VoidCallback onToggleAnswer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final estimatedSeconds = _estimateSpeakingSeconds(question.answer);
    final compact = MediaQuery.sizeOf(context).height < 760;

    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minHeight = constraints.maxHeight > 40
              ? constraints.maxHeight - 2
              : constraints.maxHeight;
          return Scrollbar(
            thumbVisibility: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                compact ? 10 : 12,
                compact ? 10 : 12,
                compact ? 10 : 12,
                compact ? 8 : 10,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colors.primary
                                .withOpacity(isDark ? 0.22 : 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            'Q ${index + 1}/$total',
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.record_voice_over_rounded,
                          color: colors.secondary,
                          size: compact ? 18 : 20,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: colors.secondary.withOpacity(0.18),
                          ),
                          child: Text(
                            '~${estimatedSeconds}s',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: compact ? 12 : 16),
                    Text(
                      question.prompt,
                      style: (compact
                              ? textTheme.titleMedium
                              : textTheme.titleLarge)
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                    ),
                    SizedBox(height: compact ? 10 : 12),
                    _AnswerSection(
                      answer: question.answer,
                      answerVisible: answerVisible,
                      onToggleAnswer: onToggleAnswer,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnswerSection extends StatelessWidget {
  const _AnswerSection({
    required this.answer,
    required this.answerVisible,
    required this.onToggleAnswer,
  });

  final String answer;
  final bool answerVisible;
  final VoidCallback onToggleAnswer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Reference answer',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (answerVisible)
              IconButton(
                tooltip: 'Copy answer',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: answer));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Answer copied')),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded),
              ),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const Key('toggle-answer'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.onSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onToggleAnswer,
          icon: Icon(answerVisible ? Icons.visibility_off : Icons.visibility),
          label: Text(answerVisible ? 'Hide Answer' : 'Show Answer'),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          child: answerVisible
              ? Container(
                  key: const ValueKey<String>('answer-visible'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colors.primary.withOpacity(isDark ? 0.18 : 0.1),
                  ),
                  child: SelectableText(
                    answer,
                    style: textTheme.bodyLarge,
                  ),
                )
              : Container(
                  key: const ValueKey<String>('answer-hidden'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colors.tertiary.withOpacity(isDark ? 0.18 : 0.1),
                  ),
                  child: Text(
                    'Answer hidden. Tap to reveal and practice speaking first.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.75),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

int _estimateSpeakingSeconds(String answer) {
  final words = answer
      .split(RegExp(r'\s+'))
      .where((segment) => segment.trim().isNotEmpty)
      .length;
  final seconds = (words / 2.4).round();
  return seconds.clamp(15, 180);
}
