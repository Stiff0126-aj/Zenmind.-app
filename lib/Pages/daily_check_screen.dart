import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class DailyCheckScreen extends StatefulWidget {
  const DailyCheckScreen({super.key});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  String? q1; // How did you wake up
  String? q2; // Have you felt stressed
  String? q3; // Have you taken a pause
  String? q4; // Energy level
  String? q5; // Are you present

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _radioRow(List<String> options, String? groupValue, ValueChanged<String?> onChanged) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: options.map((opt) {
        final selected = groupValue == opt;
        return ChoiceChip(
          label: Text(opt, style: TextStyle(color: selected ? Colors.white : AppColors.textDark)),
          selected: selected,
          onSelected: (_) => onChanged(opt),
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                // Header
                  Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.border.withOpacity(0.2),
                            blurRadius: 8,
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Daily Check',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Quick check-in for how you feel',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),

                const SizedBox(height: 18),

                // Card-like rounded container with the questionnaire
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.border.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('How did you wake up today?'),
                          _radioRow(['Happy', 'Tired', 'Motivated', 'Irritable'], q1, (v) => setState(() => q1 = v)),

                          const SizedBox(height: 16),
                          _sectionTitle('Have you felt stressed today?'),
                          _radioRow(['Yes', 'No'], q2, (v) => setState(() => q2 = v)),

                          const SizedBox(height: 16),
                          _sectionTitle('Have you taken a pause to breathe or distract yourself?'),
                          _radioRow(['Yes', 'No'], q3, (v) => setState(() => q3 = v)),

                          const SizedBox(height: 16),
                          _sectionTitle('How is your energy level?'),
                          _radioRow(['Low', 'Medium', 'High'], q4, (v) => setState(() => q4 = v)),

                          const SizedBox(height: 16),
                          _sectionTitle('Do you feel present in what you are doing?'),
                          _radioRow(['Yes', 'No'], q5, (v) => setState(() => q5 = v)),

                          const SizedBox(height: 20),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // Basic validation: at least q1 & q2 selected
                                if (q1 == null || q2 == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor responde las preguntas principales.')));
                                  return;
                                }

                                // For now show a confirmation and go back
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respuesta guardada')));
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
