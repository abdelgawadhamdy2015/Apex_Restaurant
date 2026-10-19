/// Splits the ORIGINAL invoice's discounts across its items so that a return
/// only gives back the discount that belongs to the returned quantity.
///
/// Pure Dart (no Flutter, no models) so it is trivial to unit test.
///
/// Rules (same allocation rule as InvoiceCalculator):
///  1. Item gross       = unitPrice x soldQuantity
///  2. Item own discount (percentage or fixed) -> converted to a fixed amount
///     for the SOLD quantity
///  3. Invoice discount -> fixed amount (a percentage is taken from
///     "total gross - own discounts")
///  4. Each item's share = itemGross / totalGross x invoiceDiscountAmount
///
/// Everything here is for the SOLD quantity. Scaling to the returned
/// quantity is done later in ONE place: ReturnInvoiceMode.itemDiscountValue
/// (perUnit = discount / soldQty, then x returnedQty).
class ReturnDiscountLine {
  final String key;
  final double unitPrice;
  final double soldQuantity;
  final double ownDiscountValue;
  final bool ownDiscountIsPercentage;

  const ReturnDiscountLine({
    required this.key,
    required this.unitPrice,
    required this.soldQuantity,
    this.ownDiscountValue = 0.0,
    this.ownDiscountIsPercentage = false,
  });

  double get gross => unitPrice * soldQuantity;
}

class ReturnLineDiscount {
  /// The item's own discount, as a fixed amount for the sold quantity.
  final double ownDiscount;

  /// The item's share of the invoice discount, for the sold quantity.
  final double invoiceShare;

  const ReturnLineDiscount({
    required this.ownDiscount,
    required this.invoiceShare,
  });

  static const none = ReturnLineDiscount(ownDiscount: 0.0, invoiceShare: 0.0);

  /// Total fixed discount for the SOLD quantity.
  double get total => _round2(ownDiscount + invoiceShare);
}

class ReturnDiscountAllocator {
  const ReturnDiscountAllocator();

  Map<String, ReturnLineDiscount> allocate({
    required List<ReturnDiscountLine> lines,
    required double invoiceDiscountValue,
    required bool invoiceDiscountIsPercentage,
  }) {
    // 1 + 2: gross and own discount per line
    final gross = <String, double>{};
    final own = <String, double>{};
    for (final line in lines) {
      final g = line.gross;
      gross[line.key] = g;

      final raw = line.ownDiscountValue <= 0
          ? 0.0
          : (line.ownDiscountIsPercentage
                ? g * line.ownDiscountValue / 100
                : line.ownDiscountValue);
      own[line.key] = raw.clamp(0.0, g).toDouble();
    }

    final totalGross = _sum(gross.values);
    final totalOwn = _sum(own.values);

    // 3: invoice discount as a fixed amount
    final netAfterOwn = totalGross - totalOwn;
    var invoiceAmount = invoiceDiscountValue <= 0
        ? 0.0
        : (invoiceDiscountIsPercentage
              ? netAfterOwn * invoiceDiscountValue / 100
              : invoiceDiscountValue);
    invoiceAmount = invoiceAmount.clamp(0.0, netAfterOwn).toDouble();

    // 4: proportional split
    final shares = _splitByGross(gross, totalGross, invoiceAmount);

    return {
      for (final line in lines)
        line.key: ReturnLineDiscount(
          ownDiscount: _round2(own[line.key]!),
          invoiceShare: shares[line.key]!,
        ),
    };
  }

  /// Rounds every share to 2 decimals and gives the rounding remainder to the
  /// biggest line, so the shares always add up exactly to [amount].
  Map<String, double> _splitByGross(
    Map<String, double> gross,
    double totalGross,
    double amount,
  ) {
    if (amount <= 0 || totalGross <= 0 || gross.isEmpty) {
      return {for (final k in gross.keys) k: 0.0};
    }

    final shares = {
      for (final e in gross.entries)
        e.key: _round2(e.value / totalGross * amount),
    };

    final remainder = _round2(_round2(amount) - _sum(shares.values));
    if (remainder != 0) {
      final biggest = gross.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      shares[biggest.key] = _round2(shares[biggest.key]! + remainder);
    }
    return shares;
  }
}

double _sum(Iterable<double> values) => values.fold(0.0, (a, b) => a + b);

double _round2(double v) => double.parse(v.toStringAsFixed(2));
