import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/repo/more_actions_repo.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';

class GetAllPOSInvoicesUseCase {
  final MoreActionsRepo repository;
  GetAllPOSInvoicesUseCase(this.repository);
  Future<ApiResult<BaseResponse<List<PosInvoiceData>?>>> call({
    required GetAllPosInvoiceRequest request,
  }) => repository.getAllPosInvoice(request: request);
}

class AddPOSResturnInvoiceUseCase {
  final MoreActionsRepo repository;
  AddPOSResturnInvoiceUseCase(this.repository);
  Future<ApiResult<BaseResponse<PosInvoiceData?>>> call({
    required GetAllPosInvoiceRequest request,
  }) => repository.addPOSResturnInvoice(request: request);
}

class AddPOSTotalReturnInvoiceUseCase {
  final MoreActionsRepo repository;
  AddPOSTotalReturnInvoiceUseCase(this.repository);
  Future<ApiResult<BaseResponse<PosInvoiceData?>?>> call({
    required AddPOSTotalReturnInvoiceRequest request,
  }) => repository.addPOSTotalReturnInvoice(request: request);
}
