import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';
import '../../utils/widgets/app_toggle.dart';

class ParcelBookingReqScreen extends StatefulWidget {
  const ParcelBookingReqScreen({super.key});

  @override
  State<ParcelBookingReqScreen> createState() => _ParcelBookingReqScreenState();
}

class _ParcelBookingReqScreenState extends State<ParcelBookingReqScreen> {
  // Sender
  final _senderNameController = TextEditingController();
  final _senderMobileController = TextEditingController();
  bool _isSending = false;

  // Receiver
  final _receiverNameController = TextEditingController();
  final _receiverMobileController = TextEditingController();
  bool _isReceiving = false;

  // Parcel Info
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _weightController = TextEditingController();

  bool _acceptTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderMobileController.dispose();
    _receiverNameController.dispose();
    _receiverMobileController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Parcel Details')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sender ─────────────────────────────────────
              const Text('Sender Info', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              TextFormField(controller: _senderNameController, decoration: const InputDecoration(hintText: 'Sender Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _senderMobileController, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Sender Mobile'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('I am the sender', style: TextStyle(fontFamily: 'Urbanist')),
                  const Spacer(),
                  AppToggle(value: _isSending, onChanged: (v) => setState(() => _isSending = v)),
                ],
              ),
              const Divider(height: 32),

              // ── Receiver ────────────────────────────────────
              const Text('Receiver Info', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              TextFormField(controller: _receiverNameController, decoration: const InputDecoration(hintText: 'Receiver Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _receiverMobileController, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Receiver Mobile'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('I am the receiver', style: TextStyle(fontFamily: 'Urbanist')),
                  const Spacer(),
                  AppToggle(value: _isReceiving, onChanged: (v) => setState(() => _isReceiving = v)),
                ],
              ),
              const Divider(height: 32),

              // ── Parcel Info ──────────────────────────────────
              const Text('Parcel Dimensions', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _heightController, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Height (cm)'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _widthController, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Width (cm)'))),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _weightController, keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Weight (kg)')),
              const SizedBox(height: 20),

              // ── T&C ─────────────────────────────────────────
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                  ),
                  const Expanded(child: Text('I accept the Terms & Conditions', style: TextStyle(fontFamily: 'Urbanist', fontSize: 13))),
                ],
              ),
              const SizedBox(height: 24),
              CustomAppButton(
                title: 'Confirm Booking',
                isDisabled: !_acceptTerms,
                onPressed: () {
                  if (_formKey.currentState!.validate() && _acceptTerms) {
                    context.push(AppRoutes.parcelDetails);
                    // TODO: call BookingRequestByUser + SaveParcelDescription API
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
