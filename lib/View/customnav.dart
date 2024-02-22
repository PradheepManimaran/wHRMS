import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final ValueChanged<int>? onItemSelected;
  final int currentIndex;
  final Color iconColor;

  CustomBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.backgroundColor = const Color(0xFF5F5DA0),
    this.selectedItemColor = const Color(0xFFEAEAF4),
    this.unselectedItemColor = const Color(0xFF5F5DA0),
    required this.iconColor,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.asMap().entries.map((entry) {
          var index = entry.key;
          var item = entry.value;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemSelected!(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                color: index == widget.currentIndex
                    ? widget.selectedItemColor
                    : Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Use conditional color for icons
                    Icon(
                      item.icon is Icon
                          ? (item.icon as Icon).icon
                          : Icons.error, // Default icon if not Icon widget
                      color: index == widget.currentIndex
                          ? Colors.black
                          : widget.iconColor,
                    ),
                    Text(
                      item.label!,
                      style: TextStyle(
                        color: index == widget.currentIndex
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
