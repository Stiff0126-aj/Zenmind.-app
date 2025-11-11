// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import '../Animations/audio_spectrum_lines.dart';
import '../Buttons/audio_player_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class AudioScreen extends StatefulWidget {
  final DateTime startTime;
  const AudioScreen({super.key, required this.startTime});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with TickerProviderStateMixin {
  int currentSoundIndex = 0;
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  late AnimationController _fadeController;
  late AnimationController _titleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleAnimation;

  final List<String> soundTexts = [
    'Olas',
    'Lluvia',
    'Pájaros',
    'Fuego',
    'Bosque',
    'Viento',
  ];

  final List<String> sounds = [
    'assets/music-1.mp3',
    'assets/music-2.mp3',
    'assets/music-3.mp3',
    'assets/music-4.mp3',
    'assets/music-5.mp3',
    'assets/music-6.mp3',
  ];

  // Sound-specific colors and icons
  final Map<String, Color> soundColors = {
    'Olas': AppColors.primary,
    'Lluvia': AppColors.border,
    'Pájaros': AppColors.primary,
    'Fuego': AppColors.secondary,
    'Bosque': AppColors.border,
    'Viento': AppColors.primary,
  };

  final Map<String, IconData> soundIcons = {
    'Olas': Icons.waves_rounded,
    'Lluvia': Icons.grain_rounded,
    'Pájaros': Icons.flutter_dash_rounded,
    'Fuego': Icons.local_fire_department_rounded,
    'Bosque': Icons.forest_rounded,
    'Viento': Icons.air_rounded,
  };

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _titleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _onSoundChanged(int index) {
    setState(() {
      currentSoundIndex = index;
    });

    // Animate title change
    _titleController.reset();
    _titleController.forward();

    // Add haptic feedback
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final currentColor =
        soundColors[soundTexts[currentSoundIndex]] ?? AppColors.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentColor.withOpacity(0.05),
              currentColor.withOpacity(0.02),
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                _buildHeader(context, currentColor),

                const SizedBox(height: 10),

                // Title section
                _buildTitleSection(currentColor),

                SizedBox(height: screenHeight * 0.05),

                // Audio spectrum container
                _buildAudioSpectrumContainer(
                  screenWidth,
                  screenHeight,
                  currentColor,
                ),

                SizedBox(height: screenHeight * 0.06),

                // Audio player controls
                AudioPlayerButtons(
                  player: player,
                  onSoundIndexChanged: _onSoundChanged,
                  onPlayPauseChanged: (playing) {
                    setState(() {
                      isPlaying = playing;
                    });
                  },
                ),

                const Spacer(),

                // Navigation buttons
                _buildNavigationButtons(context, screenWidth, currentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color currentColor) {
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
                  color: AppColors.textDark.withOpacity(0.1),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Terapia Auditiva',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'Sonidos Calmantes',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Sound indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: currentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  soundIcons[soundTexts[currentSoundIndex]] ??
                      Icons.music_note_rounded,
                  size: 16,
                  color: currentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${currentSoundIndex + 1}/6',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: currentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(Color currentColor) {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _titleAnimation.value,
          child: Column(
            children: [
              Text(
                'Concéntrate en',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 8),

              // Enhanced sound name with icon
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      currentColor.withOpacity(0.8),
                      currentColor.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: currentColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      soundIcons[soundTexts[currentSoundIndex]] ??
                          Icons.music_note_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      soundTexts[currentSoundIndex],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
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

  Widget _buildAudioSpectrumContainer(
    double screenWidth,
    double screenHeight,
    Color currentColor,
  ) {
    return Container(
      width: screenWidth * 0.85,
      height: screenHeight * 0.35,
      constraints: const BoxConstraints(
        minWidth: 280,
        minHeight: 220,
        maxWidth: 450,
        maxHeight: 320,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: currentColor.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: currentColor.withOpacity(0.1), width: 1),
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
                  colors: [currentColor.withOpacity(0.03), Colors.transparent],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          // Audio spectrum
          Center(child: AudioSpectrumLines(isPlaying: isPlaying)),

          // Play state indicator
          if (!isPlaying)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pause_rounded,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Paused',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
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

  Widget _buildNavigationButtons(
    BuildContext context,
    double screenWidth,
    Color currentColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Secondary action button
          Container(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () async {
                HapticFeedback.selectionClick();
                await player.stop();
                if (!mounted) return;
                // Finish session: return to menu
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.border.withOpacity(0.3),
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
                    'Menú principal',
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
}
