// -----------------------------------------------------------------------------
// Customer picker — bottom sheet
//

import 'dart:developer';

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerPickerSheet extends StatefulWidget {
  const CustomerPickerSheet({super.key, required this.persons});
  final List<PosClientModel> persons;

  @override
  State<CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<CustomerPickerSheet> {
  final _searchController = TextEditingController();
  late List<PosClientModel> _filtered = widget.persons;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final normalized = query.trim().toLowerCase();
    setState(() {
      _filtered = normalized.isEmpty
          ? widget.persons
          : widget.persons.where((p) {
              final name = (p.arabicName).toLowerCase();
              final phone = (p.phone ?? '').toLowerCase();
              return name.contains(normalized) || phone.contains(normalized);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.persons.length.toString());
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(bottom: bottomInset),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(spacing.radiusXl),
              topRight: Radius.circular(spacing.radiusXl),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: spacing.sm),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(spacing.radiusPill),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.md,
                  spacing.md,
                  spacing.md,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: lang.searchCustomerHint,
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.tertiary,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusLg),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: spacing.sm,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    // Add new customer button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            vertical: spacing.sm + spacing.xxs,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusLg,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushNamed(Routes.addCustomerScreen);
                        },
                        icon: Icon(Icons.person_add_alt_1, size: icons.sm),
                        label: Text(
                          lang.addNewCustomer,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                  ],
                ),
              ),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                          child: Text(
                            lang.noResultsFound,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: spacing.md),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        itemBuilder: (context, index) {
                          final person = _filtered[index];
                          return _CustomerPickerRow(
                            person: person,
                            onTap: () => Navigator.pop(context, person),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerPickerRow extends StatelessWidget {
  const _CustomerPickerRow({required this.person, required this.onTap});

  final PosClientModel person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm + spacing.xxs / 2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.arabicName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (person.personPhones?.isNotEmpty == true) ...[
                    SizedBox(height: spacing.xxs / 2),
                    Text(
                      person.personPhones!.first.phoneNumber!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: theme.colorScheme.outline,
              size: icons.md,
            ),
          ],
        ),
      ),
    );
  }
}
