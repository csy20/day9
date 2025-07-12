import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/onboarding_screen.dart';
import 'widgets/recipe_list_screen.dart';
import 'providers/recipe_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnboardingCompleted = ref.watch(onboardingProvider);
    
    return MaterialApp(
      title: 'Digital Recipe Card',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: isOnboardingCompleted 
          ? const RecipeListScreen() 
          : const OnboardingScreen(),
    );
  }
}