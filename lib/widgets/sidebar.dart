import 'package:flutter/material.dart';
import 'package:todo_model/todo_model.dart';

class Sidebar extends StatefulWidget {
  final List<ToDoList> userLists;
  final ValueChanged<String> onAddList;
  final ValueChanged<ToDoList> onChangeSelected;
  final bool sidebarShown;
  const Sidebar({
    super.key,
    required this.userLists,
    required this.onAddList,
    required this.onChangeSelected,
    required this.sidebarShown,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final ExpansibleController _expansionTileController = ExpansibleController();
  late List<ToDoList> userLists;
  final Color _selectedColor = Color.fromARGB(20, 255, 255, 255);
  late bool sidebarShown;
  // final Color _hoveredColor = Color.fromARGB(20, 255, 255, 255);
  // final Color _restingColor = Color.fromARGB(0, 255, 255, 255);

  @override
  void initState() {
    super.initState();
    userLists = widget.userLists;
    sidebarShown = widget.sidebarShown;
  }

  @override
  void didUpdateWidget(Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sidebarShown != oldWidget.sidebarShown) {
      setState(() {
        sidebarShown = widget.sidebarShown;
      });
    }
  }

  void _showAddListDialog(
    BuildContext context,
    ValueChanged<String> onAddList,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New List'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter list name...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                widget.onAddList(value.trim());
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  widget.onAddList(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return sidebarShown == false
        ? SizedBox.shrink()
        : SizedBox(
            width: 250,
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Material(
                color: Color.fromARGB(25, 0, 0, 0),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    ListTile(
                      selectedColor: _selectedColor,
                      onTap: () {
                        debugPrint('All tab was clicked');
                      },
                      title: Text('All'),
                    ),
                    ListTile(
                      selectedColor: _selectedColor,
                      onTap: () {
                        debugPrint('Week tab clicked');
                      },
                      title: Text('Week'),
                    ),
                    ListTile(
                      selectedColor: _selectedColor,
                      title: Text('Today'),
                      onTap: () {
                        debugPrint('Today Tab Clicked');
                      },
                    ),
                    Expanded(
                      child: ExpansionTile(
                        controller: _expansionTileController,
                        initiallyExpanded: true,
                        controlAffinity: .leading,
                        title: Text('Lists'),
                        leading: Icon(
                          _expansionTileController.isExpanded
                              ? Icons.arrow_drop_down
                              : Icons.arrow_right,
                        ),
                        trailing: IconButton(
                          onPressed: () =>
                              _showAddListDialog(context, widget.onAddList),
                          icon: Icon(Icons.add),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _expansionTileController;
                          });
                        },
                        children: [
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: userLists.length,
                              itemBuilder: (context, index) {
                                final list = userLists[index];
                                return GestureDetector(
                                  onSecondaryTap: () {
                                    debugPrint(
                                      '${list.name} was right clicked',
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(list.name),
                                    onTap: () => widget.onChangeSelected(list),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(5),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_box),
                                iconSize: 40,
                                onPressed: () {
                                  debugPrint('Task page view button Clicked');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_month),
                                iconSize: 40,
                                onPressed: () {
                                  debugPrint('Task page view button Clicked');
                                },
                              ),
                            ],
                          ),

                          Container(
                            padding: EdgeInsets.all(5),
                            height: 60,
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color.fromARGB(100, 0, 0, 0),
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.all(3),
                                          child: Row(
                                            children: [
                                              Icon(Icons.account_box),
                                              Text(
                                                'Username',
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsetsGeometry.all(5),
                                    child: IconButton(
                                      onPressed: () {
                                        debugPrint('Settings button Pressed');
                                      },
                                      icon: Icon(Icons.settings),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
