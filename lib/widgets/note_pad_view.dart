import 'package:flutter/material.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

class NotePadView extends StatefulWidget {
  final VoidCallback onPulloutMenuButtonPressed;
  final bool sidebarShown;
  const new({
    super.key,
    required this.onPulloutMenuButtonPressed,
    required this.sidebarShown,
  });

  @override
  State<NotePadView> createState() => _NotePadViewState();
}

class _NotePadViewState extends State<NotePadView> {
  final editorState = EditorState.blank(withInitialText: true);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsetsGeometry.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(25, 0, 0, 0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => {widget.onPulloutMenuButtonPressed()},
                    icon: widget.sidebarShown == false
                        ? Icon(Icons.menu)
                        : Icon(Icons.menu_open),
                    iconSize: 30,
                  ),
                  // Text(currentNote.title, style: TextStyle(fontSize: 20)),
                ],
              ),

              SizedBox(
                width: 600,
                height: 300,
                child: AppFlowyEditor(
                  editorState: editorState,
                  autoFocus: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
