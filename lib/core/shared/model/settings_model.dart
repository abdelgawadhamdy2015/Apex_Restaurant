import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel {
  final PurchaseSettingsModel? purchase;
  final PosSettingsModel? pos;

  @JsonKey(name: 'pos_restaurant')
  final PosRestaurantSettingsModel? posRestaurant;

  final SalesSettingsModel? sales;
  final OtherSettingsModel? other;
  final FundsSettingsModel? funds;
  final BarcodeSettingsModel? barcode;
  final VatSettingModel? vat;
  final AccrediteSettingsModel? accredite;
  final CustomerDisplaySettingsModel? customerDisplay;

  const SettingsModel({
    this.purchase,
    this.pos,
    this.posRestaurant,
    this.sales,
    this.other,
    this.funds,
    this.barcode,
    this.vat,
    this.accredite,
    this.customerDisplay,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}

@JsonSerializable()
class PurchaseSettingsModel {
  @JsonKey(name: 'purchases_ModifyPrices')
  final bool? modifyPrices;

  @JsonKey(name: 'purchases_PayTotalNet')
  final bool? payTotalNet;

  @JsonKey(name: 'purchases_UseLastPrice')
  final bool? useLastPrice;

  @JsonKey(name: 'purchases_PriceIncludeVat')
  final bool? priceIncludeVat;

  @JsonKey(name: 'purchases_PrintWithSave')
  final bool? printWithSave;

  @JsonKey(name: 'purchases_ReturnWithoutQuantity')
  final bool? returnWithoutQuantity;

  @JsonKey(name: 'purchases_ActiveDiscount')
  final bool? activeDiscount;

  @JsonKey(name: 'purchase_UpdateItemsPricesAfterInvoice')
  final bool? updateItemsPricesAfterInvoice;

  const PurchaseSettingsModel({
    this.modifyPrices,
    this.payTotalNet,
    this.useLastPrice,
    this.priceIncludeVat,
    this.printWithSave,
    this.returnWithoutQuantity,
    this.activeDiscount,
    this.updateItemsPricesAfterInvoice,
  });

  factory PurchaseSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseSettingsModelToJson(this);
}

@JsonSerializable()
class PosSettingsModel {
  @JsonKey(name: 'pos_ModifyPrices')
  final bool? modifyPrices;

  @JsonKey(name: 'pos_ModifyStyle')
  final bool? modifyStyle;

  @JsonKey(name: 'pos_Style')
  final int? style;

  @JsonKey(name: 'pos_ActivateServices')
  final bool? activateServices;

  @JsonKey(name: 'pos_ModifyPricesType')
  final int? modifyPricesType;

  @JsonKey(name: 'pos_ExceedDiscountRatio')
  final bool? exceedDiscountRatio;

  @JsonKey(name: 'pos_UseLastPrice')
  final bool? useLastPrice;

  @JsonKey(name: 'pos_ActivePricesList')
  final bool? activePricesList;

  @JsonKey(name: 'pos_ExtractWithoutQuantity')
  final bool? extractWithoutQuantity;

  @JsonKey(name: 'pos_PriceIncludeVat')
  final bool? priceIncludeVat;

  @JsonKey(name: 'pos_ActiveDiscount')
  final bool? activeDiscount;

  @JsonKey(name: 'pos_DeferredSale')
  final bool? deferredSale;

  @JsonKey(name: 'pos_IndividualCoding')
  final bool? individualCoding;

  @JsonKey(name: 'pos_PreventEditingRecieptFlag')
  final bool? preventEditingRecieptFlag;

  @JsonKey(name: 'pos_PreventEditingRecieptValue')
  final int? preventEditingRecieptValue;

  @JsonKey(name: 'pos_ActiveCashierCustody')
  final bool? activeCashierCustody;

  @JsonKey(name: 'pos_PrintPreview')
  final bool? printPreview;

  @JsonKey(name: 'pos_PrintWithEnding')
  final bool? printWithEnding;

  @JsonKey(name: 'pos_EditingOnDate')
  final bool? editingOnDate;

  @JsonKey(name: 'posTochSettings')
  final dynamic posTochSettings;

  const PosSettingsModel({
    this.modifyPrices,
    this.modifyStyle,
    this.style,
    this.activateServices,
    this.modifyPricesType,
    this.exceedDiscountRatio,
    this.useLastPrice,
    this.activePricesList,
    this.extractWithoutQuantity,
    this.priceIncludeVat,
    this.activeDiscount,
    this.deferredSale,
    this.individualCoding,
    this.preventEditingRecieptFlag,
    this.preventEditingRecieptValue,
    this.activeCashierCustody,
    this.printPreview,
    this.printWithEnding,
    this.editingOnDate,
    this.posTochSettings,
  });

  factory PosSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PosSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosSettingsModelToJson(this);
}

@JsonSerializable()
class PosRestaurantSettingsModel {
  @JsonKey(name: 'pos_ModifyPrices')
  final bool? modifyPrices;

  @JsonKey(name: 'pos_ActivateServices')
  final bool? activateServices;

  @JsonKey(name: 'pos_ModifyPricesType')
  final int? modifyPricesType;

  @JsonKey(name: 'pos_ExceedDiscountRatio')
  final bool? exceedDiscountRatio;

  @JsonKey(name: 'pos_ExtractWithoutQuantity')
  final bool? extractWithoutQuantity;

  @JsonKey(name: 'pos_PriceIncludeVat')
  final bool? priceIncludeVat;

  @JsonKey(name: 'pos_ActiveDiscount')
  final bool? activeDiscount;

  @JsonKey(name: 'pos_EditingOnDate')
  final bool? editingOnDate;

  @JsonKey(name: 'pos_PreventEditingRecieptFlag')
  final bool? preventEditingRecieptFlag;

  @JsonKey(name: 'pos_PreventEditingRecieptValue')
  final int? preventEditingRecieptValue;

  @JsonKey(name: 'pos_PrintNoteWithChique')
  final bool? printNoteWithChique;

  @JsonKey(name: 'pos_StopEditingAfterKitchenPrinting')
  final bool? stopEditingAfterKitchenPrinting;

  @JsonKey(name: 'pos_PrintFullKitchenInvoice')
  final bool? printFullKitchenInvoice;

  @JsonKey(name: 'pos_PrintSplitedKitchenInvoice')
  final bool? printSplitedKitchenInvoice;

  @JsonKey(name: 'pos_PrintKitchenInvoiceForReturn')
  final bool? printKitchenInvoiceForReturn;

  @JsonKey(name: 'pos_PrintNotes')
  final bool? printNotes;

  @JsonKey(name: 'pos_ActiveCashierCustody')
  final bool? activeCashierCustody;

  @JsonKey(name: 'pos_AllowShifts')
  final bool? allowShifts;

  @JsonKey(name: 'pos_ResetOrderCodeWithNewShift')
  final bool? resetOrderCodeWithNewShift;

  @JsonKey(name: 'pos_SaveWithPay')
  final bool? saveWithPay;

  @JsonKey(name: 'pos_AutomaticallyExtractIngredients')
  final bool? automaticallyExtractIngredients;

  @JsonKey(name: 'pos_ViewOfferIngredientsInInvoice')
  final bool? viewOfferIngredientsInInvoice;

  @JsonKey(name: 'pos_ViewOfferIngredientsInInvoice_KichenPrinting')
  final bool? viewOfferIngredientsInInvoiceKichenPrinting;

  @JsonKey(name: 'pos_ViewOfferIngredientsInInvoice_ChiquePrinting')
  final bool? viewOfferIngredientsInInvoiceChiquePrinting;

  @JsonKey(name: 'pos_Takeaway_PrintWithSavingKitchen')
  final bool? takeawayPrintWithSavingKitchen;

  @JsonKey(name: 'pos_Takeaway_PrintWithSavingChique')
  final bool? takeawayPrintWithSavingChique;

  @JsonKey(name: 'pos_Takeaway_PrintPreviewChique')
  final bool? takeawayPrintPreviewChique;

  @JsonKey(name: 'pos_Takeaway_DeferredSale')
  final bool? takeawayDeferredSale;

  @JsonKey(name: 'pos_hall_PrintWithSavingKitchen')
  final bool? hallPrintWithSavingKitchen;

  @JsonKey(name: 'pos_hall_PrintWithSavingChique')
  final bool? hallPrintWithSavingChique;

  @JsonKey(name: 'pos_hall_PrintChiqueBeforeSaving')
  final bool? hallPrintChiqueBeforeSaving;

  @JsonKey(name: 'pos_hall_PreventCancelInvoiceAfterKitchenPrinting')
  final bool? hallPreventCancelInvoiceAfterKitchenPrinting;

  @JsonKey(name: 'pos_hall_PrintPreviewChique')
  final bool? hallPrintPreviewChique;

  @JsonKey(name: 'pos_hall_DeferredSale')
  final bool? hallDeferredSale;

  @JsonKey(name: 'pos_Delivery_PrintWithSavingKitchen')
  final bool? deliveryPrintWithSavingKitchen;

  @JsonKey(name: 'pos_Delivery_PrintWithSavingChique')
  final bool? deliveryPrintWithSavingChique;

  @JsonKey(name: 'pos_Delivery_PrintPreviewChique')
  final bool? deliveryPrintPreviewChique;

  @JsonKey(name: 'pos_Delivery_DeferredSale')
  final bool? deliveryDeferredSale;

  final double? deliveryCost;

  final bool? editDeliveryCost;

  const PosRestaurantSettingsModel({
    this.modifyPrices,
    this.activateServices,
    this.modifyPricesType,
    this.exceedDiscountRatio,
    this.extractWithoutQuantity,
    this.priceIncludeVat,
    this.activeDiscount,
    this.editingOnDate,
    this.preventEditingRecieptFlag,
    this.preventEditingRecieptValue,
    this.printNoteWithChique,
    this.stopEditingAfterKitchenPrinting,
    this.printFullKitchenInvoice,
    this.printSplitedKitchenInvoice,
    this.printKitchenInvoiceForReturn,
    this.printNotes,
    this.activeCashierCustody,
    this.allowShifts,
    this.resetOrderCodeWithNewShift,
    this.saveWithPay,
    this.automaticallyExtractIngredients,
    this.viewOfferIngredientsInInvoice,
    this.viewOfferIngredientsInInvoiceKichenPrinting,
    this.viewOfferIngredientsInInvoiceChiquePrinting,
    this.takeawayPrintWithSavingKitchen,
    this.takeawayPrintWithSavingChique,
    this.takeawayPrintPreviewChique,
    this.takeawayDeferredSale,
    this.hallPrintWithSavingKitchen,
    this.hallPrintWithSavingChique,
    this.hallPrintChiqueBeforeSaving,
    this.hallPreventCancelInvoiceAfterKitchenPrinting,
    this.hallPrintPreviewChique,
    this.hallDeferredSale,
    this.deliveryPrintWithSavingKitchen,
    this.deliveryPrintWithSavingChique,
    this.deliveryPrintPreviewChique,
    this.deliveryDeferredSale,
    this.deliveryCost,
    this.editDeliveryCost,
  });

  factory PosRestaurantSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PosRestaurantSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosRestaurantSettingsModelToJson(this);
}

@JsonSerializable()
class SalesSettingsModel {
  @JsonKey(name: 'sales_ModifyPrices')
  final bool? modifyPrices;

  @JsonKey(name: 'sales_ModifyPricesType')
  final int? modifyPricesType;

  @JsonKey(name: 'sales_ExceedDiscountRatio')
  final bool? exceedDiscountRatio;

  @JsonKey(name: 'sales_PayTotalNet')
  final bool? payTotalNet;

  @JsonKey(name: 'sales_UseLastPrice')
  final bool? useLastPrice;

  @JsonKey(name: 'sales_ExtractWithoutQuantity')
  final bool? extractWithoutQuantity;

  @JsonKey(name: 'sales_PriceIncludeVat')
  final bool? priceIncludeVat;

  @JsonKey(name: 'sales_PrintWithSave')
  final bool? printWithSave;

  @JsonKey(name: 'sales_ActiveDiscount')
  final bool? activeDiscount;

  @JsonKey(name: 'sales_LinkRepresentCustomer')
  final bool? linkRepresentCustomer;

  @JsonKey(name: 'sales_ActivePricesList')
  final bool? activePricesList;

  const SalesSettingsModel({
    this.modifyPrices,
    this.modifyPricesType,
    this.exceedDiscountRatio,
    this.payTotalNet,
    this.useLastPrice,
    this.extractWithoutQuantity,
    this.priceIncludeVat,
    this.printWithSave,
    this.activeDiscount,
    this.linkRepresentCustomer,
    this.activePricesList,
  });

  factory SalesSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SalesSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesSettingsModelToJson(this);
}

@JsonSerializable()
class OtherSettingsModel {
  @JsonKey(name: 'other_MergeItems')
  final bool? mergeItems;

  @JsonKey(name: 'otherMergeItemMethod')
  final String? mergeItemMethod;

  @JsonKey(name: 'other_ItemsAutoCoding')
  final bool? itemsAutoCoding;

  @JsonKey(name: 'other_ZeroPricesInItems')
  final bool? zeroPricesInItems;

  @JsonKey(name: 'other_PrintSerials')
  final bool? printSerials;

  @JsonKey(name: 'other_AutoExtractExpireDate')
  final bool? autoExtractExpireDate;

  @JsonKey(name: 'other_ViewStorePlace')
  final bool? viewStorePlace;

  @JsonKey(name: 'other_ConfirmeSupplierPhone')
  final bool? confirmeSupplierPhone;

  @JsonKey(name: 'other_ConfirmeCustomerPhone')
  final bool? confirmeCustomerPhone;

  @JsonKey(name: 'other_DemandLimitNotification')
  final bool? demandLimitNotification;

  @JsonKey(name: 'other_ExpireNotificationFlag')
  final bool? expireNotificationFlag;

  @JsonKey(name: 'other_ExpireNotificationValue')
  final int? expireNotificationValue;

  @JsonKey(name: 'other_Decimals')
  final int? decimals;

  @JsonKey(name: 'other_useRoundNumber')
  final bool? useRoundNumber;

  final int? autoLogoutInMints;

  @JsonKey(name: 'other_ShowBalanceOfPerson')
  final bool? showBalanceOfPerson;

  final bool? isCollectionReceipt;

  @JsonKey(name: 'other_ActivatePriceLists')
  final bool? activatePriceLists;

  final int? priceListType;

  final bool? isExpenses;

  @JsonKey(name: 'other_AlertMessageForCustomerSupplierBalance')
  final bool? alertMessageForCustomerSupplierBalance;

  @JsonKey(name: 'other_AutoExtractFromCustomerSupplierBalance')
  final bool? autoExtractFromCustomerSupplierBalance;

  @JsonKey(name: 'other_DoNothingForCustomerSupplierBalance')
  final bool? doNothingForCustomerSupplierBalance;

  final bool? addAttachment;

  @JsonKey(name: 'other_ShowPriceAndTotalInOutgoingAndIncommingTransfer')
  final bool? showPriceAndTotalInOutgoingAndIncommingTransfer;

  @JsonKey(name: 'other_PhoneNumberLengthForCustomerOrSupplier')
  final int? phoneNumberLengthForCustomerOrSupplier;

  @JsonKey(name: 'other_DocemntNumber')
  final bool? docemntNumber;

  @JsonKey(name: 'other_ReferenceTime')
  final bool? referenceTime;

  const OtherSettingsModel({
    this.mergeItems,
    this.mergeItemMethod,
    this.itemsAutoCoding,
    this.zeroPricesInItems,
    this.printSerials,
    this.autoExtractExpireDate,
    this.viewStorePlace,
    this.confirmeSupplierPhone,
    this.confirmeCustomerPhone,
    this.demandLimitNotification,
    this.expireNotificationFlag,
    this.expireNotificationValue,
    this.decimals,
    this.useRoundNumber,
    this.autoLogoutInMints,
    this.showBalanceOfPerson,
    this.isCollectionReceipt,
    this.activatePriceLists,
    this.priceListType,
    this.isExpenses,
    this.alertMessageForCustomerSupplierBalance,
    this.autoExtractFromCustomerSupplierBalance,
    this.doNothingForCustomerSupplierBalance,
    this.addAttachment,
    this.showPriceAndTotalInOutgoingAndIncommingTransfer,
    this.phoneNumberLengthForCustomerOrSupplier,
    this.docemntNumber,
    this.referenceTime,
  });

  factory OtherSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$OtherSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtherSettingsModelToJson(this);
}

@JsonSerializable()
class FundsSettingsModel {
  @JsonKey(name: 'funds_Items')
  final bool? items;

  @JsonKey(name: 'funds_Supplires')
  final bool? supplires;

  @JsonKey(name: 'funds_Customers')
  final bool? customers;

  @JsonKey(name: 'funds_Safes')
  final bool? safes;

  @JsonKey(name: 'funds_Banks')
  final bool? banks;

  const FundsSettingsModel({
    this.items,
    this.supplires,
    this.customers,
    this.safes,
    this.banks,
  });

  factory FundsSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$FundsSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FundsSettingsModelToJson(this);
}

@JsonSerializable()
class BarcodeSettingsModel {
  final String? barcodeType;

  @JsonKey(name: 'barcode_ItemCodestart')
  final bool? itemCodeStart;

  const BarcodeSettingsModel({this.barcodeType, this.itemCodeStart});

  factory BarcodeSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$BarcodeSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BarcodeSettingsModelToJson(this);
}

@JsonSerializable()
class VatSettingModel {
  @JsonKey(name: 'vat_Active')
  final bool? vatActive;

  @JsonKey(name: 'vat_DefaultValue')
  final double? vatDefaultValue;

  @JsonKey(name: 'toppacoTAX_Active')
  final bool? toppacoTaxActive;

  @JsonKey(name: 'toppacoTAX_DefaultValue')
  final double? toppacoTaxDefaultValue;

  const VatSettingModel({
    this.vatActive,
    this.vatDefaultValue,
    this.toppacoTaxActive,
    this.toppacoTaxDefaultValue,
  });

  factory VatSettingModel.fromJson(Map<String, dynamic> json) =>
      _$VatSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$VatSettingModelToJson(this);
}

@JsonSerializable()
class AccrediteSettingsModel {
  @JsonKey(name: 'accredite_StartPeriod')
  final DateTime? accrediteStartPeriod;

  @JsonKey(name: 'accredite_EndPeriod')
  final DateTime? accrediteEndPeriod;

  const AccrediteSettingsModel({
    this.accrediteStartPeriod,
    this.accrediteEndPeriod,
  });

  factory AccrediteSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AccrediteSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccrediteSettingsModelToJson(this);
}

@JsonSerializable()
class CustomerDisplaySettingsModel {
  @JsonKey(name: 'customerDisplay_Active')
  final bool? active;

  @JsonKey(name: 'customerDisplay_PortNumber')
  final String? portNumber;

  @JsonKey(name: 'customerDisplay_Code')
  final int? code;

  @JsonKey(name: 'customerDisplay_LinesNumber')
  final int? linesNumber;

  @JsonKey(name: 'customerDisplay_CharNumber')
  final int? charNumber;

  @JsonKey(name: 'customerDisplay_DefaultWord')
  final String? defaultWord;

  @JsonKey(name: 'customerDisplay_ScreenType')
  final int? screenType;

  const CustomerDisplaySettingsModel({
    this.active,
    this.portNumber,
    this.code,
    this.linesNumber,
    this.charNumber,
    this.defaultWord,
    this.screenType,
  });

  factory CustomerDisplaySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerDisplaySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDisplaySettingsModelToJson(this);
}
