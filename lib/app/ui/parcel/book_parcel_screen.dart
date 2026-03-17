import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';

class BookParcelScreen extends StatefulWidget {
  const BookParcelScreen({super.key});

  @override
  State<BookParcelScreen> createState() => _BookParcelScreenState();
}

class _BookParcelScreenState extends State<BookParcelScreen> {
  int _selectedIndex = 0;

  // TODO: Replace with API data from GetRideType (parcel types)
  final List<Map<String, dynamic>> _parcelTypes = [
    {'name': 'Small', 'desc': 'Up to 2kg', 'fare': 39.0},
    {'name': 'Medium', 'desc': 'Up to 5kg', 'fare': 69.0},
    {'name': 'Large', 'desc': 'Up to 10kg', 'fare': 99.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Choose Parcel Type')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _parcelTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final type = _parcelTypes[i];
                final selected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.lightGreen : AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.greyBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 36, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(type['name'] as String, style: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16)),
                              Text(type['desc'] as String, style: const TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 13)),
                            ],
                          ),
                        ),
                        Text('₹${type['fare']}', style: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomAppButton(
              title: 'Continue',
              onPressed: () => context.push(AppRoutes.parcelBookingReq),
            ),
          ),
        ],
      ),
    );
  }
}
