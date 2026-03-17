import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';
import '../../utils/widgets/app_toggle.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime? _dob;
  bool _generalNotification = true;
  bool _orderNotification = true;
  bool _emailNotification = false;

  @override
  void initState() {
    super.initState();
    // TODO: Pre-fill from HiveService / API
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('About Me')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.lightGreen,
                    child: const Icon(Icons.person, size: 44, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 14, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(controller: _firstNameController, decoration: const InputDecoration(hintText: 'First Name')),
            const SizedBox(height: 16),
            TextFormField(controller: _lastNameController, decoration: const InputDecoration(hintText: 'Last Name')),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email')),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDob,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.greyBorder)),
                child: Row(
                  children: [
                    Expanded(child: Text(_dob == null ? 'Date of Birth' : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                      style: TextStyle(fontFamily: 'Urbanist', color: _dob == null ? AppColors.textHint : AppColors.textPrimary))),
                    const Icon(Icons.calendar_today_outlined, color: AppColors.gray, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Gender', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                final selected = _selectedGender == g;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(g, style: const TextStyle(fontFamily: 'Urbanist')),
                    selected: selected,
                    selectedColor: AppColors.lightGreen,
                    onSelected: (_) => setState(() => _selectedGender = g),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 32),
            const Text('Notifications', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _NotifRow(label: 'General', value: _generalNotification, onChanged: (v) => setState(() => _generalNotification = v)),
            _NotifRow(label: 'Orders', value: _orderNotification, onChanged: (v) => setState(() => _orderNotification = v)),
            _NotifRow(label: 'Email', value: _emailNotification, onChanged: (v) => setState(() => _emailNotification = v)),
            const SizedBox(height: 32),
            CustomAppButton(
              title: 'Save Changes',
              onPressed: () {
                Navigator.pop(context);
                // TODO: call UpdateUserProfile API
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _NotifRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Urbanist')),
        const Spacer(),
        AppToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
