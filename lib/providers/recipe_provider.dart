import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/shared_preferences_service.dart';

// State notifier for managing recipe list
class RecipeListNotifier extends StateNotifier<List<Recipe>> {
  late SharedPreferencesService _prefsService;
  final List<Recipe> _sampleRecipes;

  RecipeListNotifier(this._sampleRecipes) : super([]) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    _prefsService = await SharedPreferencesService.getInstance();
    _loadRecipes();
  }

  void _loadRecipes() {
    final recipes = _prefsService.getRecipes();
    if (recipes.isEmpty && _sampleRecipes.isNotEmpty) {
      // Load sample recipes if no recipes exist
      state = _sampleRecipes;
      _prefsService.saveRecipes(_sampleRecipes);
    } else {
      state = recipes;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    state = [...state, recipe];
    await _prefsService.saveRecipes(state);
  }

  Future<void> removeRecipe(String id) async {
    state = state.where((recipe) => recipe.id != id).toList();
    await _prefsService.saveRecipes(state);
  }

  Future<void> updateRecipe(Recipe updatedRecipe) async {
    state = [
      for (final recipe in state)
        if (recipe.id == updatedRecipe.id) updatedRecipe else recipe,
    ];
    await _prefsService.saveRecipes(state);
  }

  Future<void> clearRecipes() async {
    state = [];
    await _prefsService.saveRecipes(state);
  }

  Future<void> refreshRecipes() async {
    _loadRecipes();
  }
}

// State notifier for managing favorite recipes
class FavoriteRecipesNotifier extends StateNotifier<List<String>> {
  late SharedPreferencesService _prefsService;

  FavoriteRecipesNotifier() : super([]) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    _prefsService = await SharedPreferencesService.getInstance();
    _loadFavorites();
  }

  void _loadFavorites() {
    final favorites = _prefsService.getFavoriteRecipes();
    state = favorites;
  }

  Future<void> toggleFavorite(String recipeId) async {
    if (state.contains(recipeId)) {
      state = state.where((id) => id != recipeId).toList();
      await _prefsService.removeFromFavorites(recipeId);
    } else {
      state = [...state, recipeId];
      await _prefsService.addToFavorites(recipeId);
    }
  }

  bool isFavorite(String recipeId) {
    return state.contains(recipeId);
  }

  Future<void> clearFavorites() async {
    state = [];
    await _prefsService.saveFavoriteRecipes(state);
  }
}

// State notifier for managing onboarding state
class OnboardingNotifier extends StateNotifier<bool> {
  late SharedPreferencesService _prefsService;

  OnboardingNotifier() : super(false) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    _prefsService = await SharedPreferencesService.getInstance();
    state = _prefsService.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    state = true;
    await _prefsService.setOnboardingCompleted(true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    await _prefsService.setOnboardingCompleted(false);
  }
}

// Provider for the recipe list
final recipeListProvider = StateNotifierProvider<RecipeListNotifier, List<Recipe>>((ref) {
  final sampleRecipes = ref.read(sampleRecipesProvider);
  return RecipeListNotifier(sampleRecipes);
});

// Provider for favorites
final favoriteRecipesProvider = StateNotifierProvider<FavoriteRecipesNotifier, List<String>>((ref) {
  return FavoriteRecipesNotifier();
});

// Provider for onboarding state
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

// Provider for getting a specific recipe by ID
final recipeByIdProvider = Provider.family<Recipe?, String>((ref, id) {
  final recipes = ref.watch(recipeListProvider);
  try {
    return recipes.firstWhere((recipe) => recipe.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for filtered recipes (for search functionality)
final filteredRecipesProvider = Provider.family<List<Recipe>, String>((ref, query) {
  final recipes = ref.watch(recipeListProvider);
  if (query.isEmpty) {
    return recipes;
  }
  
  return recipes.where((recipe) {
    return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
           recipe.description.toLowerCase().contains(query.toLowerCase()) ||
           recipe.ingredients.any((ingredient) => 
               ingredient.toLowerCase().contains(query.toLowerCase()));
  }).toList();
});

// Provider for getting favorite recipes
final favoriteRecipeListProvider = Provider<List<Recipe>>((ref) {
  final allRecipes = ref.watch(recipeListProvider);
  final favoriteIds = ref.watch(favoriteRecipesProvider);
  return allRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
});

// Sample data provider for initial recipes
final sampleRecipesProvider = Provider<List<Recipe>>((ref) {
  return [
    Recipe(
      id: '1',
      title: 'Classic Spaghetti Carbonara',
      description: 'A traditional Italian pasta dish with eggs, cheese, and pancetta.',
      ingredients: [
        '400g spaghetti',
        '200g pancetta or guanciale',
        '4 large eggs',
        '100g Pecorino Romano cheese',
        '2 cloves garlic',
        'Black pepper',
        'Salt',
      ],
      instructions: [
        'Bring a large pot of salted water to boil and cook spaghetti according to package directions.',
        'Meanwhile, cook pancetta in a large skillet until crispy.',
        'In a bowl, whisk together eggs, grated cheese, and black pepper.',
        'Drain pasta, reserving 1 cup pasta water.',
        'Add hot pasta to the skillet with pancetta.',
        'Remove from heat and quickly stir in egg mixture, adding pasta water as needed.',
        'Serve immediately with extra cheese and pepper.',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=800',
      prepTime: 10,
      cookTime: 20,
      servings: 4,
      difficulty: 'Medium',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Recipe(
      id: '2',
      title: 'Chocolate Chip Cookies',
      description: 'Soft and chewy chocolate chip cookies that are perfect for any occasion.',
      ingredients: [
        '2 1/4 cups all-purpose flour',
        '1 tsp baking soda',
        '1 tsp salt',
        '1 cup butter, softened',
        '3/4 cup granulated sugar',
        '3/4 cup brown sugar',
        '2 large eggs',
        '2 tsp vanilla extract',
        '2 cups chocolate chips',
      ],
      instructions: [
        'Preheat oven to 375°F (190°C).',
        'In a bowl, whisk together flour, baking soda, and salt.',
        'In another bowl, cream butter and both sugars until fluffy.',
        'Beat in eggs and vanilla.',
        'Gradually blend in flour mixture.',
        'Stir in chocolate chips.',
        'Drop rounded tablespoons of dough onto ungreased cookie sheets.',
        'Bake 9-11 minutes or until golden brown.',
        'Cool on baking sheet for 2 minutes before removing.',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=800',
      prepTime: 15,
      cookTime: 11,
      servings: 24,
      difficulty: 'Easy',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Recipe(
      id: '3',
      title: 'Grilled Salmon with Lemon',
      description: 'Perfectly grilled salmon with a fresh lemon and herb marinade.',
      ingredients: [
        '4 salmon fillets',
        '2 lemons (juiced)',
        '3 tbsp olive oil',
        '2 cloves garlic, minced',
        '1 tbsp fresh dill',
        '1 tbsp fresh parsley',
        'Salt and pepper',
        'Lemon wedges for serving',
      ],
      instructions: [
        'Preheat grill to medium-high heat.',
        'In a bowl, mix lemon juice, olive oil, garlic, dill, and parsley.',
        'Season salmon with salt and pepper.',
        'Marinate salmon in herb mixture for 15 minutes.',
        'Grill salmon for 4-6 minutes per side.',
        'Cook until fish flakes easily with a fork.',
        'Serve with lemon wedges and fresh herbs.',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
      prepTime: 20,
      cookTime: 12,
      servings: 4,
      difficulty: 'Medium',
      createdAt: DateTime.now(),
    ),
  ];
});
