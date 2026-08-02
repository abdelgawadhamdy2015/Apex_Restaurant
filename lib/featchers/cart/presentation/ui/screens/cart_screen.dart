// // ignore_for_file: deprecated_member_use

// import 'package:apex_restaurant/core/helpers/extensions.dart';
// import 'package:apex_restaurant/core/helpers/helper_methods.dart';
// import 'package:apex_restaurant/core/router/routes.dart';
// import 'package:apex_restaurant/core/themes/app_colors.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
// import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
// import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
// import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
// import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/cart_top_bar.dart';
// import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
// import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
// import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
// import 'package:apex_restaurant/featchers/tables/data/models/tables_screen_arg.dart';
// import 'package:apex_restaurant/generated/l10n.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CartBloc>().add(LoadCartDataEvent());
//       context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
//       context.read<CartBloc>().add(
//         LoadPersonsData(
//           request: GetClientsRequest(
//             isSupplier: false,
//             pageNumber: 1,
//             pageSize: 50,
//           ),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;

//     return Scaffold(
//       appBar: CartTopBar(
//         onClearAll: () {
//           context.read<CartBloc>().add(ClearCartEvent());
//         },
//       ),

//       backgroundColor: theme.colorScheme.surface,
//       body: BlocConsumer<CartBloc, CartState>(
//         listener: (context, state) {
//           if (state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage!),
//                 backgroundColor: theme.colorScheme.error,
//               ),
//             );
//           }
//           if (state.successMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.successMessage!),
//                 backgroundColor: theme.colorScheme.primary,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.status == CartStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final isWide = constraints.maxWidth > 700;
//               final contentWidth = isWide ? 700.0 : constraints.maxWidth;

//               return Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.all(spacing.md),
//                       child: Center(
//                         child: SizedBox(
//                           width: contentWidth,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               const _HeaderInfoCard(),
//                               SizedBox(height: spacing.sm),
//                               const _OrderTypeSelector(),
//                               SizedBox(height: spacing.sm),
//                               _CustomerInfoCard(
//                                 persons: state.persons,
//                                 selectedPerson:
//                                     state.selectedPerson ??
//                                     (state.persons.isNotEmpty
//                                         ? state.persons.first
//                                         : null),
//                               ),
//                               SizedBox(height: spacing.sm),
//                               _buildDynamicTypeSelection(state),
//                               SizedBox(height: spacing.md),
//                               ...state.items.asMap().entries.map((entry) {
//                                 return _CartItemTile(
//                                   index: entry.key,
//                                   item: entry.value,
//                                 );
//                               }),
//                               SizedBox(height: spacing.md),
//                               _DiscountSection(
//                                 selectedPerson: state.selectedPerson,
//                                 dynamicisActive: state.dynamicDiscountIsActive,
//                                 dynamicDiscountModel: state.activeDiscountModel,
//                               ),
//                               SizedBox(height: spacing.md),
//                               const _OrderSummaryCard(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const _BottomActionBar(),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDynamicTypeSelection(CartState state) {
//     switch (state.selectedOrderType) {
//       case OrderType.dineIn:
//         return _DineInSelector(persons: state.persons);
//       case OrderType.delivery:
//         return const _DeliveryAgentSelector();
//       case OrderType.deliveryCompany:
//         return const _DeliveryCompanySelector();
//       case OrderType.takeaway:
//         return const SizedBox.shrink();
//     }
//   }
// }

// // -----------------------------------------------------------------------------
// // Sub-Widgets
// // -----------------------------------------------------------------------------

// class _HeaderInfoCard extends StatelessWidget {
//   const _HeaderInfoCard();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: spacing.md,
//         vertical: spacing.sm,
//       ),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _HeaderInfoItem(title: lang.orderNumber, value: '#12345'),
//           _HeaderInfoItem(
//             title: lang.invoiceNumber,
//             value: 'INV-9876',
//             isValueBlue: true,
//           ),
//           _HeaderInfoItem(title: lang.date, value: '10/07/2026'),
//         ],
//       ),
//     );
//   }
// }

// class _HeaderInfoItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isValueBlue;

