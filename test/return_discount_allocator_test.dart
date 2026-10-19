import 'package:apex_restaurant/featchers/cart/presentation/bloc/return_discount_allocator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const allocator = ReturnDiscountAllocator();

  // 5 items, total gross = 2000
  const lines = [
    ReturnDiscountLine(key: 'A', unitPrice: 100, soldQuantity: 5), // 500
    ReturnDiscountLine(key: 'B', unitPrice: 50, soldQuantity: 10), // 500
    ReturnDiscountLine(key: 'C', unitPrice: 200, soldQuantity: 2), // 400
    ReturnDiscountLine(key: 'D', unitPrice: 100, soldQuantity: 1), // 100
    ReturnDiscountLine(key: 'E', unitPrice: 25, soldQuantity: 20), // 500
  ];

  test('fixed 100 L.E invoice discount is split by gross', () {
    final r = allocator.allocate(
      lines: lines,
      invoiceDiscountValue: 100,
      invoiceDiscountIsPercentage: false,
    );

    expect(r['A']!.invoiceShare, 25);
    expect(r['B']!.invoiceShare, 25);
    expect(r['C']!.invoiceShare, 20);
    expect(r['D']!.invoiceShare, 5);
    expect(r['E']!.invoiceShare, 25);

    final sum = r.values.fold(0.0, (a, b) => a + b.invoiceShare);
    expect(sum, 100);

    // Item A: sold 5, returning 3 -> 25 / 5 * 3 = 15
    final perUnit = r['A']!.total / 5;
    expect(perUnit * 3, 15);
  });

  test('10% invoice discount', () {
    final r = allocator.allocate(
      lines: lines,
      invoiceDiscountValue: 10,
      invoiceDiscountIsPercentage: true,
    );
    expect(r['A']!.invoiceShare, 50); // 10% of 2000 = 200, A = 25%
  });

  test('shares always add up exactly (rounding remainder)', () {
    final r = allocator.allocate(
      lines: const [
        ReturnDiscountLine(key: 'A', unitPrice: 10, soldQuantity: 1),
        ReturnDiscountLine(key: 'B', unitPrice: 10, soldQuantity: 1),
        ReturnDiscountLine(key: 'C', unitPrice: 10, soldQuantity: 1),
      ],
      invoiceDiscountValue: 10,
      invoiceDiscountIsPercentage: false,
    );
    final sum = r.values.fold(0.0, (a, b) => a + b.invoiceShare);
    expect(double.parse(sum.toStringAsFixed(2)), 10.0);
  });
}
