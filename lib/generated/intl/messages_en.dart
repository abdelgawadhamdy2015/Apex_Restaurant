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

  static String m3(hours) => "${hours} hours ago";

  static String m4(count) => "${count} Item";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 Item', other: '${count} Items')}";

  static String m6(minutes) => "${minutes} min ago";

  static String m7(notes) => "Notes: ${notes}";

  static String m8(count) => "${count} Orders";

  static String m9(price) => "+${price} SAR";

  static String m10(price) => "${price} SAR";

  static String m11(quantity) => "Qty: ${quantity}";

  static String m12(minutes) => "Reservation Period (${minutes} min)";

  static String m13(size) => "Size: ${size}";

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
    "actualCashInDrawer": MessageLookupByLibrary.simpleMessage(
      "Actual Cash in Drawer",
    ),
    "actualWorkingHours": MessageLookupByLibrary.simpleMessage(
      "Actual WorkingHours",
    ),
    "addAdditives": MessageLookupByLibrary.simpleMessage("Add Additives"),
    "addAnotherAddress": MessageLookupByLibrary.simpleMessage(
      "Add Another Address",
    ),
    "addBalance": MessageLookupByLibrary.simpleMessage("Add Balance"),
    "addCustody": MessageLookupByLibrary.simpleMessage("Add Custody"),
    "addCustomer": MessageLookupByLibrary.simpleMessage("Add Customer"),
    "addMoreAddressesHint": MessageLookupByLibrary.simpleMessage(
      "You can add more than one address for the customer",
    ),
    "addNewAddress": MessageLookupByLibrary.simpleMessage("Add new address"),
    "addNewCustomer": MessageLookupByLibrary.simpleMessage("Add New Customer"),
    "addNewReservation": MessageLookupByLibrary.simpleMessage(
      "Add New Reservation",
    ),
    "addNotesHint": MessageLookupByLibrary.simpleMessage(
      "Add your notes here...",
    ),
    "addToCartWithPrice": m0,
    "additionTag": MessageLookupByLibrary.simpleMessage("Addition"),
    "additionalNotes": MessageLookupByLibrary.simpleMessage("Additional Notes"),
    "additionalNotesHint": MessageLookupByLibrary.simpleMessage(
      "Write operation details here...",
    ),
    "additions": MessageLookupByLibrary.simpleMessage("Additions"),
    "addons": MessageLookupByLibrary.simpleMessage("Add-ons"),
    "addonsWithVal": m1,
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "alternatePhoneOptional": MessageLookupByLibrary.simpleMessage(
      "Alternate Phone (optional)",
    ),
    "am": MessageLookupByLibrary.simpleMessage("A.M"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountDue": MessageLookupByLibrary.simpleMessage("Amount Due"),
    "amountPaid": MessageLookupByLibrary.simpleMessage("Amount Paid"),
    "amountRemaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "annual": MessageLookupByLibrary.simpleMessage("Annual"),
    "annualLeave": MessageLookupByLibrary.simpleMessage("Annual leave"),
    "apartmentNumber": MessageLookupByLibrary.simpleMessage("Apartment Number"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "approvals": MessageLookupByLibrary.simpleMessage("Approvals"),
    "approve": MessageLookupByLibrary.simpleMessage("Approve"),
    "approveDeficitVoucher": MessageLookupByLibrary.simpleMessage(
      "Approve Deficit Voucher",
    ),
    "approved": MessageLookupByLibrary.simpleMessage("Approved"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "attachReceiptOrInvoice": MessageLookupByLibrary.simpleMessage(
      "Attach Receipt or Invoice",
    ),
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
    "available": MessageLookupByLibrary.simpleMessage("Available"),
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
    "branches": MessageLookupByLibrary.simpleMessage("Branches"),
    "branchs": MessageLookupByLibrary.simpleMessage("Branchs"),
    "btnNewOrder": MessageLookupByLibrary.simpleMessage("New Order"),
    "btnPreviousOrders": MessageLookupByLibrary.simpleMessage(
      "Previous Orders",
    ),
    "btnPrintKitchen": MessageLookupByLibrary.simpleMessage("Print Kitchen"),
    "btnPrintReceipt": MessageLookupByLibrary.simpleMessage("Print Receipt"),
    "buildingNumber": MessageLookupByLibrary.simpleMessage("Building Number"),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "cardNetwork": MessageLookupByLibrary.simpleMessage("Network"),
    "cart": MessageLookupByLibrary.simpleMessage("Cart"),
    "cartIsEmpty": MessageLookupByLibrary.simpleMessage("Your cart is empty."),
    "cash": MessageLookupByLibrary.simpleMessage("Cash"),
    "cashCustomer": MessageLookupByLibrary.simpleMessage("Walk-in Customer"),
    "cashierCustody": MessageLookupByLibrary.simpleMessage("Cashier Custody"),
    "changeAddress": MessageLookupByLibrary.simpleMessage("Change address"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage(
      "Please check your email for password reset instructions.",
    ),
    "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
    "chooseDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "Choose Delivery Company",
    ),
    "city": MessageLookupByLibrary.simpleMessage("City"),
    "clearAll": MessageLookupByLibrary.simpleMessage("Clear All"),
    "clickToUploadFile": MessageLookupByLibrary.simpleMessage(
      "Click to upload file",
    ),
    "closeApp": MessageLookupByLibrary.simpleMessage("Close App"),
    "closeCustody": MessageLookupByLibrary.simpleMessage("Close Custody"),
    "closeSession": MessageLookupByLibrary.simpleMessage("Close Session"),
    "comeFromReset": MessageLookupByLibrary.simpleMessage("Come from reset"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm Action"),
    "confirmAdditives": MessageLookupByLibrary.simpleMessage(
      "Confirm additives",
    ),
    "confirmReservation": MessageLookupByLibrary.simpleMessage(
      "Confirm Reservation",
    ),
    "confirmTransaction": MessageLookupByLibrary.simpleMessage(
      "Confirm Transaction",
    ),
    "confirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
    "controlBoard": MessageLookupByLibrary.simpleMessage("Control Board"),
    "coupon": MessageLookupByLibrary.simpleMessage("Coupon"),
    "currencySar": MessageLookupByLibrary.simpleMessage("SAR"),
    "currencySarShort": MessageLookupByLibrary.simpleMessage("SAR"),
    "currentAvailableBalance": MessageLookupByLibrary.simpleMessage(
      "Current Available Balance",
    ),
    "currentOrder": MessageLookupByLibrary.simpleMessage("Current Order"),
    "currentStatusOffShift": MessageLookupByLibrary.simpleMessage(
      "Current status: Off shift",
    ),
    "custodyLog": MessageLookupByLibrary.simpleMessage("Custody Log"),
    "customer": MessageLookupByLibrary.simpleMessage("Customer"),
    "customerAddresses": MessageLookupByLibrary.simpleMessage(
      "Customer Addresses",
    ),
    "customerName": MessageLookupByLibrary.simpleMessage("Customer Name"),
    "customerNameHint": MessageLookupByLibrary.simpleMessage(
      "Customer Name or Mobile",
    ),
    "customerNameLabel": MessageLookupByLibrary.simpleMessage("Customer Name"),
    "customerSelection": MessageLookupByLibrary.simpleMessage(
      "Customer Selection",
    ),
    "customers": MessageLookupByLibrary.simpleMessage("Customers"),
    "customizationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select the appropriate size and desired add-ons",
    ),
    "dailyClose": MessageLookupByLibrary.simpleMessage("Daily Close"),
    "dailyWorkingHours": MessageLookupByLibrary.simpleMessage(
      "from 9:00 A.M to 6:00 P.M",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateFormatHint": MessageLookupByLibrary.simpleMessage("mm/dd/yyyy"),
    "datePlaceholder": MessageLookupByLibrary.simpleMessage("mm/dd/yyyy"),
    "dateWarning": MessageLookupByLibrary.simpleMessage(
      "The start date must be before the end date",
    ),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "dayStatus": MessageLookupByLibrary.simpleMessage("Day Status"),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "dbName": MessageLookupByLibrary.simpleMessage("DataBase Name"),
    "deficit": MessageLookupByLibrary.simpleMessage("Deficit"),
    "deleteOrder": MessageLookupByLibrary.simpleMessage("Delete Order"),
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
    "district": MessageLookupByLibrary.simpleMessage("District"),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editCustomer": MessageLookupByLibrary.simpleMessage("Edit Customer"),
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
    "enterCustomerNameHint": MessageLookupByLibrary.simpleMessage(
      "Enter customer name",
    ),
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
    "expectedTotalCash": MessageLookupByLibrary.simpleMessage(
      "Expected Total Cash",
    ),
    "expenseReimbursement": MessageLookupByLibrary.simpleMessage(
      "Expense Reimbursement",
    ),
    "exportCsv": MessageLookupByLibrary.simpleMessage("Export CSV"),
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
    "firstFloor": MessageLookupByLibrary.simpleMessage("1st Floor"),
    "fixedAmountDiscount": MessageLookupByLibrary.simpleMessage("Fixed Amount"),
    "floor": MessageLookupByLibrary.simpleMessage("Floor"),
    "floors": MessageLookupByLibrary.simpleMessage("Floors"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("Forget Password?"),
    "formattedDateTime": m2,
    "free": MessageLookupByLibrary.simpleMessage("Free"),
    "from": MessageLookupByLibrary.simpleMessage("from"),
    "fromBranch": MessageLookupByLibrary.simpleMessage("From Branch"),
    "fromDate": MessageLookupByLibrary.simpleMessage("From Date "),
    "fullDay": MessageLookupByLibrary.simpleMessage("Day"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "fullReturn": MessageLookupByLibrary.simpleMessage("Full Return"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("Grand Total"),
    "group": MessageLookupByLibrary.simpleMessage("Group"),
    "guestsCount": MessageLookupByLibrary.simpleMessage("Number of Guests"),
    "guestsCountHint": MessageLookupByLibrary.simpleMessage("e.g. 3"),
    "heldOrders": MessageLookupByLibrary.simpleMessage("Held Orders"),
    "holdOrder": MessageLookupByLibrary.simpleMessage("Hold Order"),
    "holidayNotSelected": MessageLookupByLibrary.simpleMessage(
      "Please select your holiday type ",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Please select the required action to continue",
    ),
    "hour": MessageLookupByLibrary.simpleMessage("hour"),
    "hours": MessageLookupByLibrary.simpleMessage("Hour"),
    "hoursAgo": m3,
    "identityConfirmed": MessageLookupByLibrary.simpleMessage(
      "Identity Confirmed",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("Inactive"),
    "indoorTerrace": MessageLookupByLibrary.simpleMessage("Indoor Terrace"),
    "insertDBName": MessageLookupByLibrary.simpleMessage(
      "Insert DataBase Name",
    ),
    "insertEmail": MessageLookupByLibrary.simpleMessage("Insert Email"),
    "insertPassword": MessageLookupByLibrary.simpleMessage("Insert Password"),
    "invoiceNumber": MessageLookupByLibrary.simpleMessage("Invoice No."),
    "invoiceNumberExample": MessageLookupByLibrary.simpleMessage(
      "e.g., INV-1024",
    ),
    "invoiceNumberHint": MessageLookupByLibrary.simpleMessage("Ex: INV-1024"),
    "invoiceNumberLabel": MessageLookupByLibrary.simpleMessage(
      "Invoice Number",
    ),
    "isDefaultAddress": MessageLookupByLibrary.simpleMessage(
      "Is Default Address",
    ),
    "itemCountSingle": m4,
    "itemsCount": m5,
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
    "maxFileSizeHint": MessageLookupByLibrary.simpleMessage(
      "(JPG, PNG, PDF max size 5MB)",
    ),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "microfone": MessageLookupByLibrary.simpleMessage("Microfone"),
    "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "minutesAgo": m6,
    "mobile": MessageLookupByLibrary.simpleMessage("Mobile"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
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
    "noAddonsAvailable": MessageLookupByLibrary.simpleMessage(
      "No Add-ons Available",
    ),
    "noCustomerSelected": MessageLookupByLibrary.simpleMessage(
      "No customer selected",
    ),
    "noDataFound": MessageLookupByLibrary.simpleMessage("No Data Found"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      " No internet , check your connection and try again",
    ),
    "noReservations": MessageLookupByLibrary.simpleMessage(
      "No reservations found",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("No results found"),
    "noTablesAvailable": MessageLookupByLibrary.simpleMessage(
      "No Tables Available",
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
    "notesWithVal": m7,
    "notice": MessageLookupByLibrary.simpleMessage("Notice"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "okDialog": MessageLookupByLibrary.simpleMessage("OK"),
    "openInvoice": MessageLookupByLibrary.simpleMessage("Open Invoice"),
    "openSetting": MessageLookupByLibrary.simpleMessage("Open Settings"),
    "openingBalance": MessageLookupByLibrary.simpleMessage("Opening Balance"),
    "openingCash": MessageLookupByLibrary.simpleMessage("Opening Cash"),
    "openingCustody": MessageLookupByLibrary.simpleMessage("Opening Custody"),
    "openingCustodyTitle": MessageLookupByLibrary.simpleMessage(
      "Opening Custody",
    ),
    "operationReason": MessageLookupByLibrary.simpleMessage("Operation Reason"),
    "optionalNotes": MessageLookupByLibrary.simpleMessage("Notes (optional)"),
    "orderDetails": MessageLookupByLibrary.simpleMessage("Order Details"),
    "orderNumber": MessageLookupByLibrary.simpleMessage("Order No."),
    "orderProcessedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Order processed successfully and sent to kitchen",
    ),
    "orders": MessageLookupByLibrary.simpleMessage("Orders"),
    "ordersCount": m8,
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "outdoorArea": MessageLookupByLibrary.simpleMessage("Outdoor Area"),
    "overallReport": MessageLookupByLibrary.simpleMessage("Overall"),
    "partialReturn": MessageLookupByLibrary.simpleMessage("Partial Return"),
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
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
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
    "pettyExpenses": MessageLookupByLibrary.simpleMessage("Petty Expenses"),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneNumbers": MessageLookupByLibrary.simpleMessage("Phone Numbers"),
    "play": MessageLookupByLibrary.simpleMessage("Play"),
    "pleaseCheckInFirst": MessageLookupByLibrary.simpleMessage(
      "Please check in first",
    ),
    "pleaseFill": MessageLookupByLibrary.simpleMessage("please fill "),
    "pleaseSelectValidCustomer": MessageLookupByLibrary.simpleMessage(
      "Please select a valid customer.",
    ),
    "pleaseSelectValidDeliveryCompany": MessageLookupByLibrary.simpleMessage(
      "Please select a valid delivery company.",
    ),
    "pleaseSelectValidDeliveryManAndAddress":
        MessageLookupByLibrary.simpleMessage(
          "Please select a valid delivery person and address.",
        ),
    "pleaseSelectValidDineInTableandWaiter":
        MessageLookupByLibrary.simpleMessage(
          "Please select a valid table and waiter.",
        ),
    "pleaseSelectValidFromBranchDateTime": MessageLookupByLibrary.simpleMessage(
      "Please select a valid branch and date/time.",
    ),
    "pleaseSelectValidSize": MessageLookupByLibrary.simpleMessage(
      "Please select a valid size.",
    ),
    "pleaseSelectValidTakeawayDateTime": MessageLookupByLibrary.simpleMessage(
      "Please select a valid takeaway date and time.",
    ),
    "plusPriceWithCurrency": m9,
    "pm": MessageLookupByLibrary.simpleMessage("P.M"),
    "popular": MessageLookupByLibrary.simpleMessage("Popular"),
    "pos": MessageLookupByLibrary.simpleMessage("POS"),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previousOrders": MessageLookupByLibrary.simpleMessage("Previous Orders"),
    "priceWithCurrency": m10,
    "print": MessageLookupByLibrary.simpleMessage("Print"),
    "printReceipt": MessageLookupByLibrary.simpleMessage("Print Receipt"),
    "printWithApproval": MessageLookupByLibrary.simpleMessage(
      "Print with Approval",
    ),
    "productSize": MessageLookupByLibrary.simpleMessage("Product Size"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "quantityWithCount": m11,
    "quickAccessList": MessageLookupByLibrary.simpleMessage(
      "Quick access list",
    ),
    "readSentance": MessageLookupByLibrary.simpleMessage(
      "Please read the line below clearly to confirm attendance. ",
    ),
    "recentTransactionsSummary": MessageLookupByLibrary.simpleMessage(
      "Recent Transactions Summary",
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
    "reservationPeriod": MessageLookupByLibrary.simpleMessage(
      "Reservation Period",
    ),
    "reservationPeriodInMinutes": m12,
    "reservationSuccess": MessageLookupByLibrary.simpleMessage(
      "Reservation added successfully",
    ),
    "reservations": MessageLookupByLibrary.simpleMessage("Reservations"),
    "reserved": MessageLookupByLibrary.simpleMessage("Reserved"),
    "restMinutes": MessageLookupByLibrary.simpleMessage("Rest 60 minutes"),
    "restaurantManager": MessageLookupByLibrary.simpleMessage(
      "Restaurant Manager",
    ),
    "restoreOrder": MessageLookupByLibrary.simpleMessage("Restore Order"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "returns": MessageLookupByLibrary.simpleMessage("Returns"),
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
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchCustomerHint": MessageLookupByLibrary.simpleMessage(
      "Search by name or phone",
    ),
    "seats": MessageLookupByLibrary.simpleMessage("seats"),
    "seatsAndDurationHeader": MessageLookupByLibrary.simpleMessage(
      "Seats / Duration",
    ),
    "secondFloor": MessageLookupByLibrary.simpleMessage("2nd Floor"),
    "section": MessageLookupByLibrary.simpleMessage("Section"),
    "securityWarning": MessageLookupByLibrary.simpleMessage("Security Warning"),
    "selectBranch": MessageLookupByLibrary.simpleMessage("Select Branch"),
    "selectCustomer": MessageLookupByLibrary.simpleMessage("Select Customer"),
    "selectDateAndTimeError": MessageLookupByLibrary.simpleMessage(
      "Please select both date and time",
    ),
    "selectDeliveryAgent": MessageLookupByLibrary.simpleMessage(
      "Select Delivery Agent",
    ),
    "selectInvoiceType": MessageLookupByLibrary.simpleMessage(
      "Select Invoice Type",
    ),
    "selectReason": MessageLookupByLibrary.simpleMessage("Select reason"),
    "selectReservationPeriod": MessageLookupByLibrary.simpleMessage(
      "Select Reservation Period",
    ),
    "selectTable": MessageLookupByLibrary.simpleMessage("Select Table"),
    "selectTableHint": MessageLookupByLibrary.simpleMessage("Select table"),
    "selectWaiter": MessageLookupByLibrary.simpleMessage("Select Waiter"),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedTable": MessageLookupByLibrary.simpleMessage("Selected Table"),
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
    "singleItemCount": MessageLookupByLibrary.simpleMessage("1 Item"),
    "sizeWithVal": m13,
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
    "streetName": MessageLookupByLibrary.simpleMessage("Street Name"),
    "subtotal": MessageLookupByLibrary.simpleMessage("Subtotal"),
    "supplierPayment": MessageLookupByLibrary.simpleMessage("Supplier Payment"),
    "sureDelete": MessageLookupByLibrary.simpleMessage(
      "are you sure you need delete this request",
    ),
    "surplus": MessageLookupByLibrary.simpleMessage("Surplus"),
    "suspendSession": MessageLookupByLibrary.simpleMessage("Suspend Session"),
    "systemTime": MessageLookupByLibrary.simpleMessage("System time"),
    "table": MessageLookupByLibrary.simpleMessage("Table"),
    "tableArrangement": MessageLookupByLibrary.simpleMessage(
      "Table Arrangement",
    ),
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
    "thisItemHasNoValidSize": MessageLookupByLibrary.simpleMessage(
      "This item has no valid size.",
    ),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeFormatHint": MessageLookupByLibrary.simpleMessage("hh:mm"),
    "timesOfWork": MessageLookupByLibrary.simpleMessage("Times of work"),
    "to": MessageLookupByLibrary.simpleMessage("to"),
    "toDate": MessageLookupByLibrary.simpleMessage(" To Date"),
    "toRestaurant": MessageLookupByLibrary.simpleMessage(" To Restaurant"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalAdditions": MessageLookupByLibrary.simpleMessage("Total Additions"),
    "totalAmountRequired": MessageLookupByLibrary.simpleMessage(
      "Total Amount Required",
    ),
    "totalDays": MessageLookupByLibrary.simpleMessage("Total vacation days"),
    "totalHeldOrders": MessageLookupByLibrary.simpleMessage(
      "Total Held Orders",
    ),
    "totalInvoices": MessageLookupByLibrary.simpleMessage("Total Invoices"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("Total Amount Paid"),
    "totalWithdrawals": MessageLookupByLibrary.simpleMessage(
      "Total Withdrawals",
    ),
    "transaction": MessageLookupByLibrary.simpleMessage("Attendance "),
    "transactionDate": MessageLookupByLibrary.simpleMessage("Transaction Date"),
    "transactionLog": MessageLookupByLibrary.simpleMessage("Transaction Log"),
    "transferFromManagement": MessageLookupByLibrary.simpleMessage(
      "Transfer from Management",
    ),
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
    "viewFullCustodyLog": MessageLookupByLibrary.simpleMessage(
      "View Full Custody Log",
    ),
    "waitLocation": MessageLookupByLibrary.simpleMessage(
      "Please wait until the current location data is loaded",
    ),
    "waiting": MessageLookupByLibrary.simpleMessage("Waiting"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "withdrawCustody": MessageLookupByLibrary.simpleMessage("Withdraw Custody"),
    "withdrawExpenses": MessageLookupByLibrary.simpleMessage(
      "Expense Withdrawal",
    ),
    "withdrawalTag": MessageLookupByLibrary.simpleMessage("Withdrawal"),
    "withdrawals": MessageLookupByLibrary.simpleMessage("Withdrawals"),
    "workHours": MessageLookupByLibrary.simpleMessage("Work Hours"),
    "workTime": MessageLookupByLibrary.simpleMessage("Work Time"),
    "writeOperationDetailsHint": MessageLookupByLibrary.simpleMessage(
      "Enter operation details here...",
    ),
  };
}
