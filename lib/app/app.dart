import 'package:flutter/material.dart';
import '../repositories/observation_repository.dart';
import '../screens/welcome_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'theme.dart';

class AquaVerifyApp extends StatefulWidget {
  const AquaVerifyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
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
          return const WelcomeScreen();
        },
      ),
    );
  }
}
