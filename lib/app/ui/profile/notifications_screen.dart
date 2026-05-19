import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/storage/hive_service.dart';
import '../../model/auth/signup_model.dart';
import '../../provider/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';
import '../../utils/widgets/app_toggle.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _allowNotifications = true;
  bool _emailNotifications = false;
  bool _orderNotifications = true;
  bool _generalNotifications = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generalNotifications = HiveService.getGeneralNotification();
    _orderNotifications = HiveService.getOrderNotification();
    _emailNotifications = HiveService.getEmailNotification();
    _allowNotifications = _generalNotifications || _orderNotifications || _emailNotifications;
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    final request = SignUpRequestModel(
      pkUserId: int.tryParse(HiveService.getUserId() ?? '0') ?? 0,
      firstName: HiveService.getFirstName() ?? '',
      lastName: HiveService.getLastName() ?? '',
      mobileNo: HiveService.getMobileNo() ?? '',
      dateOfBirth: HiveService.getDateOfBirth() ?? '2025-01-01',
      gender: HiveService.getGender() ?? 'Male',
      email: HiveService.getEmail() ?? '',
      generalNotification: _generalNotifications,
      orderNotification: _orderNotifications,
      emailNotification: _emailNotifications,
    );

    final provider = context.read<AuthProvider>();
    final success = await provider.updateProfile(request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification preferences saved')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(AppImages.backBtn),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Toggle Items ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    _NotifItem(
                      title: 'Allow Notifications',
                      description: 'Stay updated with important alerts, reminders, and updates right when you need them.',
                      value: _allowNotifications,
                      onChanged: (v) => setState(() {
                        _allowNotifications = v;
                        if (!v) {
                          _generalNotifications = false;
                          _orderNotifications = false;
                          _emailNotifications = false;
                        }
                      }),
                    ),
                    _NotifItem(
                      marginTop: 10,
                      title: 'Email Notifications',
                      description: 'Stay in the loop with updates, offers, and important info sent straight to your inbox.',
                      value: _emailNotifications,
                      onChanged: (v) => setState(() => _emailNotifications = v),
                    ),
                    _NotifItem(
                      marginTop: 10,
                      title: 'Order Notifications',
                      description: 'Get real-time updates on your order status, from confirmation to delivery.',
                      value: _orderNotifications,
                      onChanged: (v) => setState(() => _orderNotifications = v),
                    ),
                    _NotifItem(
                      marginTop: 10,
                      title: 'General Notifications',
                      description: 'Receive helpful tips, reminders, and updates to enhance your experience.',
                      value: _generalNotifications,
                      onChanged: (v) => setState(() => _generalNotifications = v),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Save Button ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: CustomAppButton(
              title: 'Save Settings',
              isLoading: _isLoading,
              onPressed: _save,
              buttonHeight: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double marginTop;

  const _NotifItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.marginTop = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppColors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          AppToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
