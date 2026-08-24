import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class PosTopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PosTopAppBar({super.key, this.onSearchChanged});

  /// Fired on every keystroke while the search field is open, and once more
  /// with an empty string when search is closed so the caller can reset
  /// back to the unfiltered list. Debouncing/throttling is the caller's
  /// responsibility (see MenuScreen) — this widget stays presentational.
  final ValueChanged<String>? onSearchChanged;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<PosTopAppBar> createState() => _PosTopAppBarState();
}

class _PosTopAppBarState extends State<PosTopAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void _openSearch() {
    setState(() => _isSearching = true);
    // Wait for the field to mount before requesting focus.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    setState(() => _isSearching = false);
    _searchController.clear();
    widget.onSearchChanged?.call('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);

    return SafeArea(
      child: Container(
        height: widget.preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        color: theme.colorScheme.onSurface,
        child: _isSearching
            ? _buildSearchField(theme, lang)
            : _buildDefaultBar(context, theme, spacing, iconSizes, lang),
      ),
    );
  }

  Widget _buildDefaultBar(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    dynamic iconSizes,
    S lang,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.4),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              SizedBox(width: spacing.xs),
              Text(
                lang.restaurantManager,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _openSearch,
          icon: Icon(
            Icons.search,
            size: iconSizes.xl,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme, S lang) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: TextStyle(color: theme.colorScheme.onPrimary),
            cursorColor: theme.colorScheme.onPrimary,
            decoration: InputDecoration(
              isDense: true,
              hintText: lang.search,
              hintStyle: TextStyle(
                color: theme.colorScheme.onPrimary.withOpacity(0.6),
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) => widget.onSearchChanged?.call(value),
          ),
        ),
        IconButton(
          onPressed: _closeSearch,
          icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
        ),
      ],
    );
  }
}
