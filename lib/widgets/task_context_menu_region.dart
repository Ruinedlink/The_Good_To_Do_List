//THIS FILE IS CURRENTLY UNUSED

import 'package:flutter/material.dart';

typedef ContextMenuBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

class _TaskContextMenuRegion extends StatefulWidget {
  const _TaskContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  final ContextMenuBuilder contextMenuBuilder;

  final Widget child;

  @override
  State<_TaskContextMenuRegion> createState() => _TaskContextMenuRegionState();
}

class _TaskContextMenuRegionState extends State<_TaskContextMenuRegion> {
  // Offset? _longPressOffset;

  final ContextMenuController contextMenuControlller = ContextMenuController();
  @override
  void initState() {
    super.initState();
    contextMenuControlller;
  }

  void _onTap() {
    if (!contextMenuControlller.isShown) {
      return;
    }
    _hide();
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _show(Offset position) {
    contextMenuControlller.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    contextMenuControlller.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      onSecondaryTapUp: _onSecondaryTapUp,
      child: widget.child,
    );
  }
}
