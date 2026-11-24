import '../../data/models/calculation_requests.dart';
import '../../data/models/calculation_result.dart';

abstract class CalculationRepository {
  Future<String?> openNewCart(OpenNewCartRequest request);

  Future<CalculationResult?> addItem(AddCalculationItemRequest request);
  Future<CalculationResult> editItem(EditCalculationItemRequest request);
  Future<CalculationResult> editListOfItems(EditListOfItemsRequest request);

  Future<CalculationResult> clearAllItems(String cartId);

  Future<void> removeCart(String cartId);
  Future<CalculationResult> setPosType(SetPosTypeRequest request);
  Future<CalculationResult> setDiscountOnTotal(
    SetDiscountOnTotalRequest request,
  );
  Future<CalculationResult> addVoucher(AddVoucherRequest request);
  Future<CalculationResult> removeVoucher(String cartId);
}
