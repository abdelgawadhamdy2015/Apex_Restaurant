// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdditivesDialog extends StatefulWidget {
  final List<FoodAdditiveModel> additives;
  final List<FoodAdditiveModel> initialSelection;

  const AdditivesDialog({
    super.key,
    required this.additives,
    required this.initialSelection,
  });

  @override
  State<AdditivesDialog> createState() => _AdditivesDialogState();
}

class _AdditivesDialogState extends State<AdditivesDialog> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialSelection.map((a) => a.id!).toSet();
  }

  void _toggle(String id) => setState(() {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  });

  List<FoodAdditiveModel> get _selected =>
      widget.additives.where((a) => _selectedIds.contains(a.id)).toList();

  double get _totalPrice => _selected.fold(0.0, (sum, a) => sum + a.price!);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add additives',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap items to select',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── list
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: widget.additives.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final item = widget.additives[i];
                  final selected = _selectedIds.contains(item.id);
                  return _AdditiveItem(
                    additive: item,
                    selected: selected,
                    onTap: () => _toggle(item.id!),
                  );
                },
              ),
            ),

            // ── footer
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // summary row
                    if (_selected.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selected.length} selected',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            '+${_totalPrice.toStringAsFixed(2)} EGP',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    // confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          context.pop(_selected);
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _selected.isEmpty ? 'Skip' : 'Confirm additives',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single additive row ───────────────────────────────────────────────────────

class _AdditiveItem extends StatelessWidget {
  final FoodAdditiveModel additive;
  final bool selected;
  final VoidCallback onTap;

  const _AdditiveItem({
    required this.additive,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary.withOpacity(0.08)
            : colorScheme.surface,
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.25),
          width: selected ? 1.8 : 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // image
              if (additive.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: _AdditiveImage(url: additive.imagePath!),
                  ),
                ),
              const SizedBox(width: 12),

              // text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: additive.arabicName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: '  ·  ${additive.latinName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${additive.price?.toStringAsFixed(2)} EGP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                    if (additive.notes != null && additive.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          additive.notes!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // check circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Network image with fallback ───────────────────────────────────────────────

class _AdditiveImage extends StatelessWidget {
  final String url;
  const _AdditiveImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              color: colorScheme.surfaceVariant,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            ),
      errorBuilder: (_, __, ___) => Container(
        color: colorScheme.surfaceVariant,
        child: Icon(
          Icons.fastfood_rounded,
          size: 26,
          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
      ),
    );
  }
}
