// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
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
  late S lang;
  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialSelection.map((a) => a.id!).toSet();
  }

  void _toggle(String id) => setState(() {
    _selectedIds.contains(id) ? _selectedIds.remove(id) : _selectedIds.add(id);
  });

  List<FoodAdditiveModel> get _selected =>
      widget.additives.where((a) => _selectedIds.contains(a.id)).toList();

  double get _totalPrice => _selected.fold(0.0, (sum, a) => sum + a.price!);

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppPadding.sm),
              child: Container(
                width: AppSizes.w40,
                height: AppSizes.h4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppPadding.xl,
                AppPadding.lg,
                AppPadding.lg,
                AppPadding.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang.addAdditives, style: AppFonts.titleMedium),
                        AppSizes.gapH4,
                        Text(lang.tapItemsToSelect, style: AppFonts.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.lg,
                  vertical: AppPadding.md,
                ),
                itemCount: widget.additives.length,
                separatorBuilder: (_, __) => AppSizes.gapH8,
                itemBuilder: (_, i) {
                  final item = widget.additives[i];
                  return _AdditiveItem(
                    additive: item,
                    selected: _selectedIds.contains(item.id),
                    onTap: () => _toggle(item.id!),
                  );
                },
              ),
            ),

            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.lg,
                  vertical: AppPadding.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.border.withOpacity(0.2)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selected.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selected.length} ${lang.selected}',
                            style: AppFonts.bodySmall,
                          ),
                          Text(
                            '+${_totalPrice.toStringAsFixed(2)} ${lang.sar}',
                            style: AppFonts.bodyMedium.semiBold(),
                          ),
                        ],
                      ),
                      AppSizes.gapH8,
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: FilledButton(
                        onPressed: () => context.pop(_selected),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          _selected.isEmpty ? lang.skip : lang.confirmAdditives,
                          style: AppFonts.bodyMedium
                              .colored(AppColors.white)
                              .semiBold(),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.08) : AppColors.white,
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.border.withOpacity(0.25),
          width: selected ? 1.8 : 0.8,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppPadding.allSm,
          child: Row(
            children: [
              if (additive.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: SizedBox(
                    width: AppSizes.w48,
                    height: AppSizes.h48,
                    child: _AdditiveImage(url: additive.imagePath!),
                  ),
                ),
              AppSizes.gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: additive.arabicName,
                            style: AppFonts.bodyMedium
                                .colored(AppColors.textPrimary)
                                .semiBold(),
                          ),
                          TextSpan(
                            text: '  ·  ${additive.latinName}',
                            style: AppFonts.bodySmall.colored(
                              AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSizes.gapH4,
                    Text(
                      '${additive.price?.toStringAsFixed(2)} ${S.of(context).sar}',
                      style: AppFonts.bodySmall
                          .colored(
                            selected ? AppColors.primary : AppColors.textMuted,
                          )
                          .semiBold(),
                    ),
                    if (additive.notes != null && additive.notes!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: AppPadding.xs),
                        child: Text(
                          additive.notes!,
                          style: AppFonts.bodySmall.colored(
                            AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              AppSizes.gapW8,

              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: AppSizes.w24,
                height: AppSizes.h24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        size: AppSizes.iconSm,
                        color: AppColors.white,
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

class _AdditiveImage extends StatelessWidget {
  final String url;
  const _AdditiveImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              color: AppColors.background,
              child: Center(
                child: SizedBox(
                  width: AppSizes.w20,
                  height: AppSizes.h20,
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
        color: AppColors.background,
        child: Icon(
          Icons.fastfood_rounded,
          size: AppSizes.iconLg,
          color: AppColors.textMuted.withOpacity(0.5),
        ),
      ),
    );
  }
}
