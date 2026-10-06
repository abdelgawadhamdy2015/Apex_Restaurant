import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_request.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_response.dart';
import 'package:apex_restaurant/core/shared/repo/shared_repo.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_response.dart';

class PrintKitchenUseCase {
  final SharedRepository repository;
  PrintKitchenUseCase(this.repository);

  Future<ApiResult<BaseResponse<PrintKitchenResponse?>>> call({
    required PrintKitchenRequest request,
  }) {
    return repository.printKitchen(request: request);
  }
}

class GetInvoiceReportUseCase {
  final SharedRepository repository;
  GetInvoiceReportUseCase(this.repository);
  Future<ApiResult<InvoiceReportResponse?>> call({
    required InvoiceReportRequest request,
  }) => repository.getInvoiceReport(request: request);
}
