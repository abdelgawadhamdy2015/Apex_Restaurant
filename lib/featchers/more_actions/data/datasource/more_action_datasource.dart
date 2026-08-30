import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/invoice_return_response.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';

abstract class MoreActionDatasource {
  Future<BaseResponse<List<PosInvoiceData>?>> getAllPosInvoice({
    required GetAllPosInvoiceRequest request,
  });
  Future<BaseResponse<PosInvoiceData?>> addPOSResturnInvoice({
    required GetAllPosInvoiceRequest request,
  });

  Future<BaseResponse<InvoiceReturnResponse?>> addPOSTotalReturnInvoice({
    required AddPOSTotalReturnInvoiceRequest request,
  });
}

class MoreActionsRemoteDataSourceImpl implements MoreActionDatasource {
  final ApiService apiService;
  MoreActionsRemoteDataSourceImpl(this.apiService);

  @override
  Future<BaseResponse<PosInvoiceData?>> addPOSResturnInvoice({
    required GetAllPosInvoiceRequest request,
  }) async {
    return await apiService.addPOSResturnInvoice(request);
  }

  @override
  Future<BaseResponse<InvoiceReturnResponse?>> addPOSTotalReturnInvoice({
    required AddPOSTotalReturnInvoiceRequest request,
  }) async {
    return await apiService.addPOSTotalReturnInvoice(request);
  }

  @override
  Future<BaseResponse<List<PosInvoiceData>?>> getAllPosInvoice({
    required GetAllPosInvoiceRequest request,
  }) async {
    return await apiService.getAllPOSInvoices(request, request.financialYearId);
  }
}
