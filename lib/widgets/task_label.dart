import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';

class TaskLabel extends StatefulWidget {
  const TaskLabel({
    super.key,
    required this.thisTask,
    required this.onTap,
    required this.onDelete,
    required this.selectedTask,
    required this.currentList,
    this.isEditing = false,
  });

  final Task thisTask;
  final ValueChanged<Task> onTap;
  final ValueChanged<Task> onDelete;
  final Task? selectedTask;
  final ToDoList currentList;
  final bool isEditing;

  @override
  State<TaskLabel> createState() => _TaskLabel();
}

class _TaskLabel extends State<TaskLabel> {
  late Task thisTask;
  late bool isComplete;
  late Task? selectedTask;
  late bool _isSelected;
  late FocusNode _focusNode;

  late bool _isEditing;
  late String displayDate;

  bool? _isHovered = false;

  final _trailingButtonKey = GlobalKey();
  final contextMenuController = ContextMenuController();
  final listTileController = WidgetStatesController();
  final textController = TextEditingController();
  final _expansionController = ExpansibleController();

  @override
  void initState() {
    super.initState();
    thisTask = widget.thisTask;
    isComplete = thisTask.status;
    contextMenuController;
    selectedTask = widget.selectedTask;
    _isSelected = selectedTask == thisTask ? true : false;
    _isHovered = false;
    _isEditing = widget.isEditing;
    _focusNode = FocusNode();
    if (_isEditing) {
      _focusNode.requestFocus();
    }
    textController.text = thisTask.text;
  }

  @override
  void didUpdateWidget(TaskLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTask != oldWidget.selectedTask) {
      setState(() {
        _isSelected = selectedTask == thisTask ? true : false;
      });
    }
    if (widget.selectedTask != oldWidget.selectedTask) {
      setState(() {
        _expansionController.expand();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    textController.dispose();
    listTileController.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  void _onToggle() {
    setState(() {
      debugPrint('Task label toggled');
      isComplete = !isComplete;
      thisTask.status = isComplete;
      widget.currentList.saveToFile();
    });
  }

  void onTap() {
    if (_isSelected == false) {
      debugPrint('\'${thisTask.text}\' selected');
      widget.onTap(thisTask);
    }
    setState(() {
      ContextMenuController.removeAny();
    });
    // if (contextMenuController.isShown) {
    //   _hide();
    // }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _show(Offset position) {
    contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) =>
          _buildContextMenu(context, position),
    );
  }

  void _addSubtask() {
    thisTask.addChildTask(Task('', parentId: thisTask.id, subTasks: []));

    setState(() {
      _expansionController.expand();
    });
  }

  void _setTaskText(String text) {
    setState(() {
      thisTask.text = text;
      widget.currentList.saveToFile();
      _isEditing = false;
    });
  }

  void _enableTextEditing() {
    setState(() {
      _isEditing = true;
      _focusNode.requestFocus();
    });
  }

  void _onContextMenuButtonClicked(GlobalKey key) {
    final RenderBox? buttonBox =
        _trailingButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonBox != null) {
      final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
      _show(buttonPosition);
    }
  }

  Widget _buildShowDate(BuildContext context) {
    if (thisTask.deadline != null) {
      const Map<int, String> months = {
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      };
      const Map<int, String> days = {
        DateTime.monday: 'Mon',
        DateTime.tuesday: 'Tue',
        DateTime.wednesday: 'Wed',
        DateTime.thursday: 'Thu',
        DateTime.friday: 'Fri',
        DateTime.saturday: 'Sat',
        DateTime.sunday: 'Sun',
      };
      DateTime now = DateTime.now();
      if (0 < thisTask.deadline!.difference(now).inDays &&
          thisTask.deadline!.difference(now).inDays < 6) {
        displayDate = '${days[thisTask.deadline!.weekday]}';
      } else {
        displayDate =
            '${months[thisTask.deadline!.month]}, ${thisTask.deadline!.day}';
      }
    }

    return thisTask.deadline != null
        ? Text(
            displayDate,
            style: TextStyle(
              fontSize: 10,
              color: thisTask.deadline!.isAfter(DateTime.now())
                  ? null
                  : Color.fromARGB(200, 255, 120, 120),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildContextMenu(BuildContext context, Offset offset) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: offset),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(
          onPressed: () {
            ContextMenuController.removeAny();
            widget.onDelete(thisTask);
          },
          label: 'Delete',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            ContextMenuController.removeAny();
            // Edit This Task;
          },
          label: 'Edit Task',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            ContextMenuController.removeAny();
            _addSubtask();
          },
          label: 'Add Subtask',
        ),
        ContextMenuButtonItem(
          onPressed: () {
            ContextMenuController.removeAny();
            _enableTextEditing();
          },
          label: 'Rename',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onDoubleTap: () => {_isEditing = true, _focusNode.requestFocus()},
        onSecondaryTapUp: _onSecondaryTapUp,
        child: Expansible(
          controller: _expansionController,
          headerBuilder: (context, animation) => ListTile(
            contentPadding: EdgeInsetsGeometry.directional(start: 5, end: 5),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
              side: BorderSide.none,
            ),
            minLeadingWidth: 0,
            minTileHeight: 0,
            minVerticalPadding: 8,
            titleTextStyle: TextStyle(
              fontSize: 13,
              decoration: isComplete
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            selected: _isSelected,
            selectedTileColor: Color.fromARGB(50, 255, 255, 255),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                thisTask.subTasks.isNotEmpty
                    ? IconButton(
                        iconSize: 16,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: _expansionController.isExpanded
                            ? Icon(Icons.expand_more_rounded)
                            : Icon(Icons.chevron_right_rounded),
                        onPressed: () {
                          if (_expansionController.isExpanded) {
                            _expansionController.collapse();
                          } else {
                            _expansionController.expand();
                          }
                        },
                      )
                    : SizedBox(width: 16, height: 16),
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isComplete,
                  onChanged: (bool? value) => {
                    _onToggle(),
                    widget.onTap(thisTask),
                  },
                ),
              ],
            ),

            title: _isEditing == false
                ? Text(thisTask.text)
                : TextField(
                    focusNode: _focusNode,
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: _setTaskText,
                    onTapUpOutside: (value) => {
                      _setTaskText(textController.text),
                    },
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                _isHovered == true
                    ? IconButton(
                        key: _trailingButtonKey,
                        icon: Icon(Icons.more_horiz),
                        onPressed: () =>
                            _onContextMenuButtonClicked(_trailingButtonKey),
                        style: IconButton.styleFrom(
                          maximumSize: Size(35, 35),
                          minimumSize: Size(8, 8),
                          iconSize: 15,
                        ),
                      )
                    : SizedBox.shrink(key: _trailingButtonKey),
                _buildShowDate(context),
              ],
            ),
          ),
          bodyBuilder: (context, animation) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsGeometry.fromLTRB(20, 0, 0, 0),
            itemCount: thisTask.subTasks.length,
            itemBuilder: (context, index) {
              final thisSubTask = thisTask.subTasks[index];
              return TaskLabel(
                key: ValueKey(thisSubTask.id),
                onTap: (value) => widget.onTap(value),
                thisTask: thisSubTask,
                currentList: widget.currentList,
                selectedTask: selectedTask,
                onDelete: widget.onDelete,
                isEditing: thisSubTask.text.isEmpty,
              );
            },
            separatorBuilder: (context, int index) {
              return const Divider(
                indent: 20,
                color: Color.fromARGB(30, 255, 255, 255),
                thickness: .5,
              );
            },
          ),
        ),
      ),
    );
  }
}
