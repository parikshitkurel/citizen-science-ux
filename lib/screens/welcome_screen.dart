import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'history_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background water ripples
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryTeal.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightTealSurface.withOpacity(0.08),
                ),
              ),
            ),

            // Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header branding & Tagline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryTeal.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.science_outlined,
                                color: AppColors.lightTealSurface,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'OneAquaHealth × IEEE Hackathon',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.lightTealSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 20),

                        // Logo Icon & Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryTeal.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.water_drop_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Flexible(
                              child: Text(
                                AppConstants.appName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                        const SizedBox(height: 16),
                        Text(
                          AppConstants.appTagline,
                          style: const TextStyle(
                            color: AppColors.lightTealSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                        const SizedBox(height: 10),
                        Text(
                          AppConstants.appPurpose,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Feature highlights
                    Column(
                      children: [
                        _buildFeatureCard(
                          icon: Icons.alt_route_rounded,
                          title: 'Guided 4-Step Workflow',
                          subtitle:
                              'Step-by-step visual questions designed for students and community members.',
                        ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                        const SizedBox(height: 10),
                        _buildFeatureCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Educational Explanations',
                          subtitle:
                              'Clear "Why we ask this" guidance on clarity, odour, flow, and vegetation.',
                        ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
                        const SizedBox(height: 10),
                        _buildFeatureCard(
                          icon: Icons.storage_rounded,
                          title: '100% Offline Local Storage',
                          subtitle:
                              'All records stay stored safely on your device without login or internet.',
                        ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Actions
                    Column(
                      children: [
                        CustomButton(
                          text: 'Get Started',
                          icon: Icons.arrow_forward_rounded,
                          type: CustomButtonType.primary,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                        ).animate().fadeIn(delay: 1000.ms).scale(begin: const Offset(0.95, 0.95)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.history_rounded, size: 18),
                            label: const Text(
                              'View My Observations',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ).animate().fadeIn(delay: 1100.ms),
                        const SizedBox(height: 16),
                        Text(
                          'Track 1: Citizen Science UX • Water Observation Tool',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.lightTealSurface, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
