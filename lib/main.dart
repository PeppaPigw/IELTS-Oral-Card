import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/questions/data/question_repository.dart';
import 'features/questions/presentation/topic_list_screen.dart';
import 'features/settings/theme_mode_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeModeController.create();
  final questionRepository = QuestionRepository();

  runApp(
    OralRevisionApp(
      themeController: themeController,
      questionRepository: questionRepository,
    ),
  );
}

class OralRevisionApp extends StatelessWidget {
  const OralRevisionApp({
    required this.themeController,
    required this.questionRepository,
    super.key,
  });

  final ThemeModeController themeController;
  final QuestionRepository questionRepository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'IELTS Oral Revision',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: TextScaler.linear(themeController.fontScale),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: TopicListScreen(
            repository: questionRepository,
            themeController: themeController,
          ),
        );
      },
    );
  }
}
