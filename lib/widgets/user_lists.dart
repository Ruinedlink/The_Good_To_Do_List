import 'package:todo_model/todo_model.dart';

enum ViewSortMethod {
  all('All'),
  week('Week'),
  today('Today'),
  none('None');

  final String view;

  const ViewSortMethod(this.view);
}

List<Task> sortViewCatagory(List<Task> tasks, ViewSortMethod method) {
  final now = DateTime.now();
  List<Task> returnList = [];
  switch (method) {
    case ViewSortMethod.all:
      returnList = tasks;
      return returnList;

    case ViewSortMethod.week:
      final inAWeek = DateTime(now.year, now.month, (now.day + 7), 23, 59);
      for (Task task in tasks) {
        if (task.deadline != null) {
          if (task.deadline!.isBefore(inAWeek)) {
            returnList.add(task);
          }
        }
      }
      return returnList;

    case ViewSortMethod.today:
      final today = DateTime(now.year, now.month, now.day, 23, 59);
      for (Task task in tasks) {
        if (task.deadline != null) {
          if (task.deadline!.isBefore(today)) {
            returnList.add(task);
          }
        }
      }
      return returnList;

    default:
      returnList = tasks;
      return returnList;
  }
}

class ToDoLists {
  late List<ToDoList> lists;
  late ToDoList? inbox;

  ToDoLists({required this.lists, required this.inbox});

  List<ToDoList> get userLists {
    final List<ToDoList> returnList = [];

    for (ToDoList list in lists) {
      if (list != inbox) {
        returnList.add(list);
      }
    }
    return returnList;
  }

  List<Task> get allTasks {
    final List<Task> returnList = [];

    for (ToDoList list in lists) {
      returnList.addAll(list.tasks);
    }
    return returnList;
  }

  Map<String, ToDoList> get _idToListMap {
    Map<String, ToDoList> finalMap = {};
    for (ToDoList list in lists) {
      finalMap[list.id!] = list;
    }
    return finalMap;
  }

  ToDoList? idToList(String id) {
    return _idToListMap[id];
  }
}
