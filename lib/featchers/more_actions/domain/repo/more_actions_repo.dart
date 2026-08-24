import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';

abstract class MoreActionsRepo {
  Future<ApiResult<BaseResponse<List<PosInvoiceData>?>>> getAllPosInvoice({
    required GetAllPosInvoiceRequest request,
  });
  Future<ApiResult<BaseResponse<PosInvoiceData?>>> addPOSResturnInvoice({
    required GetAllPosInvoiceRequest request,
  });

  Future<ApiResult<BaseResponse<PosInvoiceData?>>> addPOSTotalReturnInvoice({
    required AddPOSTotalReturnInvoiceRequest request,
  });
}
