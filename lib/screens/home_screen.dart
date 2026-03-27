import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  String searchQuery = "";
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🔽 Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(),
              ),
              items: ["All", "To-Do", "In Progress", "Done"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("No tasks yet"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      if (!task.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase())) {
                        return const SizedBox();
                      }

                      if (selectedFilter != "All") {
                        String statusText =
                            task.status == TaskStatus.todo
                                ? "To-Do"
                                : task.status == TaskStatus.inProgress
                                    ? "In Progress"
                                    : "Done";

                        if (statusText != selectedFilter) {
                          return const SizedBox();
                        }
                      }

                      bool isBlocked = task.blockedBy != null &&
                          tasks.any((t) =>
                              t.id == task.blockedBy &&
                              t.status != TaskStatus.done);

                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child:
                              const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                        child: Card(
                          color: isBlocked ? Colors.grey[300] : null,
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Text(task.status.name),
                            onTap: () async {
                              final updatedTask = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddTaskScreen(task: task, tasks: tasks),
                                ),
                              );

                              if (updatedTask != null) {
                                setState(() {
                                  tasks[index] = updatedTask;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(tasks: tasks),
            ),
          );

          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}