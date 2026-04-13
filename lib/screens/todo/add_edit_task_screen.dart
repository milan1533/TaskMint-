import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taskmint/models/task_model.dart';
import 'package:taskmint/services/app_provider.dart';
import 'package:taskmint/theme/app_colors.dart';
import 'package:taskmint/widgets/glass_card.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDate = widget.task?.dueDate ?? DateTime.now();
    _imagePath = widget.task?.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputLabel('Title', isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'What needs to be done?',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              _buildInputLabel('Description', isDark),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descController,
                hint: 'Add some details...',
                maxLines: 4,
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              _buildInputLabel('Due Date', isDark),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  borderRadius: 15,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('MMMM d, yyyy').format(_selectedDate),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputLabel('Task Image (Optional)', isDark),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: GlassCard(
                  padding: const EdgeInsets.all(0),
                  borderRadius: 15,
                  height: 200,
                  width: double.infinity,
                  child: _imagePath == null
                      ? Icon(
                          Icons.add_a_photo_rounded,
                          color: primaryColor,
                          size: 40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(File(_imagePath!), fit: BoxFit.cover),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () =>
                                      setState(() => _imagePath = null),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final provider = Provider.of<AppProvider>(
                        context,
                        listen: false,
                      );
                      if (widget.task == null) {
                        provider.addTask(
                          Task(
                            id: const Uuid().v4(),
                            title: _titleController.text,
                            description: _descController.text,
                            dueDate: _selectedDate,
                            imagePath: _imagePath,
                          ),
                        );
                      } else {
                        provider.updateTask(
                          widget.task!.copyWith(
                            title: _titleController.text,
                            description: _descController.text,
                            dueDate: _selectedDate,
                            imagePath: _imagePath,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: primaryColor.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    widget.task == null ? 'Save Task' : 'Update Task',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }
}
