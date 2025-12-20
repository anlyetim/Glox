import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'models/theme_config.dart';
import 'themes/app_theme.dart';
import 'screens/main_menu_screen.dart';
import 'services/sound_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sound system (non-blocking)
  SoundManager().init().timeout(
    const Duration(seconds: 3),
    onTimeout: () {},
  ).catchError((e) {});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => ThemeConfig()),
      ],
      child: Consumer2<GameState, ThemeConfig>(
        builder: (context, gameState, themeConfig, _) {
          return MaterialApp(
            title: 'GLOX',
            theme: AppTheme.getTheme(
              themeConfig,
              gameState.difficulty.color,
            ),
            home: const MainMenuScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
