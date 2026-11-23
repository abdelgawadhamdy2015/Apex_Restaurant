/// Server-calculated numbers for ONE cart line (main item + addons).
class ItemLinePreview {
  final double gross; // main + addons, before discount
  final double discount; // item discount (server value)
  final double vat;
  final bool vatIncluded; // price already includes VAT
  const ItemLinePreview({
    required this.gross,
    required this.discount,
    required this.vat,
    required this.vatIncluded,
  });

  double get total => gross - discount;
}