//   const _HeaderInfoItem({
//     required this.title,
//     required this.value,
//     this.isValueBlue = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       children: [
//         Text(
//           title,
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: theme.colorScheme.onSurfaceVariant,
//           ),
//         ),
//         SizedBox(height: context.spacing.xxs),
//         Text(
//           value,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: isValueBlue
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrderTypeSelector extends StatelessWidget {
//   const _OrderTypeSelector();

//   @override
//   Widget build(BuildContext context) {
//     context.select((CartBloc b) => b.state.selectedOrderType);
//     final spacing = context.spacing;
//     final lang = S.of(context);

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _buildChip(
//             context,
//             OrderType.takeaway,
//             lang.takeaway,
//             Icons.shopping_bag_outlined,
//           ),
//           SizedBox(width: spacing.xs),
//           _buildChip(context, OrderType.dineIn, lang.dineIn, Icons.restaurant),
//           SizedBox(width: spacing.xs),
//           _buildChip(
//             context,
//             OrderType.delivery,
//             lang.delivery,
//             Icons.two_wheeler,
//           ),
//           SizedBox(width: spacing.xs),
//           _buildChip(
//             context,
//             OrderType.deliveryCompany,
//             lang.deliveryCompanies,
//             Icons.storefront,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChip(
//     BuildContext context,
//     OrderType type,
//     String label,
//     IconData icon,
//   ) {
//     final theme = Theme.of(context);
//     final isSelected = context.select(
//       (CartBloc b) => b.state.selectedOrderType == type,
//     );
//     final spacing = context.spacing;
//     final icons = context.iconSizes;

//     final activeColor = theme.colorScheme.primary;
//     final inactiveColor = theme.colorScheme.surfaceContainerHighest;
//     final activeTextColor = theme.colorScheme.onPrimary;
//     final inactiveTextColor = theme.colorScheme.onSurfaceVariant;

//     return InkWell(
//       onTap: () => context.read<CartBloc>().add(ChangeOrderTypeEvent(type)),
//       borderRadius: BorderRadius.circular(spacing.radiusPill),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(
//           horizontal: spacing.md,
//           vertical: spacing.xs,
//         ),
//         decoration: BoxDecoration(
//           color: isSelected ? activeColor : inactiveColor,
//           borderRadius: BorderRadius.circular(spacing.radiusPill),
//           border: Border.all(
//             color: isSelected ? activeColor : theme.colorScheme.outlineVariant,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: icons.sm,
//               color: isSelected ? activeTextColor : inactiveTextColor,
//             ),
//             SizedBox(width: spacing.xxs + spacing.xxs / 2),
//             Text(
//               label,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? activeTextColor : inactiveTextColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CustomerInfoCard extends StatelessWidget {
//   const _CustomerInfoCard({required this.persons, this.selectedPerson});
//   final List<PosClientModel> persons;
//   final PosClientModel? selectedPerson;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final icons = context.iconSizes;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.sm),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: theme.colorScheme.primaryContainer,
//             radius: icons.lg - icons.sm / 2,
//             child: Icon(
//               Icons.person,
//               color: theme.colorScheme.onPrimaryContainer,
//               size: icons.md,
//             ),
//           ),
//           SizedBox(width: spacing.sm),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => HelperMethods.openPicker(context, persons),
//               behavior: HitTestBehavior.opaque,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     selectedPerson?.arabicName ?? lang.noCustomerSelected,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                     ),
//                   ),
//                   if (selectedPerson != null &&
//                       selectedPerson!.personPhones != null &&
//                       selectedPerson!.personPhones!.isNotEmpty)
//                     Text(
//                       selectedPerson?.personPhones?.first.phoneNumber
//                               .toString() ??
//                           "",
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: theme.colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               context.pushNamed(Routes.addCustomerScreen);
//             },
//             icon: Icon(
//               Icons.person_add_outlined,
//               size: icons.lg,
//               color: theme.colorScheme.primary,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               context.pushNamed(
//                 Routes.addCustomerScreen,
//                 extra: selectedPerson,
//               );
//             },
//             icon: Icon(
//               Icons.edit,
//               size: icons.lg,
//               color: theme.colorScheme.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DineInSelector extends StatelessWidget {
//   const _DineInSelector({required this.persons});
//   final List<PosClientModel> persons;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final icons = context.iconSizes;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.sm),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               hintText: lang.selectWaiter,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: spacing.sm,
//                 vertical: spacing.xs,
//               ),
//             ),
//             items: const [],
//             onChanged: (val) {},
//           ),
//           SizedBox(height: spacing.xs + spacing.xxs / 2),
//           BlocBuilder<HomeBloc, HomeState>(
//             builder: (context, state) {
//               return OutlinedButton.icon(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size.fromHeight(icons.xl + spacing.md),
//                   side: BorderSide(color: theme.colorScheme.tertiary),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(spacing.radiusMd),
//                   ),
//                 ),
//                 onPressed: () {
//                   context.pushNamed(
//                     Routes.tableScreen,
//                     extra: TablesScreenArgs(
//                       branchId: state.selectedEmployeeBranch?.branchId ?? 0,
//                       personList: persons,
//                     ),
//                   );
//                 },
//                 icon: Icon(
//                   Icons.table_restaurant,
//                   color: theme.colorScheme.tertiary,
//                   size: icons.md,
//                 ),
//                 label: Text(
//                   lang.selectTable,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.tertiary,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DeliveryAgentSelector extends StatelessWidget {
//   const _DeliveryAgentSelector();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.sm),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           hintText: lang.selectDeliveryAgent,
//           prefixIcon: Icon(
//             Icons.two_wheeler,
//             color: theme.colorScheme.primary,
//             size: context.iconSizes.md,
//           ),
//         ),
//         items: const [],
//         onChanged: (val) {},
//       ),
//     );
//   }
// }

// class _DeliveryCompanySelector extends StatelessWidget {
//   const _DeliveryCompanySelector();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.sm),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           hintText: lang.deliveryCompanyDetails,
//           prefixIcon: Icon(
//             Icons.storefront,
//             color: theme.colorScheme.primary,
//             size: context.iconSizes.md,
//           ),
//         ),
//         items: const [],
//         onChanged: (val) {},
//       ),
//     );
//   }
// }

// class _CartItemTile extends StatelessWidget {
//   final int index;
//   final OrderItem item;

//   const _CartItemTile({required this.index, required this.item});

//   List<String> _getFormattedAddons() {
//     final Map<String, int> addonCounts = {};
//     for (var addon in item.addons) {
//       final name = addon.arabicName;
//       addonCounts[name] = (addonCounts[name] ?? 0) + 1;
//     }
//     return addonCounts.entries
//         .map((entry) => '+ ${entry.key} ${entry.value}x')
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final icons = context.iconSizes;
//     final lang = S.of(context);

//     final sizeName = item.selectedSize?.sizeNameAr ?? '';
//     final formattedAddons = _getFormattedAddons();

//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: spacing.sm),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(spacing.radiusLg),
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   color: theme.colorScheme.surfaceContainerHighest,
//                   child: item.menuItem.imagePath != null
//                       ? Image.network(
//                           item.menuItem.imagePath!,
//                           fit: BoxFit.cover,
//                         )
//                       : Icon(
//                           Icons.fastfood,
//                           color: theme.colorScheme.onSurfaceVariant,
//                           size: icons.lg,
//                         ),
//                 ),
//               ),
//               SizedBox(width: spacing.md),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item.menuItem.itemNameAr,
//                             textAlign: TextAlign.right,
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: theme.colorScheme.onSurface,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: spacing.xs),
//                         Text(
//                           '${item.totalPrice.toStringAsFixed(2)} ${lang.currencySar}',
//                           style: theme.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: theme.colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (sizeName.isNotEmpty) ...[
//                       SizedBox(height: spacing.xxs),
//                       Text(
//                         lang.sizeWithVal(sizeName) + (" | ${item.notes}"),
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                     if (formattedAddons.isNotEmpty) ...[
//                       SizedBox(height: spacing.xxs),
//                       ...formattedAddons.map(
//                         (addonText) => Padding(
//                           padding: EdgeInsets.only(top: spacing.xxs / 2),
//                           child: Text(
//                             addonText,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: theme.colorScheme.secondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     if (item.notes != null && item.notes!.isNotEmpty) ...[
//                       SizedBox(height: spacing.xxs),
//                       Text(
//                         item.notes!,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                     SizedBox(height: spacing.sm),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(
//                             Icons.delete_outline_rounded,
//                             color: theme.colorScheme.error,
//                             size: icons.md,
//                           ),
//                           onPressed: () => context.read<CartBloc>().add(
//                             RemoveItemEvent(index),
//                           ),
//                         ),
//                         const Spacer(),
//                         Container(
//                           height: 38,
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(
//                               spacing.radiusMd,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.add, size: 18),
//                                 color: theme.colorScheme.onSurface,
//                                 onPressed: () => context.read<CartBloc>().add(
//                                   UpdateItemQuantityEvent(index, 1),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: spacing.xs,
//                                 ),
//                                 child: Text(
//                                   '${item.quantity}',
//                                   style: theme.textTheme.titleMedium?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.remove, size: 18),
//                                 color: theme.colorScheme.onSurface,
//                                 onPressed: () => context.read<CartBloc>().add(
//                                   UpdateItemQuantityEvent(index, -1),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: spacing.md),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           height: 1,
//           thickness: 0.8,
//           color: theme.colorScheme.outlineVariant.withOpacity(0.5),
//         ),
//       ],
//     );
//   }
// }

// class _DiscountSection extends StatelessWidget {
//   _DiscountSection({
//     required this.dynamicisActive,
//     this.dynamicDiscountModel,
//     this.selectedPerson,
//   });
//   final bool dynamicisActive;
//   final DynamicDiscountModel? dynamicDiscountModel;
//   final PosClientModel? selectedPerson;
//   final TextEditingController _discountCodeController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final discountType = context.select(
//       (CartBloc b) => b.state.selectedDiscountType,
//     );
//     final spacing = context.spacing;
//     final icons = context.iconSizes;
//     final lang = S.of(context);
//     if (dynamicisActive &&
//         selectedPerson != null &&
//         selectedPerson!.discountRatio != 0) {
//       _discountCodeController.text = selectedPerson!.discountRatio.toString();
//     }
//     return Container(
//       padding: EdgeInsets.all(spacing.sm),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           Wrap(
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               Radio<DiscountType>(
//                 value: DiscountType.coupon,
//                 groupValue: discountType,
//                 activeColor: theme.colorScheme.primary,
//                 onChanged: dynamicisActive
//                     ? null
//                     : (val) {
//                         if (val != null) {
//                           context.read<CartBloc>().add(
//                             ChangeDiscountTypeEvent(val),
//                           );
//                         }
//                       },
//               ),
//               Text(
//                 lang.coupon,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(width: spacing.md),
//               Radio<DiscountType>(
//                 value: DiscountType.direct,
//                 groupValue: discountType,
//                 activeColor: theme.colorScheme.primary,
//                 onChanged: dynamicisActive
//                     ? null
//                     : (val) {
//                         if (val != null) {
//                           context.read<CartBloc>().add(
//                             ChangeDiscountTypeEvent(val),
//                           );
//                         }
//                       },
//               ),
//               Text(
//                 lang.directDiscount,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: spacing.xs),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _discountCodeController,
//                   enabled: !dynamicisActive,
//                   decoration: InputDecoration(
//                     hintText: lang.enterDiscountCode,
//                     prefixIcon: Icon(
//                       Icons.local_offer_outlined,
//                       color: theme.colorScheme.tertiary,
//                       size: icons.sm,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: spacing.xs),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: theme.colorScheme.primaryContainer
//                       .withOpacity(.1),
//                   foregroundColor: theme.colorScheme.onPrimaryContainer,
//                   elevation: 0,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: spacing.lg,
//                     vertical: spacing.sm + spacing.xxs / 2,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(spacing.radiusMd),
//                   ),
//                 ),
//                 onPressed: dynamicisActive ? null : () {},
//                 child: Text(
//                   lang.apply,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OrderSummaryCard extends StatelessWidget {
//   const _OrderSummaryCard();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final state = context.watch<CartBloc>().state;
//     final spacing = context.spacing;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.md),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(spacing.radiusLg),
//         border: Border.all(color: theme.colorScheme.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           _summaryRow(
//             context,
//             lang.subtotal,
//             '${state.subtotal.toStringAsFixed(2)} ${lang.currencySar}',
//           ),
//           SizedBox(height: spacing.xs),
//           _summaryRow(
//             context,
//             lang.discountCoupon,
//             '-${state.discountAmount.toStringAsFixed(2)} ${lang.currencySar}',
//             isSuccess: true,
//           ),
//           if (state.selectedOrderType == OrderType.delivery ||
//               state.selectedOrderType == OrderType.deliveryCompany) ...[
//             SizedBox(height: spacing.xs),
//             _summaryRow(
//               context,
//               lang.deliveryFee,
//               '${state.deliveryFee.toStringAsFixed(2)} ${lang.currencySar}',
//             ),
//           ],
//           SizedBox(height: spacing.xs),
//           _summaryRow(
//             context,
//             lang.vat15,
//             '${state.vatAmount.toStringAsFixed(2)} ${lang.currencySar}',
//           ),
//           Divider(height: spacing.xl, color: theme.colorScheme.outlineVariant),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 lang.grandTotal,
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 '${state.grandTotal.toStringAsFixed(2)} ${lang.currencySar}',
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: theme.colorScheme.primary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryRow(
//     BuildContext context,
//     String title,
//     String value, {
//     bool isSuccess = false,
//   }) {
//     final theme = Theme.of(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: isSuccess
//                 ? AppColors.green
//                 : theme.colorScheme.onSurfaceVariant,
//           ),
//         ),
//         Text(
//           value,
//           style: theme.textTheme.bodySmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: isSuccess ? AppColors.green : theme.colorScheme.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _BottomActionBar extends StatelessWidget {
//   const _BottomActionBar();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final spacing = context.spacing;
//     final icons = context.iconSizes;
//     final lang = S.of(context);

//     return Container(
//       padding: EdgeInsets.all(spacing.md),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         border: Border(
//           top: BorderSide(color: theme.colorScheme.outlineVariant),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: spacing.sm - spacing.xxs / 2,
//             offset: Offset(0, -spacing.xxs),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: theme.colorScheme.primary,
//                 foregroundColor: theme.colorScheme.onPrimary,
//                 padding: EdgeInsets.symmetric(
//                   vertical: spacing.sm + spacing.xxs / 2,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(spacing.radiusMd),
//                 ),
//               ),
//               onPressed: () => context.pushNamed(Routes.paymentScreen),
//               icon: Icon(Icons.payments_outlined, size: icons.md),
//               label: Text(
//                 lang.checkout,
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   color: theme.colorScheme.onPrimary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: spacing.sm),
//           OutlinedButton.icon(
//             style: OutlinedButton.styleFrom(
//               padding: EdgeInsets.symmetric(
//                 horizontal: spacing.md,
//                 vertical: spacing.sm + spacing.xxs / 2,
//               ),
//               side: BorderSide(color: theme.colorScheme.outline),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(spacing.radiusMd),
//               ),
//             ),
//             onPressed: () =>
//                 context.read<CartBloc>().add(HoldOrderSubmittedEvent()),
//             icon: Icon(
//               Icons.pause_circle_outline,
//               color: theme.colorScheme.onSurface,
//               size: icons.md,
//             ),
//             label: Text(
//               lang.holdOrder,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/cart_top_bar.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/discount_type_toggle.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_sheet.dart';
import 'package:apex_restaurant/featchers/tables/data/models/tables_screen_arg.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartDataEvent());
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
      context.read<CartBloc>().add(
        LoadPersonsData(
          request: GetClientsRequest(
            isSupplier: false,
            pageNumber: 1,
            pageSize: 50,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: CartTopBar(
        onClearAll: () {
          context.read<CartBloc>().add(ClearCartEvent());
        },
      ),
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final contentWidth = isWide ? 700.0 : constraints.maxWidth;
              final showAddressCard =
                  state.selectedOrderType == OrderType.delivery ||
                  state.selectedOrderType == OrderType.deliveryCompany;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.md),
                      child: Center(
                        child: SizedBox(
                          width: contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _HeaderInfoCard(),
                              SizedBox(height: spacing.sm),
                              const _OrderTypeSelector(),
                              SizedBox(height: spacing.sm),
                              _CustomerInfoCard(
                                persons: state.persons,
                                selectedPerson:
                                    state.selectedPerson ??
                                    (state.persons.isNotEmpty
                                        ? state.persons.first
                                        : null),
                              ),
                              if (showAddressCard) ...[
                                SizedBox(height: spacing.sm),
                                _AddressCard(
                                  selectedAddress: state.selectedAddress,
                                  addresses:
                                      state.selectedPerson?.personAddress ??
                                      const [],
                                ),
                              ],
                              SizedBox(height: spacing.sm),
                              _buildDynamicTypeSelection(state),
                              SizedBox(height: spacing.md),
                              ...state.items.asMap().entries.map((entry) {
                                return _CartItemTile(
                                  index: entry.key,
                                  item: entry.value,
                                );
                              }),
                              SizedBox(height: spacing.md),
                              _DiscountSection(
                                selectedPerson: state.selectedPerson,
                                dynamicisActive: state.dynamicDiscountIsActive,
                                dynamicDiscountModel: state.activeDiscountModel,
                              ),
                              SizedBox(height: spacing.md),
                              const _OrderSummaryCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const _BottomActionBar(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDynamicTypeSelection(CartState state) {
    switch (state.selectedOrderType) {
      case OrderType.dineIn:
        return _DineInSelector(persons: state.persons, waiters: state.waiters);
      case OrderType.delivery:
        return _DeliveryAgentSelector(deliveryMens: state.deliveryAgents);
      case OrderType.deliveryCompany:
        return _DeliveryCompanySelector(
          deliveryCompanies: state.deliveryCompanies,
        );
      case OrderType.takeaway:
        return const SizedBox.shrink();
    }
  }
}

// -----------------------------------------------------------------------------
// Sub-Widgets
// -----------------------------------------------------------------------------

class _HeaderInfoCard extends StatelessWidget {
  const _HeaderInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderInfoItem(title: lang.orderNumber, value: '#12345'),
          _HeaderInfoItem(
            title: lang.invoiceNumber,
            value: 'INV-9876',
            isValueBlue: true,
          ),
          _HeaderInfoItem(
            title: lang.date,
            value: DateTime.now().toString().split(' ').first,
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isValueBlue;

  const _HeaderInfoItem({
    required this.title,
    required this.value,
    this.isValueBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isValueBlue
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _OrderTypeSelector extends StatelessWidget {
  const _OrderTypeSelector();

  @override
  Widget build(BuildContext context) {
    context.select((CartBloc b) => b.state.selectedOrderType);
    final spacing = context.spacing;
    final lang = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context,
            OrderType.takeaway,
            lang.takeaway,
            Icons.shopping_bag_outlined,
          ),
          SizedBox(width: spacing.xs),
          _buildChip(context, OrderType.dineIn, lang.dineIn, Icons.restaurant),
          SizedBox(width: spacing.xs),
          _buildChip(
            context,
            OrderType.delivery,
            lang.delivery,
            Icons.two_wheeler,
          ),
          SizedBox(width: spacing.xs),
          _buildChip(
            context,
            OrderType.deliveryCompany,
            lang.deliveryCompanies,
            Icons.storefront,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    OrderType type,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = context.select(
      (CartBloc b) => b.state.selectedOrderType == type,
    );
    final spacing = context.spacing;
    final icons = context.iconSizes;

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.surfaceContainerHighest;
    final activeTextColor = theme.colorScheme.onPrimary;
    final inactiveTextColor = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => context.read<CartBloc>().add(ChangeOrderTypeEvent(type)),
      borderRadius: BorderRadius.circular(spacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(spacing.radiusPill),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: icons.sm,
              color: isSelected ? activeTextColor : inactiveTextColor,
            ),
            SizedBox(width: spacing.xxs + spacing.xxs / 2),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerInfoCard extends StatelessWidget {
  const _CustomerInfoCard({required this.persons, this.selectedPerson});
  final List<PosClientModel> persons;
  final PosClientModel? selectedPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            radius: icons.lg - icons.sm / 2,
            child: Icon(
              Icons.person,
              color: theme.colorScheme.onPrimaryContainer,
              size: icons.md,
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => HelperMethods.openPicker(context, persons),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPerson?.arabicName ?? lang.noCustomerSelected,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (selectedPerson != null &&
                      selectedPerson!.personPhones != null &&
                      selectedPerson!.personPhones!.isNotEmpty)
                    Text(
                      selectedPerson?.personPhones?.first.phoneNumber
                              .toString() ??
                          "",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.addCustomerScreen);
            },
            icon: Icon(
              Icons.person_add_outlined,
              size: icons.lg,
              color: theme.colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(
                Routes.addCustomerScreen,
                extra: selectedPerson,
              );
            },
            icon: Icon(
              Icons.edit,
              size: icons.lg,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.selectedAddress, required this.addresses});

  final ClientAddressModel? selectedAddress;
  final List<ClientAddressModel> addresses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${lang.address}: ${selectedAddress?.id.toString()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: spacing.xxs),
                  Icon(
                    Icons.location_on_outlined,
                    size: icons.sm,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              InkWell(
                onTap: () => _openAddressPicker(context),
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xxs,
                    vertical: spacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: icons.sm,
                        color: theme.colorScheme.onSurface,
                      ),
                      SizedBox(width: spacing.xxs),
                      Text(
                        lang.changeAddress,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (selectedAddress != null) ...[
            SizedBox(height: spacing.xxs),
            Text(
              selectedAddress!.fullAddress,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openAddressPicker(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: cartBloc,
          child: _AddressPickerSheet(
            addresses: addresses,
            selectedAddress: selectedAddress,
          ),
        ),
      ),
    );
  }
}

class _AddressPickerSheet extends StatelessWidget {
  const _AddressPickerSheet({
    required this.addresses,
    required this.selectedAddress,
  });

  final List<ClientAddressModel> addresses;
  final ClientAddressModel? selectedAddress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusPill),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.changeAddress,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.md),
              InkWell(
                onTap: () {
                  Navigator.pop(context);

                  context.pushNamed(
                    Routes.addCustomerScreen,
                    extra: context.read<CartBloc>().state.selectedPerson,
                  );
                },
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.sm + spacing.xxs,
                    horizontal: spacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    '+ ${lang.addNewAddress}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final isSelected = address.id == selectedAddress?.id;

                    return InkWell(
                      onTap: () {
                        context.read<CartBloc>().add(
                          ChangeAddressEvent(address),
                        );
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                      child: Container(
                        padding: EdgeInsets.all(spacing.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.05)
                              : null,
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.city ?? "",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: spacing.xxs),
                                  Text(
                                    address.fullAddress,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<int>(
                              value: address.id,
                              groupValue: selectedAddress?.id,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (_) {
                                context.read<CartBloc>().add(
                                  ChangeAddressEvent(address),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DineInSelector extends StatelessWidget {
  const _DineInSelector({required this.persons, required this.waiters});
  final List<PosClientModel> persons;
  final List<WaiterModel> waiters; // Replace with actual waiters list
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<WaiterModel?>(
            decoration: InputDecoration(
              hintText: lang.selectWaiter,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
              ),
            ),
            items: waiters.map((waiter) {
              return DropdownMenuItem<WaiterModel?>(
                value: waiter,
                child: Text(waiter.arabicName ?? ''),
              );
            }).toList(),
            onChanged: (val) {
              context.read<CartBloc>().add(SelectWaiterEvent(val));
            },
          ),
          SizedBox(height: spacing.xs + spacing.xxs / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${lang.selectedTable} : ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                context.read<CartBloc>().state.selectedTable?.arabicName ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(icons.xl + spacing.md),
                  side: BorderSide(color: theme.colorScheme.tertiary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                  ),
                ),
                onPressed: () {
                  context.pushNamed(
                    Routes.tableScreen,
                    extra: TablesScreenArgs(
                      branchId: state.selectedEmployeeBranch?.branchId ?? 0,
                      personList: persons,
                      inCartScreen: true,
                    ),
                  );
                },
                icon: Icon(
                  Icons.table_restaurant,
                  color: theme.colorScheme.tertiary,
                  size: icons.md,
                ),
                label: Text(
                  lang.selectTable,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeliveryAgentSelector extends StatelessWidget {
  const _DeliveryAgentSelector({required this.deliveryMens});
  final List<WaiterModel> deliveryMens;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<WaiterModel?>(
        decoration: InputDecoration(
          hintText: lang.selectDeliveryAgent,
          prefixIcon: Icon(
            Icons.two_wheeler,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: deliveryMens.map((waiter) {
          return DropdownMenuItem<WaiterModel?>(
            value: waiter,
            child: Text(waiter.arabicName ?? ''),
          );
        }).toList(),
        onChanged: (val) {
          context.read<CartBloc>().add(SelectDeliveryManEvent(val));
        },
      ),
    );
  }
}

class _DeliveryCompanySelector extends StatelessWidget {
  const _DeliveryCompanySelector({required this.deliveryCompanies});
  final List<DeliveryCompanyModel> deliveryCompanies;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<DeliveryCompanyModel?>(
        decoration: InputDecoration(
          hintText: lang.deliveryCompanyDetails,
          prefixIcon: Icon(
            Icons.storefront,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: deliveryCompanies.map((company) {
          return DropdownMenuItem<DeliveryCompanyModel?>(
            value: company,
            child: Text(company.arabicName ?? ''),
          );
        }).toList(),
        onChanged: (val) {
          context.read<CartBloc>().add(
            SelectDeliveryCompanyEvent(deliveryCompanyModel: val!),
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final int index;
  final OrderItem item;

  const _CartItemTile({required this.index, required this.item});

  List<String> _getFormattedAddons() {
    final Map<String, int> addonCounts = {};
    for (var addon in item.addons) {
      final name = addon.arabicName;
      addonCounts[name] = (addonCounts[name] ?? 0) + 1;
    }
    return addonCounts.entries
        .map((entry) => '+ ${entry.key} ${entry.value}x')
        .toList();
  }

  void _openEditSheet(BuildContext context) {
    final posState = context.read<PosBloc>().state;

    final restaurantItem = posState.currentMenuItems.firstWhere(
      (m) => m.itemId == item.menuItem.itemId,
      orElse: () => item.menuItem,
    );

    final allAddons = posState.selectedCategory?.additives ?? [];
    final cartBloc = context.read<CartBloc>();

    ItemCustomizationSheet.show(
      context,
      restaurantItem,
      allAddons,
      (
        restaurantItem,
        additives, {
        required selectedSize,
        required selectedAddons,
        required discount,
        required isPercentageDiscount,
        required String notes,
        required int quantity,
      }) {
        cartBloc.add(
          EditCartItemEvent(
            index: index,
            selectedSize: selectedSize,
            selectedAddons: selectedAddons,
            discount: discount,
            isPercentageDiscount: isPercentageDiscount,
            notes: notes,
            quantity: quantity,
          ),
        );
      },
      existingItem: item,
      cartIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    final sizeName = item.selectedSize?.sizeNameAr ?? '';
    final formattedAddons = _getFormattedAddons();

    return InkWell(
      onTap: () => _openEditSheet(context),
      borderRadius: BorderRadius.circular(spacing.radiusLg),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: item.menuItem.imagePath != null
                        ? Image.network(
                            item.menuItem.imagePath!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.fastfood,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: icons.lg,
                          ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.menuItem.itemNameAr,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(width: spacing.xs),
                          Text(
                            '${item.totalPrice.toStringAsFixed(2)} ${lang.currencySar}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (sizeName.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          lang.sizeWithVal(sizeName) + (" | ${item.notes}"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (formattedAddons.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        ...formattedAddons.map(
                          (addonText) => Padding(
                            padding: EdgeInsets.only(top: spacing.xxs / 2),
                            child: Text(
                              addonText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          item.notes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      SizedBox(height: spacing.sm),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: theme.colorScheme.error,
                              size: icons.md,
                            ),
                            onPressed: () => context.read<CartBloc>().add(
                              RemoveItemEvent(index),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  color: theme.colorScheme.onSurface,
                                  onPressed: () => context.read<CartBloc>().add(
                                    UpdateItemQuantityEvent(index, 1),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing.xs,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  color: theme.colorScheme.onSurface,
                                  onPressed: () => context.read<CartBloc>().add(
                                    UpdateItemQuantityEvent(index, -1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: spacing.md),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.8,
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _DiscountSection extends StatefulWidget {
  const _DiscountSection({
    required this.dynamicisActive,
    this.dynamicDiscountModel,
    this.selectedPerson,
  });
  final bool dynamicisActive;
  final DynamicDiscountModel? dynamicDiscountModel;
  final PosClientModel? selectedPerson;

  @override
  State<_DiscountSection> createState() => _DiscountSectionState();
}

class _DiscountSectionState extends State<_DiscountSection> {
  final TextEditingController _discountCodeController = TextEditingController();
  bool _isPercentageDiscount = true;

  @override
  void initState() {
    super.initState();
    _syncCustomerDiscount();
  }

  @override
  void didUpdateWidget(covariant _DiscountSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPerson != widget.selectedPerson ||
        oldWidget.dynamicisActive != widget.dynamicisActive) {
      _syncCustomerDiscount();
    }
  }

  void _syncCustomerDiscount() {
    if (widget.dynamicisActive &&
        widget.selectedPerson != null &&
        widget.selectedPerson!.discountRatio != 0) {
      context.read<CartBloc>().add(
        const ChangeDiscountTypeEvent(DiscountType.direct),
      );
      _discountCodeController.text = widget.selectedPerson!.discountRatio
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CartBloc>().state;
    final discountType = context.select(
      (CartBloc b) => b.state.selectedDiscountType,
    );
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Radio<DiscountType>(
                value: DiscountType.coupon,
                groupValue: discountType,
                activeColor: theme.colorScheme.primary,
                onChanged: widget.dynamicisActive
                    ? null
                    : (val) {
                        if (val != null) {
                          context.read<CartBloc>().add(
                            ChangeDiscountTypeEvent(val),
                          );
                        }
                      },
              ),
              Text(
                lang.coupon,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: spacing.md),
              Radio<DiscountType>(
                value: DiscountType.direct,
                groupValue: discountType,
                activeColor: theme.colorScheme.primary,
                onChanged: widget.dynamicisActive
                    ? null
                    : (val) {
                        if (val != null) {
                          context.read<CartBloc>().add(
                            ChangeDiscountTypeEvent(val),
                          );
                        }
                      },
              ),
              Text(
                lang.directDiscount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (state.selectedDiscountType != DiscountType.coupon)
            DiscountTypeToggle(
              enabled: !widget.dynamicisActive,
              isPercentage: _isPercentageDiscount,
              onChanged: (value) =>
                  setState(() => _isPercentageDiscount = value),
            ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _discountCodeController,
                  enabled: !widget.dynamicisActive,
                  decoration: InputDecoration(
                    hintText: state.selectedDiscountType == DiscountType.coupon
                        ? lang.enterDiscountCode
                        : lang.enterDiscountValue,
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: theme.colorScheme.tertiary,
                      size: icons.sm,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.xs),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer
                      .withOpacity(.1),
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.sm + spacing.xxs / 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                  ),
                ),
                onPressed: widget.dynamicisActive
                    ? null
                    : () {
                        final textValue = _discountCodeController.text.trim();
                        if (textValue.isEmpty) return;

                        if (state.selectedDiscountType == DiscountType.direct) {
                          final discountValue =
                              double.tryParse(textValue) ?? 0.0;
                          context.read<CartBloc>().add(
                            ApplyDiscountEvent(
                              saveDiscountModel: SaveDiscountModel(
                                type: _isPercentageDiscount
                                    ? 1
                                    : 2, // 1 for %, 2 for fixed SAR
                                value: discountValue,
                              ),
                            ),
                          );
                        } else {
                          context.read<CartBloc>().add(
                            ApplyCouponDiscountEvent(code: textValue),
                          );
                        }
                      },
                child: Text(
                  lang.apply,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CartBloc>().state;
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _summaryRow(
            context,
            lang.subtotal,
            '${state.subtotal.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          SizedBox(height: spacing.xs),
          _summaryRow(
            context,
            lang.discountCoupon,
            '-${state.totalDiscountAmount.toStringAsFixed(2)} ${lang.currencySar}',
            isSuccess: true,
          ),
          if (state.selectedOrderType == OrderType.delivery ||
              state.selectedOrderType == OrderType.deliveryCompany) ...[
            SizedBox(height: spacing.xs),
            _summaryRow(
              context,
              lang.deliveryFee,
              '${state.deliveryFee.toStringAsFixed(2)} ${lang.currencySar}',
            ),
          ],
          SizedBox(height: spacing.xs),
          _summaryRow(
            context,
            lang.vat15,
            '${state.vatAmount.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          Divider(height: spacing.xl, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.grandTotal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.grandTotal.toStringAsFixed(2)} ${lang.currencySar}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isSuccess = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSuccess
                ? AppColors.green
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isSuccess ? AppColors.green : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: spacing.sm - spacing.xxs / 2,
            offset: Offset(0, -spacing.xxs),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm + spacing.xxs / 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              onPressed: () {
                final SaveInvoiceRequestModel invoiceRequestModel = context
                    .read<CartBloc>()
                    .state
                    .toSaveInvoiceRequestModel;
                context.pushNamed(
                  Routes.paymentScreen,
                  extra: invoiceRequestModel,
                );
              },
              icon: Icon(Icons.payments_outlined, size: icons.md),
              label: Text(
                lang.checkout,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm + spacing.xxs / 2,
              ),
              side: BorderSide(color: theme.colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            onPressed: () =>
                context.read<CartBloc>().add(HoldOrderSubmittedEvent()),
            icon: Icon(
              Icons.pause_circle_outline,
              color: theme.colorScheme.onSurface,
              size: icons.md,
            ),
            label: Text(
              lang.holdOrder,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
