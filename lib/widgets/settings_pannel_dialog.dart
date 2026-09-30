import 'package:flutter/material.dart';

void showSettingsPanelDialoug(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(content: SettingsPannelDialoug());
    },
  );
}

class SettingsPannelDialoug extends StatefulWidget {
  const SettingsPannelDialoug({super.key});

  @override
  State<SettingsPannelDialoug> createState() => _SettingsPannelDialougState();
}

class _SettingsPannelDialougState extends State<SettingsPannelDialoug> {
  late Widget currentSelectedTab;

  @override
  void initState() {
    super.initState();
    currentSelectedTab = _accountSettingsPanelBuilder(context);
  }

  Widget _accountSettingsPanelBuilder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.fromARGB(25, 0, 0, 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(children: [Text('Account', style: TextStyle(fontSize: 20))]),
          ],
        ),
      ),
    );
  }

  Widget _featuresSettingsPanelBuilder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.fromARGB(25, 0, 0, 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(children: [Text('Features', style: TextStyle(fontSize: 20))]),
          ],
        ),
      ),
    );
  }

  Widget _themeSettingsPanelBuilder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.fromARGB(25, 0, 0, 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(children: [Text('Theme', style: TextStyle(fontSize: 20))]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 200,
            child: Material(
              color: Color.fromARGB(25, 0, 0, 0),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Account'),
                      onTap: () => {
                        setState(() {
                          currentSelectedTab = _accountSettingsPanelBuilder(
                            context,
                          );
                        }),
                      },
                    ),
                    ListTile(
                      title: Text('Features'),
                      onTap: () => {
                        setState(() {
                          currentSelectedTab = _featuresSettingsPanelBuilder(
                            context,
                          );
                        }),
                      },
                    ),
                    ListTile(
                      title: Text('Theme'),
                      onTap: () => {
                        setState(() {
                          currentSelectedTab = _themeSettingsPanelBuilder(
                            context,
                          );
                        }),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              currentSelectedTab,
            ],
          ),
        ),
      ],
    );
  }
}
