import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/expense_model.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _expensesKey = 'expenses';
  static const String _themeKey = 'isDarkMode';
  static const String _usernameKey = 'username';

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Tasks
  Future<void> saveTasks(List<Task> tasks) async {
    final String encodedData = json.encode(
      tasks.map((t) => t.toMap()).toList(),
    );
    await _prefs?.setString(_tasksKey, encodedData);
  }

  List<Task> getTasks() {
    final String? encodedData = _prefs?.getString(_tasksKey);
    if (encodedData == null) return [];
    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((t) => Task.fromMap(t)).toList();
  }

  // Expenses
  Future<void> saveExpenses(List<Expense> expenses) async {
    final String encodedData = json.encode(
      expenses.map((e) => e.toMap()).toList(),
    );
    await _prefs?.setString(_expensesKey, encodedData);
  }

  List<Expense> getExpenses() {
    final String? encodedData = _prefs?.getString(_expensesKey);
    if (encodedData == null) return [];
    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((e) => Expense.fromMap(e)).toList();
  }

  // Theme
  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs?.setBool(_themeKey, isDarkMode);
  }

  bool getThemeMode() {
    return _prefs?.getBool(_themeKey) ?? false;
  }

  // Username
  Future<void> saveUsername(String username) async {
    await _prefs?.setString(_usernameKey, username);
  }

  String getUsername() {
    return _prefs?.getString(_usernameKey) ?? 'User';
  }
}
