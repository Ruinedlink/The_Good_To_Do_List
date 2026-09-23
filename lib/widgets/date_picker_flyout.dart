import 'package:flutter/material.dart';

class DatePickerFlyout extends StatefulWidget {
  final ValueChanged<DateTime?> onApply;
  final DateTime? currentDeadline;
  const DatePickerFlyout({
    super.key,
    required this.onApply,
    this.currentDeadline,
  });

  @override
  State<DatePickerFlyout> createState() => _DatePickerFlyoutState();
}

class _DatePickerFlyoutState extends State<DatePickerFlyout> {
  final OverlayPortalController _controller = OverlayPortalController();
  final GlobalKey _buttonKey = GlobalKey();
  late DateTime? currentDeadline;
  late DateTime currentDate;
  late String displayDate;

  @override
  void initState() {
    super.initState();
    currentDeadline = widget.currentDeadline;
    debugPrint(currentDeadline?.toString());
    currentDate = DateTime.now();
  }

  void _reportChange() {
    widget.onApply(_getFinalTime());
    _controller.hide();
  }

  DateTime _getFinalTime() {
    if (selectedDate == null) {
      DateTime now = DateTime.now();
      updateSelectedDate(DateTime(now.year, now.month, now.day, 00, 00));
    }
    if (selectedTime == null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedDate!.hour,
        selectedDate!.minute,
      );
    } else {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }
  }

  void updateSelectedDate(DateTime time) {
    debugPrint(time.toString());
    setState(() {
      selectedDate = time;
    });
  }

  void updateSelectedTime(TimeOfDay time) {
    debugPrint(time.toString());
    setState(() {
      selectedTime = time;
    });
  }

  void applySelectedDateTime() {
    debugPrint('Returning ');
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Widget _buildShowDate(BuildContext context) {
    if (widget.currentDeadline != null) {
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
      if (0 < widget.currentDeadline!.difference(now).inDays &&
          widget.currentDeadline!.difference(now).inDays < 6) {
        displayDate = '${days[widget.currentDeadline!.weekday]}';
      } else {
        displayDate =
            '${months[widget.currentDeadline!.month]}, ${widget.currentDeadline!.day}';
      }
    }

    return widget.currentDeadline != null
        ? Text(
            displayDate,
            style: TextStyle(
              fontSize: 10,
              color: widget.currentDeadline!.isAfter(DateTime.now())
                  ? null
                  : Color.fromARGB(200, 255, 120, 120),
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) {
        // Find the button's RenderBox using the key, not the local context
        final RenderBox? buttonBox =
            _buttonKey.currentContext?.findRenderObject() as RenderBox?;

        if (buttonBox == null) {
          return const SizedBox.shrink(); // button not laid out yet, render nothing
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
              left: buttonPosition.dx - 320 + buttonSize.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 320,
                  height: 420,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: CalendarDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2027),
                            onDateChanged: (time) => updateSelectedDate(time),
                          ),
                        ),
                        ExpansionTile(
                          title: Text('Pick Time'),
                          children: [
                            CustomTimePicker(
                              initalTime: widget.currentDeadline == null
                                  ? null
                                  : TimeOfDay(
                                      hour: widget.currentDeadline!.hour,
                                      minute: widget.currentDeadline!.minute,
                                    ),
                              onTimeChanged: (value) =>
                                  updateSelectedTime(value),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => {
                                widget.onApply(null),
                                _controller.hide(),
                              },
                              child: const Text('Clear'),
                            ),
                            ElevatedButton(
                              onPressed: _reportChange,
                              child: const Text('OK'),
                            ),
                          ],
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
      child: widget.currentDeadline == null
          ? IconButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              icon: Icon(Icons.calendar_month),
            )
          : ElevatedButton(
              key: _buttonKey,
              onPressed: _controller.toggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [Icon(Icons.calendar_month), _buildShowDate(context)],
              ),
            ),
    );
  }
}

class CustomTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onTimeChanged;

  const CustomTimePicker({
    super.key,
    required this.onTimeChanged,
    this.initalTime,
  });

  final TimeOfDay? initalTime;

  @override
  State<CustomTimePicker> createState() => _CustomTimePicker();
}

class _CustomTimePicker extends State<CustomTimePicker> {
  late ValueChanged<TimeOfDay> onTimeChanged;
  late int selectedHour;
  late int selectedMinute;
  late String selectedAMPM;

  @override
  void initState() {
    super.initState();
    if (widget.initalTime == null) {
      selectedHour = 0;
      selectedMinute = 0;
      selectedAMPM = 'AM';
    } else {
      if (widget.initalTime!.hour > 12) {
        selectedHour = widget.initalTime!.hour - 12;
        selectedMinute = widget.initalTime!.minute;
        selectedAMPM = 'PM';
      } else {
        selectedHour = widget.initalTime!.hour;
        selectedMinute = widget.initalTime!.minute;
        selectedAMPM = 'AM';
      }
    }
  }

  void _reportChange() {
    widget.onTimeChanged(
      TimeOfDay(
        hour: selectedAMPM == 'AM' ? selectedHour : selectedHour + 12,
        minute: selectedMinute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 40,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: selectedHour,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = index;
                });
                _reportChange();
              },
              children: List.generate(
                12,
                (index) => Center(
                  child: Text(
                    (index == 00 ? 12 : index).toString().padLeft(2, '0'),
                  ),
                ),
              ),
            ),
          ),
          const Text(':', style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 40,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: selectedMinute,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = index + 1;
                });
                _reportChange();
              },
              children: List.generate(
                60,
                (index) =>
                    Center(child: Text(index.toString().padLeft(2, '0'))),
              ),
            ),
          ),
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 40,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: selectedAMPM == 'AM' ? 0 : 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedAMPM = index == 0 ? 'AM' : 'PM';
                });
                _reportChange();
              },
              children: [
                Center(child: Text('AM')),
                Center(child: Text('PM')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
