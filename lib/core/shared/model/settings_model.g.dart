// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      purchase: json['purchase'] == null
          ? null
          : PurchaseSettingsModel.fromJson(
              json['purchase'] as Map<String, dynamic>,
            ),
      pos: json['pos'] == null
          ? null
          : PosSettingsModel.fromJson(json['pos'] as Map<String, dynamic>),
      posRestaurant: json['pos_restaurant'] == null
          ? null
          : PosRestaurantSettingsModel.fromJson(
              json['pos_restaurant'] as Map<String, dynamic>,
            ),
      sales: json['sales'] == null
          ? null
          : SalesSettingsModel.fromJson(json['sales'] as Map<String, dynamic>),
      other: json['other'] == null
          ? null
          : OtherSettingsModel.fromJson(json['other'] as Map<String, dynamic>),
      funds: json['funds'] == null
          ? null
          : FundsSettingsModel.fromJson(json['funds'] as Map<String, dynamic>),
      barcode: json['barcode'] == null
          ? null
          : BarcodeSettingsModel.fromJson(
              json['barcode'] as Map<String, dynamic>,
            ),
      vat: json['vat'] == null
          ? null
          : VatSettingModel.fromJson(json['vat'] as Map<String, dynamic>),
      accredite: json['accredite'] == null
          ? null
          : AccrediteSettingsModel.fromJson(
              json['accredite'] as Map<String, dynamic>,
            ),
      customerDisplay: json['customerDisplay'] == null
          ? null
          : CustomerDisplaySettingsModel.fromJson(
              json['customerDisplay'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'purchase': instance.purchase,
      'pos': instance.pos,
      'pos_restaurant': instance.posRestaurant,
      'sales': instance.sales,
      'other': instance.other,
      'funds': instance.funds,
      'barcode': instance.barcode,
      'vat': instance.vat,
      'accredite': instance.accredite,
      'customerDisplay': instance.customerDisplay,
    };

PurchaseSettingsModel _$PurchaseSettingsModelFromJson(
  Map<String, dynamic> json,
) => PurchaseSettingsModel(
  modifyPrices: json['purchases_ModifyPrices'] as bool?,
  payTotalNet: json['purchases_PayTotalNet'] as bool?,
  useLastPrice: json['purchases_UseLastPrice'] as bool?,
  priceIncludeVat: json['purchases_PriceIncludeVat'] as bool?,
  printWithSave: json['purchases_PrintWithSave'] as bool?,
  returnWithoutQuantity: json['purchases_ReturnWithoutQuantity'] as bool?,
  activeDiscount: json['purchases_ActiveDiscount'] as bool?,
  updateItemsPricesAfterInvoice:
      json['purchase_UpdateItemsPricesAfterInvoice'] as bool?,
);

Map<String, dynamic> _$PurchaseSettingsModelToJson(
  PurchaseSettingsModel instance,
) => <String, dynamic>{
  'purchases_ModifyPrices': instance.modifyPrices,
  'purchases_PayTotalNet': instance.payTotalNet,
  'purchases_UseLastPrice': instance.useLastPrice,
  'purchases_PriceIncludeVat': instance.priceIncludeVat,
  'purchases_PrintWithSave': instance.printWithSave,
  'purchases_ReturnWithoutQuantity': instance.returnWithoutQuantity,
  'purchases_ActiveDiscount': instance.activeDiscount,
  'purchase_UpdateItemsPricesAfterInvoice':
      instance.updateItemsPricesAfterInvoice,
};

PosSettingsModel _$PosSettingsModelFromJson(Map<String, dynamic> json) =>
    PosSettingsModel(
      modifyPrices: json['pos_ModifyPrices'] as bool?,
      modifyStyle: json['pos_ModifyStyle'] as bool?,
      style: (json['pos_Style'] as num?)?.toInt(),
      activateServices: json['pos_ActivateServices'] as bool?,
      modifyPricesType: (json['pos_ModifyPricesType'] as num?)?.toInt(),
      exceedDiscountRatio: json['pos_ExceedDiscountRatio'] as bool?,
      useLastPrice: json['pos_UseLastPrice'] as bool?,
      activePricesList: json['pos_ActivePricesList'] as bool?,
      extractWithoutQuantity: json['pos_ExtractWithoutQuantity'] as bool?,
      priceIncludeVat: json['pos_PriceIncludeVat'] as bool?,
      activeDiscount: json['pos_ActiveDiscount'] as bool?,
      deferredSale: json['pos_DeferredSale'] as bool?,
      individualCoding: json['pos_IndividualCoding'] as bool?,
      preventEditingRecieptFlag: json['pos_PreventEditingRecieptFlag'] as bool?,
      preventEditingRecieptValue:
          (json['pos_PreventEditingRecieptValue'] as num?)?.toInt(),
      activeCashierCustody: json['pos_ActiveCashierCustody'] as bool?,
      printPreview: json['pos_PrintPreview'] as bool?,
      printWithEnding: json['pos_PrintWithEnding'] as bool?,
      editingOnDate: json['pos_EditingOnDate'] as bool?,
      posTochSettings: json['posTochSettings'],
    );

Map<String, dynamic> _$PosSettingsModelToJson(PosSettingsModel instance) =>
    <String, dynamic>{
      'pos_ModifyPrices': instance.modifyPrices,
      'pos_ModifyStyle': instance.modifyStyle,
      'pos_Style': instance.style,
      'pos_ActivateServices': instance.activateServices,
      'pos_ModifyPricesType': instance.modifyPricesType,
      'pos_ExceedDiscountRatio': instance.exceedDiscountRatio,
      'pos_UseLastPrice': instance.useLastPrice,
      'pos_ActivePricesList': instance.activePricesList,
      'pos_ExtractWithoutQuantity': instance.extractWithoutQuantity,
      'pos_PriceIncludeVat': instance.priceIncludeVat,
      'pos_ActiveDiscount': instance.activeDiscount,
      'pos_DeferredSale': instance.deferredSale,
      'pos_IndividualCoding': instance.individualCoding,
      'pos_PreventEditingRecieptFlag': instance.preventEditingRecieptFlag,
      'pos_PreventEditingRecieptValue': instance.preventEditingRecieptValue,
      'pos_ActiveCashierCustody': instance.activeCashierCustody,
      'pos_PrintPreview': instance.printPreview,
      'pos_PrintWithEnding': instance.printWithEnding,
      'pos_EditingOnDate': instance.editingOnDate,
      'posTochSettings': instance.posTochSettings,
    };

PosRestaurantSettingsModel _$PosRestaurantSettingsModelFromJson(
  Map<String, dynamic> json,
) => PosRestaurantSettingsModel(
  modifyPrices: json['pos_ModifyPrices'] as bool?,
  activateServices: json['pos_ActivateServices'] as bool?,
  modifyPricesType: (json['pos_ModifyPricesType'] as num?)?.toInt(),
  exceedDiscountRatio: json['pos_ExceedDiscountRatio'] as bool?,
  extractWithoutQuantity: json['pos_ExtractWithoutQuantity'] as bool?,
  priceIncludeVat: json['pos_PriceIncludeVat'] as bool?,
  activeDiscount: json['pos_ActiveDiscount'] as bool?,
  editingOnDate: json['pos_EditingOnDate'] as bool?,
  preventEditingRecieptFlag: json['pos_PreventEditingRecieptFlag'] as bool?,
  preventEditingRecieptValue: (json['pos_PreventEditingRecieptValue'] as num?)
      ?.toInt(),
  printNoteWithChique: json['pos_PrintNoteWithChique'] as bool?,
  stopEditingAfterKitchenPrinting:
      json['pos_StopEditingAfterKitchenPrinting'] as bool?,
  printFullKitchenInvoice: json['pos_PrintFullKitchenInvoice'] as bool?,
  printSplitedKitchenInvoice: json['pos_PrintSplitedKitchenInvoice'] as bool?,
  printKitchenInvoiceForReturn:
      json['pos_PrintKitchenInvoiceForReturn'] as bool?,
  printNotes: json['pos_PrintNotes'] as bool?,
  activeCashierCustody: json['pos_ActiveCashierCustody'] as bool?,
  allowShifts: json['pos_AllowShifts'] as bool?,
  resetOrderCodeWithNewShift: json['pos_ResetOrderCodeWithNewShift'] as bool?,
  saveWithPay: json['pos_SaveWithPay'] as bool?,
  automaticallyExtractIngredients:
      json['pos_AutomaticallyExtractIngredients'] as bool?,
  viewOfferIngredientsInInvoice:
      json['pos_ViewOfferIngredientsInInvoice'] as bool?,
  viewOfferIngredientsInInvoiceKichenPrinting:
      json['pos_ViewOfferIngredientsInInvoice_KichenPrinting'] as bool?,
  viewOfferIngredientsInInvoiceChiquePrinting:
      json['pos_ViewOfferIngredientsInInvoice_ChiquePrinting'] as bool?,
  takeawayPrintWithSavingKitchen:
      json['pos_Takeaway_PrintWithSavingKitchen'] as bool?,
  takeawayPrintWithSavingChique:
      json['pos_Takeaway_PrintWithSavingChique'] as bool?,
  takeawayPrintPreviewChique: json['pos_Takeaway_PrintPreviewChique'] as bool?,
  takeawayDeferredSale: json['pos_Takeaway_DeferredSale'] as bool?,
  hallPrintWithSavingKitchen: json['pos_hall_PrintWithSavingKitchen'] as bool?,
  hallPrintWithSavingChique: json['pos_hall_PrintWithSavingChique'] as bool?,
  hallPrintChiqueBeforeSaving:
      json['pos_hall_PrintChiqueBeforeSaving'] as bool?,
  hallPreventCancelInvoiceAfterKitchenPrinting:
      json['pos_hall_PreventCancelInvoiceAfterKitchenPrinting'] as bool?,
  hallPrintPreviewChique: json['pos_hall_PrintPreviewChique'] as bool?,
  hallDeferredSale: json['pos_hall_DeferredSale'] as bool?,
  deliveryPrintWithSavingKitchen:
      json['pos_Delivery_PrintWithSavingKitchen'] as bool?,
  deliveryPrintWithSavingChique:
      json['pos_Delivery_PrintWithSavingChique'] as bool?,
  deliveryPrintPreviewChique: json['pos_Delivery_PrintPreviewChique'] as bool?,
  deliveryDeferredSale: json['pos_Delivery_DeferredSale'] as bool?,
  deliveryCost: (json['deliveryCost'] as num?)?.toDouble(),
  editDeliveryCost: json['editDeliveryCost'] as bool?,
);

Map<String, dynamic> _$PosRestaurantSettingsModelToJson(
  PosRestaurantSettingsModel instance,
) => <String, dynamic>{
  'pos_ModifyPrices': instance.modifyPrices,
  'pos_ActivateServices': instance.activateServices,
  'pos_ModifyPricesType': instance.modifyPricesType,
  'pos_ExceedDiscountRatio': instance.exceedDiscountRatio,
  'pos_ExtractWithoutQuantity': instance.extractWithoutQuantity,
  'pos_PriceIncludeVat': instance.priceIncludeVat,
  'pos_ActiveDiscount': instance.activeDiscount,
  'pos_EditingOnDate': instance.editingOnDate,
  'pos_PreventEditingRecieptFlag': instance.preventEditingRecieptFlag,
  'pos_PreventEditingRecieptValue': instance.preventEditingRecieptValue,
  'pos_PrintNoteWithChique': instance.printNoteWithChique,
  'pos_StopEditingAfterKitchenPrinting':
      instance.stopEditingAfterKitchenPrinting,
  'pos_PrintFullKitchenInvoice': instance.printFullKitchenInvoice,
  'pos_PrintSplitedKitchenInvoice': instance.printSplitedKitchenInvoice,
  'pos_PrintKitchenInvoiceForReturn': instance.printKitchenInvoiceForReturn,
  'pos_PrintNotes': instance.printNotes,
  'pos_ActiveCashierCustody': instance.activeCashierCustody,
  'pos_AllowShifts': instance.allowShifts,
  'pos_ResetOrderCodeWithNewShift': instance.resetOrderCodeWithNewShift,
  'pos_SaveWithPay': instance.saveWithPay,
  'pos_AutomaticallyExtractIngredients':
      instance.automaticallyExtractIngredients,
  'pos_ViewOfferIngredientsInInvoice': instance.viewOfferIngredientsInInvoice,
  'pos_ViewOfferIngredientsInInvoice_KichenPrinting':
      instance.viewOfferIngredientsInInvoiceKichenPrinting,
  'pos_ViewOfferIngredientsInInvoice_ChiquePrinting':
      instance.viewOfferIngredientsInInvoiceChiquePrinting,
  'pos_Takeaway_PrintWithSavingKitchen':
      instance.takeawayPrintWithSavingKitchen,
  'pos_Takeaway_PrintWithSavingChique': instance.takeawayPrintWithSavingChique,
  'pos_Takeaway_PrintPreviewChique': instance.takeawayPrintPreviewChique,
  'pos_Takeaway_DeferredSale': instance.takeawayDeferredSale,
  'pos_hall_PrintWithSavingKitchen': instance.hallPrintWithSavingKitchen,
  'pos_hall_PrintWithSavingChique': instance.hallPrintWithSavingChique,
  'pos_hall_PrintChiqueBeforeSaving': instance.hallPrintChiqueBeforeSaving,
  'pos_hall_PreventCancelInvoiceAfterKitchenPrinting':
      instance.hallPreventCancelInvoiceAfterKitchenPrinting,
  'pos_hall_PrintPreviewChique': instance.hallPrintPreviewChique,
  'pos_hall_DeferredSale': instance.hallDeferredSale,
  'pos_Delivery_PrintWithSavingKitchen':
      instance.deliveryPrintWithSavingKitchen,
  'pos_Delivery_PrintWithSavingChique': instance.deliveryPrintWithSavingChique,
  'pos_Delivery_PrintPreviewChique': instance.deliveryPrintPreviewChique,
  'pos_Delivery_DeferredSale': instance.deliveryDeferredSale,
  'deliveryCost': instance.deliveryCost,
  'editDeliveryCost': instance.editDeliveryCost,
};

SalesSettingsModel _$SalesSettingsModelFromJson(Map<String, dynamic> json) =>
    SalesSettingsModel(
      modifyPrices: json['sales_ModifyPrices'] as bool?,
      modifyPricesType: (json['sales_ModifyPricesType'] as num?)?.toInt(),
      exceedDiscountRatio: json['sales_ExceedDiscountRatio'] as bool?,
      payTotalNet: json['sales_PayTotalNet'] as bool?,
      useLastPrice: json['sales_UseLastPrice'] as bool?,
      extractWithoutQuantity: json['sales_ExtractWithoutQuantity'] as bool?,
      priceIncludeVat: json['sales_PriceIncludeVat'] as bool?,
      printWithSave: json['sales_PrintWithSave'] as bool?,
      activeDiscount: json['sales_ActiveDiscount'] as bool?,
      linkRepresentCustomer: json['sales_LinkRepresentCustomer'] as bool?,
      activePricesList: json['sales_ActivePricesList'] as bool?,
    );

Map<String, dynamic> _$SalesSettingsModelToJson(SalesSettingsModel instance) =>
    <String, dynamic>{
      'sales_ModifyPrices': instance.modifyPrices,
      'sales_ModifyPricesType': instance.modifyPricesType,
      'sales_ExceedDiscountRatio': instance.exceedDiscountRatio,
      'sales_PayTotalNet': instance.payTotalNet,
      'sales_UseLastPrice': instance.useLastPrice,
      'sales_ExtractWithoutQuantity': instance.extractWithoutQuantity,
      'sales_PriceIncludeVat': instance.priceIncludeVat,
      'sales_PrintWithSave': instance.printWithSave,
      'sales_ActiveDiscount': instance.activeDiscount,
      'sales_LinkRepresentCustomer': instance.linkRepresentCustomer,
      'sales_ActivePricesList': instance.activePricesList,
    };

OtherSettingsModel _$OtherSettingsModelFromJson(
  Map<String, dynamic> json,
) => OtherSettingsModel(
  mergeItems: json['other_MergeItems'] as bool?,
  mergeItemMethod: json['otherMergeItemMethod'] as String?,
  itemsAutoCoding: json['other_ItemsAutoCoding'] as bool?,
  zeroPricesInItems: json['other_ZeroPricesInItems'] as bool?,
  printSerials: json['other_PrintSerials'] as bool?,
  autoExtractExpireDate: json['other_AutoExtractExpireDate'] as bool?,
  viewStorePlace: json['other_ViewStorePlace'] as bool?,
  confirmeSupplierPhone: json['other_ConfirmeSupplierPhone'] as bool?,
  confirmeCustomerPhone: json['other_ConfirmeCustomerPhone'] as bool?,
  demandLimitNotification: json['other_DemandLimitNotification'] as bool?,
  expireNotificationFlag: json['other_ExpireNotificationFlag'] as bool?,
  expireNotificationValue: (json['other_ExpireNotificationValue'] as num?)
      ?.toInt(),
  decimals: (json['other_Decimals'] as num?)?.toInt(),
  useRoundNumber: json['other_useRoundNumber'] as bool?,
  autoLogoutInMints: (json['autoLogoutInMints'] as num?)?.toInt(),
  showBalanceOfPerson: json['other_ShowBalanceOfPerson'] as bool?,
  isCollectionReceipt: json['isCollectionReceipt'] as bool?,
  activatePriceLists: json['other_ActivatePriceLists'] as bool?,
  priceListType: (json['priceListType'] as num?)?.toInt(),
  isExpenses: json['isExpenses'] as bool?,
  alertMessageForCustomerSupplierBalance:
      json['other_AlertMessageForCustomerSupplierBalance'] as bool?,
  autoExtractFromCustomerSupplierBalance:
      json['other_AutoExtractFromCustomerSupplierBalance'] as bool?,
  doNothingForCustomerSupplierBalance:
      json['other_DoNothingForCustomerSupplierBalance'] as bool?,
  addAttachment: json['addAttachment'] as bool?,
  showPriceAndTotalInOutgoingAndIncommingTransfer:
      json['other_ShowPriceAndTotalInOutgoingAndIncommingTransfer'] as bool?,
  phoneNumberLengthForCustomerOrSupplier:
      (json['other_PhoneNumberLengthForCustomerOrSupplier'] as num?)?.toInt(),
  docemntNumber: json['other_DocemntNumber'] as bool?,
  referenceTime: json['other_ReferenceTime'] as bool?,
);

Map<String, dynamic> _$OtherSettingsModelToJson(OtherSettingsModel instance) =>
    <String, dynamic>{
      'other_MergeItems': instance.mergeItems,
      'otherMergeItemMethod': instance.mergeItemMethod,
      'other_ItemsAutoCoding': instance.itemsAutoCoding,
      'other_ZeroPricesInItems': instance.zeroPricesInItems,
      'other_PrintSerials': instance.printSerials,
      'other_AutoExtractExpireDate': instance.autoExtractExpireDate,
      'other_ViewStorePlace': instance.viewStorePlace,
      'other_ConfirmeSupplierPhone': instance.confirmeSupplierPhone,
      'other_ConfirmeCustomerPhone': instance.confirmeCustomerPhone,
      'other_DemandLimitNotification': instance.demandLimitNotification,
      'other_ExpireNotificationFlag': instance.expireNotificationFlag,
      'other_ExpireNotificationValue': instance.expireNotificationValue,
      'other_Decimals': instance.decimals,
      'other_useRoundNumber': instance.useRoundNumber,
      'autoLogoutInMints': instance.autoLogoutInMints,
      'other_ShowBalanceOfPerson': instance.showBalanceOfPerson,
      'isCollectionReceipt': instance.isCollectionReceipt,
      'other_ActivatePriceLists': instance.activatePriceLists,
      'priceListType': instance.priceListType,
      'isExpenses': instance.isExpenses,
      'other_AlertMessageForCustomerSupplierBalance':
          instance.alertMessageForCustomerSupplierBalance,
      'other_AutoExtractFromCustomerSupplierBalance':
          instance.autoExtractFromCustomerSupplierBalance,
      'other_DoNothingForCustomerSupplierBalance':
          instance.doNothingForCustomerSupplierBalance,
      'addAttachment': instance.addAttachment,
      'other_ShowPriceAndTotalInOutgoingAndIncommingTransfer':
          instance.showPriceAndTotalInOutgoingAndIncommingTransfer,
      'other_PhoneNumberLengthForCustomerOrSupplier':
          instance.phoneNumberLengthForCustomerOrSupplier,
      'other_DocemntNumber': instance.docemntNumber,
      'other_ReferenceTime': instance.referenceTime,
    };

FundsSettingsModel _$FundsSettingsModelFromJson(Map<String, dynamic> json) =>
    FundsSettingsModel(
      items: json['funds_Items'] as bool?,
      supplires: json['funds_Supplires'] as bool?,
      customers: json['funds_Customers'] as bool?,
      safes: json['funds_Safes'] as bool?,
      banks: json['funds_Banks'] as bool?,
    );

Map<String, dynamic> _$FundsSettingsModelToJson(FundsSettingsModel instance) =>
    <String, dynamic>{
      'funds_Items': instance.items,
      'funds_Supplires': instance.supplires,
      'funds_Customers': instance.customers,
      'funds_Safes': instance.safes,
      'funds_Banks': instance.banks,
    };

BarcodeSettingsModel _$BarcodeSettingsModelFromJson(
  Map<String, dynamic> json,
) => BarcodeSettingsModel(
  barcodeType: json['barcodeType'] as String?,
  itemCodeStart: json['barcode_ItemCodestart'] as bool?,
);

Map<String, dynamic> _$BarcodeSettingsModelToJson(
  BarcodeSettingsModel instance,
) => <String, dynamic>{
  'barcodeType': instance.barcodeType,
  'barcode_ItemCodestart': instance.itemCodeStart,
};

VatSettingModel _$VatSettingModelFromJson(Map<String, dynamic> json) =>
    VatSettingModel(
      vatActive: json['vat_Active'] as bool?,
      vatDefaultValue: (json['vat_DefaultValue'] as num?)?.toDouble(),
      toppacoTaxActive: json['toppacoTAX_Active'] as bool?,
      toppacoTaxDefaultValue: (json['toppacoTAX_DefaultValue'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$VatSettingModelToJson(VatSettingModel instance) =>
    <String, dynamic>{
      'vat_Active': instance.vatActive,
      'vat_DefaultValue': instance.vatDefaultValue,
      'toppacoTAX_Active': instance.toppacoTaxActive,
      'toppacoTAX_DefaultValue': instance.toppacoTaxDefaultValue,
    };

AccrediteSettingsModel _$AccrediteSettingsModelFromJson(
  Map<String, dynamic> json,
) => AccrediteSettingsModel(
  accrediteStartPeriod: json['accredite_StartPeriod'] == null
      ? null
      : DateTime.parse(json['accredite_StartPeriod'] as String),
  accrediteEndPeriod: json['accredite_EndPeriod'] == null
      ? null
      : DateTime.parse(json['accredite_EndPeriod'] as String),
);

Map<String, dynamic> _$AccrediteSettingsModelToJson(
  AccrediteSettingsModel instance,
) => <String, dynamic>{
  'accredite_StartPeriod': instance.accrediteStartPeriod?.toIso8601String(),
  'accredite_EndPeriod': instance.accrediteEndPeriod?.toIso8601String(),
};

CustomerDisplaySettingsModel _$CustomerDisplaySettingsModelFromJson(
  Map<String, dynamic> json,
) => CustomerDisplaySettingsModel(
  active: json['customerDisplay_Active'] as bool?,
  portNumber: json['customerDisplay_PortNumber'] as String?,
  code: (json['customerDisplay_Code'] as num?)?.toInt(),
  linesNumber: (json['customerDisplay_LinesNumber'] as num?)?.toInt(),
  charNumber: (json['customerDisplay_CharNumber'] as num?)?.toInt(),
  defaultWord: json['customerDisplay_DefaultWord'] as String?,
  screenType: (json['customerDisplay_ScreenType'] as num?)?.toInt(),
);

Map<String, dynamic> _$CustomerDisplaySettingsModelToJson(
  CustomerDisplaySettingsModel instance,
) => <String, dynamic>{
  'customerDisplay_Active': instance.active,
  'customerDisplay_PortNumber': instance.portNumber,
  'customerDisplay_Code': instance.code,
  'customerDisplay_LinesNumber': instance.linesNumber,
  'customerDisplay_CharNumber': instance.charNumber,
  'customerDisplay_DefaultWord': instance.defaultWord,
  'customerDisplay_ScreenType': instance.screenType,
};
