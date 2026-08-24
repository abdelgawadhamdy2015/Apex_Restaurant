import 'package:json_annotation/json_annotation.dart';

part 'other_settings_model.g.dart';

@JsonSerializable()
class OtherSettingsModel {
  final int? id;

  final bool? posAddDiscount;
  final bool? posAllowCreditSales;
  final bool? posEditOtherPersonsInv;
  final bool? posShowOtherPersonsInv;
  final bool? posShowReportsOfOtherPersons;

  final bool? allowCloseCloudPOSSession;
  final bool? canShowAllPOSSessions;

  final bool? posCashPayment;
  final bool? posNetPayment;
  final bool? posOtherPayment;

  final bool? salesAddDiscount;
  final bool? salesAllowCreditSales;
  final bool? salesEditOtherPersonsInv;
  final bool? salesShowOtherPersonsInv;
  final bool? salesShowReportsOfOtherPersons;

  final bool? salesCashPayment;
  final bool? salesNetPayment;
  final bool? salesOtherPayment;

  final bool? salesShowBalanceOfPerson;
  final bool? salesShowAllPersonBalance;
  final bool? salesShowDebitorPersonBalance;
  final bool? salesShowCreditorPersonBaalance;

  final bool? salesPaymentFromInsideInvoice;

  final bool? purchasesAddDiscount;
  final bool? purchasesAllowCreditSales;
  final bool? purchasesEditOtherPersonsInv;
  final bool? purchasesShowOtherPersonsInv;
  final bool? purchasesShowReportsOfOtherPersons;

  final bool? purchaseShowBalanceOfPerson;
  final bool? purchasesCashPayment;
  final bool? purchasesNetPayment;
  final bool? purchasesOtherPayment;

  final bool? purchaseShowAllPersonBalance;
  final bool? purchaseShowDebitorPersonBalance;
  final bool? purchaseShowCreditorPersonBaalance;

  final bool? purchasesPaymentFromInsideInvoice;

  final bool? purchasesallowEdidJournalEntry;
  final bool? wovPurchasesallowEdidJournalEntry;

  final bool? showHistory;
  final bool? accredditForAllUsers;
  final bool? showCustomersOfOtherUsers;
  final bool? showOfferPricesOfOtherUser;
  final bool? showDashboardForAllUsers;
  final bool? allowPrintBarcode;
  final bool? collectionReceipts;
  final bool? addAttachment;
  final bool? showItemBalanceInStores;
  final bool? addItemNote;
  final bool? addDeleteNoteforItem;
  final bool? electonivInvoicesNotificationsPermission;
  final bool? transferBetweenFinancialYears;
  final bool? showAllBranchesInCustomerInfo;
  final bool? showAllBranchesInSuppliersInfo;
  final bool? showAllEmployees;
  final bool? allowLiveStreem;

  final int? userAccountId;
  final int? closingFinancialYearId;

  OtherSettingsModel({
    this.id,
    this.posAddDiscount,
    this.posAllowCreditSales,
    this.posEditOtherPersonsInv,
    this.posShowOtherPersonsInv,
    this.posShowReportsOfOtherPersons,
    this.allowCloseCloudPOSSession,
    this.canShowAllPOSSessions,
    this.posCashPayment,
    this.posNetPayment,
    this.posOtherPayment,
    this.salesAddDiscount,
    this.salesAllowCreditSales,
    this.salesEditOtherPersonsInv,
    this.salesShowOtherPersonsInv,
    this.salesShowReportsOfOtherPersons,
    this.salesCashPayment,
    this.salesNetPayment,
    this.salesOtherPayment,
    this.salesShowBalanceOfPerson,
    this.salesShowAllPersonBalance,
    this.salesShowDebitorPersonBalance,
    this.salesShowCreditorPersonBaalance,
    this.salesPaymentFromInsideInvoice,
    this.purchasesAddDiscount,
    this.purchasesAllowCreditSales,
    this.purchasesEditOtherPersonsInv,
    this.purchasesShowOtherPersonsInv,
    this.purchasesShowReportsOfOtherPersons,
    this.purchaseShowBalanceOfPerson,
    this.purchasesCashPayment,
    this.purchasesNetPayment,
    this.purchasesOtherPayment,
    this.purchaseShowAllPersonBalance,
    this.purchaseShowDebitorPersonBalance,
    this.purchaseShowCreditorPersonBaalance,
    this.purchasesPaymentFromInsideInvoice,
    this.purchasesallowEdidJournalEntry,
    this.wovPurchasesallowEdidJournalEntry,
    this.showHistory,
    this.accredditForAllUsers,
    this.showCustomersOfOtherUsers,
    this.showOfferPricesOfOtherUser,
    this.showDashboardForAllUsers,
    this.allowPrintBarcode,
    this.collectionReceipts,
    this.addAttachment,
    this.showItemBalanceInStores,
    this.addItemNote,
    this.addDeleteNoteforItem,
    this.electonivInvoicesNotificationsPermission,
    this.transferBetweenFinancialYears,
    this.showAllBranchesInCustomerInfo,
    this.showAllBranchesInSuppliersInfo,
    this.showAllEmployees,
    this.allowLiveStreem,
    this.userAccountId,
    this.closingFinancialYearId,
  });

  factory OtherSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$OtherSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtherSettingsModelToJson(this);
}
