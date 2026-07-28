import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class BranchModel {
  final int id;
  final String name;

  const BranchModel({required this.id, required this.name});
}

class BranchMultiSelectDropdown extends StatefulWidget {
  const BranchMultiSelectDropdown({
    super.key,
    required this.branches,
    required this.selectedBranchIds,
    required this.onChanged,
  });

  final List<BranchModel> branches;
  final List<int> selectedBranchIds;
  final ValueChanged<List<int>> onChanged;

  @override
  State<BranchMultiSelectDropdown> createState() =>
      _BranchMultiSelectDropdownState();
}

class _BranchMultiSelectDropdownState extends State<BranchMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleOverlay() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss when tapping outside
          GestureDetector(
            onTap: _closeMenu,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.branches.map((branch) {
                      final isSelected = widget.selectedBranchIds.contains(
                        branch.id,
                      );
                      return StatefulBuilder(
                        builder: (context, setTileState) {
                          return InkWell(
                            onTap: () {
                              final updated = List<int>.from(
                                widget.selectedBranchIds,
                              );
                              if (isSelected) {
                                updated.remove(branch.id);
                              } else {
                                updated.add(branch.id);
                              }
                              widget.onChanged(updated);
                              _overlayEntry?.markNeedsBuild();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (val) {
                                        final updated = List<int>.from(
                                          widget.selectedBranchIds,
                                        );
                                        if (val == true) {
                                          updated.add(branch.id);
                                        } else {
                                          updated.remove(branch.id);
                                        }
                                        widget.onChanged(updated);
                                        _overlayEntry?.markNeedsBuild();
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      branch.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    final selectedNames = widget.branches
        .where((b) => widget.selectedBranchIds.contains(b.id))
        .map((b) => b.name)
        .join(', ');

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: InputDecorator(
          decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                text: lang.branches,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            suffixIcon: Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: theme.colorScheme.outline,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isOpen
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ),
          ),
          child: Text(
            selectedNames.isEmpty ? '' : selectedNames,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
