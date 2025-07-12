import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class SharedPreferencesService {
  static const String _recipesKey = 'recipes';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _favoriteRecipesKey = 'favorite_recipes';
  static const String _userPreferencesKey = 'user_preferences';

  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  SharedPreferencesService._();

  // Onboarding related methods
  Future<bool> setOnboardingCompleted(bool completed) async {
    return await _preferences!.setBool(_onboardingCompletedKey, completed);
  }

  bool isOnboardingCompleted() {
    return _preferences!.getBool(_onboardingCompletedKey) ?? false;
  }

  // Recipe related methods
  Future<bool> saveRecipes(List<Recipe> recipes) async {
    try {
      final List<String> recipesJson = recipes
          .map((recipe) => jsonEncode(recipe.toJson()))
          .toList();
      return await _preferences!.setStringList(_recipesKey, recipesJson);
    } catch (e) {
      print('Error saving recipes: $e');
      return false;
    }
  }

  List<Recipe> getRecipes() {
    try {
      final List<String>? recipesJson = _preferences!.getStringList(_recipesKey);
      if (recipesJson == null) return [];
      
      return recipesJson
          .map((recipeString) => Recipe.fromJson(jsonDecode(recipeString)))
          .toList();
    } catch (e) {
      print('Error loading recipes: $e');
      return [];
    }
  }

  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final List<Recipe> currentRecipes = getRecipes();
      currentRecipes.add(recipe);
      return await saveRecipes(currentRecipes);
    } catch (e) {
      print('Error adding recipe: $e');
      return false;
    }
  }

  Future<bool> updateRecipe(int index, Recipe recipe) async {
    try {
      final List<Recipe> currentRecipes = getRecipes();
      if (index >= 0 && index < currentRecipes.length) {
        currentRecipes[index] = recipe;
        return await saveRecipes(currentRecipes);
      }
      return false;
    } catch (e) {
      print('Error updating recipe: $e');
      return false;
    }
  }

  Future<bool> deleteRecipe(int index) async {
    try {
      final List<Recipe> currentRecipes = getRecipes();
      if (index >= 0 && index < currentRecipes.length) {
        currentRecipes.removeAt(index);
        return await saveRecipes(currentRecipes);
      }
      return false;
    } catch (e) {
      print('Error deleting recipe: $e');
      return false;
    }
  }

  // Favorite recipes methods
  Future<bool> saveFavoriteRecipes(List<String> favoriteIds) async {
    return await _preferences!.setStringList(_favoriteRecipesKey, favoriteIds);
  }

  List<String> getFavoriteRecipes() {
    return _preferences!.getStringList(_favoriteRecipesKey) ?? [];
  }

  Future<bool> addToFavorites(String recipeId) async {
    final List<String> favorites = getFavoriteRecipes();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      return await saveFavoriteRecipes(favorites);
    }
    return true;
  }

  Future<bool> removeFromFavorites(String recipeId) async {
    final List<String> favorites = getFavoriteRecipes();
    favorites.remove(recipeId);
    return await saveFavoriteRecipes(favorites);
  }

  bool isFavorite(String recipeId) {
    return getFavoriteRecipes().contains(recipeId);
  }

  // User preferences methods
  Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final String preferencesJson = jsonEncode(preferences);
      return await _preferences!.setString(_userPreferencesKey, preferencesJson);
    } catch (e) {
      print('Error saving user preferences: $e');
      return false;
    }
  }

  Map<String, dynamic> getUserPreferences() {
    try {
      final String? preferencesJson = _preferences!.getString(_userPreferencesKey);
      if (preferencesJson == null) return {};
      return jsonDecode(preferencesJson);
    } catch (e) {
      print('Error loading user preferences: $e');
      return {};
    }
  }

  // Generic methods for additional storage needs
  Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences!.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences!.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences!.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  Future<bool> clear() async {
    return await _preferences!.clear();
  }

  Set<String> getKeys() {
    return _preferences!.getKeys();
  }

  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }
}
