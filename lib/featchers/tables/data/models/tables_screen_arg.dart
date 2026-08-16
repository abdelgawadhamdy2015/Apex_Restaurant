import '../../../cart/data/models/pos_client_model.dart';

class TablesScreenArgs {
  final int branchId;
  final List<PosClientModel> personList;
  final bool inCartScreen;

  const TablesScreenArgs({
    required this.branchId,
    required this.personList,
    required this.inCartScreen,
  });
}
