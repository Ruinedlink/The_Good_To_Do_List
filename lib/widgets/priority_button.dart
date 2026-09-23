import 'package:flutter/material.dart';

class PriorityButton extends StatefulWidget {
  final ValueChanged<String?> onSelectedItemChanged;
  final String? currentPriority;
  const PriorityButton({
    super.key,
    required this.onSelectedItemChanged,
    this.currentPriority,
  });

  @override
  State<PriorityButton> createState() => _PriorityButtonState();
}

class _PriorityButtonState extends State<PriorityButton> {
  final OverlayPortalController _controller = OverlayPortalController();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _reportPriority(String? priority) {
    widget.onSelectedItemChanged(priority);
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) {
        final RenderBox? buttonBox =
            _buttonKey.currentContext?.findRenderObject() as RenderBox?;

        if (buttonBox == null) {
          return const SizedBox.shrink();
        }

        final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
        final Size buttonSize = buttonBox.size;

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _controller.hide,
              ),
            ),
            Positioned(
              top: buttonPosition.dy + buttonSize.height,
              left: buttonPosition.dx - 160 + buttonSize.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 160,
                  height: 215,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: Icon(Icons.flag),
                                title: Text('None'),
                                onTap: () => _reportPriority(null),
                              ),
                              ListTile(
                                leading: Icon(Icons.flag),
                                title: Text(
                                  'Low',
                                  style: TextStyle(color: Colors.green),
                                ),
                                iconColor: Colors.green,
                                onTap: () => _reportPriority('Low'),
                              ),
                              ListTile(
                                leading: Icon(Icons.flag),
                                title: Text(
                                  'Medium',
                                  style: TextStyle(color: Colors.orange),
                                ),
                                iconColor: Colors.orange,
                                onTap: () => _reportPriority('Medium'),
                              ),
                              ListTile(
                                leading: Icon(Icons.flag),
                                title: Text(
                                  'High',
                                  style: TextStyle(color: Colors.red),
                                ),
                                iconColor: Colors.red,
                                onTap: () => _reportPriority('High'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.currentPriority == null
          ? IconButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              icon: Icon(Icons.flag),
            )
          : ElevatedButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag,
                    color: widget.currentPriority! == 'Low'
                        ? Colors.green
                        : widget.currentPriority! == 'Medium'
                        ? Colors.orange
                        : Colors.red,
                  ),
                  Text(widget.currentPriority!),
                ],
              ),
            ),
    );
  }
}
