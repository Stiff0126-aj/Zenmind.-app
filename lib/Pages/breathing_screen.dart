// ignore_for_file: sized_box_for_whitespace

import 'package:panicaid/Animations/breathing_cloud.dart';
import 'package:panicaid/Pages/vibration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class BreathingScreen extends StatefulWidget {
  final DateTime startTime;
  const BreathingScreen({super.key, required this.startTime});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with TickerProviderStateMixin {
  String _breathingText = 'INHALE';
  late AnimationController _textAnimationController;
  late AnimationController _backgroundController;
  late Animation<double> _textScaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  // Color schemes for different breathing phases
  final Map<String, Color> _phaseColors = {
    'INHALE': AppColors.primary,
    'HOLD': AppColors.secondary,
    'EXHALE': AppColors.border,
  };

  @override
  void initState() {
    super.initState();

    // Text animation controller for breathing text
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Background color animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Text scale animation
    _textScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.elasticOut,
    ));

    // Background color animation
    _backgroundColorAnimation = ColorTween(
      begin: _phaseColors['INHALE'],
      end: _phaseColors['INHALE'],
    ).animate(_backgroundController);
  }

  void _updateBreathingText(String text) {
    setState(() {
      _breathingText = text;
    });

    // Trigger text animation
    _textAnimationController.forward().then((_) {
      _textAnimationController.reverse();
    });

    // Update background color
    _backgroundColorAnimation = ColorTween(
      begin: _backgroundColorAnimation.value,
      end: _phaseColors[text],
    ).animate(_backgroundController);

    _backgroundController.forward().then((_) {
      _backgroundController.reset();
    });

    // Add haptic feedback for better user experience
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (_backgroundColorAnimation.value ?? _phaseColors['INHALE']!).withOpacity(0.1),
                  (_backgroundColorAnimation.value ?? _phaseColors['INHALE']!).withOpacity(0.05),
                  AppColors.background,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with back button and session info
                  _buildHeader(context),

                  const SizedBox(height: 30),

                  // Breathing phases display
                  const BreathingPhases(),

                  const SizedBox(height: 40),

                  // Current breathing phase text with animation
                  AnimatedBuilder(
                    animation: _textScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _textScaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (_backgroundColorAnimation.value ?? _phaseColors['INHALE']!)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (_backgroundColorAnimation.value ?? _phaseColors['INHALE']!)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _breathingText,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: _backgroundColorAnimation.value ?? _phaseColors['INHALE'],
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenSize.height * 0.08),

                  // Breathing cloud animation
                  Expanded(
                    child: Center(
                      child: BreathingCloud(callback: _updateBreathingText),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.08),

                  // Navigation buttons
                  NavigationButtons(startTime: widget.startTime),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.textDark,
            ),
          ),

          const Spacer(),

          // Session title
          Column(
            children: [
              Text(
                'Breathing Exercise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'Find your calm',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Session timer placeholder
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: AppColors.textDark.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  '3:00',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
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

// Enhanced breathing phases widget
class BreathingPhases extends StatelessWidget {
  const BreathingPhases({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const Expanded(
              child: BreathingPhaseWidget(
                duration: '3',
                phase: 'INHALE',
                color: AppColors.primary,
                icon: Icons.keyboard_arrow_up_rounded,
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.border.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const Expanded(
              child: BreathingPhaseWidget(
                duration: '3',
                phase: 'HOLD',
                color: AppColors.secondary,
                icon: Icons.pause_rounded,
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.border.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const Expanded(
              child: BreathingPhaseWidget(
                duration: '3',
                phase: 'EXHALE',
                color: AppColors.border,
                icon: Icons.keyboard_arrow_down_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced breathing phase widget
class BreathingPhaseWidget extends StatelessWidget {
  final String duration;
  final String phase;
  final Color color;
  final IconData icon;

  const BreathingPhaseWidget({
    super.key,
    required this.duration,
    required this.phase,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),

        const SizedBox(height: 8),

        // Duration
        Text(
          duration,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        // Seconds label
        Text(
          'Seconds',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textDark.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        // Phase name
        Text(
          phase,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Enhanced navigation buttons
class NavigationButtons extends StatelessWidget {
  final DateTime startTime;
  const NavigationButtons({super.key, required this.startTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Primary action button: proceed to Vibration
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VibrationScreen(startTime: startTime),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Next: Vibration',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Secondary action button: finish session (back to menu)
          Container(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.textDark.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Finish Session',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
