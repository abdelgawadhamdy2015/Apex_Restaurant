import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class DeliveryCompanySelectionDialog extends StatelessWidget {
  DeliveryCompanySelectionDialog({super.key});
  late S lang;
  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final companies = state.deliveryCompanies;
          return Container(
            width: AppSizes.w200,
            padding: AppPadding.allXxl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang.chooseDeliveryCompany, style: AppFonts.displayMedium),
                AppSizes.gapH32,

                ...companies.map((e) {
                  return Column(
                    children: [
                      _TypeCard(
                        title: e.arabicName ?? '',
                        icon: Icons.shopping_bag,
                        onTap: () {
                          context.pop(e);
                          context.read<PosBloc>().add(
                            SelectDeliveryCompanyEvent(deliveryCompanyModel: e),
                          );
                        },
                      ),
                      AppSizes.gapH12,
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: AppSizes.h64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: AppSizes.iconLg),
            AppSizes.gapW12,
            Text(
              title,
              style: AppFonts.titleLarge.colored(AppColors.white).bold(),
            ),
          ],
        ),
      ),
    );
  }
}
