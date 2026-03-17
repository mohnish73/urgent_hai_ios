import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _addressType = 'Home';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Add Address')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address type chips
              const Text('Address Type', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: ['Home', 'Work', 'Other'].map((type) {
                  final selected = _addressType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(type, style: const TextStyle(fontFamily: 'Urbanist')),
                      selected: selected,
                      selectedColor: AppColors.lightGreen,
                      onSelected: (_) => setState(() => _addressType = type),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Full Address'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(hintText: 'City'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'ZIP / Pincode'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // TODO: Add map pin selector (Google Maps)
              Container(
                height: 160,
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text('Tap to pin on map', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                ),
              ),
              const SizedBox(height: 32),
              CustomAppButton(
                title: 'Save Address',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    // TODO: call AddUserNewAddress API
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
