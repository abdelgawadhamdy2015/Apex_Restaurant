// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherSettingsModel _$OtherSettingsModelFromJson(
  Map<String, dynamic> json,
) => OtherSettingsModel(
  id: (json['id'] as num?)?.toInt(),
  posAddDiscount: json['posAddDiscount'] as bool?,
  posAllowCreditSales: json['posAllowCreditSales'] as bool?,
  posEditOtherPersonsInv: json['posEditOtherPersonsInv'] as bool?,
  posShowOtherPersonsInv: json['posShowOtherPersonsInv'] as bool?,
  posShowReportsOfOtherPersons: json['posShowReportsOfOtherPersons'] as bool?,
  allowCloseCloudPOSSession: json['allowCloseCloudPOSSession'] as bool?,
  canShowAllPOSSessions: json['canShowAllPOSSessions'] as bool?,
  posCashPayment: json['posCashPayment'] as bool?,
  posNetPayment: json['posNetPayment'] as bool?,
  posOtherPayment: json['posOtherPayment'] as bool?,
  salesAddDiscount: json['salesAddDiscount'] as bool?,
  salesAllowCreditSales: json['salesAllowCreditSales'] as bool?,
  salesEditOtherPersonsInv: json['salesEditOtherPersonsInv'] as bool?,
  salesShowOtherPersonsInv: json['salesShowOtherPersonsInv'] as bool?,
  salesShowReportsOfOtherPersons:
      json['salesShowReportsOfOtherPersons'] as bool?,
  salesCashPayment: json['salesCashPayment'] as bool?,
  salesNetPayment: json['salesNetPayment'] as bool?,
  salesOtherPayment: json['salesOtherPayment'] as bool?,
  salesShowBalanceOfPerson: json['salesShowBalanceOfPerson'] as bool?,
  salesShowAllPersonBalance: json['salesShowAllPersonBalance'] as bool?,
  salesShowDebitorPersonBalance: json['salesShowDebitorPersonBalance'] as bool?,
  salesShowCreditorPersonBaalance:
      json['salesShowCreditorPersonBaalance'] as bool?,
  salesPaymentFromInsideInvoice: json['salesPaymentFromInsideInvoice'] as bool?,
  purchasesAddDiscount: json['purchasesAddDiscount'] as bool?,
  purchasesAllowCreditSales: json['purchasesAllowCreditSales'] as bool?,
  purchasesEditOtherPersonsInv: json['purchasesEditOtherPersonsInv'] as bool?,
  purchasesShowOtherPersonsInv: json['purchasesShowOtherPersonsInv'] as bool?,
  purchasesShowReportsOfOtherPersons:
      json['purchasesShowReportsOfOtherPersons'] as bool?,
  purchaseShowBalanceOfPerson: json['purchaseShowBalanceOfPerson'] as bool?,
  purchasesCashPayment: json['purchasesCashPayment'] as bool?,
  purchasesNetPayment: json['purchasesNetPayment'] as bool?,
  purchasesOtherPayment: json['purchasesOtherPayment'] as bool?,
  purchaseShowAllPersonBalance: json['purchaseShowAllPersonBalance'] as bool?,
  purchaseShowDebitorPersonBalance:
      json['purchaseShowDebitorPersonBalance'] as bool?,
  purchaseShowCreditorPersonBaalance:
      json['purchaseShowCreditorPersonBaalance'] as bool?,
  purchasesPaymentFromInsideInvoice:
      json['purchasesPaymentFromInsideInvoice'] as bool?,
  purchasesallowEdidJournalEntry:
      json['purchasesallowEdidJournalEntry'] as bool?,
  wovPurchasesallowEdidJournalEntry:
      json['wovPurchasesallowEdidJournalEntry'] as bool?,
  showHistory: json['showHistory'] as bool?,
  accredditForAllUsers: json['accredditForAllUsers'] as bool?,
  showCustomersOfOtherUsers: json['showCustomersOfOtherUsers'] as bool?,
  showOfferPricesOfOtherUser: json['showOfferPricesOfOtherUser'] as bool?,
  showDashboardForAllUsers: json['showDashboardForAllUsers'] as bool?,
  allowPrintBarcode: json['allowPrintBarcode'] as bool?,
  collectionReceipts: json['collectionReceipts'] as bool?,
  addAttachment: json['addAttachment'] as bool?,
  showItemBalanceInStores: json['showItemBalanceInStores'] as bool?,
  addItemNote: json['addItemNote'] as bool?,
  addDeleteNoteforItem: json['addDeleteNoteforItem'] as bool?,
  electonivInvoicesNotificationsPermission:
      json['electonivInvoicesNotificationsPermission'] as bool?,
  transferBetweenFinancialYears: json['transferBetweenFinancialYears'] as bool?,
  showAllBranchesInCustomerInfo: json['showAllBranchesInCustomerInfo'] as bool?,
  showAllBranchesInSuppliersInfo:
      json['showAllBranchesInSuppliersInfo'] as bool?,
  showAllEmployees: json['showAllEmployees'] as bool?,
  allowLiveStreem: json['allowLiveStreem'] as bool?,
  userAccountId: (json['userAccountId'] as num?)?.toInt(),
  closingFinancialYearId: (json['closingFinancialYearId'] as num?)?.toInt(),
);

