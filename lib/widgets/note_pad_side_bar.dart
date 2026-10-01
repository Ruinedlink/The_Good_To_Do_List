import 'package:flutter/material.dart';

class NotePadSideBar extends StatefulWidget {
  final bool sidebarShown;
  final List<dynamic> userNotes;
  final ValueChanged<String> onChangeSelected;
  const new({
    super.key,
    required this.sidebarShown,
    required this.userNotes,
    required this.onChangeSelected,
  });

  @override
  State<NotePadSideBar> createState() => _NotePadSideBarState();
}

class _NotePadSideBarState extends State<NotePadSideBar> {
  final ExpansibleController _expansionTileController = ExpansibleController();

  @override
  void initState() {
    super.initState();
    _expansionTileController.expand();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sidebarShown == false
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsetsGeometry.all(10),
            width: 250,
            child: Container(
              padding: EdgeInsetsGeometry.all(10),
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(25, 0, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: ExpansionTile(
                        controller: _expansionTileController,
                        controlAffinity: .leading,
                        title: Text('Notes'),
                        leading: Icon(
                          _expansionTileController.isExpanded
                              ? Icons.arrow_drop_down
                              : Icons.arrow_right,
                        ),
                        trailing: IconButton(
                          onPressed: () => {
                            // _showAddListDialog(context, widget.onAddList),
                            debugPrint('Add Note Button Pressed'),
                          },
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
                              itemCount: widget.userNotes.length,
                              itemBuilder: (context, index) {
                                final note = widget.userNotes[index];
                                return GestureDetector(
                                  onSecondaryTap: () {
                                    debugPrint('$note was right clicked');
                                  },
                                  child: ListTile(
                                    title: Text(note),
                                    onTap: () => widget.onChangeSelected(note),
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
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_month),
                                iconSize: 40,
                                onPressed: () {
                                  debugPrint('Task page view button Clicked');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.sticky_note_2_rounded),
                                iconSize: 40,
                                onPressed: () {
                                  debugPrint(
                                    'Notepad page view button Clicked',
                                  );
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
                                        // widget.onOpenSettingsPanel();
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
