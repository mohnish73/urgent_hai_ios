import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class BookRideScreen extends StatefulWidget {
  const BookRideScreen({super.key});

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  int _selectedIndex = 0;

  // TODO: Replace with API data from GetRideType
  final List<Map<String, dynamic>> _rideTypes = [
    {'name': 'Bike', 'image': AppImages.bike, 'seats': 1, 'fare': 49.0},
    {'name': 'Auto', 'image': AppImages.auto, 'seats': 3, 'fare': 79.0},
    {'name': 'Car', 'image': AppImages.car, 'seats': 4, 'fare': 129.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Choose Ride')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _rideTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final ride = _rideTypes[i];
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
                        Image.asset(ride['image'] as String, width: 52, height: 52, fit: BoxFit.contain),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride['name'] as String, style: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16)),
                              Text('${ride['seats']} seat(s)', style: const TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 13)),
                            ],
                          ),
                        ),
                        Text('₹${ride['fare']}', style: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
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
              title: 'Book ${_rideTypes[_selectedIndex]['name']}',
              onPressed: () => context.push(AppRoutes.rideDetails),
            ),
          ),
        ],
      ),
    );
  }
}
