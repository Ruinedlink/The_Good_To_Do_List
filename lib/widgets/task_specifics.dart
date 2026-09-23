import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/date_picker_flyout.dart';
import 'package:todo_model/widgets/priority_button.dart';

class TaskSpecifics extends StatefulWidget {
  final Task? selectedTask;
  final ToDoList? selectedList;
  final ValueChanged<Task> onUpdateSelectedTaskDetails;
  const TaskSpecifics({
    super.key,
    required this.selectedTask,
    required this.selectedList,
    required this.onUpdateSelectedTaskDetails,
  });

  @override
  State<TaskSpecifics> createState() => _TaskSpecificsState();
}

class _TaskSpecificsState extends State<TaskSpecifics> {
  final notesController = TextEditingController();
  final taskTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TaskSpecifics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTask != oldWidget.selectedTask) {
      setState(() {
        widget.selectedList;
        widget.selectedTask;

        if (widget.selectedTask!.notes != null) {
          notesController.text = widget.selectedTask!.notes!;
        } else {
          notesController.text = '';
        }

        taskTextController.text = widget.selectedTask!.text;
      });
    }
  }

  void _setDeadline(DateTime? time) {
    debugPrint(
      'Changing Deadline of ${widget.selectedTask == null ? 'no task selected' : widget.selectedTask!.text}to $time',
    );
    if (widget.selectedTask != null) {
      setState(() {
        widget.selectedTask!.setDeadline(time);
      });
      widget.onUpdateSelectedTaskDetails(widget.selectedTask!);
    }
  }

  void _setNotes(String text) {
    debugPrint('Updating ${widget.selectedTask!.text}\'s Note');
    if (widget.selectedTask != null) {
      setState(() {
        widget.selectedTask!.setNotes(text);
        widget.onUpdateSelectedTaskDetails(widget.selectedTask!);
      });
    }
  }

  void _setPriority(String? priority) {
    debugPrint(
      'Changing prioriyt of ${widget.selectedTask == null ? '\'no task selected\'' : widget.selectedTask!.text} to $priority',
    );
    if (widget.selectedTask != null) {
      setState(() {
        widget.selectedTask!.setPriority(priority);
        widget.onUpdateSelectedTaskDetails(widget.selectedTask!);
      });
    }
  }

  void _setText(String? text) {
    if (widget.selectedTask != null) {
      setState(() {
        debugPrint('updating the task text!');
        widget.selectedTask!.setText(text ?? '');
        widget.onUpdateSelectedTaskDetails(widget.selectedTask!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectedTask == null
        ? Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Material(
              color: Color.fromARGB(25, 0, 0, 0),
              borderRadius: BorderRadius.circular(20),
              child: Container(),
            ),
          )
        : Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Material(
              color: Color.fromARGB(25, 0, 0, 0),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DatePickerFlyout(
                          onApply: (value) => _setDeadline(value),
                          currentDeadline: widget.selectedTask?.deadline,
                        ),
                        PriorityButton(
                          onSelectedItemChanged: (value) => _setPriority(value),
                          currentPriority: widget.selectedTask?.priority,
                        ),
                      ],
                    ),
                    Divider(),

                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: taskTextController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'add task title...',
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: _setText,
                        ),
                      ),
                    ),

                    Divider(),
                    Expanded(
                      child: TextField(
                        controller: notesController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Type Notes Here...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) => _setNotes(text),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('${widget.selectedTask?.time}')],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
