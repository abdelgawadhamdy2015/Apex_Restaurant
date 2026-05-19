enum AppPermission {
  // ─── أرصدة أول المدة (Funds) ─────────────────────────────
  itemsFund(1), // أرصدة أول المدة - أصناف
  safesFund(2), // أرصدة أول المدة - خزائن
  banksFund(3), // أرصدة أول المدة - بنوك
  suppliersFund(4), // أرصدة أول المدة - موردين
  customersFund(5), // أرصدة أول المدة - عملاء

  // ─── البيانات الأساسية (MainData) ────────────────────────
  branchesMainData(6), // الفروع
  currenciesMainData(7), // العملات
  safesMainData(8), // الخزائن
  banksMainData(9), // البنوك
  otherAuthoritiesMainData(10), // جهات صرف أخرى

  // ─── الأستاذ العام (GL) ──────────────────────────────────
  calculationGuideGL(11), // شجرة الحسابات
  openingBalanceGL(12), // الأرصدة الافتتاحية
  accountingEntriesGL(13), // القيود
  costCenterGL(14), // مراكز التكلفة

  payReceiptForSafe(15), // سند صرف خزينة
  payReceiptForBank(16), // سند صرف بنك
  cashReceiptForSafe(17), // سند قبض خزائن
  cashReceiptForBank(18), // سند قبض بنك

  incomeListGL(19), // قائمة الدخل - تقارير
  detailedTrialBalanceGL(20), // ميزان المراجعة التفصيلي - تقارير
  publicBudgetGL(21), // الميزانية العمومية - تقارير
  ledgerReportGL(22), // دفتر الأستاذ - تقارير
  costCenterReportGL(23), // مراكز التكلفة - تقارير
  accountStatementDetailGL(24), // كشف حساب تفصيلي - تقارير
  generalLedgerSettingsGL(25), // الإعدادات العامة

  // ─── الوحدات الأساسية (MainUnits) ───────────────────────
  unitsMainUnits(26), // الوحدات
  sizesMainUnits(27), // الأحجام
  colorMainUnits(28), // الألوان
  categoriesMainUnits(29), // مجموعات الأصناف
  itemCardMainUnits(30), // كارت الصنف
  employeesMainUnits(31), // الموظفين
  jobsMainUnits(32), // الوظائف
  storesMainUnits(33), // المستودعات
  storePlacesMainUnits(34), // أماكن التخزين

  // ─── المستودعات (Repository) ──────────────────────────────
  addPermissionRepository(35), // إذن إضافة
  barcodeRepository(36), // الباركود
  detailedMovementOfAnItemRepository(37), // الحركة التفصيلية لصنف - تقارير
  itemBalanceInStoreRepository(38), // رصيد صنف في المخازن - تقارير
  totalItemBalancesInStoreRepository(39), // أرصدة أصناف في المخازن - تقارير
  inventoryValuationRepository(40), // تقييم المخزون - تقارير
  detailedTransactionsOfItemRepository(41), // تقارير
  getItemBalanceInStoresRepository(42), // تقارير
  getTotalTransactionsOfItemsRepository(
    43,
  ), // إجمالي حركة صنف في المخازن - تقارير

  // ─── المشتريات (Purchases) ────────────────────────────────
  suppliersPurchases(44), // الموردين
  purchases(45), // المشتريات
  purchasesReturnPurchases(46), // مرتجع المشتريات
  purchasesClosingPurchases(47), // إقفال المشتريات
  purchasesTransactionPurchases(48), // حركة المشتريات
  supplierStatementPurchases(49), // كشف حساب مورد - تقارير
  getVatStatementDataPurchases(50), // كشف حساب القيمة المضافة - تقارير
  getSuppliersAccountDataPurchases(51), // بيانات الموردين - تقارير
  supplierItemsPurchasedPurchases(53), // مشتريات صنف من مورد - تقارير
  itemPurchasesPurchases(54), // مشتريات صنف - تقارير
  itemsPurchasesPurchases(55), // مشتريات أصناف

  // ─── المبيعات (Sales) ─────────────────────────────────────
  customersSales(56), // العملاء
  commissionListSales(57), // لائحة العمولات
  salesmenSales(58), // مناديب البيع
  sales(59), // المبيعات
  salesClosingSales(60), // إقفال المبيعات
  customerStatementSales(61), // كشف حساب عميل - تقرير
  salesReturnSales(62), // مرتجع المبيعات

  // ─── التسويات (Settlements) ──────────────────────────────
  earnedDiscountSettlements(63), // خصم مكتسب
  permittedDiscountSettlements(64), // خصم مسموح به

  // ─── المستخدمين (Users) ───────────────────────────────────
  permissionUsers(65), // الصلاحيات
  users(66), // المستخدمين

  // ─── الإعدادات (Settings) ────────────────────────────────
  generalSettingsSettings(67), // الإعدادات العامة
  storeSettingsSettings(68), // إعدادات المخازن
  companyInformationSettings(69), // بيانات الشركة

  // ─── نقاط البيع / تقارير ─────────────────────────────────
  payPermission(70), // إذن صرف
  posClosingSales(71), // نقاط البيع - إقفال
  pos(72), // نقاط البيع
  returnPOS(73), // مرتجع نقاط البيع
  itemSales(74), // مبيعات أصناف
  salesOfCasher(76), // مبيعات الكاشير
  salesOfCasherNotAccredit(77), // مبيعات الكاشير غير معتمدة
  salesOfAnItem(78), // مبيعات صنف
  supplierData(79), // بيانات الموردين
  vatDetailedStatement(80), // كشف حساب الضريبة التفصيلي
  itemsTransaction(81), // الحركة التفصيلية لصنف
  salesTransaction(82), // حركة المبيعات
  safeAccountStatement(83), // كشف حساب خزنة
  bankAccountStatement(84), // كشف حساب بنك
  safeReceipts(85), // مقبوضات خزينة
  bankReceipts(86), // مقبوضات بنك
  safeExpenses(87), // مصروفات خزنة
  bankExpenses(88), // مصروفات بنك
  customersData(89), // بيانات العملاء
  customersBalances(90), // أرصدة العملاء
  itemSalesForCustomer(91), // مبيعات صنف لعميل
  itemsSalesForCustomer(92), // مبيعات أصناف لعميل
  itemSalesForCustomers(93), // مبيعات صنف لعملاء
  itemNotSold(94), // أصناف لم تبع
  salesAndReturnSalesTransaction(95), // حركة المبيعات والمرتجعات
  detailsOfSerialTransactions(96), // الحركة التفصيلية لسيريال
  demandLimit(97), // حد الطلب
  totalSalesOfBranch(98), // إجمالي مبيعات الفرع
  itemsSoldMost(99), // الأصناف الأكثر مبيعاً
  itemsPrices(100), // أسعار الأصناف
  getDetailsOfExpiredItems(101), // انتهاء الصلاحية
  paymentsAndDisbursements(102), // جهات قبض وصرف
  totalBranchTransaction(103), // إجمالي حركات الفرع
  incomingTransfer(104), // تحويل وارد
  outgoingTransfer(105), // تحويل صادر
  reviewWarehouseTransfersReport(106), // مراجعة تحويلات المخازن
  detailedTransferReport(107), // تقرير تحويلات تفصيلي
  paymentMethods(108), // طرق الدفع
  purchasesTransactionOfBranch(109), // حركة المشتريات
  offerPriceSales(110), // عرض السعر
  supplierItemsPurchasesPurchases(111), // مشتريات أصناف من مورد - تقارير
  salesBranchProfit(112), // ربحية مبيعات الفرع
  getCompanySubscriptionInformation(113), // بيانات الاشتراك
  posSession(115), // جلسات نقاط البيع
  totalAccountBalance(116), // إجمالي رصيد الحساب
  balanceReviewFunds(117), // ميزان المراجعة أرصدة
  costCenterForAccount(118), // مراكز التكلفة لحساب
  salesOfSalesMan(119), // مبيعات مندوب المبيعات
  salesProfitOfItems(120), // ربحية مبيعات الأصناف
  additions(121), // إضافات لفواتير الشراء
  purchasesWithoutVat(122), // مشتريات بدون ضريبة
  returnPurchasesWithoutVat(123), // مرتجع مشتريات بدون ضريبة
  getTotalVatData(124), // إجمالي الضريبة
  debtAgingForCustomers(125), // أعمار الديون لفواتير العملاء
  debtAgingForSupplier(126), // أعمار الديون لفواتير الموردين
  printers(127), // شاشة الطابعات
  kitchens(128), // شاشة المطابخ
  collectionReceipts(129), // سند تحصيل
  userActions(130), // حركات المستخدمين
  offerPriceReport(131), // تقرير عروض الأسعار

  // ─── الموارد البشرية (HR) ─────────────────────────────────
  nationality(132), // الجنسيات
  missions(133), // المهام
  projects(134), // المشاريع
  employeeGroups(135), // مجموعات الموظفين
  shifts(136), // الدوامات
  holidays(137), // العطلات الرسمية
  vacation(138), // الإجازات
  detailedAttendance(139), // تقرير الحضور التفصيلي

  // ─── التحويلات البنكية ────────────────────────────────────
  transferFromBanks(140), // تحويل من البنوك
  transferFromSafes(141), // تحويل من الخزائن
  detailedInvoices(142), // تقرير تفصيلي الفواتير
  safeMultiCollectionReceipt(143), // سند مجمع خزائن
  bankMultiCollectionReceipt(144), // سند مجمع بنوك
  storeInventory(145), // جرد المخزن
  quantitySettlement(146), // تسوية الكميات
  debitNotesSales(147), // مذكرة مديونية مبيعات
  closingFinancialYear(148), // إقفال السنة المالية
  itemSalesTransaction(149), // حركة مبيعات الأصناف
  totalSalesOfSalesmen(150), // إجمالي مبيعات المناديب
  importItems(151), // استيراد الأصناف

  // ─── تقارير HR ───────────────────────────────────────────
  employeeReport(600), // تقرير الموظفين
  absenceReport(601), // تقرير الغياب
  totalAbsenceReport(602), // تقرير الغياب الإجمالي
  attendancePermissions(603), // أذونات الحضور
  attendanceMachines(604), // أجهزة الحضور
  dayStatusReport(605), // تقرير حالة اليوم
  vacationEmployees(606), // العطلات الشخصية
  machineTransaction(607), // حركات أجهزة الحضور والانصراف
  totalAttendance(608), // إجمالي الحضور
  nonRegisteredEmployees(609), // الموظفون غير المسجلون
  vacationsReport(610), // تقرير الإجازات
  ramadanDates(616), // مواعيد رمضان
  getTotalLateReport(617), // تقرير التأخير الإجمالي
  getDetailedLateReport(618), // تقرير التأخير التفصيلي
  getAttendLateLeaveEarlyReport(619), // تقرير الحضور المتأخر والانصراف المبكر
  religion(620), // الأديان
  attendLeavingSettings(621), // إعدادات الحضور والانصراف
  transactionCancellation(622), // إلغاء المعاملات
  attendancePermissionsReport(650), // تقرير أذونات الموظفين
  attendanceLeavingByBranchesReport(641), // تقرير الحضور بالفروع

  // ─── المواقع والطلبات ────────────────────────────────────
  location(700), // المواقع
  locationGroup(701), // مجموعات المواقع
  ordersSettings(703), // إعدادات الطلبات
  orders(712), // الطلبات
  vacationsOrders(715), // طلبات الإجازات
  attendancePermissionsOrders(716), // طلبات أذونات الحضور
  incompletedTransactions(717), // المعاملات غير المكتملة
  detailedServiceIntroduction(718), // تقديم الخدمة التفصيلي
  totalServiceIntroduction(719), // تقديم الخدمة الإجمالي

  // ─── HR إضافي ─────────────────────────────────────────────
  rejectedMachineTransactionsWithoutReasons(
    693,
  ), // معاملات الأجهزة المرفوضة بدون أسباب
  rejectedMachineTransactionsWithReasons(
    694,
  ), // معاملات الأجهزة المرفوضة بأسباب
  detailedExtraTime(695), // الوقت الإضافي التفصيلي
  purchaseOrder(720), // أمر شراء
  transactionPermissionsOrders(721), // طلبات أذونات المعاملات

  // ─── المطاعم (Restaurants) ────────────────────────────────
  tableTypes(722), // أنواع الطاولات
  foodAdditives(723), // الإضافات
  itemCardMaterials(724), // كارت الخامات
  floors(725), // الطوابق
  foodTable(726), // طاولات الطعام
  itemCardRestaurant(727), // كارت مطاعم / شركة التوصيل

  // ─── الإعدادات ────────────────────────────────────────────
  electronicInvoiceSettings(900); // إعدادات الفاتورة الإلكترونية

  // ────────────────────────────────────────────────────────────
  const AppPermission(this.id);

  /// الـ ID الفعلي اللي بييجي من الـ backend
  final int id;

  /// ابحث عن الـ enum بالـ id — بيرجع null لو مش موجود
  static AppPermission? fromId(int id) {
    for (final p in AppPermission.values) {
      if (p.id == id) return p;
    }
    return null;
  }
}
