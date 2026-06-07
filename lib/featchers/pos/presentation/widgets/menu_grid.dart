import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pos_bloc.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (state.status == PosStatus.loading) return const _MenuGridSkeleton();

        if (state.currentMenuItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: AppSizes.w48,
                  color: AppColors.textMuted,
                ),
                AppSizes.gapH12,
                Text('لا توجد عناصر في هذه الفئة', style: AppFonts.bodyMedium),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: AppPadding.allLg,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            //   childAspectRatio: .65,
            crossAxisSpacing: AppPadding.xs,
            mainAxisSpacing: AppPadding.xs,
          ),
          itemCount: state.currentMenuItems.length,
          itemBuilder: (context, index) =>
              _MenuItemCard(item: state.currentMenuItems[index]),
        );
      },
    );
  }
}

class _MenuItemCard extends StatefulWidget {
  final MenuItemModel item;
  const _MenuItemCard({required this.item});

  @override
  State<_MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<_MenuItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () =>
          context.read<PosBloc>().add(AddItemToOrderEvent(widget.item)),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: _isPressed
                  ? AppColors.accent.withOpacity(0.4)
                  : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ItemImage(item: widget.item, isPressed: _isPressed),
              ),
              Expanded(child: _ItemInfo(item: widget.item)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final MenuItemModel item;
  final bool isPressed;

  const _ItemImage({required this.item, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (item.imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.sm),
              topRight: Radius.circular(AppRadius.sm),
            ),
            child: Image.network(
              item.imagePath!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.background,
                child: Icon(
                  Icons.restaurant,
                  color: AppColors.textMuted,
                  size: AppSizes.w32,
                ),
              ),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: AppColors.background,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
            ),
          ),
        Positioned(
          top: AppPadding.sm,
          left: AppPadding.sm,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.sm,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: AppColors.priceBadge,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              'SAR ${item.units?.first.salePrice1?.toStringAsFixed(0)}',
              style: AppFonts.bodySmall
                  .colored(AppColors.priceBadgeText)
                  .bold(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemInfo extends StatelessWidget {
  final MenuItemModel item;
  const _ItemInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.allXs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.arabicName ?? "",
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.bodySmall.colored(AppColors.textPrimary).bold(),
          ),
          FittedBox(
            child: Text(
              item.description ?? "",
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.bodySmall.colored(AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGridSkeleton extends StatelessWidget {
  const _MenuGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppPadding.allLg,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppPadding.md,
        mainAxisSpacing: AppPadding.md,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
