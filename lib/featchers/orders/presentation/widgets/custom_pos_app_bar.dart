import 'package:flutter/material.dart';

class CustomPosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomPosAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFFF7F9FC),
    this.primaryColor = const Color(0xFF005DB9),
    this.onMenuPressed,
    this.onSearchPressed,
    this.onNotificationPressed,
  });

  final String title;
  final Color backgroundColor;
  final Color primaryColor;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: onMenuPressed,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: primaryColor),
          onPressed: onSearchPressed,
        ),
        IconButton(
          icon: Icon(Icons.notifications_none_outlined, color: primaryColor),
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
