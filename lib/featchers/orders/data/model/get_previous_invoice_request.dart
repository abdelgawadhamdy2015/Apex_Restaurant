class GetPreviousInvoiceRequest {
  final int? pageNumber;
  final int? pageSize;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? invoiceCode;
  final String? personName;

  const GetPreviousInvoiceRequest({
    this.pageNumber,
    this.pageSize,
    this.fromDate,
    this.toDate,
    this.invoiceCode,
    this.personName,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'PageNumber': pageNumber,
      'PageSize': pageSize,
      if (fromDate != null) 'FromDate': fromDate?.toIso8601String(),
      if (toDate != null) 'ToDate': toDate?.toIso8601String(),
      if (invoiceCode != null) 'InvoiceCode': invoiceCode,
      if (personName != null) 'PersonName': personName,
    };
  }
}
