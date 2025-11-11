import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'audio_screen.dart';
import 'breathing_screen.dart';
import 'bubble_pop_game_screen.dart';
import 'flashcards_screen.dart';
import 'panic_call_screen.dart';
import 'contacts_screen.dart';

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
      color: AppColors.primary,
      route: (startTime) => BreathingScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Calming Sounds',
      subtitle: 'Relaxing audio therapy',
      icon: Icons.music_note_rounded,
      color: AppColors.primary.withOpacity(0.9),
      route: (startTime) => AudioScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Vibration Therapy',
      subtitle: 'Soothing haptic patterns',
      icon: Icons.vibration_rounded,
      color: AppColors.primary.withOpacity(0.8),
      route: (startTime) => PanicCallScreen(startTime: startTime),
    ),
    MenuOption(
      title: 'Bubble Pop Game',
      subtitle: 'Interactive distraction',
      icon: Icons.bubble_chart_rounded,
      color: AppColors.primary.withOpacity(0.85),
      route: (startTime) => BubblePopGameScreen(),
    ),
    MenuOption(
      title: 'Smell Exercise',
      subtitle: 'Mindful scent awareness',
      icon: Icons.local_florist_rounded,
      color: AppColors.primary.withOpacity(0.75),
      route: (startTime) => ContactsScreen(startTime: startTime),
    ),
    // 'Taste Exercise' removed from menu per user request
    MenuOption(
      title: 'Flash Cards',
      subtitle: 'Learn the PAP Protocol',
      icon: Icons.style_rounded,
      color: AppColors.primary.withOpacity(0.7),
      route: (startTime) => const FlashcardsScreen(),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
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
                  
                  // Header Image - Full Width
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo/zenmind_logo.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.border.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Daily Check Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Check',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
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
    // map option titles to image assets
    final images = {
      'Breathing Exercise': 'assets/images/breathing_button.png',
      'Calming Sounds': 'assets/images/calming_sounds_button.png',
      'Vibration Therapy': 'assets/images/vibration_button.png',
      'Bubble Pop Game': 'assets/images/bubble_pop_button.png',
  'Smell Exercise': 'assets/images/smell_button.png',
      'Flash Cards': 'assets/images/flashcards_button.png',
    };

    final asset = images[option.title];

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
      child: asset != null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(asset),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.border.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.border.withOpacity(0.3),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
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
                        color: AppColors.textDark.withOpacity(0.6),
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