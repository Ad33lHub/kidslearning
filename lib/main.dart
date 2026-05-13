import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/screen_time_service.dart';
import 'package:kids/features/auth/presentation/screens/login_screen.dart';
import 'package:kids/features/parent/presentation/screens/child_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/db/app_database.dart';
import 'firebase_options.dart';
import 'main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AppDatabase.instance.database;

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ScreenTimeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child ?? const SizedBox.shrink(),
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F3FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D28D9),
          primary: const Color(0xFF6D28D9),
          secondary: const Color(0xFFF43F5E),
          background: const Color(0xFFF5F3FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        fontFamily: 'arlrdbd',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AppEntryScreen(),
    );
  }
}

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  Future<void> _init() async {
    await context.read<AppState>().loadSession();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF4C1D95),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🌟',
                style: TextStyle(fontSize: 64),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
    }

    final state = context.watch<AppState>();

    if (!state.isLoggedIn) return const LoginScreen();
    if (!state.hasChild) return const ChildSelectionScreen();
    return const MainShell();
  }
}
