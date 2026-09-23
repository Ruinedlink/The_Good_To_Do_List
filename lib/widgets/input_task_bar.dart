import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';
import 'package:todo_model/widgets/date_picker_flyout.dart';
import 'package:todo_model/widgets/priority_button.dart';

class TaskInput extends StatefulWidget {
  final ValueChanged<Task> onAddTask;
  final ToDoList selectedList;

  const TaskInput({
    super.key,
    required this.onAddTask,
    required this.selectedList,
  });

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final controller = TextEditingController();
  DateTime? currentDeadline;
  String? currentPriority;

  @override
  void initState() {
    super.initState();
  }

  void _addPrioriy(String? priority) {
    debugPrint("Adding current priority of $priority");
    setState(() {
      currentPriority = priority;
    });
  }

  void _addDedline(DateTime? time) {
    debugPrint('Adding Deadline of $time');
    setState(() {
      currentDeadline = time;
    });
  }

  void _reportAddTask(String text) {
    DateTime now = DateTime.now();
    widget.onAddTask(
      Task(
        text,
        deadline: currentDeadline,
        priority: currentPriority,
        time: DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        ).toString().replaceRange(16, 23, ''),
        subTasks: [],
      ),
    );
    setState(() {
      currentDeadline = null;
      currentPriority = null;
    });
  }

  void _onChanged(String text) {
    setState(() {
      controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsetsGeometry.directional(end: 5),
              child: Stack(
                children: [
                  TextField(
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => _onChanged(value),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _reportAddTask(value);
                        controller.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hint: Row(children: [Icon(Icons.add), Text('Add Task')]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: controller.text.trim().isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DatePickerFlyout(
                                currentDeadline: currentDeadline,
                                onApply: (value) => _addDedline(value),
                              ),
                              PriorityButton(
                                currentPriority: currentPriority,
                                onSelectedItemChanged: (value) =>
                                    _addPrioriy(value),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
