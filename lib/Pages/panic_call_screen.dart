// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class PanicCallScreen extends StatefulWidget {
  final DateTime startTime;
  const PanicCallScreen({super.key, required this.startTime});

  @override
  State<PanicCallScreen> createState() => _PanicCallScreenState();
}

class _PanicCallScreenState extends State<PanicCallScreen> {
  String? _phoneNumber;

  Future<void> _makeCall() async {
    final phone = _phoneNumber;
    if (phone == null || phone.isEmpty) {
      await _promptSetPhone();
      return;
    }

    // confirm with user first
    final should = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Call'),
        content: Text('Would you like to call $phone?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Call')),
        ],
      ),
    );

    if (should != true) return;

    try {
      final url = Uri.parse('tel:$phone');
      if (!await canLaunchUrl(url)) {
        throw 'Could not launch phone call';
      }
      await launchUrl(url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place call: $e')));
    }
  }

  Future<void> _promptSetPhone() async {
    final controller = TextEditingController(text: _phoneNumber ?? '');
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set emergency number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Enter phone number (e.g. +34123456789)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _phoneNumber = result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency number saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final btnRaw = size.width * 0.85;
    final btnSize = btnRaw > 520 ? 520.0 : btnRaw;

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
                // Header similar to other pages
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
                            'Panic Call',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Call your emergency contact',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // placeholder to balance header
                    SizedBox(width: 44),
                  ],
                ),

                SizedBox(height: size.height * 0.06),

                // Description
                const Text(
                  'Press the big button to call\n your emergency contact.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: size.height * 0.04),

                // Large centered circular button
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _makeCall,
                      child: Container(
                        width: btnSize,
                        height: btnSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.border.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/vibration_button.png',
                              width: btnSize - 40,
                              height: btnSize - 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Phone display and actions
                Text(
                  _phoneNumber ?? 'No emergency number set',
                  style: TextStyle(
                    color: AppColors.textDark.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: _promptSetPhone,
                      child: const Text('Set / Change number', style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        child: Text('Back to menu', style: TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
