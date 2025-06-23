import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momentum/task_services.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3ECF9), // soft blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Task', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildTextField('Task Name', _titleController),
              const SizedBox(height: 16),
              _buildTextField('Description', _descController, maxLines: 4),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dueDate == null
                            ? 'Due Date'
                            : DateFormat.yMd().format(_dueDate!),
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              SizedBox(height: 60,),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _dueDate == null) return;

    await TaskService().addTask(
      _titleController.text,
      _descController.text,
      _dueDate!,
    );

    Navigator.pop(context); // Go back after saving
  }
}
