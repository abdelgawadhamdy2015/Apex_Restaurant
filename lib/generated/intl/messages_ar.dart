// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(price) => "أضف للسلة ${price} ر.س";

  static String m1(addons) => "الإضافات: ${addons}";

  static String m2(version) => "إصدار التطبيق${version}";

  static String m3(count) => "منذ ${count} يوم";

  static String m4(year, month, day, hour, minute) =>
      "${year}/${month}/${day} - ${hour}:${minute}";

  static String m5(count) => "منذ ${count} ساعة";

  static String m6(count) => "${count} صنف";

  static String m7(count) =>
      "${Intl.plural(count, one: 'صنف واحد', two: 'صنفان', few: '${count} أصناف', many: '${count} صنفاً', other: '${count} صنف')}";

  static String m8(count) => "منذ ${count} دقيقة";

  static String m9(notes) => "ملاحظات: ${notes}";

  static String m10(count) => "${count} طلبات";

  static String m11(price) => "+${price} ر.س";

  static String m12(price) => "${price} ر.س";

  static String m13(quantity) => "الكمية: ${quantity}";

  static String m14(minutes) => "فترة الحجز (${minutes} دقيقة)";

  static String m15(size) => "الحجم: ${size}";

  static String m16(vat) => "ضريبة القيمة المضافة : % ${vat} ";

  static String m17(value) => "تم تطبيق القسيمة (${value} ريال)";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "PleaseAuthenticateToLogin": MessageLookupByLibrary.simpleMessage(
      "الرجاء المصادقة لتسجيل الدخول",
    ),
    "RequestPermission": MessageLookupByLibrary.simpleMessage("طلب إذن"),
    "absence": MessageLookupByLibrary.simpleMessage("الغياب"),
    "accept": MessageLookupByLibrary.simpleMessage("قبول"),
    "accessDenied": MessageLookupByLibrary.simpleMessage("تم رفض الوصول"),
    "account": MessageLookupByLibrary.simpleMessage("الحساب"),
    "active": MessageLookupByLibrary.simpleMessage("نشط"),
    "activeNow": MessageLookupByLibrary.simpleMessage("نشط الآن"),
    "actualCashInDrawer": MessageLookupByLibrary.simpleMessage(
      "المبلغ النقدي الفعلي بالدرج",
    ),
    "actualWorkingHours": MessageLookupByLibrary.simpleMessage(
      "ساعات العمل الفعلية",
    ),
    "addAdditives": MessageLookupByLibrary.simpleMessage("إضافة إضافات"),
    "addAnotherAddress": MessageLookupByLibrary.simpleMessage(
      "إضافة عنوان آخر",
    ),
    "addBalance": MessageLookupByLibrary.simpleMessage("إضافة رصيد"),
    "addCustody": MessageLookupByLibrary.simpleMessage("إضافة عهدة"),
    "addCustomer": MessageLookupByLibrary.simpleMessage("إضافة عميل"),
    "addMoreAddressesHint": MessageLookupByLibrary.simpleMessage(
      "يمكن إضافة أكثر من عنوان للعميل",
    ),
    "addNewAddress": MessageLookupByLibrary.simpleMessage("إضافة عنوان جديد"),
    "addNewCustomer": MessageLookupByLibrary.simpleMessage("إضافة عميل جديد"),
    "addNewItem": MessageLookupByLibrary.simpleMessage("إضافة صنف جديد"),
    "addNewReservation": MessageLookupByLibrary.simpleMessage("إضافة حجز جديد"),
    "addNotesHint": MessageLookupByLibrary.simpleMessage("أضف ملاحظاتك هنا..."),
    "addToCartWithPrice": m0,
    "additionTag": MessageLookupByLibrary.simpleMessage("إضافة"),
    "additionalNotes": MessageLookupByLibrary.simpleMessage("ملاحظات إضافية"),
    "additionalNotesHint": MessageLookupByLibrary.simpleMessage(
      "اكتب تفاصيل العملية هنا ....",
    ),
    "additionalOperations": MessageLookupByLibrary.simpleMessage(
      "العمليات الإضافية",
    ),
    "additions": MessageLookupByLibrary.simpleMessage("إضافات"),
    "additionsFilter": MessageLookupByLibrary.simpleMessage("الإضافات"),
    "addons": MessageLookupByLibrary.simpleMessage("الإضافات"),
    "addonsWithVal": m1,
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "allFilter": MessageLookupByLibrary.simpleMessage("الكل"),
    "alternatePhoneOptional": MessageLookupByLibrary.simpleMessage(
      "تليفون آخر (اختياري)",
    ),
    "am": MessageLookupByLibrary.simpleMessage("صباحا"),
    "amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "amountDue": MessageLookupByLibrary.simpleMessage("المستحق"),
    "amountPaid": MessageLookupByLibrary.simpleMessage("المسدد"),
    "amountRemaining": MessageLookupByLibrary.simpleMessage("المتبقي"),
    "annual": MessageLookupByLibrary.simpleMessage("إجازة"),
    "annualLeave": MessageLookupByLibrary.simpleMessage("إجازة سنوية"),
    "apartmentNumber": MessageLookupByLibrary.simpleMessage("رقم الشقة"),
    "appVersion": m2,
    "apply": MessageLookupByLibrary.simpleMessage("تطبيق"),
    "approvals": MessageLookupByLibrary.simpleMessage("الاعتمادات"),
    "approve": MessageLookupByLibrary.simpleMessage("اعتماد"),
    "approveDeficitVoucher": MessageLookupByLibrary.simpleMessage(
      "اعتماد سند صرف العجز",
    ),
    "approved": MessageLookupByLibrary.simpleMessage("موافق عليه"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "attachReceiptOrInvoice": MessageLookupByLibrary.simpleMessage(
      "إرفاق إيصال أو فاتورة",
    ),
    "attachment": MessageLookupByLibrary.simpleMessage("المرفق"),
    "attendance": MessageLookupByLibrary.simpleMessage("حضور"),
    "attendanceMethod": MessageLookupByLibrary.simpleMessage("طريقة الحضور"),
    "attendanceMovementsToday": MessageLookupByLibrary.simpleMessage(
      "حركات الحضور اليوم",
    ),
    "attendanceRecord": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الحضور في ",
    ),
    "attendanceReports": MessageLookupByLibrary.simpleMessage(
      "تقارير الحضور والانصراف",
    ),
    "attendanceTime": MessageLookupByLibrary.simpleMessage("وقت الحضور"),
    "available": MessageLookupByLibrary.simpleMessage("متاح"),
    "badeResponse": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ يرجى تسجيل الدخول مرة أخرى",
    ),
    "badgeNew": MessageLookupByLibrary.simpleMessage("جديد"),
    "badgeOffer": MessageLookupByLibrary.simpleMessage("عرض"),
    "bankTransfer": MessageLookupByLibrary.simpleMessage("تحويل بنكي"),
    "bestSellers": MessageLookupByLibrary.simpleMessage("الأكثر مبيعاً 🔥"),
    "biometricAuthenticationCanceled": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء المصادقة  من قبل المستخدم.",
    ),
    "biometricAuthenticationError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء المصادقة . يرجى المحاولة مرة أخرى.",
    ),
    "biometricAuthenticationFailed": MessageLookupByLibrary.simpleMessage(
      "فشلت المصادقة . يرجى المحاولة مرة أخرى.",
    ),
    "biometricAuthenticationInProgress": MessageLookupByLibrary.simpleMessage(
      "المصادقة  جارية. يرجى الانتظار...",
    ),
    "biometricAuthenticationLockout": MessageLookupByLibrary.simpleMessage(
      "عدد كبير من المحاولات الفاشلة. تم إيقاف المصادقة  مؤقتًا. يرجى المحاولة مرة أخرى لاحقًا.",
    ),
    "biometricAuthenticationSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت المصادقة  بنجاح. جارٍ تسجيل الدخول...",
    ),
    "biometricNotAvailable": MessageLookupByLibrary.simpleMessage(
      "المصادقة  غير متوفرة على هذا الجهاز.",
    ),
    "biometricNotEnrolled": MessageLookupByLibrary.simpleMessage(
      "لا توجد بيانات  مسجلة. يرجى إعداد المصادقة البيومترية في إعدادات جهازك.",
    ),
    "biometricRequired": MessageLookupByLibrary.simpleMessage(
      "عذراً! المصادقة مطلوبة!",
    ),
    "birthDate": MessageLookupByLibrary.simpleMessage("تاريخ الميلاد"),
    "branch": MessageLookupByLibrary.simpleMessage("الفرع"),
    "branches": MessageLookupByLibrary.simpleMessage("الفروع"),
    "branchs": MessageLookupByLibrary.simpleMessage("الفروع"),
    "btnNewOrder": MessageLookupByLibrary.simpleMessage("طلب جديد"),
    "btnPreviousOrders": MessageLookupByLibrary.simpleMessage(
      "الطلبات السابقة",
    ),
    "btnPrintKitchen": MessageLookupByLibrary.simpleMessage("طباعة مطبخ"),
    "btnPrintReceipt": MessageLookupByLibrary.simpleMessage("طباعة إيصال"),
    "buildingNumber": MessageLookupByLibrary.simpleMessage("رقم البناية"),
    "camera": MessageLookupByLibrary.simpleMessage("كاميرا"),
    "cancel": MessageLookupByLibrary.simpleMessage(" إلغاء"),
    "cancelOrder": MessageLookupByLibrary.simpleMessage("إلغاء الطلب"),
    "cancelled": MessageLookupByLibrary.simpleMessage("ملغي"),
    "card": MessageLookupByLibrary.simpleMessage("شبكة"),
    "cardNetwork": MessageLookupByLibrary.simpleMessage("شبكة"),
    "cart": MessageLookupByLibrary.simpleMessage("السلة"),
    "cartEmpty": MessageLookupByLibrary.simpleMessage(
      "لا توجد أصناف في السلة بعد",
    ),
    "cartIsEmpty": MessageLookupByLibrary.simpleMessage("السلة فارغة."),
    "cash": MessageLookupByLibrary.simpleMessage("نقدي"),
    "cashCustomer": MessageLookupByLibrary.simpleMessage("عميل نقدي"),
    "cashierCustody": MessageLookupByLibrary.simpleMessage("عهدة الكاشير"),
    "changeAddress": MessageLookupByLibrary.simpleMessage("تغيير العنوان"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى التحقق من بريدك الإلكتروني لتعليمات إعادة تعيين كلمة المرور.",
    ),
    "checkout": MessageLookupByLibrary.simpleMessage("إتمام الدفع"),
    "chooseDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "اختر شركة التوصيل",
    ),
    "city": MessageLookupByLibrary.simpleMessage("المدينة"),
    "clearAll": MessageLookupByLibrary.simpleMessage("مسح الكل"),
    "clickToUploadFile": MessageLookupByLibrary.simpleMessage(
      "اضغط لرفع الملف",
    ),
    "closeApp": MessageLookupByLibrary.simpleMessage("إغلاق التطبيق"),
    "closeCustody": MessageLookupByLibrary.simpleMessage("إغلاق العهدة"),
    "closeSession": MessageLookupByLibrary.simpleMessage("إغلاق الجلسة"),
    "comeFromReset": MessageLookupByLibrary.simpleMessage("العودة من الراحة"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("تأكيد الإجراء"),
    "confirmAdditives": MessageLookupByLibrary.simpleMessage("تأكيد الإضافات"),
    "confirmReservation": MessageLookupByLibrary.simpleMessage("تأكيد الحجز"),
    "confirmTransaction": MessageLookupByLibrary.simpleMessage("اعتماد الحركة"),
    "confirmed": MessageLookupByLibrary.simpleMessage("مؤكد"),
    "controlBoard": MessageLookupByLibrary.simpleMessage("لوحة التحكم"),
    "coupon": MessageLookupByLibrary.simpleMessage("كوبون"),
    "couponDiscount": MessageLookupByLibrary.simpleMessage("الخصم (كوبون)"),
    "currencySar": MessageLookupByLibrary.simpleMessage("ريال سعودي"),
    "currencySarShort": MessageLookupByLibrary.simpleMessage("ر.س"),
    "currencySymbol": MessageLookupByLibrary.simpleMessage("ر.س"),
    "currentAvailableBalance": MessageLookupByLibrary.simpleMessage(
      "الرصيد المتوفر حالياً",
    ),
    "currentBalance": MessageLookupByLibrary.simpleMessage("الرصيد الحالي"),
    "currentOrder": MessageLookupByLibrary.simpleMessage("الطلب الحالي"),
    "currentStatusOffShift": MessageLookupByLibrary.simpleMessage(
      "الحالة الحالية: خارج الوردية",
    ),
    "custodyLog": MessageLookupByLibrary.simpleMessage("سجل العهدة"),
    "custodyLogTitle": MessageLookupByLibrary.simpleMessage("سجل الحركات"),
    "customer": MessageLookupByLibrary.simpleMessage("العميل"),
    "customerAddresses": MessageLookupByLibrary.simpleMessage("عناوين العميل"),
    "customerName": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "customerNameHint": MessageLookupByLibrary.simpleMessage(
      "اسم العميل أو الجوال",
    ),
    "customerNameLabel": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "customerSelection": MessageLookupByLibrary.simpleMessage("اختيار العميل"),
    "customers": MessageLookupByLibrary.simpleMessage("العملاء"),
    "customizationSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر الحجم المناسب والإضافات المرغوبة",
    ),
    "dailyClose": MessageLookupByLibrary.simpleMessage("إقفال اليومية"),
    "dailyWorkingHours": MessageLookupByLibrary.simpleMessage(
      "من 9:00 صباحًا الي 6:00 مساءً",
    ),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "dateFormatHint": MessageLookupByLibrary.simpleMessage("mm/dd/yyyy"),
    "datePlaceholder": MessageLookupByLibrary.simpleMessage("mm/dd/yyyy"),
    "dateWarning": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون تاريخ البدء قبل تاريخ الانتهاء",
    ),
    "day": MessageLookupByLibrary.simpleMessage("اليوم"),
    "dayStatus": MessageLookupByLibrary.simpleMessage("حالة اليوم"),
    "days": MessageLookupByLibrary.simpleMessage("ايام"),
    "daysAgo": m3,
    "dbName": MessageLookupByLibrary.simpleMessage("اسم قاعدة البيانات"),
    "deficit": MessageLookupByLibrary.simpleMessage("العجز"),
    "deleteOrder": MessageLookupByLibrary.simpleMessage("حذف الطلب"),
    "delivery": MessageLookupByLibrary.simpleMessage("توصيل"),
    "deliveryCompanies": MessageLookupByLibrary.simpleMessage("شركات التوصيل"),
    "deliveryCompany": MessageLookupByLibrary.simpleMessage("شركة التوصيل"),
    "deliveryCompanyDetails": MessageLookupByLibrary.simpleMessage(
      "بيانات شركة التوصيل",
    ),
    "deliveryFee": MessageLookupByLibrary.simpleMessage("رسوم التوصيل"),
    "deliveryOrder": MessageLookupByLibrary.simpleMessage("طلب استلام"),
    "department": MessageLookupByLibrary.simpleMessage("الإدارة"),
    "departures": MessageLookupByLibrary.simpleMessage("المغادرات"),
    "detailedReport": MessageLookupByLibrary.simpleMessage("التفصيلي"),
    "dineIn": MessageLookupByLibrary.simpleMessage("محلي"),
    "dineInCost": MessageLookupByLibrary.simpleMessage("تكلفة الصالة"),
    "dineInOrder": MessageLookupByLibrary.simpleMessage("طلب صالة"),
    "directDiscount": MessageLookupByLibrary.simpleMessage("خصم مباشر"),
    "directManager": MessageLookupByLibrary.simpleMessage("المدير المباشر"),
    "discount": MessageLookupByLibrary.simpleMessage("الخصم"),
    "discountCoupon": MessageLookupByLibrary.simpleMessage("الخصم (كوبون)"),
    "district": MessageLookupByLibrary.simpleMessage("الحي"),
    "duration": MessageLookupByLibrary.simpleMessage("المدة"),
    "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
    "editCustomer": MessageLookupByLibrary.simpleMessage("تعديل عميل"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailNotFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على عنوان البريد الإلكتروني. يرجى المحاولة مرة أخرى.",
    ),
    "emergencyLeave": MessageLookupByLibrary.simpleMessage("إجازة طارئة"),
    "employeeBranch": MessageLookupByLibrary.simpleMessage("فرع الموظف"),
    "employeeCode": MessageLookupByLibrary.simpleMessage("كود الموظف"),
    "employeeDefinition": MessageLookupByLibrary.simpleMessage("تعريف الموظف"),
    "employeeEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني للموظف",
    ),
    "employeeInformation": MessageLookupByLibrary.simpleMessage(
      "معلومات الموظف",
    ),
    "employeeJob": MessageLookupByLibrary.simpleMessage("وظيفة الموظف"),
    "employeeMobile": MessageLookupByLibrary.simpleMessage("جوال الموظف"),
    "employeeNameAr": MessageLookupByLibrary.simpleMessage(
      "اسم الموظف (بالعربية)",
    ),
    "employeeNameEn": MessageLookupByLibrary.simpleMessage(
      "اسم الموظف (بالإنجليزية)",
    ),
    "employeeStatus": MessageLookupByLibrary.simpleMessage("حالة الموظف"),
    "endDate": MessageLookupByLibrary.simpleMessage("تاريخ النهاية"),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "enterCustomerNameHint": MessageLookupByLibrary.simpleMessage(
      "اكتب اسم العميل",
    ),
    "enterDiscountCode": MessageLookupByLibrary.simpleMessage("أدخل كود الخصم"),
    "enterDiscountValue": MessageLookupByLibrary.simpleMessage(
      "أدخل قيمة الخصم",
    ),
    "enterTransactionNumber": MessageLookupByLibrary.simpleMessage(
      "ادخل رقم العملية .....",
    ),
    "eventsApprovals": MessageLookupByLibrary.simpleMessage(
      "الأحداث والموافقات",
    ),
    "exitApp": MessageLookupByLibrary.simpleMessage("اضغط مرة أخرى للخروج"),
    "expectedTotalCash": MessageLookupByLibrary.simpleMessage(
      "الإجمالي النقدي المتوقع",
    ),
    "expenseReimbursement": MessageLookupByLibrary.simpleMessage(
      "تعويض مصروفات",
    ),
    "exportCsv": MessageLookupByLibrary.simpleMessage("تصدير CSV"),
    "extraTime": MessageLookupByLibrary.simpleMessage("وقت إضافي "),
    "favorites": MessageLookupByLibrary.simpleMessage("المفضلة ⭐"),
    "filterAll": MessageLookupByLibrary.simpleMessage("الكل"),
    "filterBestSeller": MessageLookupByLibrary.simpleMessage(
      "🔥 الأكثر مبيعاً",
    ),
    "filterFavorites": MessageLookupByLibrary.simpleMessage("⭐ المفضلة"),
    "filterNew": MessageLookupByLibrary.simpleMessage("🆕 جديد"),
    "filterTodayOffers": MessageLookupByLibrary.simpleMessage("🎁 عروض اليوم"),
    "fingerPrint": MessageLookupByLibrary.simpleMessage("بصمة"),
    "fingerPrintType": MessageLookupByLibrary.simpleMessage("نوع البصمة"),
    "fingerPrints": MessageLookupByLibrary.simpleMessage("بصمات"),
    "firstFloor": MessageLookupByLibrary.simpleMessage("الدور الأول"),
    "fixedAmountDiscount": MessageLookupByLibrary.simpleMessage("قيمة ثابتة"),
    "floor": MessageLookupByLibrary.simpleMessage("الدور"),
    "floors": MessageLookupByLibrary.simpleMessage("الطوابق"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "formattedDateTime": m4,
    "free": MessageLookupByLibrary.simpleMessage("مجاناً"),
    "from": MessageLookupByLibrary.simpleMessage("من"),
    "fromBranch": MessageLookupByLibrary.simpleMessage("من الفرع"),
    "fromDate": MessageLookupByLibrary.simpleMessage("من تاريخ"),
    "fullDay": MessageLookupByLibrary.simpleMessage("يومى"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم بالكامل"),
    "fullReturn": MessageLookupByLibrary.simpleMessage("مرتجع كلي"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("الإجمالي النهائي"),
    "group": MessageLookupByLibrary.simpleMessage("المجموعة"),
    "guestsCount": MessageLookupByLibrary.simpleMessage("عدد الضيوف"),
    "guestsCountHint": MessageLookupByLibrary.simpleMessage("مثال: 3"),
    "heldOrders": MessageLookupByLibrary.simpleMessage("طلبات معلقة"),
    "holdOrder": MessageLookupByLibrary.simpleMessage("تعليق الطلب"),
    "holidayNotSelected": MessageLookupByLibrary.simpleMessage(
      "برجاء اختيار نوع الإجازة",
    ),
    "home": MessageLookupByLibrary.simpleMessage("الصفحة الرئيسية"),
    "homeSubtitle": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار الإجراء المطلوب للمتابعة",
    ),
    "hour": MessageLookupByLibrary.simpleMessage("ساعة"),
    "hours": MessageLookupByLibrary.simpleMessage("ساعة"),
    "hoursAgo": m5,
    "identityConfirmed": MessageLookupByLibrary.simpleMessage(
      "تم تأكيد الهوية",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("غير نشط"),
    "indoorTerrace": MessageLookupByLibrary.simpleMessage("التراس الداخلي"),
    "insertDBName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم قاعدة البيانات",
    ),
    "insertEmail": MessageLookupByLibrary.simpleMessage(
      "أدخل البريد الإلكتروني",
    ),
    "insertPassword": MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
    "invalidAmount": MessageLookupByLibrary.simpleMessage("المبلغ غير صالح"),
    "invoiceDiscountNotAllowed": MessageLookupByLibrary.simpleMessage(
      "لا يمكن إضافة خصم على الفاتورة لوجود خصم مطبّق على أحد أصناف الطلب، ولكن يمكن إضافة خصم قسيمة.",
    ),
    "invoiceNumber": MessageLookupByLibrary.simpleMessage("رقم الفاتورة"),
    "invoiceNumberExample": MessageLookupByLibrary.simpleMessage(
      "مثال: INV-1024",
    ),
    "invoiceNumberHint": MessageLookupByLibrary.simpleMessage(
      "مثال : INV-1024",
    ),
    "invoiceNumberLabel": MessageLookupByLibrary.simpleMessage("رقم الفاتورة"),
    "invoiceReturnedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إرتجاع الفاتورة بنجاح",
    ),
    "invoices": MessageLookupByLibrary.simpleMessage("الفواتير"),
    "isDefaultAddress": MessageLookupByLibrary.simpleMessage(
      "العنوان الافتراضي",
    ),
    "itemCountSingle": m6,
    "itemsCount": m7,
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "language": MessageLookupByLibrary.simpleMessage("اللغة"),
    "lastCheckOut": MessageLookupByLibrary.simpleMessage("آخر تسجيل خروج"),
    "lastCheckOutValue": MessageLookupByLibrary.simpleMessage("أمس، 11:30 م"),
    "lateTime": MessageLookupByLibrary.simpleMessage("وقت التأخير "),
    "leaveForReset": MessageLookupByLibrary.simpleMessage("خروج للراحة"),
    "leaveRecord": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الانصراف في  ",
    ),
    "leaveTime": MessageLookupByLibrary.simpleMessage("وقت الانصراف"),
    "leaving": MessageLookupByLibrary.simpleMessage("انصراف"),
    "location": MessageLookupByLibrary.simpleMessage("موقعي"),
    "locationServicesDisabled": MessageLookupByLibrary.simpleMessage(
      "تم تعطيل خدمات الموقع",
    ),
    "locationSpoofingDetected": MessageLookupByLibrary.simpleMessage(
      "تم اكتشاف استخدام موقع وهمي. سيتم إغلاق التطبيق.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل دخول"),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل خروج"),
    "loyaltyPoints": MessageLookupByLibrary.simpleMessage("نقاط الولاء"),
    "map": MessageLookupByLibrary.simpleMessage("خريطة"),
    "matchTimeFormat": MessageLookupByLibrary.simpleMessage(
      "تنسيق الوقت، 7:00، 12:30",
    ),
    "maxFileSizeHint": MessageLookupByLibrary.simpleMessage(
      "(JPG, PNG, PDF أقصى حجم 5MB)",
    ),
    "menu": MessageLookupByLibrary.simpleMessage("القائمة"),
    "microfone": MessageLookupByLibrary.simpleMessage("ميكروفون"),
    "minutes": MessageLookupByLibrary.simpleMessage("دقائق"),
    "minutesAgo": m8,
    "mobile": MessageLookupByLibrary.simpleMessage("الموبايل"),
    "more": MessageLookupByLibrary.simpleMessage("المزيد"),
    "myRequests": MessageLookupByLibrary.simpleMessage("طلباتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nationalId": MessageLookupByLibrary.simpleMessage(" رقم الهوية"),
    "nationality": MessageLookupByLibrary.simpleMessage("الجنسية"),
    "navCart": MessageLookupByLibrary.simpleMessage("السلة"),
    "navMenu": MessageLookupByLibrary.simpleMessage("القائمة"),
    "navOrders": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "navSettings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "needSignOut": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك بحاجة إلى تسجيل الخروج",
    ),
    "newItems": MessageLookupByLibrary.simpleMessage("جديد 🟢"),
    "noAddons": MessageLookupByLibrary.simpleMessage("بدون إضافات"),
    "noAddonsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد إضافات متاحة",
    ),
    "noCustomerSelected": MessageLookupByLibrary.simpleMessage(
      "لم يتم اختيار عميل",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("لا يوجد بيانات"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت، تحقق من الاتصال وحاول مرة أخرى.",
    ),
    "noReservations": MessageLookupByLibrary.simpleMessage("لا توجد حجوزات"),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
    "noTablesAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد طاولات متاحة",
    ),
    "notActive": MessageLookupByLibrary.simpleMessage("غير نشط"),
    "notAttendance": MessageLookupByLibrary.simpleMessage(
      " لم تقم بتسجيل الحضور بعد",
    ),
    "notLeave": MessageLookupByLibrary.simpleMessage(
      "لم تقم بتسجيل الانصراف بعد",
    ),
    "notPrinted": MessageLookupByLibrary.simpleMessage("لم تتم الطباعة"),
    "notRestaurantCompany": MessageLookupByLibrary.simpleMessage(
      "هذه الشركة ليست شركة مطاعم.",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "notesWithVal": m9,
    "notice": MessageLookupByLibrary.simpleMessage("تنبيه"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "okDialog": MessageLookupByLibrary.simpleMessage("موافق"),
    "openInvoice": MessageLookupByLibrary.simpleMessage("فتح فاتورة"),
    "openSetting": MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "openingBalance": MessageLookupByLibrary.simpleMessage("الرصيد الإفتتاحي"),
    "openingCash": MessageLookupByLibrary.simpleMessage("العهدة الافتتاحية"),
    "openingCustody": MessageLookupByLibrary.simpleMessage("افتتاح عهدة"),
    "openingCustodyTitle": MessageLookupByLibrary.simpleMessage(
      "عهدة افتتاحية",
    ),
    "operationReason": MessageLookupByLibrary.simpleMessage("سبب العملية"),
    "optionalNotes": MessageLookupByLibrary.simpleMessage("ملاحظات (اختياري)"),
    "orderDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الطلب"),
    "orderNumber": MessageLookupByLibrary.simpleMessage("رقم الطلب"),
    "orderProcessedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تمت معالجة الطلب بنجاح وإرساله للمطبخ",
    ),
    "orders": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "ordersCount": m10,
    "other": MessageLookupByLibrary.simpleMessage("أخرى"),
    "outdoorArea": MessageLookupByLibrary.simpleMessage("المنطقة الخارجية"),
    "overallReport": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "paid": MessageLookupByLibrary.simpleMessage("المدفوع"),
    "paidAmount": MessageLookupByLibrary.simpleMessage("المسدد"),
    "partialReturn": MessageLookupByLibrary.simpleMessage("مرتجع جزئي"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "pay": MessageLookupByLibrary.simpleMessage("سداد"),
    "payNow": MessageLookupByLibrary.simpleMessage("سداد"),
    "payment": MessageLookupByLibrary.simpleMessage("الدفع"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
    "paymentMethodBankTransfer": MessageLookupByLibrary.simpleMessage(
      "تحويل بنكي",
    ),
    "paymentMethodCard": MessageLookupByLibrary.simpleMessage("شبكة"),
    "paymentMethodCash": MessageLookupByLibrary.simpleMessage("نقدي"),
    "paymentMethodCredit": MessageLookupByLibrary.simpleMessage("آجل"),
    "paymentMethodLoyalty": MessageLookupByLibrary.simpleMessage("نقاط الولاء"),
    "paymentMethodLoyaltyPoints": MessageLookupByLibrary.simpleMessage(
      "نقاط الولاء",
    ),
    "paymentMethodOther": MessageLookupByLibrary.simpleMessage("... أخرى"),
    "paymentMethodVisa": MessageLookupByLibrary.simpleMessage("فيزا"),
    "paymentMethodVoucher": MessageLookupByLibrary.simpleMessage("قسيمة شراء"),
    "paymentSuccessful": MessageLookupByLibrary.simpleMessage("تم الدفع بنجاح"),
    "pending": MessageLookupByLibrary.simpleMessage("في الانتظار"),
    "percentageDiscount": MessageLookupByLibrary.simpleMessage(
      "نسبة مئوية (%)",
    ),
    "performancePanel": MessageLookupByLibrary.simpleMessage("لوحة الأداء"),
    "period": MessageLookupByLibrary.simpleMessage("الفترة"),
    "permission": MessageLookupByLibrary.simpleMessage("إذن"),
    "permissionType": MessageLookupByLibrary.simpleMessage("نوع الإذن"),
    "permissions": MessageLookupByLibrary.simpleMessage("أذونات"),
    "permissionsReports": MessageLookupByLibrary.simpleMessage(
      "تقارير الأذونات",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "المعلومات الشخصية",
    ),
    "pettyExpenses": MessageLookupByLibrary.simpleMessage("مصروفات نثرية"),
    "phone": MessageLookupByLibrary.simpleMessage("التليفون"),
    "phoneNumbers": MessageLookupByLibrary.simpleMessage("رقم الجوال"),
    "play": MessageLookupByLibrary.simpleMessage("تشغيل"),
    "pleaseCheckInFirst": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الحضور أولاً",
    ),
    "pleaseFill": MessageLookupByLibrary.simpleMessage("يرجى ملء"),
    "pleaseSelectValidCustomer": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار عميل صالح.",
    ),
    "pleaseSelectValidDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار شركة توصيل صالحة.",
    ),
    "pleaseSelectValidDeliveryManAndAddress":
        MessageLookupByLibrary.simpleMessage(
          "يرجى اختيار مندوب توصيل وعنوان صالحين.",
        ),
    "pleaseSelectValidDineInTableandWaiter":
        MessageLookupByLibrary.simpleMessage("يرجى اختيار طاولة ونادل صالحين."),
    "pleaseSelectValidFromBranchDateTime": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار فرع وتاريخ/وقت صالحين.",
    ),
    "pleaseSelectValidSize": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار حجم صالح.",
    ),
    "pleaseSelectValidTakeawayDateTime": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار تاريخ ووقت صالحين للاستلام.",
    ),
    "plusPriceWithCurrency": m11,
    "pm": MessageLookupByLibrary.simpleMessage("مساءً"),
    "popular": MessageLookupByLibrary.simpleMessage("شائع"),
    "pos": MessageLookupByLibrary.simpleMessage("نقطة البيع"),
    "preview": MessageLookupByLibrary.simpleMessage("معاينة"),
    "previousOrders": MessageLookupByLibrary.simpleMessage("طلبات سابقة"),
    "priceWithCurrency": m12,
    "print": MessageLookupByLibrary.simpleMessage("طباعة"),
    "printReceipt": MessageLookupByLibrary.simpleMessage("طباعة إيصال"),
    "printWithApproval": MessageLookupByLibrary.simpleMessage(
      "طباعة مع الإعتماد",
    ),
    "printed": MessageLookupByLibrary.simpleMessage("تمت الطباعة"),
    "productSize": MessageLookupByLibrary.simpleMessage("حجم المنتج"),
    "project": MessageLookupByLibrary.simpleMessage("المشروع"),
    "quantityWithCount": m13,
    "quickAccessList": MessageLookupByLibrary.simpleMessage(
      "قائمة الوصول السريع",
    ),
    "readSentance": MessageLookupByLibrary.simpleMessage(
      "من فضلك، اقرأ السطر أدناه بصوت واضح لقبول الحضور",
    ),
    "recentTransactionsSummary": MessageLookupByLibrary.simpleMessage(
      "ملخص آخر العمليات",
    ),
    "record": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "recordPresenceAndLeave": MessageLookupByLibrary.simpleMessage(
      "تسجيل الحضور والإجازة",
    ),
    "referenceNumber": MessageLookupByLibrary.simpleMessage("رقم المرجع"),
    "registeredCustomer": MessageLookupByLibrary.simpleMessage("عميل مسجل"),
    "reject": MessageLookupByLibrary.simpleMessage("رفض"),
    "rejected": MessageLookupByLibrary.simpleMessage("مرفوض"),
    "religion": MessageLookupByLibrary.simpleMessage("الديانة"),
    "remaining": MessageLookupByLibrary.simpleMessage("المتبقي"),
    "remainingAmount": MessageLookupByLibrary.simpleMessage("المتبقي"),
    "rememberMe": MessageLookupByLibrary.simpleMessage("تذكرني"),
    "reports": MessageLookupByLibrary.simpleMessage("تقارير "),
    "requestFailed": MessageLookupByLibrary.simpleMessage("فشل إرسال الطلب"),
    "requestFingerPrint": MessageLookupByLibrary.simpleMessage(
      "طلب تسجيل بصمة",
    ),
    "requestLeave": MessageLookupByLibrary.simpleMessage("طلب إجازة"),
    "requestLocationPermission": MessageLookupByLibrary.simpleMessage(
      "ليس لديك إذن للوصول إلى الموقع، وهو مطلوب لاستخدام التطبيق. هل ترغب في طلب الإذن الآن؟",
    ),
    "requestNumber": MessageLookupByLibrary.simpleMessage("رقم الطلب"),
    "requestSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الطلب بنجاح",
    ),
    "requestType": MessageLookupByLibrary.simpleMessage("نوع الطلب"),
    "requests": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "reservationPeriod": MessageLookupByLibrary.simpleMessage("فترة الحجز"),
    "reservationPeriodInMinutes": m14,
    "reservationSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إضافة الحجز بنجاح",
    ),
    "reservations": MessageLookupByLibrary.simpleMessage("الحجوزات"),
    "reserved": MessageLookupByLibrary.simpleMessage("محجوز"),
    "restMinutes": MessageLookupByLibrary.simpleMessage("راحة 60 دقيقة"),
    "restaurantManager": MessageLookupByLibrary.simpleMessage("مدير المطعم"),
    "restoreOrder": MessageLookupByLibrary.simpleMessage("استعادة الطلب"),
    "resumeSession": MessageLookupByLibrary.simpleMessage("استئناف الجلسة"),
    "retry": MessageLookupByLibrary.simpleMessage("حاول ثانية"),
    "returns": MessageLookupByLibrary.simpleMessage("المرتجع"),
    "salaries": MessageLookupByLibrary.simpleMessage("الرواتب"),
    "salesScreen": MessageLookupByLibrary.simpleMessage("شاشة البيع"),
    "salesScreenSubtitle": MessageLookupByLibrary.simpleMessage(
      "الوصول إلى لوحة التحكم والطلبات والمبيعات",
    ),
    "sar": MessageLookupByLibrary.simpleMessage("ر.س"),
    "saudiRiyal": MessageLookupByLibrary.simpleMessage("ريال سعودي"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "saveAndOpenShift": MessageLookupByLibrary.simpleMessage(
      "حفظ وفتح الوردية",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "فشل الحفظ. يرجى المحاولة مرة أخرى.",
    ),
    "savedSuccessfully": MessageLookupByLibrary.simpleMessage("تم الحفظ بنجاح"),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchCustomerHint": MessageLookupByLibrary.simpleMessage(
      "ابحث بالاسم أو رقم الهاتف",
    ),
    "seats": MessageLookupByLibrary.simpleMessage("مقاعد"),
    "seatsAndDurationHeader": MessageLookupByLibrary.simpleMessage(
      "المقاعد / المدة",
    ),
    "secondFloor": MessageLookupByLibrary.simpleMessage("الدور الثاني"),
    "section": MessageLookupByLibrary.simpleMessage("القسم"),
    "securityWarning": MessageLookupByLibrary.simpleMessage("تحذير أمني"),
    "selectBranch": MessageLookupByLibrary.simpleMessage("اختر الفرع"),
    "selectCustomer": MessageLookupByLibrary.simpleMessage("اختر عميل"),
    "selectDateAndTimeError": MessageLookupByLibrary.simpleMessage(
      "الرجاء تحديد التاريخ والوقت",
    ),
    "selectDeliveryAgent": MessageLookupByLibrary.simpleMessage(
      "اختر عامل التوصيل",
    ),
    "selectFloor": MessageLookupByLibrary.simpleMessage("اختر الطابق"),
    "selectInvoiceType": MessageLookupByLibrary.simpleMessage(
      "اختر نوع الفاتورة",
    ),
    "selectReason": MessageLookupByLibrary.simpleMessage("اختر السبب"),
    "selectReservationPeriod": MessageLookupByLibrary.simpleMessage(
      "اختر فترة الحجز",
    ),
    "selectSafe": MessageLookupByLibrary.simpleMessage("اختر الخزينة"),
    "selectTable": MessageLookupByLibrary.simpleMessage("اختيار الطاولة"),
    "selectTableHint": MessageLookupByLibrary.simpleMessage("اختر الطاولة"),
    "selectWaiter": MessageLookupByLibrary.simpleMessage("اختر الويتر"),
    "selected": MessageLookupByLibrary.simpleMessage("محدد"),
    "selectedTable": MessageLookupByLibrary.simpleMessage("الطاولة المحددة"),
    "send": MessageLookupByLibrary.simpleMessage("إرسال"),
    "sessionExpired": MessageLookupByLibrary.simpleMessage("انتهت الجلسة"),
    "shift": MessageLookupByLibrary.simpleMessage("الدوام"),
    "shift1": MessageLookupByLibrary.simpleMessage("الفترة الأولى"),
    "shift2": MessageLookupByLibrary.simpleMessage("الفترة الثانية"),
    "shift3": MessageLookupByLibrary.simpleMessage("الفترة الثالثة"),
    "shift4": MessageLookupByLibrary.simpleMessage("الفترة الرابعة"),
    "shiftNotStarted": MessageLookupByLibrary.simpleMessage(
      "الوردية لم تبدأ بعد",
    ),
    "shiftStart": MessageLookupByLibrary.simpleMessage("بداية الوردية"),
    "shiftToSecondDay": MessageLookupByLibrary.simpleMessage(
      "الشفت ممتد لليوم التالي",
    ),
    "shoppingCart": MessageLookupByLibrary.simpleMessage("سلة المشتريات"),
    "sickLeave": MessageLookupByLibrary.simpleMessage("إجازة مرضية"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الحضور"),
    "signInSubtitle": MessageLookupByLibrary.simpleMessage(
      "قم بتسجيل حضورك لبدء وردية العمل الجديدة",
    ),
    "signOut": MessageLookupByLibrary.simpleMessage("تسجيل الانصراف"),
    "signOutTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "singleItemCount": MessageLookupByLibrary.simpleMessage("1 صنف"),
    "sizeWithVal": m15,
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("حدث خطأ ما"),
    "specialDiscount": MessageLookupByLibrary.simpleMessage("خصم خاص"),
    "specialNotes": MessageLookupByLibrary.simpleMessage("ملاحظات خاصة"),
    "specialNotesHint": MessageLookupByLibrary.simpleMessage(
      "مثال: زيادة تسوية، وضع الصوص في علبة خارجية...",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("تاريخ البداية"),
    "status": MessageLookupByLibrary.simpleMessage("الحالة"),
    "stop": MessageLookupByLibrary.simpleMessage("إيقاف"),
    "streetName": MessageLookupByLibrary.simpleMessage("اسم الشارع"),
    "subtotal": MessageLookupByLibrary.simpleMessage("المجموع الفرعي"),
    "supplierPayment": MessageLookupByLibrary.simpleMessage("دفع مورد"),
    "sureDelete": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك بحاجة إلى حذف هذا الطلب",
    ),
    "surplus": MessageLookupByLibrary.simpleMessage("الفائض"),
    "suspendSession": MessageLookupByLibrary.simpleMessage("تعليق الجلسة"),
    "systemTime": MessageLookupByLibrary.simpleMessage("توقيت النظام"),
    "table": MessageLookupByLibrary.simpleMessage("طاولة"),
    "tableArrangement": MessageLookupByLibrary.simpleMessage("ترتيب الطاولات"),
    "tables": MessageLookupByLibrary.simpleMessage("الطاولات"),
    "takeaway": MessageLookupByLibrary.simpleMessage("سفري"),
    "takeawayOrder": MessageLookupByLibrary.simpleMessage("طلب سفري"),
    "tapAnyItemToAdd": MessageLookupByLibrary.simpleMessage(
      "اضغط على أي صنف لإضافته إلى الطلب",
    ),
    "tapItemsToSelect": MessageLookupByLibrary.simpleMessage(
      "اضغط على العناصر للاختيار",
    ),
    "task": MessageLookupByLibrary.simpleMessage("المهمة"),
    "tax": MessageLookupByLibrary.simpleMessage("الضريبة"),
    "temporary": MessageLookupByLibrary.simpleMessage("مؤقت"),
    "thisItemHasNoValidSize": MessageLookupByLibrary.simpleMessage(
      "لا يحتوي هذا الصنف على حجم صالح.",
    ),
    "time": MessageLookupByLibrary.simpleMessage("الوقت"),
    "timeFormatHint": MessageLookupByLibrary.simpleMessage("hh:mm"),
    "timesOfWork": MessageLookupByLibrary.simpleMessage("مواعيد الدوام"),
    "to": MessageLookupByLibrary.simpleMessage("إلى"),
    "toDate": MessageLookupByLibrary.simpleMessage("إلى تاريخ"),
    "toRestaurant": MessageLookupByLibrary.simpleMessage("للمطعم"),
    "tobaccoVat": MessageLookupByLibrary.simpleMessage("ضريبة التبغ"),
    "todayOffers": MessageLookupByLibrary.simpleMessage("عروض اليوم 🎁"),
    "total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "totalAdditions": MessageLookupByLibrary.simpleMessage("إجمالي الإضافات"),
    "totalAmountRequired": MessageLookupByLibrary.simpleMessage(
      "إجمالي المبلغ المطلوب",
    ),
    "totalDays": MessageLookupByLibrary.simpleMessage("إجمالي مدة الإجازات"),
    "totalHeldOrders": MessageLookupByLibrary.simpleMessage(
      "إجمالي الطلبات المعلقة",
    ),
    "totalInvoices": MessageLookupByLibrary.simpleMessage("إجمالي الفواتير"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("إجمالي المبلغ المدفوع"),
    "totalWithdrawals": MessageLookupByLibrary.simpleMessage("إجمالي السحوبات"),
    "transaction": MessageLookupByLibrary.simpleMessage(" الحضور "),
    "transactionAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تمت إضافة المعاملة بنجاح",
    ),
    "transactionDate": MessageLookupByLibrary.simpleMessage("تاريخ العملية"),
    "transactionLog": MessageLookupByLibrary.simpleMessage("سجل الحركات"),
    "transferFromManagement": MessageLookupByLibrary.simpleMessage(
      "تحويل من الإدارة",
    ),
    "type": MessageLookupByLibrary.simpleMessage("النوع"),
    "typeOfLeave": MessageLookupByLibrary.simpleMessage("نوع الإجازة"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع. حاول مرة أخرى.",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "user": MessageLookupByLibrary.simpleMessage("المستخدم"),
    "userProfile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "vacations": MessageLookupByLibrary.simpleMessage("الإجازات"),
    "vaccations": MessageLookupByLibrary.simpleMessage("إجازات"),
    "vaccationsReports": MessageLookupByLibrary.simpleMessage(
      "تقارير الإجازات",
    ),
    "vat": MessageLookupByLibrary.simpleMessage("ضريبة القيمة المضافة"),
    "vatPrecentage": m16,
    "verificationFailed": MessageLookupByLibrary.simpleMessage("فشل التحقق"),
    "verified": MessageLookupByLibrary.simpleMessage("تم التحقق"),
    "viewCart": MessageLookupByLibrary.simpleMessage("عرض السلة"),
    "viewFullCustodyLog": MessageLookupByLibrary.simpleMessage(
      "عرض سجل العهدة بالكامل",
    ),
    "visa": MessageLookupByLibrary.simpleMessage("فيزا"),
    "voucher": MessageLookupByLibrary.simpleMessage("قسيمة شراء"),
    "voucherApplied": m17,
    "waitLocation": MessageLookupByLibrary.simpleMessage(
      "يرجى الانتظار حتي يتم تحميل بيانات الموقع الحالى",
    ),
    "waiting": MessageLookupByLibrary.simpleMessage("انتظار"),
    "welcome": MessageLookupByLibrary.simpleMessage("أهلا بك!"),
    "withdrawCustody": MessageLookupByLibrary.simpleMessage("سحب عهدة"),
    "withdrawExpenses": MessageLookupByLibrary.simpleMessage("سحب مصروفات"),
    "withdrawalTag": MessageLookupByLibrary.simpleMessage("سحب"),
    "withdrawals": MessageLookupByLibrary.simpleMessage("سحوبات"),
    "withdrawalsFilter": MessageLookupByLibrary.simpleMessage("السحوبات"),
    "workHours": MessageLookupByLibrary.simpleMessage("ساعات الدوام"),
    "workTime": MessageLookupByLibrary.simpleMessage("وقت الدوام"),
    "writeOperationDetailsHint": MessageLookupByLibrary.simpleMessage(
      "اكتب تفاصيل العملية هنا ....",
    ),
  };
}
