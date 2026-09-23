import 'package:flutter/material.dart';

enum SortMethod {
  custom('Custom', Icons.sort),
  dueDate('By Duedate', Icons.calendar_today),
  alphabetical('By Alphabetical', Icons.sort_by_alpha),
  priority('By Priority', Icons.flag),
  dateCreated('By Date Created', Icons.access_time);

  final String label;
  final IconData icon;
  const SortMethod(this.label, this.icon);
}

List<dynamic> sortTasks(List<dynamic> tasks, SortMethod method) {
  final sorted = List<dynamic>.from(tasks);
  final priorityMap = <String, int>{
    'None': 0,
    'Low': 1,
    'Medium': 2,
    'High': 3,
  };

  switch (method) {
    case SortMethod.dueDate:
      sorted.sort((a, b) {
        if (a.deadline == null && b.deadline == null) {
          return 0;
        } // fixes inconsistent comparator
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    case SortMethod.alphabetical:
      sorted.sort((a, b) => (a.text as String).compareTo(b.text as String));
    case SortMethod.priority:
      sorted.sort(
        (a, b) => (priorityMap[b.priority ?? 'None'] as int).compareTo(
          priorityMap[a.priority ?? 'None'] as int,
        ),
      );
    case SortMethod.dateCreated:
      sorted.sort((a, b) => a.time.compareTo(b.time));
    case SortMethod.custom:
      break;
  }
  return sorted;
}

class SortButton extends StatefulWidget {
  final ValueChanged<SortMethod> onSortMethodChanged;
  final SortMethod? selectedMethod;

  const SortButton({
    super.key,
    required this.onSortMethodChanged,
    required this.selectedMethod,
  });

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  final OverlayPortalController _controller = OverlayPortalController();
  final GlobalKey _buttonKey = GlobalKey();

  void _onMethodTapped(SortMethod method) {
    widget.onSortMethodChanged(method);
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
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: SortMethod.values.map((method) {
                        return ListTile(
                          dense: true,
                          leading: Icon(method.icon, size: 18),
                          title: Text(method.label),
                          onTap: () => _onMethodTapped(method),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.selectedMethod == null
          ? IconButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              icon: Icon(Icons.sort),
            )
          : ElevatedButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.selectedMethod!.icon, size: 18),
                  Text(widget.selectedMethod!.label),
                ],
              ),
            ),
    );
  }
}
