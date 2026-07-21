// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(price) => "Add to Cart ${price} SAR";

  static String m1(addons) => "Add-ons: ${addons}";

  static String m2(year, month, day, hour, minute) =>
      "${year}/${month}/${day} - ${hour}:${minute}";

  static String m3(count) =>
      "${Intl.plural(count, one: '1 Item', other: '${count} Items')}";

  static String m4(notes) => "Notes: ${notes}";

  static String m5(price) => "+${price} SAR";

  static String m6(price) => "${price} SAR";

  static String m7(quantity) => "Qty: ${quantity}";

  static String m8(size) => "Size: ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Email": MessageLookupByLibrary.simpleMessage("Email"),
    "PleaseAuthenticateToLogin": MessageLookupByLibrary.simpleMessage(
      "Please authenticate to login",
    ),
    "RequestPermission": MessageLookupByLibrary.simpleMessage(
      "Request Permission",
    ),
    "absence": MessageLookupByLibrary.simpleMessage("Absence"),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "accessDenied": MessageLookupByLibrary.simpleMessage("Access Denied"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "activeNow": MessageLookupByLibrary.simpleMessage("Active Now"),
    "actualWorkingHours": MessageLookupByLibrary.simpleMessage(
      "Actual WorkingHours",
    ),
    "addAdditives": MessageLookupByLibrary.simpleMessage("Add Additives"),
    "addCustomer": MessageLookupByLibrary.simpleMessage("Add Customer"),
    "addNotesHint": MessageLookupByLibrary.simpleMessage(
      "Add your notes here...",
    ),
    "addToCartWithPrice": m0,
    "addons": MessageLookupByLibrary.simpleMessage("Add-ons"),
    "addonsWithVal": m1,
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "am": MessageLookupByLibrary.simpleMessage("A.M"),
    "amountDue": MessageLookupByLibrary.simpleMessage("Amount Due"),
    "amountPaid": MessageLookupByLibrary.simpleMessage("Amount Paid"),
    "amountRemaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "annual": MessageLookupByLibrary.simpleMessage("Annual"),
    "annualLeave": MessageLookupByLibrary.simpleMessage("Annual leave"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "approvals": MessageLookupByLibrary.simpleMessage("Approvals"),
    "approved": MessageLookupByLibrary.simpleMessage("Approved"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "attendance": MessageLookupByLibrary.simpleMessage("Attendance"),
    "attendanceMethod": MessageLookupByLibrary.simpleMessage(
      "Attendance Method",
    ),
    "attendanceMovementsToday": MessageLookupByLibrary.simpleMessage(
      "Movements today",
    ),
    "attendanceRecord": MessageLookupByLibrary.simpleMessage(
      "Attendance recorded at ",
    ),
    "attendanceReports": MessageLookupByLibrary.simpleMessage(
      "Attendance Reports",
    ),
    "attendanceTime": MessageLookupByLibrary.simpleMessage("Attendance Time"),
    "badeResponse": MessageLookupByLibrary.simpleMessage(
      "bad response please login again",
    ),
    "badgeNew": MessageLookupByLibrary.simpleMessage("New"),
    "badgeOffer": MessageLookupByLibrary.simpleMessage("Offer"),
    "biometricAuthenticationCanceled": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication canceled by user.",
    ),
    "biometricAuthenticationError": MessageLookupByLibrary.simpleMessage(
      "An error occurred during biometric authentication. Please try again.",
    ),
    "biometricAuthenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication failed. Please try again.",
    ),
    "biometricAuthenticationInProgress": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication is already in progress. Please wait.",
    ),
    "biometricAuthenticationLockout": MessageLookupByLibrary.simpleMessage(
      "Too many failed attempts. Biometric authentication is temporarily locked out. Please try again later.",
    ),
    "biometricAuthenticationSuccess": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication successful. Logging in...",
    ),
    "biometricNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication is not available on this device.",
    ),
    "biometricNotEnrolled": MessageLookupByLibrary.simpleMessage(
      "No biometric credentials are enrolled. Please set up biometric authentication in your device settings.",
    ),
    "biometricRequired": MessageLookupByLibrary.simpleMessage(
      "Oops! Biometric authentication required!",
    ),
    "birthDate": MessageLookupByLibrary.simpleMessage("Birth Date"),
    "branch": MessageLookupByLibrary.simpleMessage("Branch"),
    "branchs": MessageLookupByLibrary.simpleMessage("Branchs"),
    "btnNewOrder": MessageLookupByLibrary.simpleMessage("New Order"),
    "btnPreviousOrders": MessageLookupByLibrary.simpleMessage(
      "Previous Orders",
    ),
    "btnPrintKitchen": MessageLookupByLibrary.simpleMessage("Print Kitchen"),
    "btnPrintReceipt": MessageLookupByLibrary.simpleMessage("Print Receipt"),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage(
      "Please check your email for password reset instructions.",
    ),
    "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
    "chooseDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "Choose Delivery Company",
    ),
    "clearAll": MessageLookupByLibrary.simpleMessage("Clear All"),
    "closeApp": MessageLookupByLibrary.simpleMessage("Close App"),
    "comeFromReset": MessageLookupByLibrary.simpleMessage("Come from reset"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm Action"),
    "confirmAdditives": MessageLookupByLibrary.simpleMessage(
      "Confirm additives",
    ),
    "controlBoard": MessageLookupByLibrary.simpleMessage("Control Board"),
    "coupon": MessageLookupByLibrary.simpleMessage("Coupon"),
    "currencySar": MessageLookupByLibrary.simpleMessage("SAR"),
    "currencySarShort": MessageLookupByLibrary.simpleMessage("SAR"),
    "currentOrder": MessageLookupByLibrary.simpleMessage("Current Order"),
    "currentStatusOffShift": MessageLookupByLibrary.simpleMessage(
      "Current status: Off shift",
    ),
    "customizationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select the appropriate size and desired add-ons",
    ),
    "dailyWorkingHours": MessageLookupByLibrary.simpleMessage(
      "from 9:00 A.M to 6:00 P.M",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateWarning": MessageLookupByLibrary.simpleMessage(
      "The start date must be before the end date",
    ),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "dayStatus": MessageLookupByLibrary.simpleMessage("Day Status"),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "dbName": MessageLookupByLibrary.simpleMessage("DataBase Name"),
    "delivery": MessageLookupByLibrary.simpleMessage("Delivery"),
    "deliveryCompanies": MessageLookupByLibrary.simpleMessage(
      "Delivery Companies",
    ),
    "deliveryCompany": MessageLookupByLibrary.simpleMessage("DeliveryCompany"),
    "deliveryCompanyDetails": MessageLookupByLibrary.simpleMessage(
      "Delivery Company Info",
    ),
    "deliveryFee": MessageLookupByLibrary.simpleMessage("Delivery Fee"),
    "deliveryOrder": MessageLookupByLibrary.simpleMessage("Pickup "),
    "department": MessageLookupByLibrary.simpleMessage("Department"),
    "departures": MessageLookupByLibrary.simpleMessage("Departures"),
    "detailedReport": MessageLookupByLibrary.simpleMessage("Detailed"),
    "dineIn": MessageLookupByLibrary.simpleMessage("Dine-in"),
    "dineInOrder": MessageLookupByLibrary.simpleMessage("Dine-in "),
    "directDiscount": MessageLookupByLibrary.simpleMessage("Direct Discount"),
    "directManager": MessageLookupByLibrary.simpleMessage("Direct Manager"),
    "discountCoupon": MessageLookupByLibrary.simpleMessage("Discount (Coupon)"),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "email": MessageLookupByLibrary.simpleMessage(" Email"),
    "emailNotFound": MessageLookupByLibrary.simpleMessage(
      "Email address not found. Please try again.",
    ),
    "emergencyLeave": MessageLookupByLibrary.simpleMessage("Emergency leave"),
    "employeeBranch": MessageLookupByLibrary.simpleMessage("Employee Branch"),
    "employeeCode": MessageLookupByLibrary.simpleMessage("Employee Code"),
    "employeeDefinition": MessageLookupByLibrary.simpleMessage(
      "Employee Definition",
    ),
    "employeeEmail": MessageLookupByLibrary.simpleMessage("Employee Email"),
    "employeeInformation": MessageLookupByLibrary.simpleMessage(
      "Employee information",
    ),
    "employeeJob": MessageLookupByLibrary.simpleMessage("Employee Job"),
    "employeeMobile": MessageLookupByLibrary.simpleMessage("Employee Mobile"),
    "employeeNameAr": MessageLookupByLibrary.simpleMessage(
      "Employee Name (Arabic)",
    ),
    "employeeNameEn": MessageLookupByLibrary.simpleMessage(
      "Employee Name (English)",
    ),
    "employeeStatus": MessageLookupByLibrary.simpleMessage("Employee Status"),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Enter discount code",
    ),
    "enterDiscountValue": MessageLookupByLibrary.simpleMessage(
      "Enter discount value",
    ),
    "enterTransactionNumber": MessageLookupByLibrary.simpleMessage(
      "Enter transaction number .....",
    ),
    "eventsApprovals": MessageLookupByLibrary.simpleMessage(
      "Events and approvals",
    ),
    "exitApp": MessageLookupByLibrary.simpleMessage("click again to exit"),
    "extraTime": MessageLookupByLibrary.simpleMessage("Extra Time"),
    "filterAll": MessageLookupByLibrary.simpleMessage("All"),
    "filterBestSeller": MessageLookupByLibrary.simpleMessage("🔥 Best Seller"),
    "filterFavorites": MessageLookupByLibrary.simpleMessage("⭐ Favorites"),
    "filterNew": MessageLookupByLibrary.simpleMessage("🆕 New"),
    "filterTodayOffers": MessageLookupByLibrary.simpleMessage(
      "🎁 Today\'s Offers",
    ),
    "fingerPrint": MessageLookupByLibrary.simpleMessage("Fingerprint"),
    "fingerPrintType": MessageLookupByLibrary.simpleMessage("Fingerprint Type"),
    "fingerPrints": MessageLookupByLibrary.simpleMessage("Fingerprints"),
    "fixedAmountDiscount": MessageLookupByLibrary.simpleMessage("Fixed Amount"),
    "floors": MessageLookupByLibrary.simpleMessage("Floors"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("Forget Password?"),
    "formattedDateTime": m2,
    "free": MessageLookupByLibrary.simpleMessage("Free"),
    "from": MessageLookupByLibrary.simpleMessage("from"),
    "fromDate": MessageLookupByLibrary.simpleMessage("From Date "),
    "fullDay": MessageLookupByLibrary.simpleMessage("Day"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("Grand Total"),
    "group": MessageLookupByLibrary.simpleMessage("Group"),
    "holdOrder": MessageLookupByLibrary.simpleMessage("Hold Order"),
    "holidayNotSelected": MessageLookupByLibrary.simpleMessage(
      "Please select your holiday type ",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Please select the required action to continue",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("Hour"),
    "identityConfirmed": MessageLookupByLibrary.simpleMessage(
      "Identity Confirmed",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("Inactive"),
    "insertDBName": MessageLookupByLibrary.simpleMessage(
      "Insert DataBase Name",
    ),
    "insertEmail": MessageLookupByLibrary.simpleMessage("Insert Email"),
    "insertPassword": MessageLookupByLibrary.simpleMessage("Insert Password"),
    "invoiceNumber": MessageLookupByLibrary.simpleMessage("Invoice No."),
    "itemsCount": m3,
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastCheckOut": MessageLookupByLibrary.simpleMessage("Last check out"),
    "lastCheckOutValue": MessageLookupByLibrary.simpleMessage(
      "Yesterday, 11:30 PM",
    ),
    "lateTime": MessageLookupByLibrary.simpleMessage("Late time "),
    "leaveForReset": MessageLookupByLibrary.simpleMessage("Leave for reset"),
    "leaveRecord": MessageLookupByLibrary.simpleMessage("Leave recorded at "),
    "leaveTime": MessageLookupByLibrary.simpleMessage("Leave Time"),
    "leaving": MessageLookupByLibrary.simpleMessage("Leaving"),
    "location": MessageLookupByLibrary.simpleMessage("My Location"),
    "locationServicesDisabled": MessageLookupByLibrary.simpleMessage(
      "Location Services Disabled",
    ),
    "locationSpoofingDetected": MessageLookupByLibrary.simpleMessage(
      "Location spoofing detected. The app will be closed.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out "),
    "map": MessageLookupByLibrary.simpleMessage("Map"),
    "matchTimeFormat": MessageLookupByLibrary.simpleMessage(
      " time format (7:00 , 12:30)",
    ),
    "microfone": MessageLookupByLibrary.simpleMessage("Microfone"),
    "mobile": MessageLookupByLibrary.simpleMessage("Mobile"),
    "myRequests": MessageLookupByLibrary.simpleMessage("Requests"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nationalId": MessageLookupByLibrary.simpleMessage("National ID"),
    "nationality": MessageLookupByLibrary.simpleMessage("Nationality"),
    "navCart": MessageLookupByLibrary.simpleMessage("Cart"),
    "navMenu": MessageLookupByLibrary.simpleMessage("Menu"),
    "navOrders": MessageLookupByLibrary.simpleMessage("Orders"),
    "navSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "needSignOut": MessageLookupByLibrary.simpleMessage(
      "Are you shure you need log signOut? ",
    ),
    "noAddons": MessageLookupByLibrary.simpleMessage("No Add-ons"),
    "noDataFound": MessageLookupByLibrary.simpleMessage("No Data Found"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      " No internet , check your connection and try again",
    ),
    "notActive": MessageLookupByLibrary.simpleMessage("Not Active"),
    "notAttendance": MessageLookupByLibrary.simpleMessage(
      " you not signIn yet",
    ),
    "notLeave": MessageLookupByLibrary.simpleMessage("you not signOut yet"),
    "notRestaurantCompany": MessageLookupByLibrary.simpleMessage(
      "This company is not a restaurant.",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "notesWithVal": m4,
    "notice": MessageLookupByLibrary.simpleMessage("Notice"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "okDialog": MessageLookupByLibrary.simpleMessage("OK"),
    "openSetting": MessageLookupByLibrary.simpleMessage("Open Settings"),
    "openingCash": MessageLookupByLibrary.simpleMessage("Opening Cash"),
    "optionalNotes": MessageLookupByLibrary.simpleMessage("Notes (optional)"),
    "orderDetails": MessageLookupByLibrary.simpleMessage("Order Details"),
    "orderNumber": MessageLookupByLibrary.simpleMessage("Order No."),
    "orderProcessedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Order processed successfully and sent to kitchen",
    ),
    "overallReport": MessageLookupByLibrary.simpleMessage("Overall"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "pay": MessageLookupByLibrary.simpleMessage("Pay"),
    "payment": MessageLookupByLibrary.simpleMessage("Payment"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "paymentMethodBankTransfer": MessageLookupByLibrary.simpleMessage(
      "Bank Transfer",
    ),
    "paymentMethodCard": MessageLookupByLibrary.simpleMessage("Card"),
    "paymentMethodCash": MessageLookupByLibrary.simpleMessage("Cash"),
    "paymentMethodCredit": MessageLookupByLibrary.simpleMessage("Credit"),
    "paymentMethodLoyaltyPoints": MessageLookupByLibrary.simpleMessage(
      "Loyalty Points",
    ),
    "paymentMethodOther": MessageLookupByLibrary.simpleMessage("... Other"),
    "paymentMethodVisa": MessageLookupByLibrary.simpleMessage("Visa"),
    "paymentMethodVoucher": MessageLookupByLibrary.simpleMessage("Voucher"),
    "paymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "Payment Successful",
    ),
    "percentageDiscount": MessageLookupByLibrary.simpleMessage(
      "Percentage (%)",
    ),
    "performancePanel": MessageLookupByLibrary.simpleMessage(
      "Performance Panel",
    ),
    "period": MessageLookupByLibrary.simpleMessage("Time Period"),
    "permission": MessageLookupByLibrary.simpleMessage("Permission"),
    "permissionType": MessageLookupByLibrary.simpleMessage("Permission Type"),
    "permissions": MessageLookupByLibrary.simpleMessage("Permissions"),
    "permissionsReports": MessageLookupByLibrary.simpleMessage(
      "Permissions Reports",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Personal information",
    ),
    "phoneNumbers": MessageLookupByLibrary.simpleMessage("Phone Numbers"),
    "play": MessageLookupByLibrary.simpleMessage("Play"),
    "pleaseCheckInFirst": MessageLookupByLibrary.simpleMessage(
      "Please check in first",
    ),
    "pleaseFill": MessageLookupByLibrary.simpleMessage("please fill "),
    "plusPriceWithCurrency": m5,
    "pm": MessageLookupByLibrary.simpleMessage("P.M"),
    "popular": MessageLookupByLibrary.simpleMessage("Popular"),
    "pos": MessageLookupByLibrary.simpleMessage("POS"),
    "priceWithCurrency": m6,
    "productSize": MessageLookupByLibrary.simpleMessage("Product Size"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "quantityWithCount": m7,
    "quickAccessList": MessageLookupByLibrary.simpleMessage(
      "Quick access list",
    ),
    "readSentance": MessageLookupByLibrary.simpleMessage(
      "Please read the line below clearly to confirm attendance. ",
    ),
    "record": MessageLookupByLibrary.simpleMessage("Record"),
    "recordPresenceAndLeave": MessageLookupByLibrary.simpleMessage(
      "ٌRecord presence and leave",
    ),
    "referenceNumber": MessageLookupByLibrary.simpleMessage("Reference Number"),
    "registeredCustomer": MessageLookupByLibrary.simpleMessage(
      "Registered Customer",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "rejected": MessageLookupByLibrary.simpleMessage("Rejected"),
    "religion": MessageLookupByLibrary.simpleMessage("Religion"),
    "rememberMe": MessageLookupByLibrary.simpleMessage("Remember me"),
    "reports": MessageLookupByLibrary.simpleMessage("Reports"),
    "requestFailed": MessageLookupByLibrary.simpleMessage("Request failed"),
    "requestFingerPrint": MessageLookupByLibrary.simpleMessage(
      "Request  Fingerprint",
    ),
    "requestLeave": MessageLookupByLibrary.simpleMessage("Request Leave"),
    "requestLocationPermission": MessageLookupByLibrary.simpleMessage(
      "You don’t have permission to access location, which is required to use the app. Would you like to request permission now?",
    ),
    "requestNumber": MessageLookupByLibrary.simpleMessage("Request Number"),
    "requestSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Request sent successfully",
    ),
    "requestType": MessageLookupByLibrary.simpleMessage("Request Type"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "restMinutes": MessageLookupByLibrary.simpleMessage("Rest 60 minutes"),
    "restaurantManager": MessageLookupByLibrary.simpleMessage(
      "Restaurant Manager",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "salaries": MessageLookupByLibrary.simpleMessage("Salaries"),
    "salesScreen": MessageLookupByLibrary.simpleMessage("Sales Screen"),
    "salesScreenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Access the dashboard, orders and sales",
    ),
    "sar": MessageLookupByLibrary.simpleMessage("SAR"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveAndOpenShift": MessageLookupByLibrary.simpleMessage(
      "Save and Open Shift",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to save. Please try again.",
    ),
    "savedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Saved successfully",
    ),
    "section": MessageLookupByLibrary.simpleMessage("Section"),
    "securityWarning": MessageLookupByLibrary.simpleMessage("Security Warning"),
    "selectBranch": MessageLookupByLibrary.simpleMessage("Select Branch"),
    "selectDeliveryAgent": MessageLookupByLibrary.simpleMessage(
      "Select Delivery Agent",
    ),
    "selectInvoiceType": MessageLookupByLibrary.simpleMessage(
      "Select Invoice Type",
    ),
    "selectTable": MessageLookupByLibrary.simpleMessage("Select Table"),
    "selectWaiter": MessageLookupByLibrary.simpleMessage("Select Waiter"),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sessionExpired": MessageLookupByLibrary.simpleMessage("Session Expired"),
    "shift": MessageLookupByLibrary.simpleMessage("Shift"),
    "shift1": MessageLookupByLibrary.simpleMessage("first shift"),
    "shift2": MessageLookupByLibrary.simpleMessage("second shift"),
    "shift3": MessageLookupByLibrary.simpleMessage("third shift"),
    "shift4": MessageLookupByLibrary.simpleMessage("fourth shift"),
    "shiftNotStarted": MessageLookupByLibrary.simpleMessage(
      "Shift has not started yet",
    ),
    "shiftStart": MessageLookupByLibrary.simpleMessage("Shift Start"),
    "shiftToSecondDay": MessageLookupByLibrary.simpleMessage(
      "The shift extends to the next day",
    ),
    "shoppingCart": MessageLookupByLibrary.simpleMessage("Shopping Cart"),
    "sickLeave": MessageLookupByLibrary.simpleMessage("Sick leave"),
    "signIn": MessageLookupByLibrary.simpleMessage("Check-in "),
    "signInSubtitle": MessageLookupByLibrary.simpleMessage(
      "Check in to start your new work shift",
    ),
    "signOut": MessageLookupByLibrary.simpleMessage("Check-out "),
    "signOutTitle": MessageLookupByLibrary.simpleMessage("Sign Out"),
    "sizeWithVal": m8,
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "specialDiscount": MessageLookupByLibrary.simpleMessage("Special Discount"),
    "specialNotes": MessageLookupByLibrary.simpleMessage("Special Notes"),
    "specialNotesHint": MessageLookupByLibrary.simpleMessage(
      "Example: Extra cooked, put sauce on the side...",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "subtotal": MessageLookupByLibrary.simpleMessage("Subtotal"),
    "sureDelete": MessageLookupByLibrary.simpleMessage(
      "are you sure you need delete this request",
    ),
    "systemTime": MessageLookupByLibrary.simpleMessage("System time"),
    "table": MessageLookupByLibrary.simpleMessage("Table"),
    "tables": MessageLookupByLibrary.simpleMessage("Tables"),
    "takeaway": MessageLookupByLibrary.simpleMessage("Takeaway"),
    "takeawayOrder": MessageLookupByLibrary.simpleMessage("Takeaway "),
    "tapAnyItemToAdd": MessageLookupByLibrary.simpleMessage(
      "Tap an item to add it to the order",
    ),
    "tapItemsToSelect": MessageLookupByLibrary.simpleMessage(
      "Tap items to select",
    ),
    "task": MessageLookupByLibrary.simpleMessage("Task"),
    "tax": MessageLookupByLibrary.simpleMessage("Tax"),
    "temporary": MessageLookupByLibrary.simpleMessage("Temp"),
    "timesOfWork": MessageLookupByLibrary.simpleMessage("Times of work"),
    "to": MessageLookupByLibrary.simpleMessage("to"),
    "toDate": MessageLookupByLibrary.simpleMessage(" To Date"),
    "toRestaurant": MessageLookupByLibrary.simpleMessage(" To Restaurant"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalAmountRequired": MessageLookupByLibrary.simpleMessage(
      "Total Amount Required",
    ),
    "totalDays": MessageLookupByLibrary.simpleMessage("Total vacation days"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("Total Amount Paid"),
    "transaction": MessageLookupByLibrary.simpleMessage("Attendance "),
    "transactionDate": MessageLookupByLibrary.simpleMessage("Transaction Date"),
    "typeOfLeave": MessageLookupByLibrary.simpleMessage("Type of Leave"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred. Please try again.",
    ),
    "userProfile": MessageLookupByLibrary.simpleMessage("User Profile"),
    "vacations": MessageLookupByLibrary.simpleMessage("Vacations"),
    "vaccations": MessageLookupByLibrary.simpleMessage("Vacations"),
    "vaccationsReports": MessageLookupByLibrary.simpleMessage(
      "Vacations Reports",
    ),
    "vat": MessageLookupByLibrary.simpleMessage("VAT"),
    "vat15": MessageLookupByLibrary.simpleMessage("VAT (15%)"),
    "verificationFailed": MessageLookupByLibrary.simpleMessage(
      "Verification Failed",
    ),
    "verified": MessageLookupByLibrary.simpleMessage("Verified"),
    "viewCart": MessageLookupByLibrary.simpleMessage("View Cart"),
    "waitLocation": MessageLookupByLibrary.simpleMessage(
      "Please wait until the current location data is loaded",
    ),
    "waiting": MessageLookupByLibrary.simpleMessage("Waiting"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "workHours": MessageLookupByLibrary.simpleMessage("Work Hours"),
    "workTime": MessageLookupByLibrary.simpleMessage("Work Time"),
  };
}
