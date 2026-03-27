import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final List<Task> tasks;

  const AddTaskScreen({super.key, this.task, required this.tasks});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  String selectedStatus = "To-Do";
  String? selectedBlockedTaskId;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? "No date selected"
                        : selectedDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text("Select Date"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: ["To-Do", "In Progress", "Done"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedBlockedTaskId,
              decoration: const InputDecoration(
                labelText: "Blocked By",
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("None"),
                ),
                ...widget.tasks.map(
                  (task) => DropdownMenuItem(
                    value: task.id,
                    child: Text(task.title),
                  ),
                )
              ],
              onChanged: (value) {
                setState(() {
                  selectedBlockedTaskId = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    selectedDate == null) {
                  return;
                }

                final newTask = Task(
                  id: widget.task?.id ??
                      DateTime.now().toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: selectedDate!,
                  status: selectedStatus == "To-Do"
                      ? TaskStatus.todo
                      : selectedStatus == "In Progress"
                          ? TaskStatus.inProgress
                          : TaskStatus.done,
                  blockedBy: selectedBlockedTaskId,
                );

                Navigator.pop(context, newTask);
              },
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}