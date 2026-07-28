import 'package:dio/dio.dart';

class ApiConstants {
  static const String baseUsrl = localUrl;

  static const String localUrl = "http://192.168.1.253:1313/";
  static const String login = "api/Login";
  static const String getUserData = "api/General/UsersManager/getUserById";

  // Restaurants apis

  static const String openRestaurantPos =
      "api/Restaurants/RestaurantPos/OpenRestaurantPos";
  static const String openRestaurantPosSession =
      "api/Restaurants/RestaurantPos/OpenRestaurantPosSession";
  static const String getAllFloors = "api/Restaurants/Floors/GetAllFloors";
  static const String getAllFoodTables =
      "api/Restaurants/FoodTables/GetAllFoodTables";
  static const String getAllReservations =
      "api/Restaurants/FoodTables/GetAllReservations";
  static const String reserveFoodTable =
      "api/Restaurants/FoodTables/ReserveFoodTable";
  static const String cancelReserveFoodTable =
      "api/Restaurants/FoodTables/CancelReserveFoodTable";
  static const String editReserveFoodTable =
      "api/Restaurants/FoodTables/EditReserveFoodTable";

  static const String getAllFoodAdditives =
      "api/Restaurants/FoodAdditives/GetAllFoodAdditivesForPOS";

  static const String getAllCategoriesDropDown =
      "api/Restaurants/RestaurantPos/GetRestaurantCategoryPOS";
  static const String getAllItems =
      "api/Restaurants/RestaurantPos/GetRestaurantItemsPOS";
  static const String getAllDeliveryAgents = '/api/DeliveryAgent/GetAll';
  static const String getAllDeliveryCompany =
      "api/Restaurants/DeliveryCompany/GetAllDeliveryCompany";
  static const String getAllWaiters = '/api/Employee/GetWaiters';
  static const String applyDiscountCode = '/api/Order/ApplyDiscount';
  static const String holdOrder = '/api/Order/Hold';
  static const String completePayment = '/api/Order/CompletePayment';
  static const String getAllPersons = "api/Store/Persons/GetListOfPersons";
  static const String updatePosClient = "api/Store/Persons/UpdatePosClient";
  static const String addPosClient = "api/Store/Persons/AddPosClient";

  // General apis
  static const String getEmployeeBranches =
      "api/Store/GeneralAPIs/getEmployeeBranchs";

  static DioExceptionType dioExceptionType = DioExceptionType.unknown;

  static int? userId;

  static int? empId;
}

class ApiErrors {
  static const String methodNotAllowed = "method Not Allowed Error";

  static const String badRequestError = "bad request Error";
  static const String noContent = "no Content";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorized Error";
  static const String notFoundError = "not Found Error";
  static const String conflictError = "conflict Error";
  static const String internalServerError = "internal Server Error";
  static const String unknownError = "unknown Error";
  static const String timeoutError = "timeout Error";
  static const String defaultError = "default Error";
  static const String cacheError = "cache Error";
  static const String noInternetError = "no Internet Connection";
  static const String loadingMessage = "loading";
  static const String retryAgainMessage = "retry again";
}
