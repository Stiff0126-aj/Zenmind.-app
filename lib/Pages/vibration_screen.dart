// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;
import 'package:vibration/vibration.dart';

class VibrationScreen extends StatefulWidget {
  final DateTime startTime;
  const VibrationScreen({super.key, required this.startTime});

  @override
  _VibrationScreenState createState() => _VibrationScreenState();
}

class _VibrationScreenState extends State<VibrationScreen> with TickerProviderStateMixin {
  bool _vibrating = false;
  late RiveAnimationController _riveController;

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _titleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _riveController = SimpleAnimation('wave');

    // Animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _titleController.forward();

    startVibration();
  }

  void startVibration() async {
    setState(() {
      _vibrating = true;
      _riveController.isActive = true;
    });

    // Start pulse animation
    _pulseController.repeat(reverse: true);

    while (_vibrating) {
      if (await Vibration.hasCustomVibrationsSupport() ?? false) {
        Vibration.vibrate(pattern: [500, 500]);
      } else {
        Vibration.vibrate(duration: 500);
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void stopVibration() {
    setState(() {
      _vibrating = false;
      _riveController.isActive = false;
    });
    _pulseController.stop();
    Vibration.cancel();
    HapticFeedback.selectionClick();
  }

  void toggleVibration() {
    if (_vibrating) {
      stopVibration();
    } else {
      startVibration();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8EAF6),
              Color(0xFFF3E5F5),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context),

                      const SizedBox(height: 20),

                      // Title section
                      _buildTitleSection(),

                      SizedBox(height: screenHeight * 0.05),

                      // Vibration animation container
                      _buildVibrationContainer(screenWidth, screenHeight),

                      SizedBox(height: screenHeight * 0.04),

                      // Control button
                      _buildControlButton(),

                      SizedBox(height: screenHeight * 0.03),

                      // Vibration info
                      _buildVibrationInfo(),

                      const Spacer(),

                      // Navigation buttons
                      _buildNavigationButtons(context, screenWidth),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                stopVibration();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.grey[700],
            ),
          ),

          const Spacer(),

          // Session title
          Column(
            children: [
              Text(
                'Vibration Therapy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Feel the rhythm',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Vibration status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _vibrating
                  ? const Color(0xFF9C27B0).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _vibrating
                    ? const Color(0xFF9C27B0).withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _vibrating ? Icons.vibration_rounded : Icons.pause_rounded,
                  size: 16,
                  color: _vibrating ? const Color(0xFF9C27B0) : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _vibrating ? 'Active' : 'Paused',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _vibrating ? const Color(0xFF9C27B0) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _titleAnimation.value,
          child: Column(
            children: [
              Text(
                'Focus on',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 8),

              // Enhanced vibration title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9C27B0),
                      Color(0xFF673AB7),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.vibration_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'The Vibration',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVibrationContainer(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _vibrating ? _pulseAnimation.value : 1.0,
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.35,
            constraints: const BoxConstraints(
              minWidth: 280,
              minHeight: 280,
              maxWidth: 400,
              maxHeight: 400,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withOpacity(_vibrating ? 0.3 : 0.1),
                  spreadRadius: _vibrating ? 2 : 0,
                  blurRadius: _vibrating ? 30 : 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF9C27B0).withOpacity(_vibrating ? 0.2 : 0.1),
                width: _vibrating ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [
                          const Color(0xFF9C27B0).withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),

                // Rive animation
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: RiveAnimation.asset(
                      'assets/vibrationAni.riv',
                      controllers: [_riveController],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _vibrating
              ? [const Color(0xFFFF5722), const Color(0xFFE91E63)]
              : [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (_vibrating ? const Color(0xFFFF5722) : const Color(0xFF4CAF50))
                .withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: toggleVibration,
        icon: Icon(
          _vibrating ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildVibrationInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            _vibrating ? 'Vibrating every 3 seconds' : 'Tap play to start vibration',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Primary action button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                stopVibration();
                // Return to menu instead of navigating forward to Taste
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Taste',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Secondary action button
          Container(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                stopVibration();
                // Finish session: return to menu
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Finish Session',
                    style: TextStyle(
                      color: Colors.grey[700],
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

  @override
  void dispose() {
    stopVibration();
    _fadeController.dispose();
    _pulseController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}