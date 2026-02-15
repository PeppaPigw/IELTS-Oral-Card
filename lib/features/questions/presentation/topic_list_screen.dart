import 'package:flutter/material.dart';

import '../../../core/widgets/glow_background.dart';
import '../../../core/widgets/responsive_frame.dart';
import '../../settings/theme_mode_controller.dart';
import '../data/question_repository.dart';
import '../domain/question_models.dart';
import 'revision_screen.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({
    required this.repository,
    required this.themeController,
    super.key,
  });

  final QuestionRepository repository;
  final ThemeModeController themeController;

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late Future<QuestionBank> _questionBankFuture;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _questionBankFuture = widget.repository.loadQuestionBank();
  }

  Future<void> _refreshData() async {
    final refreshed = widget.repository.loadQuestionBank(forceRefresh: true);
    setState(() {
      _questionBankFuture = refreshed;
    });
    await refreshed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: FutureBuilder<QuestionBank>(
            future: _questionBankFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 46,
                          color: colors.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load IELTS data',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final questionBank = snapshot.data;
              if (questionBank == null || questionBank.topics.isEmpty) {
                return Center(
                  child: Text(
                    'No topics found in IELTS.md',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              }

              final topics = questionBank.topics
                  .where(
                    (topic) =>
                        _search.trim().isEmpty ||
                        topic.title
                            .toLowerCase()
                            .contains(_search.toLowerCase()),
                  )
                  .toList();

              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ResponsiveFrame(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: _HeaderPanel(
                            totalQuestions: questionBank.totalQuestions,
                            totalTopics: questionBank.topics.length,
                            onThemePressed: () {
                              showThemeModeSheet(
                                  context, widget.themeController);
                            },
                            onSearchChanged: (value) {
                              setState(() {
                                _search = value;
                              });
                            },
                          ),
                        ),
                      ),
                      if (topics.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'No topic matches "$_search".',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          sliver: SliverList.builder(
                            itemCount: topics.length,
                            itemBuilder: (context, index) {
                              final topic = topics[index];
                              return AnimatedContainer(
                                duration:
                                    Duration(milliseconds: 180 + (index * 20)),
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _TopicCard(
                                  topic: topic,
                                  index: index,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) => RevisionScreen(
                                          topic: topic,
                                          themeController:
                                              widget.themeController,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel({
    required this.totalQuestions,
    required this.totalTopics,
    required this.onThemePressed,
    required this.onSearchChanged,
  });

  final int totalQuestions;
  final int totalTopics;
  final VoidCallback onThemePressed;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IELTS Oral Studio',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'One-tap answer reveal, premium reading flow, and adaptive themes.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Theme settings',
                  onPressed: onThemePressed,
                  icon: const Icon(Icons.palette_outlined),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatChip(
                  icon: Icons.topic_outlined,
                  label: '$totalTopics topics',
                ),
                _StatChip(
                  icon: Icons.question_answer_outlined,
                  label: '$totalQuestions questions',
                ),
                const _StatChip(
                  icon: Icons.touch_app_outlined,
                  label: 'Tap to show/hide',
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search topics',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to reload from IELTS.md after edits.',
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: colors.primary.withOpacity(0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.index,
    required this.onTap,
  });

  final QuestionTopic topic;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final previewQuestion =
        topic.questions.isNotEmpty ? topic.questions.first.prompt : '';

    return Semantics(
      button: true,
      label: 'Open topic ${topic.title}',
      hint: '${topic.questionCount} questions',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface.withOpacity(0.88),
                  colors.surface.withOpacity(0.66),
                ],
              ),
              border: Border.all(color: colors.primary.withOpacity(0.14)),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withOpacity(0.14),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        previewQuestion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withOpacity(0.72),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${topic.questionCount} prompts',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withOpacity(0.16),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: colors.primary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