Map<String, dynamic> _$OtherSettingsModelToJson(
  OtherSettingsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'posAddDiscount': instance.posAddDiscount,
  'posAllowCreditSales': instance.posAllowCreditSales,
  'posEditOtherPersonsInv': instance.posEditOtherPersonsInv,
  'posShowOtherPersonsInv': instance.posShowOtherPersonsInv,
  'posShowReportsOfOtherPersons': instance.posShowReportsOfOtherPersons,
  'allowCloseCloudPOSSession': instance.allowCloseCloudPOSSession,
  'canShowAllPOSSessions': instance.canShowAllPOSSessions,
  'posCashPayment': instance.posCashPayment,
  'posNetPayment': instance.posNetPayment,
  'posOtherPayment': instance.posOtherPayment,
  'salesAddDiscount': instance.salesAddDiscount,
  'salesAllowCreditSales': instance.salesAllowCreditSales,
  'salesEditOtherPersonsInv': instance.salesEditOtherPersonsInv,
  'salesShowOtherPersonsInv': instance.salesShowOtherPersonsInv,
  'salesShowReportsOfOtherPersons': instance.salesShowReportsOfOtherPersons,
  'salesCashPayment': instance.salesCashPayment,
  'salesNetPayment': instance.salesNetPayment,
  'salesOtherPayment': instance.salesOtherPayment,
  'salesShowBalanceOfPerson': instance.salesShowBalanceOfPerson,
  'salesShowAllPersonBalance': instance.salesShowAllPersonBalance,
  'salesShowDebitorPersonBalance': instance.salesShowDebitorPersonBalance,
  'salesShowCreditorPersonBaalance': instance.salesShowCreditorPersonBaalance,
  'salesPaymentFromInsideInvoice': instance.salesPaymentFromInsideInvoice,
  'purchasesAddDiscount': instance.purchasesAddDiscount,
  'purchasesAllowCreditSales': instance.purchasesAllowCreditSales,
  'purchasesEditOtherPersonsInv': instance.purchasesEditOtherPersonsInv,
  'purchasesShowOtherPersonsInv': instance.purchasesShowOtherPersonsInv,
  'purchasesShowReportsOfOtherPersons':
      instance.purchasesShowReportsOfOtherPersons,
  'purchaseShowBalanceOfPerson': instance.purchaseShowBalanceOfPerson,
  'purchasesCashPayment': instance.purchasesCashPayment,
  'purchasesNetPayment': instance.purchasesNetPayment,
  'purchasesOtherPayment': instance.purchasesOtherPayment,
  'purchaseShowAllPersonBalance': instance.purchaseShowAllPersonBalance,
  'purchaseShowDebitorPersonBalance': instance.purchaseShowDebitorPersonBalance,
  'purchaseShowCreditorPersonBaalance':
      instance.purchaseShowCreditorPersonBaalance,
  'purchasesPaymentFromInsideInvoice':
      instance.purchasesPaymentFromInsideInvoice,
  'purchasesallowEdidJournalEntry': instance.purchasesallowEdidJournalEntry,
  'wovPurchasesallowEdidJournalEntry':
      instance.wovPurchasesallowEdidJournalEntry,
  'showHistory': instance.showHistory,
  'accredditForAllUsers': instance.accredditForAllUsers,
  'showCustomersOfOtherUsers': instance.showCustomersOfOtherUsers,
  'showOfferPricesOfOtherUser': instance.showOfferPricesOfOtherUser,
  'showDashboardForAllUsers': instance.showDashboardForAllUsers,
  'allowPrintBarcode': instance.allowPrintBarcode,
  'collectionReceipts': instance.collectionReceipts,
  'addAttachment': instance.addAttachment,
  'showItemBalanceInStores': instance.showItemBalanceInStores,
  'addItemNote': instance.addItemNote,
  'addDeleteNoteforItem': instance.addDeleteNoteforItem,
  'electonivInvoicesNotificationsPermission':
      instance.electonivInvoicesNotificationsPermission,
  'transferBetweenFinancialYears': instance.transferBetweenFinancialYears,
  'showAllBranchesInCustomerInfo': instance.showAllBranchesInCustomerInfo,
  'showAllBranchesInSuppliersInfo': instance.showAllBranchesInSuppliersInfo,
  'showAllEmployees': instance.showAllEmployees,
  'allowLiveStreem': instance.allowLiveStreem,
  'userAccountId': instance.userAccountId,
  'closingFinancialYearId': instance.closingFinancialYearId,
};
