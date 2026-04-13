import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmint/models/task_model.dart';
import 'package:taskmint/screens/todo/add_edit_task_screen.dart';
import 'package:taskmint/services/app_provider.dart';
import 'package:taskmint/theme/app_colors.dart';
import 'package:taskmint/widgets/glass_card.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<Task> filteredTasks = provider.tasks;
    if (_filter == 'Pending') {
      filteredTasks = provider.tasks.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      filteredTasks = provider.tasks.where((t) => t.isCompleted).toList();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks',
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
                              builder: (_) => const AddEditTaskScreen(),
                            ),
                          );
                        },
                        backgroundColor: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFilterChips(isDark),
                ],
              ),
            ),
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return _buildTaskCard(task, provider, isDark);
                      },
                    ),
            ),
            const SizedBox(height: 100), // Space for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return Row(
      children: ['All', 'Pending', 'Completed'].map((filter) {
        final isSelected = _filter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => _filter = filter);
            },
            selectedColor:
                (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaskCard(Task task, AppProvider provider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(task.id),
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
        onDismissed: (_) => provider.deleteTask(task.id),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
            );
          },
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 20,
            child: Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (val) {
                    provider.updateTask(
                      task.copyWith(isCompleted: val ?? false),
                    );
                  },
                  activeColor: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                if (task.imagePath != null && task.imagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(task.imagePath!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.withValues(alpha: 0.2),
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Colors.grey
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(task.dueDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_rounded,
            size: 80,
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.2)
                : AppColors.lightTextSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
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
