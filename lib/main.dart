//main.dart
import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/task_specifics.dart';
import 'package:todo_model/widgets/task_view.dart';
import 'package:todo_model/widgets/sidebar.dart';
import 'package:todo_model/widgets/input_task_bar.dart';
import 'package:todo_model/widgets/sort_button.dart';

typedef ContextMenuBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<ToDoList> userLists = await importFromFile().toList();
  for (ToDoList i in userLists) {
    debugPrint(i.name);
  }

  runApp(MyApp(userLists: userLists));
}

class MyApp extends StatefulWidget {
  final List<ToDoList> userLists;
  const MyApp({super.key, required this.userLists});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late List<ToDoList> userLists;

  @override
  void initState() {
    super.initState();
    userLists = widget.userLists;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData blueOrange = ThemeData(
      // accent Red Color.fromARGB(255, 167, 42, 9)
      // Orange Color.fromARGB(255, 244, 107, 62)
      // Cyan Color.fromARGB(255, 6, 93, 125)
      // Dark Blue Color.fromARGB(255, 0, 61, 90)
      // Forest Green Color.fromARGB(255, 30, 45, 22)

      useMaterial3: true,

      colorSchemeSeed: Color.fromARGB(255, 244, 107, 62),

      brightness: Brightness.dark,

      highlightColor: Color.fromARGB(255, 30, 45, 22),

      canvasColor: Color.fromARGB(255, 0, 61, 90),

      dialogTheme: DialogThemeData(
        backgroundColor: Color.fromARGB(255, 0, 61, 90),
      ),

      scaffoldBackgroundColor: Color.fromARGB(150, 0, 61, 90),

      iconTheme: IconThemeData(color: const Color.fromARGB(100, 255, 255, 255)),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      splashColor: Colors.transparent,

      listTileTheme: ListTileThemeData(),
    );

    ThemeData darkPurple = ThemeData(
      // Dark Grey Color.fromARGB(255, 25, 25, 25)
      // Light Grey Color.fromARGB(255, 100, 100, 100)
      // Accent Purple Color.fromARGB(255, 145, 118, 172)

      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 145, 118, 172),
      ),

      primaryColor: Color.fromARGB(255, 145, 118, 172),

      highlightColor: Color.fromARGB(255, 145, 118, 172),

      iconTheme: IconThemeData(color: const Color.fromARGB(255, 100, 100, 100)),
    );

    return MaterialApp(
      // Light Theme
      theme: darkPurple,

      //Dark Theme
      darkTheme: blueOrange,

      themeMode: ThemeMode.dark,

      debugShowCheckedModeBanner: false,
      home: HomePage(userLists: userLists),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<ToDoList> userLists;
  const HomePage({super.key, required this.userLists});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<ToDoList> userLists;
  late ToDoList selectedList;
  late Task? selectedTask;
  late bool sidebarShown;
  SortMethod? sortMethod;

  final UniqueKey _taskSpecificsKey = UniqueKey();
  final UniqueKey _taskView = UniqueKey();

  @override
  void initState() {
    super.initState();

    userLists = widget.userLists;

    if (userLists.isEmpty) {
      userLists.add(ToDoList('My first List!'));
    }

    selectedList = userLists[0];

    selectedTask = null;

    sidebarShown = true;
  }

  void onAddList(String name) {
    ToDoList newList = ToDoList(name);
    newList.saveToFile;
    setState(() {
      userLists.add(newList);
    });
    debugPrint('Added List $name');
  }

  void onChangeSelectedList(ToDoList list) {
    selectedList.saveToFile();
    debugPrint("Change selected to ${list.name}");
    selectedList = list;
    setState(() {
      selectedList;
    });
  }

  void addTask(Task task) {
    setState(() {
      task.setParentId(selectedList.id!);
      selectedList.addChildTask(task);
      selectedList.saveToFile();
    });
  }

  // void _onTapUp(TapUpDetails details) {
  //   debugPrint('Everything clicked');
  //   ContextMenuController.removeAny();
  // }

  void _updateSelectedTask(Task? task) {
    if (task == null) {
      return;
    }
    debugPrint('Updating selected task ${task.text}');
    setState(() {
      debugPrint("new task ${task.text}");
      debugPrint({selectedTask == task}.toString());
      selectedTask = task;
      selectedList;
      selectedList.saveToFile();
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

  List<dynamic> get _displayList {
    final method = sortMethod;
    return method == null
        ? selectedList.tasks
        : sortTasks(selectedList.tasks, method);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 25, 25, 25),
      body: Row(
        children: [
          Sidebar(
            userLists: userLists,
            onAddList: onAddList,
            onChangeSelected: onChangeSelectedList,
            sidebarShown: sidebarShown,
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
                        Text(selectedList.name, style: TextStyle(fontSize: 20)),
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
                        selectedList: selectedList,
                        onSelectedItemChanged: _updateSelectedTask,
                        selectedTask: selectedTask,
                        displayList: _displayList,
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
      ),
    );
  }
}
