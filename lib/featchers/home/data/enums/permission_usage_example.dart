// // ============================================================
// // مثال على الاستخدام في أي شاشة
// // ============================================================

// // 1️⃣  بعد الـ login، اعمل PermissionChecker من الـ list اللي جت من الـ API
// //
// //   final checker = PermissionChecker(loginResponse.permissions);
// //
// // أو خزّنه في GetX / Provider / Riverpod وخليه Singleton

// // ─── مثال داخل Widget ───────────────────────────────────────

// import 'package:apex_restaurant/core/helpers/permission_checker.dart';
// import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
// import 'package:flutter/material.dart';

// class SalesInvoiceScreen extends StatelessWidget {
//   final PermissionChecker checker; // injected

//   const SalesInvoiceScreen({super.key, required this.checker});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ بدل:  if (permission.id == 40)
//     // ✅ اكتب:
//     if (!checker.canShow(AppPermission.salesInvoice)) {
//       return const Center(child: Text('ليس لديك صلاحية'));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('فواتير المبيعات')),
//       floatingActionButton: checker.canAdd(AppPermission.salesInvoice)
//           ? FloatingActionButton(
//               onPressed: () => _addInvoice(),
//               child: const Icon(Icons.add),
//             )
//           : null, // مش هيظهر زرار الإضافة لو مافيش صلاحية
//       body: Column(
//         children: [
//           // زرار التعديل
//           if (checker.canEdit(AppPermission.salesInvoice))
//             ElevatedButton(
//               onPressed: () => _editInvoice(),
//               child: const Text('تعديل'),
//             ),

//           // زرار الحذف
//           if (checker.canDelete(AppPermission.salesInvoice))
//             ElevatedButton(
//               onPressed: () => _deleteInvoice(),
//               child: const Text('حذف'),
//             ),

//           // زرار الطباعة
//           if (checker.canPrint(AppPermission.salesInvoice))
//             ElevatedButton(
//               onPressed: () => _printInvoice(),
//               child: const Text('طباعة'),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // ─── مثال في NavigationMenu ─────────────────────────────────
// /*
// // تحديد إيه الشاشات اللي تظهر في القائمة
// final visibleScreens = [
//   if (checker.hasAnyAccess(AppPermission.salesInvoice))
//     NavItem(label: 'فواتير المبيعات', route: '/sales-invoice'),

//   if (checker.hasAnyAccess(AppPermission.purchaseInvoice))
//     NavItem(label: 'فواتير المشتريات', route: '/purchase-invoice'),

//   if (checker.hasAnyAccess(AppPermission.users))
//     NavItem(label: 'المستخدمين', route: '/users'),
// ];
// */

// // ─── استخدام fromId لو احتجت تحول ID لـ enum ────────────────
// /*
//   final permission = AppPermission.fromId(40); // → AppPermission.salesInvoice
//   if (permission != null) {
//     print(checker.canAdd(permission));
//   }
// */
