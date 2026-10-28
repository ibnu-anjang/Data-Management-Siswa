import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'features/s01_login_screen.dart';
import 'features/s02_client_home_screen.dart';
import 'features/s03_client_student_list_screen.dart';
import 'features/s04_admin_dashboard_screen.dart';
import 'features/s05_admin_student_list_screen.dart';
import 'features/s09_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SekolahKuApp());
}

class SekolahKuApp extends StatefulWidget {
  const SekolahKuApp({super.key});

  @override
  State<SekolahKuApp> createState() => _SekolahKuAppState();
}

class _SekolahKuAppState extends State<SekolahKuApp> {
  final AppState _appState = AppState();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    _appState.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (_appState.toastMessage != null) {
      final msg = _appState.toastMessage!;
      _appState.clearToast();
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Isolated ValueListenableBuilder for ThemeMode:
    // Changing themes ONLY triggers themeMode update on MaterialApp without rebuilding screens or child widgets!
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _appState.themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'SekolahKu — Data Management Siswa',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: _scaffoldMessengerKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          themeAnimationDuration: Duration.zero,
          home: ListenableBuilder(
            listenable: _appState,
            builder: (context, _) {
              return _buildScreen(_appState.activeScreen);
            },
          ),
        );
      },
    );
  }

  Widget _buildScreen(String activeScreen) {
    switch (activeScreen) {
      case 's01':
        return S01LoginScreen(appState: _appState);
      case 's02':
        return S02ClientHomeScreen(appState: _appState);
      case 's03':
        return S03ClientStudentListScreen(appState: _appState);
      case 's04':
        return S04AdminDashboardScreen(appState: _appState);
      case 's05':
        return S05AdminStudentListScreen(appState: _appState);
      case 's09':
        return S09ProfileScreen(appState: _appState);
      default:
        return S01LoginScreen(appState: _appState);
    }
  }
}
