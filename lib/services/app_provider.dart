import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/expense_model.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Task> _tasks = [];
  List<Expense> _expenses = [];
  bool _isDarkMode = false;
  String _username = 'User';

  List<Task> get tasks => _tasks;
  List<Expense> get expenses => _expenses;
  bool get isDarkMode => _isDarkMode;
  String get username => _username;

  Future<void> init() async {
    await _storageService.init();
    _tasks = _storageService.getTasks();
    _expenses = _storageService.getExpenses();
    _isDarkMode = _storageService.getThemeMode();
    _username = _storageService.getUsername();
    notifyListeners();
  }

  // Theme Management
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  // Task Management
  void addTask(Task task) {
    _tasks.add(task);
    _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  // Expense Management
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _storageService.saveExpenses(_expenses);
    notifyListeners();
  }

  void updateExpense(Expense expense) {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      _storageService.saveExpenses(_expenses);
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    _storageService.saveExpenses(_expenses);
    notifyListeners();
  }

  // Settings
  void updateUsername(String name) {
    _username = name;
    _storageService.saveUsername(name);
    notifyListeners();
  }
}
