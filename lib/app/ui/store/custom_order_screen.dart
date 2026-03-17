import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  final _descController = TextEditingController();
  // TODO: Add image_picker for photo selection

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Custom Order')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload Image', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: image_picker launch
              },
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyBorder, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.gray),
                      SizedBox(height: 8),
                      Text('Tap to upload', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Description', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Describe your custom order...'),
            ),
            const Spacer(),
            CustomAppButton(
              title: 'Submit Order',
              onPressed: () {
                // TODO: call custom order API
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
