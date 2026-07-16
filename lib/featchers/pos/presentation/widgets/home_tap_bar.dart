import 'package:flutter/material.dart';

/// Header row shown at the top of the mobile POS home screen:
/// avatar + manager name on the start side, search action on the end side.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.managerName, this.onSearchTap});

  final String managerName;

  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onSearchTap,
            icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
          ),
          Expanded(
            child: Text(
              managerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),

          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: .12),
            child: Icon(
              Icons.person_2_sharp,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
