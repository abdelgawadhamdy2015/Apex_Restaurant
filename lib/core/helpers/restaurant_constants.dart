import '../../featchers/home/data/models/employee_branch.dart';
import '../../featchers/auth/data/models/login_data.dart';
import 'package:intl/intl.dart';

class RestaurantConstants {
  static const String appName = "ApexRestaurant";
  static const String logOutMessage = "User Logged In From Another Place";

  static const String pushNotification = "pushNotification";
  static const String requestModel = "requestModel";
  static const String logoutNotification = "LogoutNotification";
  static String unexpectedError =
      Intl.defaultLocale == RestaurantConstants.english
      ? "An unexpected error occurred. Please try again."
      : "حدث خطأ غير متوقع. حاول مرة أخرى.";
  static const List<String> permissionTypes = ["Temporary", "Full Day"];
  static const String shiftType = "shiftType";
  static const List<String> languages = ["English", "العربية"];

  static DateFormat dayDateFormat = DateFormat('EEE, y,M,d  ');
  static DateFormat hoursFormat = DateFormat("hh:mm a");
  static DateFormat hours24Format = DateFormat(
    "HH:mm",
    RestaurantConstants.english,
  );

  static DateFormat monthNameFormat = DateFormat('MMM');
  static DateFormat dayNameFormat = DateFormat('EEE');
  static DateFormat dayNumberFormat = DateFormat(
    'dd',
    RestaurantConstants.english,
  );
  static DateFormat yearNumberFormat = DateFormat(
    'yyyy',
    RestaurantConstants.english,
  );

  static DateFormat customDateFormat = DateFormat(
    ' yyyy  d  MMMM',
    RestaurantConstants.english,
  );

  static DateFormat dateFormat = DateFormat(
    "dd/MM/yyyy",
    RestaurantConstants.english,
  );
  static DateFormat dateTimeFormat = DateFormat(
    " hh:mm a  dd/MM/yyyy ",
    // RestaurantConstants.english,
  );
  static DateFormat dateFormatwithDash = DateFormat(
    "d-M-yyyy",
    RestaurantConstants.english,
  );
  static const String imageUrl = "imageUrl";

  static String? image;
  //static String dateFormat = "dd-M-yyyy";
  //fonts
  static const String cairoFont = "Cairo";
  static const String lexendFont = "Lexend";

  static const String iBMPlexSansCondensed = "IBMPlexSansCondensed";
  static const String droidArabicKufi = "DroidArabicKufi";

  static const String temporary = "Temporary";
  static const String fullDay = "Full Day";

  static const String permission = "Permission";
  static const String annual = "Annual";
  static const String fingerPrints = "FingerPrints";
  static const String camera = "camera";
  static const String map = "map";
  static const String mic = "mic";

  static const String myTransactions = "transaction";
  static const String credits = "credits";
  static const String salaries = "salaries";
  static const String timesOfWork = "timesOfWork";
  static const String attendanceAndDepartureReports =
      "attendanceAndDepartureReports";
  static const String myRequests = "myRequests";
  static const String mydepatures = "Departures";
  static const String myToken = "token";
  static const String deviceToken = "deviceToken";

  static const String loggedUserName = 'userName';
  static const String loggedDBName = 'dBName';
  static const String userId = 'userId';
  static const String empId = 'empId';

  static const String isLoggedIn = 'isLoggedIn';
  static const String arabic = "ar";
  static const String english = "en";
  static const String myBearer = "Bearer";
  static const String authorization = 'Authorization';

  static const String waiting = "Waiting";
  static const String approved = "Approved";
  static const String rejected = "Rejected";
  static const double containerRadius = 25;

  static const String previousRoute = "Previous Route";

  static const String pageIndex = "pageIndex";

  // images;
  static const String passVector = "assets/pass_vector.png";

  static const String profileImageTage = "profileImageTage";

  static const String methodChannelMapKey = "mapsApiKey";

  static const String lastLocation = "lastLocation";

  static const String latstLatitude = "latstLatitude";

  static const String latstLongitude = "latstLongitude";

  // permission
  static List<PermissionGroupModel> permissions = [];

  static EmployeeBranch? currentBranch;
}
