import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/widgets/app_toggle.dart';
import '../../utils/custom_app_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _general = true;
  bool _orders = true;
  bool _email = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _NotifTile(
              icon: Icons.notifications_outlined,
              title: 'General Notifications',
              subtitle: 'Promotions, updates & announcements',
              value: _general,
              onChanged: (v) => setState(() => _general = v),
            ),
            const Divider(),
            _NotifTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Order Notifications',
              subtitle: 'Ride & parcel status updates',
              value: _orders,
              onChanged: (v) => setState(() => _orders = v),
            ),
            const Divider(),
            _NotifTile(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receipts & summaries by email',
              value: _email,
              onChanged: (v) => setState(() => _email = v),
            ),
            const Spacer(),
            CustomAppButton(
              title: 'Save',
              onPressed: () {
                Navigator.pop(context);
                // TODO: call UpdateUserProfile API with notification prefs
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifTile({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontFamily: 'Urbanist', fontSize: 12, color: AppColors.gray)),
              ],
            ),
          ),
          AppToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
