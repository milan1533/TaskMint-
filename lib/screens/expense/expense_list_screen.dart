import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmint/models/expense_model.dart';
import 'package:taskmint/screens/expense/add_edit_expense_screen.dart';
import 'package:taskmint/services/app_provider.dart';
import 'package:taskmint/theme/app_colors.dart';
import 'package:taskmint/widgets/glass_card.dart';
import 'package:intl/intl.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalExpenses = provider.expenses.fold(
      0.0,
      (sum, e) => sum + e.amount,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditExpenseScreen(),
                        ),
                      );
                    },
                    backgroundColor: isDark
                        ? AppColors.darkSecondary
                        : AppColors.lightSecondary,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            _buildTotalSection(totalExpenses, isDark),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: provider.expenses.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: provider.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = provider.expenses.reversed
                            .toList()[index];
                        return _buildExpenseCard(expense, provider, isDark);
                      },
                    ),
            ),
            const SizedBox(height: 100), // Space for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(double total, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassCard(
        borderRadius: 24,
        gradientColors: [
          isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
          isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ],
        child: Column(
          children: [
            const Text(
              'Total Spent',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense, AppProvider provider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(expense.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.delete_outline, color: AppColors.error),
        ),
        onDismissed: (_) => provider.deleteExpense(expense.id),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditExpenseScreen(expense: expense),
              ),
            );
          },
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 20,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        (isDark
                                ? AppColors.darkSecondary
                                : AppColors.lightSecondary)
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(expense.category),
                    color: isDark
                        ? AppColors.darkSecondary
                        : AppColors.lightSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${expense.category} • ${DateFormat('MMM d').format(expense.date)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '-₹${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood_rounded;
      case 'Transport':
        return Icons.directions_bus_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      case 'Entertainment':
        return Icons.movie_creation_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 80,
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.2)
                : AppColors.lightTextSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: TextStyle(
              fontSize: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
