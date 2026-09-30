import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/task_specifics.dart';
import 'package:todo_model/widgets/task_view.dart';
import 'package:todo_model/widgets/sidebar.dart';
import 'package:todo_model/widgets/input_task_bar.dart';
import 'package:todo_model/widgets/sort_button.dart';
import 'package:todo_model/widgets/user_lists.dart';

import 'package:todo_model/widgets/settings_pannel_dialog.dart';

class ToDoListPage extends StatelessWidget {
  final List<ToDoList> userLists;

  const new({super.key, required this.userLists});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ToDoListBody(userLists: userLists));
  }
}

class ToDoListBody extends StatefulWidget {
  final List<ToDoList> userLists;
  const new({super.key, required this.userLists});

  @override
  State<ToDoListBody> createState() => _ToDoListBodyState();
}

class _ToDoListBodyState extends State<ToDoListBody> {
  late ToDoLists toDoLists;
  late ToDoList selectedList;
  late Task? selectedTask;
  late bool sidebarShown;
  late ViewSortMethod viewSortMethod;
  late Map<String, ToDoList> listToId;

  SortMethod? sortMethod;

  final UniqueKey _taskSpecificsKey = UniqueKey();
  final UniqueKey _taskView = UniqueKey();

  @override
  void initState() {
    super.initState();
    ToDoList inbox = ToDoList('Inbox', id: '00000-000');

    if (widget.userLists.isEmpty) {
      widget.userLists.add(ToDoList('Inbox', id: '00000-000'));
      widget.userLists.add(ToDoList('My first List!'));
    }
    for (ToDoList list in widget.userLists) {
      if (list.id == '00000-000') {
        setState(() {
          inbox = list;
        });
      }
    }

    toDoLists = ToDoLists(lists: widget.userLists, inbox: inbox);

    viewSortMethod = .all;

    selectedList = toDoLists.inbox!;

    selectedTask = null;

    sidebarShown = true;
  }

  void _openSettingsPanel() {
    showSettingsPanelDialoug(context);
  }

  void onChangeSelectedView(ViewSortMethod method) {
    setState(() {
      viewSortMethod = method;
    });
  }

  void onAddList(String name) {
    ToDoList newList = ToDoList(name);
    newList.saveToFile;
    setState(() {
      toDoLists.lists.add(newList);
    });
    debugPrint('Added List $name');
  }

  void onChangeSelectedList(ToDoList list) {
    selectedList.saveToFile();
    debugPrint("Change selected to ${list.name}");
    selectedList = list;
    setState(() {
      viewSortMethod = ViewSortMethod.none;
      selectedList;
      if (!selectedList.tasks.contains(selectedTask)) {
        selectedTask = null;
      }
    });
  }

  void addTask(Task task) {
    setState(() {
      task.setParentId(selectedList.id!);

      toDoLists.idToList(task.parentId!)!.addChildTask(task);
      toDoLists.idToList(task.parentId!)!.saveToFile();
    });
  }

  // void _onTapUp(TapUpDetails details) {
  //   debugPrint('Everything clicked');
  //   ContextMenuController.removeAny();
  // }

  void _updateSelectedTask(Task? task) {
    if (task == null) {
      setState(() {
        selectedTask = null;
      });
      return;
    }
    debugPrint('Updating selected task ${task.text}');

    setState(() {
      debugPrint("new task ${task.text}");
      // debugPrint({selectedTask == task}.toString());
      selectedTask = task;
      toDoLists.idToList(task.parentId!)!.saveToFile();
    });
  }

  void _onPulloutMenuButtonPressed() {
    debugPrint('Pullout menu button clicked');
    setState(() {
      sidebarShown = !sidebarShown;
    });
  }

  void _onSortMethodChanged(SortMethod method) {
    setState(() => sortMethod = method);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Sidebar(
          toDoLists: toDoLists,
          onAddList: onAddList,
          onChangeSelected: onChangeSelectedList,
          onSelectedViewChanged: onChangeSelectedView,
          sidebarShown: sidebarShown,
          onOpenSettingsPanel: () => {
            showSettingsPanelDialoug(context),
            debugPrint('Show settings pannel'),
          },
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _onPulloutMenuButtonPressed,
                        icon: sidebarShown == false
                            ? Icon(Icons.menu)
                            : Icon(Icons.menu_open),
                        iconSize: 30,
                      ),
                      Text(
                        viewSortMethod == ViewSortMethod.none
                            ? selectedList.name
                            : viewSortMethod.view,
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      SortButton(
                        selectedMethod: sortMethod,
                        onSortMethodChanged: _onSortMethodChanged,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                height: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TaskInput(
                    key: UniqueKey(),
                    onAddTask: (value) => addTask(value),
                    selectedList: selectedList,
                  ),
                ),
              ), //Task inputs
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: TaskView(
                      key: _taskView,
                      viewSortMethod: viewSortMethod,
                      sortMethod: sortMethod,
                      allLists: toDoLists,
                      selectedList: selectedList,
                      onSelectedItemChanged: _updateSelectedTask,
                      selectedTask: selectedTask,
                    ),
                  ),
                ), // Task View,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: TaskSpecifics(
            key: _taskSpecificsKey,
            selectedList: selectedList,
            selectedTask: selectedTask,
            onUpdateSelectedTaskDetails: _updateSelectedTask,
          ),
        ),
      ],
    );
  }
}
