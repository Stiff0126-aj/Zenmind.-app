import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_screen.dart';
import 'breathing_screen.dart';
import 'bubble_pop_game_screen.dart';
import 'smell_screen.dart';
import 'taste_screen.dart';
import 'vibration_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<MenuOption> menuOptions = [
    MenuOption(
      title: 'Breathing Exercise',
      subtitle: 'Guided breathing techniques',
      icon: Icons.air_rounded,
      color: const Color(0xFF667eea),
      route: (startTime) => BreathingScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Calming Sounds',
      subtitle: 'Relaxing audio therapy',
      icon: Icons.music_note_rounded,
      color: const Color(0xFF4FC3F7),
      route: (startTime) => AudioScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Vibration Therapy',
      subtitle: 'Soothing haptic patterns',
      icon: Icons.vibration_rounded,
      color: const Color(0xFFFF7043),
      route: (startTime) => VibrationScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Bubble Pop Game',
      subtitle: 'Interactive distraction',
      icon: Icons.bubble_chart_rounded,
      color: const Color(0xFF66BB6A),
      route: (startTime) => BubblePopGameScreen(),
    ),
    MenuOption(
      title: 'Smell Exercise',
      subtitle: 'Mindful scent awareness',
      icon: Icons.local_florist_rounded,
      color: const Color(0xFF8D6E63),
      route: (startTime) => SmellScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Taste Exercise',
      subtitle: 'Sensory grounding technique',
      icon: Icons.restaurant_rounded,
      color: const Color(0xFFFF9800),
      route: (startTime) => TasteScreen(startTime: startTime),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Header
                  Text(
                    'Panic Aid',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Choose your calming technique',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Grid of options
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: menuOptions.length,
                      itemBuilder: (context, index) {
                        final option = menuOptions[index];
                        return _buildOptionCard(option);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(MenuOption option) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        final startTime = DateTime.now();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                option.route(startTime),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: option.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                option.icon,
                size: 32,
                color: option.color,
              ),
            ),

            const SizedBox(height: 15),

            // Title
            Text(
              option.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function(DateTime) route;

  MenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}