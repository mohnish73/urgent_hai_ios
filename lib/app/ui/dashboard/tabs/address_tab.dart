import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../model/address/address_model.dart';
import '../../../provider/address_provider.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../utils/widgets/api_state_builder.dart';

class AddressTab extends StatefulWidget {
  const AddressTab({super.key});

  @override
  State<AddressTab> createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('My Addresses',
            style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.addAddress),
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (_, provider, __) => ApiStateBuilder<List<AddressData>>(
          response: provider.addresses,
          onRetry: () => provider.fetchAddresses(),
          idleWidget: const _EmptyAddresses(),
          builder: (list) => list.isEmpty
              ? const _EmptyAddresses()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.greyBorder),
                  itemBuilder: (_, i) => _AddressCard(address: list[i]),
                ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressData address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            address.isPrimaryAddress
                ? AppImages.addressHome
                : AppImages.mapAddress,
            width: 24,
            height: 24,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.addressType.isNotEmpty
                          ? address.addressType
                          : 'Address',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    if (address.isPrimaryAddress) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Primary',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.address,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (address.city.isNotEmpty)
                  Text(
                    '${address.city}, ${address.country}',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                  ),
              ],
            ),
          ),
          Image.asset(AppImages.rightArrow, width: 16, height: 16),
        ],
      ),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  const _EmptyAddresses();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.mapAddress, width: 80, height: 80,
              color: AppColors.grey),
          const SizedBox(height: 16),
          const Text(
            'No addresses saved yet.',
            style: TextStyle(
                fontFamily: 'Urbanist',
                color: AppColors.gray,
                fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to add your first address',
            style: TextStyle(
                fontFamily: 'Urbanist',
                color: AppColors.grey,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}
