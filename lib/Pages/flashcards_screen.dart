import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'dart:math';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _controller;

  final List<Map<String, dynamic>> _flashcards = [
    {
      'front': '¿Qué son los Primeros Auxilios Psicológicos (PAP)?',
      'back':
          'Son una intervención inmediata para aliviar el malestar emocional y prevenir secuelas psicológicas tras una crisis.\n\n👥 Se aplican en las primeras horas o días después del evento.\n\n📚 Fuente: OMS, ONU & MINSALUD (2022)',
    },
    {
      'front': 'Objetivo principal',
      'back':
          'Brindar apoyo humano, empático y práctico para reducir el estrés inicial y fomentar la adaptación.\n\n💬 No es terapia, sino acompañamiento inicial.\n\n📚 Fuente: Guía ONU Integra (2023)',
    },
    {
      'front': 'Principios clave del PAP',
      'back':
          '1️⃣ Escuchar con empatía\n2️⃣ Transmitir calma\n3️⃣ Evaluar necesidades básicas\n4️⃣ Conectar con redes de apoyo\n5️⃣ Facilitar información clara\n\n📚 Fuente: MINSALUD (2022)',
    },
    {
      'front': 'Etapas del protocolo PAP',
      'back':
          '1️⃣ Prepararse para ayudar\n2️⃣ Establecer contacto\n3️⃣ Escuchar activamente\n4️⃣ Evaluar necesidades\n5️⃣ Conectar con apoyos y servicios\n\n📚 Fuente: UC Medicina (2021)',
    },
    {
      'front': 'Qué NO hacer en una crisis',
      'back':
          '🚫 No forzar a hablar\n🚫 No minimizar la experiencia\n🚫 No prometer lo que no se puede cumplir\n🚫 No juzgar emociones\n\n📚 Fuente: OMS (2020)',
    },
    {
      'front': 'Cuándo derivar a un profesional',
      'back':
          'Derivar cuando hay:\n⚠️ Riesgo suicida\n⚠️ Desorientación o pérdida de conciencia\n⚠️ Reacciones psicóticas\n⚠️ Falta de red de apoyo\n\n📚 Fuente: MINSALUD & ONU Integra (2023)',
    },
    {
      'front': 'Fuentes oficiales y créditos',
      'back':
          '📚 **Referencias**:\n- Organización Mundial de la Salud (OMS), 2020. *Psychological First Aid Guide.*\n- Ministerio de Salud de Colombia, 2022. *Orientaciones Técnicas PAP.*\n- ONU Integra, 2023. *Guía de Primeros Auxilios Psicológicos.*\n- UC Medicina Chile, 2021. *Manual PAP.*\n\n💡 Material con fines educativos y de bienestar emocional.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    HapticFeedback.selectionClick();
    setState(() {
      _isFlipped = !_isFlipped;
    });
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      setState(() {
        _isFlipped = false;
        _currentIndex++;
        _controller.reverse();
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _isFlipped = false;
        _currentIndex--;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _flashcards[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                          final angle = _controller.value * pi;
                          final isUnder = angle > pi / 2.0;

                          // Apply perspective and rotateY by the animated angle
                          final transform = Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle);

                          // When showing the back side we add an extra pi rotation
                          // to compensate for the mirrored text caused by the 3D flip.
                          return Transform(
                            alignment: Alignment.center,
                            transform: transform,
                            child: isUnder
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(pi),
                                    child: _buildCardBack(current['back']),
                                  )
                                : _buildCardFront(current['front']),
                          );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildControls(),
              const SizedBox(height: 20),
              _buildIndicator(),
              const SizedBox(height: 20),
            ],
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.textDark,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Spacer(),
          Text(
            'PAP Flashcards',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCardFront(String text) {
    return _buildCardBase(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildCardBack(String text) {
    return _buildCardBase(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppColors.textDark.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBase({required Widget child}) {
    return Container(
      width: 320,
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 36,
          onPressed: _prevCard,
          icon: Icon(Icons.chevron_left_rounded, color: AppColors.textDark),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          onPressed: _flipCard,
          child: const Text(
            'Girar tarjeta',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          iconSize: 36,
          onPressed: _nextCard,
          icon: Icon(Icons.chevron_right_rounded, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _flashcards.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primary
                : AppColors.textDark.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
