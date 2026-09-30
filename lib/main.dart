//main.dart
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/to_do_list_page.dart';

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

      localizationsDelegates: const [AppFlowyEditorLocalizations.delegate],

      debugShowCheckedModeBanner: false,
      home: ToDoListPage(userLists: userLists),
    );
  }
}
