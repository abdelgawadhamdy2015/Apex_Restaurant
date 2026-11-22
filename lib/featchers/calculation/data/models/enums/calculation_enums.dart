abstract final class CalculationResultStatus {
  static const int failed = 0;
  static const int success = 1;
}

abstract final class DiscountNatural {
  static const int ratio = 1;
  static const int value = 2;
}

abstract final class PosTypes {
  static const int takeaway = 1;
  static const int delivery = 2;
  static const int dineIn = 3;
  static const int fromBranch = 4;
  static const int companyDelivery = 5;
}

abstract final class CalculationItemTypes {
  static const int all = 0;
  static const int store = 1;
  static const int serial = 2;
  static const int expiary = 3;
  static const int service = 4;
  static const int composite = 5;
  static const int note = 6;
  static const int offer = 7;
  static const int additives = 10;
}
