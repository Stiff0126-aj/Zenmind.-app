import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class ContactsScreen extends StatefulWidget {
  final DateTime startTime;
  const ContactsScreen({super.key, required this.startTime});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> contacts = [
    Contact(name: 'Mamá', phone: '+34 912 345 678', icon: Icons.woman_rounded, color: const Color(0xFFE8B4D8)),
    Contact(name: 'Papá', phone: '+34 923 456 789', icon: Icons.man_rounded, color: const Color(0xFFB4D8E8)),
    Contact(name: 'Hermana', phone: '+34 934 567 890', icon: Icons.girl_rounded, color: const Color(0xFFC8E8B4)),
    Contact(name: 'Mejor Amiga', phone: '+34 945 678 901', icon: Icons.favorite_rounded, color: const Color(0xFFE8D4B4)),
    Contact(name: 'Psicologa', phone: '+34 956 789 012', icon: Icons.medical_services_rounded, color: const Color(0xFFD4B4E8)),
    Contact(name: 'Línea de Crisis', phone: '+34 024', icon: Icons.call_rounded, color: const Color(0xFFE8B4B4)),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                            'Emergency Contacts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Reach out for support',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(width: 44),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                // Contacts list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return _buildContactCard(contacts[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.border.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              contact.icon,
              color: contact.color,
              size: 28,
            ),
          ),
          title: Text(
            contact.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          subtitle: Text(
            contact.phone,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textDark.withOpacity(0.6),
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${contact.name}...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                Icons.call_rounded,
                color: contact.color,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  final IconData icon;
  final Color color;

  Contact({
    required this.name,
    required this.phone,
    required this.icon,
    required this.color,
  });
}
