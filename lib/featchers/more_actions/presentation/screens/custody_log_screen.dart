import 'package:apex_restaurant/featchers/more_actions/presentation/widgets/custody_log_mobile_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../generated/l10n.dart';

class CustodyLogScreen extends StatelessWidget {
  final int employeeId;

  const CustodyLogScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: lang.custodyLogTitle,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(child: CustodyLogMobileView(employeeId: employeeId)),
    );
  }
}
