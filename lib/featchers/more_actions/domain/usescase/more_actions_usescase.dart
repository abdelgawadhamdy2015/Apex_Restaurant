import 'package:apex_restaurant/featchers/more_actions/data/model/add_cash_transaction_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/invoice_return_response.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/transactions_response.dart';
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
  Future<ApiResult<BaseResponse<InvoiceReturnResponse?>?>> call({
    required AddPOSTotalReturnInvoiceRequest request,
  }) => repository.addPOSTotalReturnInvoice(request: request);
}

class AddCashTransactionForSessionUseCase {
  final MoreActionsRepo repository;
  AddCashTransactionForSessionUseCase(this.repository);
  Future<ApiResult<BaseResponse<dynamic>>> call({
    required AddCashTransactionRequest request,
  }) => repository.addCashTransactionForSession(request: request);
}

class GetCashTransactionForSessionUseCase {
  final MoreActionsRepo repository;
  GetCashTransactionForSessionUseCase(this.repository);
  Future<ApiResult<BaseResponse<TransactionsResponse?>>> call({
    required int employeesId,
  }) => repository.getCashTransactionForSession(employeesId: employeesId);
}
