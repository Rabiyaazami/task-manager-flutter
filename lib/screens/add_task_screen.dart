import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final List<Task> tasks;

  const AddTaskScreen({super.key, this.task, required this.tasks});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  String selectedStatus = "To-Do";
  String? selectedBlockedTaskId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = widget.task!.dueDate;
      selectedBlockedTaskId = widget.task!.blockedBy;

      selectedStatus = widget.task!.status == TaskStatus.todo
          ? "To-Do"
          : widget.task!.status == TaskStatus.inProgress
              ? "In Progress"
              : "Done";
    } else {
      loadDraft();
    }
  }

  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("title", titleController.text);
    await prefs.setString("description", descriptionController.text);
  }

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    titleController.text = prefs.getString("title") ?? "";
    descriptionController.text =
        prefs.getString("description") ?? "";
    setState(() {});
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: (_) => saveDraft(),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: "Description"),
              onChanged: (_) => saveDraft(),
            ),

            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Text(selectedDate == null
                  ? "Select Date"
                  : selectedDate.toString().split(" ")[0]),
            ),

            DropdownButtonFormField(
              initialValue: selectedStatus,
              items: ["To-Do", "In Progress", "Done"]
                  .map((e) => DropdownMenuItem(
                      value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedStatus = value!);
              },
            ),

            DropdownButtonFormField<String>(
              initialValue: selectedBlockedTaskId,
              hint: const Text("Blocked By"),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text("None")),
                ...widget.tasks.map((task) => DropdownMenuItem(
                      value: task.id,
                      child: Text(task.title),
                    )),
              ],
              onChanged: (value) {
                setState(() => selectedBlockedTaskId = value);
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          selectedDate == null) {
                        return;
                      }

                      setState(() => isLoading = true);

                      await Future.delayed(
                          const Duration(seconds: 2));

                      final newTask = Task(
                        id: widget.task?.id ??
                            DateTime.now().toString(),
                        title: titleController.text,
                        description:
                            descriptionController.text,
                        dueDate: selectedDate!,
                        status: selectedStatus == "To-Do"
                            ? TaskStatus.todo
                            : selectedStatus == "In Progress"
                                ? TaskStatus.inProgress
                                : TaskStatus.done,
                        blockedBy: selectedBlockedTaskId,
                      );

                      await clearDraft();

                      if (!mounted) return;

                      setState(() => isLoading = false);
                      Navigator.pop(context, newTask);
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}