import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/screens/returns_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../core/shared/widgets/setup_dialog.dart';
import '../../../../generated/l10n.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../screens/close_session_dialog.dart';
import '../../../more_actions/presentation/screens/daily_close_screen.dart';

/// Identifies which content is currently shown in place of the grid.
enum _MoreOptionsView { grid, returns, closeCustody }

class TabletMoreOptions extends StatefulWidget {
  const TabletMoreOptions({super.key});

  @override
  State<TabletMoreOptions> createState() => _TabletMoreOptionsState();
}

class _TabletMoreOptionsState extends State<TabletMoreOptions> {
  _MoreOptionsView _currentView = _MoreOptionsView.grid;

  void _showView(_MoreOptionsView view) {
    setState(() => _currentView = view);
  }

  void _backToGrid() {
    setState(() => _currentView = _MoreOptionsView.grid);
  }

  void _showCloseSessionDialog(BuildContext context, int sessionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<PosBloc>(),
          child: CloseSessionDialog(sessionId: sessionId),
        );
      },
    );
  }

  void _showPauseSessionDialog(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusLg),
          ),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pause,
                    color: colorScheme.onSecondaryContainer,
                    size: context.iconSizes.lg,
                  ),
                ),
                SizedBox(height: spacing.md),
                Text(
                  lang.suspendSession,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  lang.suspendSession,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(lang.resumeSession),
                  ),
                ),
                SizedBox(height: spacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.read<PosBloc>().add(
                        CurrentRestaurantPosSessionEvent(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.errorContainer),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                    icon: const Icon(Icons.power_settings_new),
                    label: Text(lang.closeSession),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic spacing,
    String title,
  ) {
    if (_currentView != _MoreOptionsView.grid) {
      return CustomAppBar(title: title, onBackPressed: _backToGrid);
    }

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic spacing,
    S lang,
  ) {
    switch (_currentView) {
      case _MoreOptionsView.returns:
        return const Expanded(child: ReturnsScreen());
      case _MoreOptionsView.closeCustody:
        return const Expanded(child: DailyCloseScreen());
      case _MoreOptionsView.grid:
        final items = _buildItems(lang, colorScheme);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: spacing.md,
                mainAxisSpacing: spacing.md,
                mainAxisExtent: 130,
              ),
              itemBuilder: (context, index) {
                return _MoreOptionCard(data: items[index]);
              },
            ),
          ),
        );
    }
  }

  List<_MoreCardData> _buildItems(S lang, ColorScheme colorScheme) {
    return [
      _MoreCardData(
        title: lang.cashierCustody,
        icon: Icons.account_balance_wallet_outlined,
        iconBgColor: colorScheme.primary.withOpacity(.2),
        iconColor: colorScheme.primary,
        onTap: () {
          // Navigate to Cash Custody Screen
        },
      ),
      _MoreCardData(
        title: lang.returns,
        icon: Icons.receipt_long_outlined,
        iconBgColor: colorScheme.primary.withOpacity(.2),
        iconColor: colorScheme.primary,
        onTap: () => _showView(_MoreOptionsView.returns),
      ),
      _MoreCardData(
        title: lang.closeCustody,
        icon: Icons.lock_clock_outlined,
        iconBgColor: colorScheme.primary.withOpacity(.2),
        iconColor: colorScheme.primary,
        onTap: () => _showView(_MoreOptionsView.closeCustody),
      ),
      _MoreCardData(
        title: lang.suspendSession,
        icon: Icons.pause_circle_outline,
        iconBgColor: colorScheme.primary.withOpacity(.2),
        iconColor: colorScheme.secondaryContainer,
        onTap: () => _showPauseSessionDialog(context),
      ),
      _MoreCardData(
        title: lang.closeSession,
        icon: Icons.power_settings_new,
        iconBgColor: colorScheme.primary.withOpacity(.2),
        iconColor: colorScheme.primary,
        onTap: () {
          context.read<PosBloc>().add(CurrentRestaurantPosSessionEvent());
        },
      ),
      _MoreCardData(
        title: lang.logout,
        icon: Icons.logout,
        iconBgColor: colorScheme.errorContainer.withOpacity(.2),
        iconColor: colorScheme.error,
        isDestructive: true,
        onTap: () {
          showLogOutDialogState(context, lang.needSignOut, [
            lang.confirm,
            lang.cancel,
          ]);
        },
      ),
    ];
  }

  String _titleFor(S lang) {
    switch (_currentView) {
      case _MoreOptionsView.returns:
        return lang.returns;
      case _MoreOptionsView.closeCustody:
        return lang.closeCustody;
      case _MoreOptionsView.grid:
        return lang.additionalOperations;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    // When a sub-view is open, the system/hardware back button should
    // return to the grid instead of popping this screen off the stack.
    return PopScope(
      canPop: _currentView == _MoreOptionsView.grid,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToGrid();
      },
      child: BlocListener<PosBloc, PosState>(
        listenWhen: (previous, current) =>
            previous.currentSessionId != current.currentSessionId ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.currentSessionId != null &&
              state.status == PosStatus.closeSession) {
            _showCloseSessionDialog(context, state.currentSessionId ?? 0);
          }

          if (state.status == PosStatus.error && state.errorMessage != null) {
            HelperMethods.showSnackBar(
              context: context,
              message: state.errorMessage!,
              isError: true,
            );
          }
        },
        child: Scaffold(
          backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(theme, colorScheme, spacing, _titleFor(lang)),
                _buildBody(theme, colorScheme, spacing, lang),
                if (_currentView == _MoreOptionsView.grid)
                  Padding(
                    padding: EdgeInsets.all(spacing.md),
                    child: Text(
                      lang.appVersion('2.4.0'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreCardData {
  _MoreCardData({
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isDestructive;
}

class _MoreOptionCard extends StatelessWidget {
  const _MoreOptionCard({required this.data});

  final _MoreCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(spacing.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          color: data.isDestructive
              ? colorScheme.errorContainer.withOpacity(0.12)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          border: Border.all(
            color: data.isDestructive
                ? colorScheme.errorContainer
                : colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: data.iconBgColor,
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
              child: Icon(
                data.icon,
                color: data.iconColor,
                size: context.iconSizes.md,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: data.isDestructive
                    ? colorScheme.error
                    : colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
