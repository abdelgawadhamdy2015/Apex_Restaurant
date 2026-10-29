import 'package:apex_restaurant/core/shared/model/print_kitchen_request.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_response.dart';
import 'package:apex_restaurant/core/shared/model/return_request.dart';
import 'package:apex_restaurant/core/shared/model/return_response.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_response.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';

abstract class SharedDatasource {
  Future<BaseResponse<PrintKitchenResponse?>> printKitchen({
    required PrintKitchenRequest request,
  });
  Future<InvoiceReportResponse?> getInvoiceReport({
    required InvoiceReportRequest request,
  });
  Future<BaseResponse<ReturnResponseData?>>
  saveRestaurantPosPartialReturnInvoice({required ReturnRequest request});
}

class SharedDatasourceImpl implements SharedDatasource {
  final ApiService _apiService;
  SharedDatasourceImpl(this._apiService);

  @override
  Future<BaseResponse<PrintKitchenResponse?>> printKitchen({
    required PrintKitchenRequest request,
  }) {
    return _apiService.printKitchen(request);
  }

  @override
  Future<InvoiceReportResponse?> getInvoiceReport({
    required InvoiceReportRequest request,
  }) {
    return _apiService.getInvoiceReport(request);
  }

  @override
  Future<BaseResponse<ReturnResponseData?>>
  saveRestaurantPosPartialReturnInvoice({
    required ReturnRequest request,
  }) async {
    return await _apiService.saveRestaurantPosReturnInvoice(request);
  }
}
