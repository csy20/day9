import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _onboardingPages = [
    const OnboardingPage(
      title: 'Welcome to Recipe Collection!',
      description: 'Discover and save your favorite recipes with ease.',
    ),
    const OnboardingPage(
      title: 'Find Your Favorites',
      description: 'Search through a vast collection of recipes from all over the world.',
    ),
    const OnboardingPage(
      title: 'Get Notified',
      description: 'Receive notifications about new recipes and updates.',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingPages.length,
              itemBuilder: (context, index) => _onboardingPages[index],
            ),
            Positioned(
              bottom: 120.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingPages.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
            Positioned(
              bottom: 40.0,
              left: 20.0,
              right: 20.0,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: _currentPage == _onboardingPages.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          // Complete onboarding and navigate automatically
                          ref.read(onboardingProvider.notifier).completeOnboarding();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Get Started'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text('Next'),
                      ),
              ),
            ),
            if (_currentPage != _onboardingPages.length - 1)
              Positioned(
                top: 20.0,
                right: 20.0,
                child: SafeArea(
                  child: TextButton(
                    onPressed: () {
                      // Skip to complete onboarding
                      ref.read(onboardingProvider.notifier).completeOnboarding();
                    },
                    child: const Text('Skip'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add an icon for visual appeal
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}