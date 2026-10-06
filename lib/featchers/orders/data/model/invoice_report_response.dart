import 'package:json_annotation/json_annotation.dart';

part 'invoice_report_response.g.dart';

@JsonSerializable()
class InvoiceReportResponse {
  final dynamic result;

  final int? dataCount;
  final dynamic data;
  final dynamic printingData;
  final String? alart;
  final dynamic id;
  final dynamic code;
  final String? note;
  final int? totalCount;
  final dynamic errors;
  final String? errorMessageAr;
  final String? errorMessageEn;
  final double? total;
  final DateTime? dateTimeNow;
  final int? updateNumber;
  final int? isUpdate;
  final bool? isPrint;

  final int? permissionListId;
  final String? employyeNameAr;
  final String? employyeNameEn;

  final dynamic posPrintFilesAr;
  final dynamic posPrintFilesEn;
  final dynamic returnPosPrintFilesAr;
  final dynamic returnPosPrintFilesEn;

  final bool? isAuthorizedOnDashboardData;

  const InvoiceReportResponse({
    this.result,
    this.dataCount,
    this.data,
    this.printingData,
    this.alart,
    this.id,
    this.code,
    this.note,
    this.totalCount,
    this.errors,
    this.errorMessageAr,
    this.errorMessageEn,
    this.total,
    this.dateTimeNow,
    this.updateNumber,
    this.isUpdate,
    this.isPrint,
    this.permissionListId,
    this.employyeNameAr,
    this.employyeNameEn,
    this.posPrintFilesAr,
    this.posPrintFilesEn,
    this.returnPosPrintFilesAr,
    this.returnPosPrintFilesEn,
    this.isAuthorizedOnDashboardData,
  });

  factory InvoiceReportResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceReportResponseToJson(this);

  // ----------------------------------------------------------
  // Success helpers
  // ----------------------------------------------------------

  bool get isSuccess {
    if (result is Map<String, dynamic>) {
      return result['result'] == 1;
    }

    return result == 1;
  }

  bool get isFailed => !isSuccess;

  String? get fileUrl {
    if (result is Map<String, dynamic>) {
      return result['fileURL'] as String?;
    }

    return null;
  }

  String? get fileName {
    if (result is Map<String, dynamic>) {
      return result['fileName'] as String?;
    }

    return null;
  }

  String? get htmlPrint {
    if (result is Map<String, dynamic>) {
      return result['htmlPrint'] as String?;
    }

    return null;
  }

  String? get fileBase64 {
    if (result is Map<String, dynamic>) {
      return result['fileBase64'] as String?;
    }

    return null;
  }

  bool get isFireFox {
    if (result is Map<String, dynamic>) {
      return result['isFireFox'] == true;
    }

    return false;
  }

  int? get resultForPrint {
    if (result is Map<String, dynamic>) {
      return result['resultForPrint'] as int?;
    }

    return null;
  }

  bool get isOverSize {
    if (result is Map<String, dynamic>) {
      return result['isOverSize'] == true;
    }

    return false;
  }

  // ----------------------------------------------------------
  // Error helpers
  // ----------------------------------------------------------

  String? get errorMessage {
    return errorMessageEn ?? errorMessageAr;
  }

  // ----------------------------------------------------------
  // Result value
  // ----------------------------------------------------------

  int? get resultCode {
    if (result is int) {
      return result as int;
    }

    if (result is Map<String, dynamic>) {
      return result['result'] as int?;
    }

    return null;
  }
}
