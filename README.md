## 📱 Task Manager App (Flutter)

A simple and functional **Task Manager Application** built using Flutter.
This app allows users to create, manage, and track tasks with features like search, filtering, and task dependencies.

---

## 🚀 Features

✅ Add new tasks
✅ Edit existing tasks
✅ Delete tasks (swipe to delete)
✅ Search tasks by title
✅ Filter tasks by status (To-Do, In Progress, Done)
✅ Task dependency (Blocked Tasks)
✅ Clean and responsive UI

---

## 🧠 Task Dependency Logic

This app supports **Blocked Tasks**:

* A task can depend on another task
* If the parent task is not completed → dependent task is **disabled (greyed out)**
* Once the parent task is marked **Done**, the blocked task becomes active

---

## 🛠️ Tech Stack

* Flutter
* Dart
* Material UI

---

## 📂 Project Structure

```
lib/
│
├── main.dart
├── models/
│   └── task_model.dart
│
└── screens/
    ├── home_screen.dart
    └── add_task_screen.dart
```

---

## ▶️ How to Run

1. Install Flutter SDK
2. Clone this repository
3. Open project in VS Code
4. Run the following command:

```
flutter pub get
flutter run
```

---

## 📸 Screenshots

* Home Screen (Task List with Search & Filter)
* Add Task Screen (with Status & Blocked By)
* Blocked Task UI (greyed out tasks)

---

## 📌 Future Improvements

* Local storage (Hive / SQLite)
* Dark mode
* Task notifications
* Drag & drop task reordering

---

## 🙌 Author

**Rabiya Azami**

---

## ⭐ Acknowledgment

This project was built as part of a Flutter assignment to demonstrate:

* UI development
* State management basics
* Logic implementation (task dependencies)

---
