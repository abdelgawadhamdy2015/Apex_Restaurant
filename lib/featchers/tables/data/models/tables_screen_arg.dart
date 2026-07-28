import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';

class TablesScreenArgs {
  final int branchId;
  final List<PosClientModel> personList;

  const TablesScreenArgs({required this.branchId, required this.personList});
}
