import 'package:flutter/material.dart';
import 'package:todo_model/widgets/note_pad_side_bar.dart';
import 'package:todo_model/widgets/note_pad_view.dart';

class NotePadPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NotePadBody());
  }
}

class NotePadBody extends StatefulWidget {
  const new({super.key});

  @override
  State<NotePadBody> createState() => _NotePadBodyState();
}

class _NotePadBodyState extends State<NotePadBody> {
  final List<dynamic> userNotes = ['Note 1', 'Note 2', 'Note 3'];

  String? selectedNote;

  bool sidebarShown = true;

  void changeSelectedNote(String newNote) {
    setState(() {
      selectedNote = newNote;
    });
  }

  void toggleSideBar() {
    setState(() {
      sidebarShown = !sidebarShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NotePadSideBar(
          sidebarShown: sidebarShown,
          userNotes: userNotes,
          onChangeSelected: changeSelectedNote,
        ),
        NotePadView(
          sidebarShown: sidebarShown,
          onPulloutMenuButtonPressed: toggleSideBar,
        ),
      ],
    );
  }
}
