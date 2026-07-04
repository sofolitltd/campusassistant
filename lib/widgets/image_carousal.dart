import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/features/banner/domain/entities/banner.dart' as entity show Banner;
import '/core/theme/tokens/app_radius.dart';

class ImageCarousel extends StatefulWidget {
  final List<entity.Banner> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Start auto sliding images every 10 seconds
  void startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.decelerate,
        );
      }
    });
  }

  // Handle looping to create a seamless transition
  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() {
      _currentPage = index;
      if (index == widget.images.length + 1) {
        _currentPage = 1;
        _pageController.jumpToPage(1);
      } else if (index == 0) {
        _currentPage = widget.images.length;
        _pageController.jumpToPage(widget.images.length);
      }
    });
  }

  // Handle manual indicator tap
  void _onIndicatorTap(int index) {
    _timer?.cancel();
    _pageController.animateToPage(
      index + 1,
      duration: const Duration(milliseconds: 2000),
      curve: Curves.decelerate,
    );
    Future.delayed(const Duration(seconds: 1), () {
      startAutoSlide();
    });
  }

  void _handleBannerTap(entity.Banner banner) async {
    if (banner.clickUrl.isEmpty) return;
    final uri = Uri.tryParse(banner.clickUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              child: SizedBox(
                width: double.infinity,
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.images.length + 2,
                  itemBuilder: (context, index) {
                    final banner = index == 0
                        ? widget.images[widget.images.length - 1]
                        : index == widget.images.length + 1
                        ? widget.images[0]
                        : widget.images[index - 1];

                    return GestureDetector(
                      onTap: () => _handleBannerTap(banner),
                      child: CachedNetworkImage(
                        imageUrl: banner.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.images.length, (index) {
                final isSelected = _currentPage == index + 1;
                return GestureDetector(
                  onTap: () => _onIndicatorTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isSelected ? Colors.white : Colors.white54,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}


