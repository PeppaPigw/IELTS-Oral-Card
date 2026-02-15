import 'package:flutter/material.dart';

import '../../../core/widgets/glow_background.dart';
import '../../../core/widgets/responsive_frame.dart';
import '../../settings/theme_mode_controller.dart';
import '../domain/question_models.dart';
import 'widgets/question_panel.dart';

class RevisionScreen extends StatefulWidget {
  const RevisionScreen({
    required this.topic,
    required this.themeController,
    super.key,
  });

  final QuestionTopic topic;
  final ThemeModeController themeController;

  @override
  State<RevisionScreen> createState() => _RevisionScreenState();
}

class _RevisionScreenState extends State<RevisionScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;
  final Set<String> _visibleAnswers = <String>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.96);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isVisible(QuestionItem item) => _visibleAnswers.contains(item.id);

  void _toggleAnswer(QuestionItem item) {
    setState(() {
      if (_visibleAnswers.contains(item.id)) {
        _visibleAnswers.remove(item.id);
      } else {
        _visibleAnswers.add(item.id);
      }
    });
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.topic.questions;
    final colors = Theme.of(context).colorScheme;
    final revealedCount = questions.where(_isVisible).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: [
          IconButton(
            tooltip: 'Theme',
            onPressed: () =>
                showThemeModeSheet(context, widget.themeController),
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ),
      body: GlowBackground(
        child: SafeArea(
          top: false,
          child: ResponsiveFrame(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: colors.surface.withOpacity(0.8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const Spacer(),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                key: ValueKey<String>(
                                  '${_currentIndex + 1}-${questions.length}',
                                ),
                                '${_currentIndex + 1}/${questions.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            value: (_currentIndex + 1) / questions.length,
                            backgroundColor: colors.primary.withOpacity(0.2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              'Answers revealed: $revealedCount',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: colors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: questions.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 2,
                            right: 2,
                            top: index == _currentIndex ? 4 : 12,
                            bottom: index == _currentIndex ? 4 : 12,
                          ),
                          child: QuestionPanel(
                            question: question,
                            index: index,
                            total: questions.length,
                            answerVisible: _isVisible(question),
                            onToggleAnswer: () => _toggleAnswer(question),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentIndex == 0
                              ? null
                              : () => _goToPage(_currentIndex - 1),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          label: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _currentIndex >= questions.length - 1
                              ? null
                              : () => _goToPage(_currentIndex + 1),
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          label: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showThemeModeSheet(
  BuildContext context,
  ThemeModeController controller,
) async {
  final textTheme = Theme.of(context).textTheme;
  final currentMode = controller.themeMode;
  var currentScale = controller.fontScale;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Display Settings',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ThemeItem(
                    icon: Icons.brightness_auto_rounded,
                    title: 'Follow System',
                    selected: currentMode == ThemeMode.system,
                    onTap: () async {
                      await controller.updateThemeMode(ThemeMode.system);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  _ThemeItem(
                    icon: Icons.light_mode_rounded,
                    title: 'Light',
                    selected: currentMode == ThemeMode.light,
                    onTap: () async {
                      await controller.updateThemeMode(ThemeMode.light);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  _ThemeItem(
                    icon: Icons.dark_mode_rounded,
                    title: 'Dark',
                    selected: currentMode == ThemeMode.dark,
                    onTap: () async {
                      await controller.updateThemeMode(ThemeMode.dark);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Font size',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(currentScale * 100).round()}%',
                        style: textTheme.labelLarge,
                      ),
                      TextButton(
                        onPressed: () async {
                          await controller.resetFontScale();
                          if (context.mounted) {
                            setSheetState(() {
                              currentScale = controller.fontScale;
                            });
                          }
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentScale,
                    min: 0.85,
                    max: 1.35,
                    divisions: 10,
                    onChanged: (value) {
                      setSheetState(() {
                        currentScale = value;
                      });
                      controller.updateFontScale(value);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected ? colors.primary.withOpacity(0.2) : colors.surface,
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? colors.primary : colors.onSurface),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
              const Spacer(),
              if (selected) Icon(Icons.check_circle, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
