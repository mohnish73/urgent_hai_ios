import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/location_service.dart';
import '../../../core/storage/hive_service.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_constants.dart';
import '../../../theme/app_images.dart';
import '../../../theme/app_strings.dart';

// ── Slider data ──────────────────────────────────────────────
class _SlideItem {
  final String image;
  final String caption;
  const _SlideItem(this.image, this.caption);
}

const _slides = [
  _SlideItem(AppImages.slider1, AppStrings.slide1Caption),
  _SlideItem(AppImages.slider2, AppStrings.slide2Caption),
  _SlideItem(AppImages.slider3, AppStrings.slide3Caption),
  _SlideItem(AppImages.slider4, AppStrings.slide4Caption),
];

// ── HomeTab ──────────────────────────────────────────────────
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _locCity = '';
  String _locCountry = AppStrings.defaultCountry;
  int _currentSlide = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final result = await LocationService.fetchCurrentLocation();
    if (result != null && mounted) {
      setState(() {
        _locCity = result.city;
        _locCountry = result.country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = HiveService.getFirstName() ?? '';
    final locationLabel =
        _locCity.isNotEmpty ? '$_locCity, $_locCountry' : _locCountry;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location row ─────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GestureDetector(
                onTap: _loadLocation,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.location, width: 24, height: 24),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        locationLabel,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Scrollable content ───────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Greeting ──────────────────────────
                    Row(
                      children: [
                        Text(
                          'Welcome $firstName!',
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('👋', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Welcome note ──────────────────────
                    const Text(
                      AppStrings.homeWelcomeNote,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Image Slider + dots ───────────────
                    Stack(
                      children: [
                        CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: AppConstants.carouselHeight,
                            autoPlay: true,
                            autoPlayInterval: const Duration(
                                milliseconds: AppConstants.carouselAutoPlayMs),
                            autoPlayAnimationDuration: const Duration(
                                milliseconds: AppConstants.carouselAnimationMs),
                            enlargeCenterPage: false,
                            viewportFraction: 1.0,
                            onPageChanged: (index, _) =>
                                setState(() => _currentSlide = index),
                          ),
                          items: _slides
                              .map((slide) => _SliderItem(slide: slide))
                              .toList(),
                        ),

                        // Dots indicator
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _slides.length,
                              (i) => GestureDetector(
                                onTap: () =>
                                    _carouselController.animateToPage(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _currentSlide == i ? 20 : 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: _currentSlide == i
                                        ? AppColors.white
                                        : AppColors.white.withAlpha(128),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Service Cards ─────────────────────
                    const SizedBox(height: 10),

                    // Row 1: Ride | Parcel
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceCard(
                            title: AppStrings.serviceRide,
                            subtitle: AppStrings.serviceRideDesc,
                            image: AppImages.dashboard1,
                            onTap: () =>
                                context.push(AppRoutes.rideDashboard),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ServiceCard(
                            title: AppStrings.serviceParcel,
                            subtitle: AppStrings.serviceParcelDesc,
                            image: AppImages.dashboard2,
                            onTap: () =>
                                context.push(AppRoutes.parcelDashboard),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Row 2: Store | empty
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceCard(
                            title: AppStrings.serviceStore,
                            subtitle: AppStrings.serviceStoreDesc,
                            image: AppImages.dashboard3,
                            onTap: () =>
                                context.push(AppRoutes.storeDashboard),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: SizedBox(height: 120)),
                      ],
                    ),

                    // ── Footer ────────────────────────────
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.homeFooterTitle,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                    ),
                    const Text(
                      AppStrings.homeFooterTagline,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 22,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slider item with caption overlay ────────────────────────
class _SliderItem extends StatelessWidget {
  final _SlideItem slide;
  const _SliderItem({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(slide.image, fit: BoxFit.cover),

        // Dark gradient at bottom for caption readability
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xCC000000), Colors.transparent],
              ),
            ),
          ),
        ),

        // Caption text
        Positioned(
          left: 12,
          right: 40, // leave space for dots
          bottom: 20,
          child: Text(
            slide.caption,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Service card ─────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.serviceCardHeight,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Title + subtitle top-left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),

            // Dashboard image bottom-right
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(image,
                  width: AppConstants.serviceCardImageW,
                  height: AppConstants.serviceCardImageH,
                  fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
