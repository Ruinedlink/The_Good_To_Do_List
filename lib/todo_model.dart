import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

Future<Directory> _listsDirectory() async {
  final base = await getApplicationSupportDirectory();
  final dir = Directory('${base.path}${Platform.pathSeparator}lists');
  await dir.create(recursive: true);
  return dir;
}

String _generateId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(99999)}';

mixin TaskContainer {
  List<Task> get tasks;

  Task? findTaskById(String id) {
    for (var t in tasks) {
      if (t.id == id) return t;
      final found = t.findTaskById(id);
      if (found != null) return found;
    }
    return null;
  }

  bool removeTaskById(String id) {
    for (var t in tasks) {
      if (t.id == id) {
        tasks.remove(t);
        return true;
      }
      if (t.removeTaskById(id)) return true;
    }
    return false;
  }

  void addChildTask(Task task) {
    tasks.add(task);
  }
}

class ToDoList with TaskContainer {
  String name;
  @override
  List<Task> tasks;
  bool isNew;
  String? id;

  void initState() {
    if (isNew) {
      saveToFile();
      isNew = !isNew;
    }
  }

  ToDoList(this.name, {this.isNew = true, List<Task>? tasks, String? id})
    : tasks = tasks ?? [],
      id = id ?? _generateId();

  Future<File> _file() async {
    final dir = await _listsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$id.json');
  }

  void addTask(Task task) {
    tasks.add(task);
    saveToFile();
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'isNew': isNew,
    'tasks': tasks.map((task) => task.toJson()).toList(),
  };

  factory ToDoList.fromJson(Map<String, dynamic> json) {
    var rawTasks = json['tasks'] as List<dynamic>? ?? [];
    List<Task> parsedTasks = rawTasks
        .map((taskJson) => Task.fromJson(taskJson))
        .toList();

    return ToDoList(
      json['name'] as String,
      isNew: json['isNew'] as bool,
      tasks: parsedTasks,
      id: json['id'] ?? _generateId() as String?,
    );
  }

  Future<void> saveToFile() async {
    final file = await _file();
    final jsonString = const JsonEncoder.withIndent('  ').convert(toJson());
    await file.writeAsString(jsonString);
  }

  String getName() {
    return name;
  }
}

class Task with TaskContainer {
  String text;
  String id;
  DateTime? deadline;
  bool status;
  String? priority;
  String time;
  String? notes;
  String? parentId;
  List<Task> subTasks;
  @override
  List<Task> get tasks => subTasks;

  Task(
    this.text, {
    this.parentId,
    String? id,
    this.deadline,
    this.status = false,
    this.priority,
    this.time = '',
    this.notes = '',
    required this.subTasks,
  }) : id = id ?? _generateId();

  factory Task.fromJson(Map<String, dynamic> json) {
    var rawSubTasks = json['subTasks'] as List<dynamic>? ?? [];
    List<Task> parcedSubTasks = rawSubTasks
        .map((subTaskJson) => Task.fromJson(subTaskJson))
        .toList();
    return Task(
      json['text'] as String,
      parentId: json['parentId'] as String?,
      id: json['id'] ?? _generateId() as String?,
      deadline: (json['deadline'] as String?) == null
          ? null
          : DateTime.tryParse(json['deadline'] as String),
      status: json['status'] as bool,
      priority: json['priority'] as String?,
      time: json['time'] as String,
      notes: json['notes'] as String?,
      subTasks: parcedSubTasks,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'id': id,
    'parentId': parentId,
    'deadline': deadline?.toString(),
    'status': status,
    'priority': priority,
    'time': time,
    'notes': notes,
    'subTasks': subTasks.map((task) => task.toJson()).toList(),
  };

  void addSubTask(Task t) {
    subTasks.add(t);
  }

  void setText(String t) {
    text = t;
  }

  void setDeadline(DateTime? d) {
    deadline = d;
  }

  void setStatus(bool s) {
    status = s;
  }

  void setPriority(String? p) {
    priority = p;
  }

  void setTime(String s) {
    time = s;
  }

  void setNotes(String n) {
    notes = n;
  }

  void setParentId(String id) {
    parentId = id;
  }
}

Stream<ToDoList> importFromFile() async* {
  final dir = await _listsDirectory();
  print((await getApplicationSupportDirectory()).path);
  await for (final entity in dir.list()) {
    if (entity is File && entity.path.endsWith('.json')) {
      try {
        final decoded = jsonDecode(await entity.readAsString());
        yield ToDoList.fromJson(decoded);
      } catch (e) {
        //ignore: avoid_print
        print('Skipping unreadable file ${entity.path}: $e');
      }
    }
  }
}

// Future main() async {
//   var chores = ToDoList('Chores');
//   chores.addTask('Feed the dog');
//   // chores.saveToFile();

//   List<ToDoList> userLists = await importFromFile().toList();
//   for (ToDoList i in userLists) {
//     // print(i.name);
//   }

// }
