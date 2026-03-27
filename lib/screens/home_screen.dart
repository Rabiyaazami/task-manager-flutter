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
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          // FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              initialValue: selectedFilter,
              decoration: const InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(),
              ),
              items: ["All", "To-Do", "In Progress", "Done"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedFilter = value!);
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

                      // SEARCH FILTER
                      if (!task.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase())) {
                        return const SizedBox();
                      }

                      // STATUS FILTER
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

                      // BLOCKED LOGIC
                      bool isBlocked = task.blockedBy != null &&
                          tasks.any((t) =>
                              t.id == task.blockedBy &&
                              t.status != TaskStatus.done);

                      return Card(
                        color: isBlocked ? Colors.grey[300] : null,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(task.status.name),

                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final updatedTask =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddTaskScreen(
                                        task: task,
                                        tasks: tasks,
                                      ),
                                    ),
                                  );

                                  if (updatedTask != null) {
                                    setState(() {
                                      tasks[index] = updatedTask;
                                    });
                                  }
                                },
                              ),

                              // DELETE
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    tasks.removeAt(index);
                                  });
                                },
                              ),
                            ],
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