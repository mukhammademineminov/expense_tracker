
import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry> items;
  final Function(dynamic) onSelected;

  const PopupMenu({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
    
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<dynamic>(
            itemBuilder: (context) => items,
            onSelected: onSelected,
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          );
  }
}
