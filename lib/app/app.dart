import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../repositories/observation_repository.dart';
import '../screens/details_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/observation_form_screen.dart';
import '../screens/review_save_screen.dart';
import '../screens/welcome_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/sample_data.dart';
import 'theme.dart';

class AquaVerifyApp extends StatefulWidget {
  final String? initialScreen;

  const AquaVerifyApp({super.key, this.initialScreen});

  @override
  State<AquaVerifyApp> createState() => _AquaVerifyAppState();
}

class _AquaVerifyAppState extends State<AquaVerifyApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = ObservationRepository.instance.init();
  }

  Widget _getHomeScreen() {
    String? screen = widget.initialScreen ?? Uri.base.queryParameters['screen'];
    if (screen == null && Uri.base.fragment.isNotEmpty) {
      final fragment = Uri.base.fragment;
      final fragUri = Uri.tryParse('http://localhost/$fragment');
      screen = fragUri?.queryParameters['screen'];
      if (screen == null) {
        final clean = fragment.replaceAll('/', '').replaceAll('#', '').trim();
        if (clean.isNotEmpty) screen = clean;
      }
    }
    final sampleObs = SampleData.initialSampleObservations.first;

    switch (screen) {
      case 'home':
        return const HomeScreen();
      case 'step1':
        return const ObservationFormScreen(initialStep: 1);
      case 'step2':
        return const ObservationFormScreen(initialStep: 2);
      case 'step3':
        return const ObservationFormScreen(initialStep: 3);
      case 'step4':
        return const ObservationFormScreen(initialStep: 4);
      case 'review':
        return ReviewSaveScreen(observation: sampleObs);
      case 'history':
        return const HistoryScreen();
      case 'details':
        return DetailsScreen(observation: sampleObs);
      case 'welcome':
      default:
        return const WelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sampleObs = SampleData.initialSampleObservations.first;

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/step1': (context) => const ObservationFormScreen(initialStep: 1),
        '/step2': (context) => const ObservationFormScreen(initialStep: 2),
        '/step3': (context) => const ObservationFormScreen(initialStep: 3),
        '/step4': (context) => const ObservationFormScreen(initialStep: 4),
        '/review': (context) => ReviewSaveScreen(observation: sampleObs),
        '/history': (context) => const HistoryScreen(),
        '/details': (context) => DetailsScreen(observation: sampleObs),
      },
      home: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: AppColors.primaryNavy,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading AquaVerify Workspace...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return _getHomeScreen();
        },
      ),
    );
  }
}
