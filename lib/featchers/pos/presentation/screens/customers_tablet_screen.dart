import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/screens/ass_customer_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class CustomersTabletView extends StatefulWidget {
  const CustomersTabletView({super.key});

  @override
  State<CustomersTabletView> createState() => _CustomersTabletViewState();
}

class _CustomersTabletViewState extends State<CustomersTabletView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(
      LoadPersonsData(
        request: GetClientsRequest(
          pageNumber: 1,
          pageSize: 10,
          isSupplier: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final filteredPersons = state.persons.where((person) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          final name = (person.arabicName ?? '').toLowerCase();
          final phone =
              (person.personPhones?.isNotEmpty == true
                      ? person.personPhones!.first.phoneNumber ?? ''
                      : '')
                  .toLowerCase();

          return name.contains(query) || phone.contains(query);
        }).toList();

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              children: [
                // Top Search & Add Customer Bar
                _buildTopHeaderBar(context, theme, spacing, lang),
                SizedBox(height: spacing.md),

                // Data Table Container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTableHeader(theme, spacing, lang),
                        const Divider(height: 1),
                        Expanded(
                          child: state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : filteredPersons.isEmpty
                              ? Center(
                                  child: Text(
                                    lang.noResultsFound,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: filteredPersons.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    return _buildTableRow(
                                      context,
                                      theme,
                                      spacing,
                                      filteredPersons[index],
                                      index + 1,
                                    );
                                  },
                                ),
                        ),
                        const Divider(height: 1),
                        _buildPaginationFooter(
                          theme,
                          spacing,
                          filteredPersons.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Top Search & Add Customer Action Bar
  Widget _buildTopHeaderBar(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    S lang,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Add New Customer Button
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                AddCustomerDialog.show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
              label: Text(
                lang.addNewCustomer,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing.md),

          // Search Field
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: lang.searchCustomerHint,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.xs,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Row matching mockup fields
  Widget _buildTableHeader(ThemeData theme, AppSpacing spacing, S lang) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '#',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              lang.customer,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              lang.phone,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lang.city,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                lang.actions,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Table Row
  Widget _buildTableRow(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    PosClientModel person,
    int index,
  ) {
    final String serialNumber = index.toString().padLeft(3, '0');
    final String clientName = person.arabicName ?? '';
    final String phone = (person.personPhones?.isNotEmpty == true)
        ? person.personPhones?.first.phoneNumber ?? ''
        : '---';
    final city =
        (person.personAddress?.isNotEmpty == true
                ? person.personAddress!.first.city ?? ''
                : '---')
            .toLowerCase();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              serialNumber,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              clientName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              phone,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              city,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          // Actions: Edit and Delete Buttons
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF0284C7),
                  backgroundColor: const Color(0xFFE0F2FE),
                  onPressed: () {
                    // Navigate or open dialog to edit client
                    AddCustomerDialog.show(context, selectedPerson: person);
                  },
                ),
                SizedBox(width: spacing.xs),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  color: const Color(0xFFDC2626),
                  backgroundColor: const Color(0xFFFEE2E2),
                  onPressed: () {
                    // Confirm and handle deletion
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // Footer Pagination Matching Layout
  Widget _buildPaginationFooter(
    ThemeData theme,
    AppSpacing spacing,
    int totalItems,
  ) {
    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildPageButton('<', enabled: false, onPressed: () {}),
              _buildPageButton('...', enabled: false, onPressed: () {}),
              _buildPageButton('3', enabled: false, onPressed: () {}),
              _buildPageButton('2', enabled: false, onPressed: () {}),
              _buildPageButton('1', selected: true, onPressed: () {}),
              _buildPageButton('>', enabled: false, onPressed: () {}),
            ],
          ),
          Text(
            'عرض 1 إلى $totalItems من $totalItems نتيجة',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    String text, {
    bool selected = false,
    bool enabled = true,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF005DB9) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? const Color(0xFF005DB9) : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
