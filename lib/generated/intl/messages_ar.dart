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

  static String m2(year, month, day, hour, minute) =>
      "${year}/${month}/${day} - ${hour}:${minute}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'صنف واحد', two: 'صنفان', few: '${count} أصناف', many: '${count} صنفاً', other: '${count} صنف')}";

  static String m4(notes) => "ملاحظات: ${notes}";

  static String m5(price) => "+${price} ر.س";

  static String m6(price) => "${price} ر.س";

  static String m7(quantity) => "الكمية: ${quantity}";

  static String m8(size) => "الحجم: ${size}";

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
    "actualWorkingHours": MessageLookupByLibrary.simpleMessage(
      "ساعات العمل الفعلية",
    ),
    "addAdditives": MessageLookupByLibrary.simpleMessage("إضافة إضافات"),
    "addCustomer": MessageLookupByLibrary.simpleMessage("إضافة عميل"),
    "addNotesHint": MessageLookupByLibrary.simpleMessage("أضف ملاحظاتك هنا..."),
    "addToCartWithPrice": m0,
    "addons": MessageLookupByLibrary.simpleMessage("الإضافات"),
    "addonsWithVal": m1,
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "am": MessageLookupByLibrary.simpleMessage("صباحا"),
    "amountDue": MessageLookupByLibrary.simpleMessage("المستحق"),
    "amountPaid": MessageLookupByLibrary.simpleMessage("المسدد"),
    "amountRemaining": MessageLookupByLibrary.simpleMessage("المتبقي"),
    "annual": MessageLookupByLibrary.simpleMessage("إجازة"),
    "annualLeave": MessageLookupByLibrary.simpleMessage("إجازة سنوية"),
    "apply": MessageLookupByLibrary.simpleMessage("تطبيق"),
    "approvals": MessageLookupByLibrary.simpleMessage("الاعتمادات"),
    "approved": MessageLookupByLibrary.simpleMessage("موافق عليه"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
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
    "badeResponse": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ يرجى تسجيل الدخول مرة أخرى",
    ),
    "badgeNew": MessageLookupByLibrary.simpleMessage("جديد"),
    "badgeOffer": MessageLookupByLibrary.simpleMessage("عرض"),
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
    "branchs": MessageLookupByLibrary.simpleMessage("الفروع"),
    "btnNewOrder": MessageLookupByLibrary.simpleMessage("طلب جديد"),
    "btnPreviousOrders": MessageLookupByLibrary.simpleMessage(
      "الطلبات السابقة",
    ),
    "btnPrintKitchen": MessageLookupByLibrary.simpleMessage("طباعة مطبخ"),
    "btnPrintReceipt": MessageLookupByLibrary.simpleMessage("طباعة إيصال"),
    "camera": MessageLookupByLibrary.simpleMessage("كاميرا"),
    "cancel": MessageLookupByLibrary.simpleMessage(" إلغاء"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى التحقق من بريدك الإلكتروني لتعليمات إعادة تعيين كلمة المرور.",
    ),
    "checkout": MessageLookupByLibrary.simpleMessage("إتمام الدفع"),
    "chooseDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "اختر شركة التوصيل",
    ),
    "clearAll": MessageLookupByLibrary.simpleMessage("مسح الكل"),
    "closeApp": MessageLookupByLibrary.simpleMessage("إغلاق التطبيق"),
    "comeFromReset": MessageLookupByLibrary.simpleMessage("العودة من الراحة"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("تأكيد الإجراء"),
    "confirmAdditives": MessageLookupByLibrary.simpleMessage("تأكيد الإضافات"),
    "controlBoard": MessageLookupByLibrary.simpleMessage("لوحة التحكم"),
    "coupon": MessageLookupByLibrary.simpleMessage("كوبون"),
    "currencySar": MessageLookupByLibrary.simpleMessage("ريال سعودي"),
    "currencySarShort": MessageLookupByLibrary.simpleMessage("ر.س"),
    "currentOrder": MessageLookupByLibrary.simpleMessage("الطلب الحالي"),
    "currentStatusOffShift": MessageLookupByLibrary.simpleMessage(
      "الحالة الحالية: خارج الوردية",
    ),
    "customizationSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر الحجم المناسب والإضافات المرغوبة",
    ),
    "dailyWorkingHours": MessageLookupByLibrary.simpleMessage(
      "من 9:00 صباحًا الي 6:00 مساءً",
    ),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "dateWarning": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون تاريخ البدء قبل تاريخ الانتهاء",
    ),
    "day": MessageLookupByLibrary.simpleMessage("اليوم"),
    "dayStatus": MessageLookupByLibrary.simpleMessage("حالة اليوم"),
    "days": MessageLookupByLibrary.simpleMessage("ايام"),
    "dbName": MessageLookupByLibrary.simpleMessage("اسم قاعدة البيانات"),
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
    "dineInOrder": MessageLookupByLibrary.simpleMessage("طلب صالة"),
    "directDiscount": MessageLookupByLibrary.simpleMessage("خصم مباشر"),
    "directManager": MessageLookupByLibrary.simpleMessage("المدير المباشر"),
    "discountCoupon": MessageLookupByLibrary.simpleMessage("الخصم (كوبون)"),
    "duration": MessageLookupByLibrary.simpleMessage("المدة"),
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
    "extraTime": MessageLookupByLibrary.simpleMessage("وقت إضافي "),
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
    "fixedAmountDiscount": MessageLookupByLibrary.simpleMessage("قيمة ثابتة"),
    "floors": MessageLookupByLibrary.simpleMessage("الطوابق"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "formattedDateTime": m2,
    "free": MessageLookupByLibrary.simpleMessage("مجاناً"),
    "from": MessageLookupByLibrary.simpleMessage("من"),
    "fromDate": MessageLookupByLibrary.simpleMessage("من تاريخ"),
    "fullDay": MessageLookupByLibrary.simpleMessage("يومى"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("الإجمالي النهائي"),
    "group": MessageLookupByLibrary.simpleMessage("المجموعة"),
    "holdOrder": MessageLookupByLibrary.simpleMessage("تعليق الطلب"),
    "holidayNotSelected": MessageLookupByLibrary.simpleMessage(
      "برجاء اختيار نوع الإجازة",
    ),
    "home": MessageLookupByLibrary.simpleMessage("الصفحة الرئيسية"),
    "homeSubtitle": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار الإجراء المطلوب للمتابعة",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("ساعة"),
    "identityConfirmed": MessageLookupByLibrary.simpleMessage(
      "تم تأكيد الهوية",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("غير نشط"),
    "insertDBName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم قاعدة البيانات",
    ),
    "insertEmail": MessageLookupByLibrary.simpleMessage(
      "أدخل البريد الإلكتروني",
    ),
    "insertPassword": MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
    "invoiceNumber": MessageLookupByLibrary.simpleMessage("رقم الفاتورة"),
    "itemsCount": m3,
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
    "map": MessageLookupByLibrary.simpleMessage("خريطة"),
    "matchTimeFormat": MessageLookupByLibrary.simpleMessage(
      "تنسيق الوقت، 7:00، 12:30",
    ),
    "microfone": MessageLookupByLibrary.simpleMessage("ميكروفون"),
    "mobile": MessageLookupByLibrary.simpleMessage("الموبايل"),
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
    "noAddons": MessageLookupByLibrary.simpleMessage("بدون إضافات"),
    "noDataFound": MessageLookupByLibrary.simpleMessage("لا يوجد بيانات"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت، تحقق من الاتصال وحاول مرة أخرى.",
    ),
    "notActive": MessageLookupByLibrary.simpleMessage("غير نشط"),
    "notAttendance": MessageLookupByLibrary.simpleMessage(
      " لم تقم بتسجيل الحضور بعد",
    ),
    "notLeave": MessageLookupByLibrary.simpleMessage(
      "لم تقم بتسجيل الانصراف بعد",
    ),
    "notRestaurantCompany": MessageLookupByLibrary.simpleMessage(
      "هذه الشركة ليست شركة مطاعم.",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "notesWithVal": m4,
    "notice": MessageLookupByLibrary.simpleMessage("تنبيه"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "okDialog": MessageLookupByLibrary.simpleMessage("موافق"),
    "openSetting": MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
    "openingCash": MessageLookupByLibrary.simpleMessage("العهدة الافتتاحية"),
    "optionalNotes": MessageLookupByLibrary.simpleMessage("ملاحظات (اختياري)"),
    "orderDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الطلب"),
    "orderNumber": MessageLookupByLibrary.simpleMessage("رقم الطلب"),
    "orderProcessedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تمت معالجة الطلب بنجاح وإرساله للمطبخ",
    ),
    "overallReport": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "pay": MessageLookupByLibrary.simpleMessage("دفع"),
    "payment": MessageLookupByLibrary.simpleMessage("الدفع"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
    "paymentMethodBankTransfer": MessageLookupByLibrary.simpleMessage(
      "تحويل بنكي",
    ),
    "paymentMethodCard": MessageLookupByLibrary.simpleMessage("شبكة"),
    "paymentMethodCash": MessageLookupByLibrary.simpleMessage("نقدي"),
    "paymentMethodCredit": MessageLookupByLibrary.simpleMessage("آجل"),
    "paymentMethodLoyaltyPoints": MessageLookupByLibrary.simpleMessage(
      "نقاط الولاء",
    ),
    "paymentMethodOther": MessageLookupByLibrary.simpleMessage("... أخرى"),
    "paymentMethodVisa": MessageLookupByLibrary.simpleMessage("فيزا"),
    "paymentMethodVoucher": MessageLookupByLibrary.simpleMessage("قسيمة شراء"),
    "paymentSuccessful": MessageLookupByLibrary.simpleMessage("تم الدفع بنجاح"),
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
    "phoneNumbers": MessageLookupByLibrary.simpleMessage("رقم الجوال"),
    "play": MessageLookupByLibrary.simpleMessage("تشغيل"),
    "pleaseCheckInFirst": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الحضور أولاً",
    ),
    "pleaseFill": MessageLookupByLibrary.simpleMessage("يرجى ملء"),
    "plusPriceWithCurrency": m5,
    "pm": MessageLookupByLibrary.simpleMessage("مساءً"),
    "popular": MessageLookupByLibrary.simpleMessage("شائع"),
    "pos": MessageLookupByLibrary.simpleMessage("نقطة البيع"),
    "priceWithCurrency": m6,
    "productSize": MessageLookupByLibrary.simpleMessage("حجم المنتج"),
    "project": MessageLookupByLibrary.simpleMessage("المشروع"),
    "quantityWithCount": m7,
    "quickAccessList": MessageLookupByLibrary.simpleMessage(
      "قائمة الوصول السريع",
    ),
    "readSentance": MessageLookupByLibrary.simpleMessage(
      "من فضلك، اقرأ السطر أدناه بصوت واضح لقبول الحضور",
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
    "restMinutes": MessageLookupByLibrary.simpleMessage("راحة 60 دقيقة"),
    "restaurantManager": MessageLookupByLibrary.simpleMessage("مدير المطعم"),
    "retry": MessageLookupByLibrary.simpleMessage("حاول ثانية"),
    "salaries": MessageLookupByLibrary.simpleMessage("الرواتب"),
    "salesScreen": MessageLookupByLibrary.simpleMessage("شاشة البيع"),
    "salesScreenSubtitle": MessageLookupByLibrary.simpleMessage(
      "الوصول إلى لوحة التحكم والطلبات والمبيعات",
    ),
    "sar": MessageLookupByLibrary.simpleMessage("ر.س"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "saveAndOpenShift": MessageLookupByLibrary.simpleMessage(
      "حفظ وفتح الوردية",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "فشل الحفظ. يرجى المحاولة مرة أخرى.",
    ),
    "savedSuccessfully": MessageLookupByLibrary.simpleMessage("تم الحفظ بنجاح"),
    "section": MessageLookupByLibrary.simpleMessage("القسم"),
    "securityWarning": MessageLookupByLibrary.simpleMessage("تحذير أمني"),
    "selectBranch": MessageLookupByLibrary.simpleMessage("اختر الفرع"),
    "selectDeliveryAgent": MessageLookupByLibrary.simpleMessage(
      "اختر عامل التوصيل",
    ),
    "selectInvoiceType": MessageLookupByLibrary.simpleMessage(
      "اختر نوع الفاتورة",
    ),
    "selectTable": MessageLookupByLibrary.simpleMessage("اختيار الطاولة"),
    "selectWaiter": MessageLookupByLibrary.simpleMessage("اختر الويتر"),
    "selected": MessageLookupByLibrary.simpleMessage("محدد"),
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
    "sizeWithVal": m8,
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
    "subtotal": MessageLookupByLibrary.simpleMessage("المجموع الفرعي"),
    "sureDelete": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك بحاجة إلى حذف هذا الطلب",
    ),
    "systemTime": MessageLookupByLibrary.simpleMessage("توقيت النظام"),
    "table": MessageLookupByLibrary.simpleMessage("طاولة"),
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
    "timesOfWork": MessageLookupByLibrary.simpleMessage("مواعيد الدوام"),
    "to": MessageLookupByLibrary.simpleMessage("إلى"),
    "toDate": MessageLookupByLibrary.simpleMessage("إلى تاريخ"),
    "toRestaurant": MessageLookupByLibrary.simpleMessage("للمطعم"),
    "total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "totalAmountRequired": MessageLookupByLibrary.simpleMessage(
      "إجمالي المبلغ المطلوب",
    ),
    "totalDays": MessageLookupByLibrary.simpleMessage("إجمالي مدة الإجازات"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("إجمالي المبلغ المدفوع"),
    "transaction": MessageLookupByLibrary.simpleMessage(" الحضور "),
    "transactionDate": MessageLookupByLibrary.simpleMessage("تاريخ العملية"),
    "typeOfLeave": MessageLookupByLibrary.simpleMessage("نوع الإجازة"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع. حاول مرة أخرى.",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "vacations": MessageLookupByLibrary.simpleMessage("الإجازات"),
    "vaccations": MessageLookupByLibrary.simpleMessage("إجازات"),
    "vaccationsReports": MessageLookupByLibrary.simpleMessage(
      "تقارير الإجازات",
    ),
    "vat": MessageLookupByLibrary.simpleMessage("ضريبة القيمة المضافة"),
    "vat15": MessageLookupByLibrary.simpleMessage("ضريبة القيمة المضافة (15%)"),
    "verificationFailed": MessageLookupByLibrary.simpleMessage("فشل التحقق"),
    "verified": MessageLookupByLibrary.simpleMessage("تم التحقق"),
    "viewCart": MessageLookupByLibrary.simpleMessage("عرض السلة"),
    "waitLocation": MessageLookupByLibrary.simpleMessage(
      "يرجى الانتظار حتي يتم تحميل بيانات الموقع الحالى",
    ),
    "waiting": MessageLookupByLibrary.simpleMessage("انتظار"),
    "welcome": MessageLookupByLibrary.simpleMessage("أهلا بك!"),
    "workHours": MessageLookupByLibrary.simpleMessage("ساعات الدوام"),
    "workTime": MessageLookupByLibrary.simpleMessage("وقت الدوام"),
  };
}
