import 'package:apex_restaurant/featchers/pos/data/models/category_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item_response.dart';
import 'package:flutter/material.dart';

class ItemCustomizationSheet extends StatefulWidget {
  final RestaurantItemResponse item;
  final List<AdditiveModel> addons;
  final Function(
    RestaurantItemResponse item, {
    required ItemSizeResponse selectedSize,
    required List<AdditiveModel> selectedAddons,
    required double discount,
    required bool isPercentageDiscount,
    required String notes,
    required int quantity,
  })
  onConfirm;

  const ItemCustomizationSheet({
    super.key,
    required this.item,
    required this.onConfirm,
    required this.addons,
  });

  static void show(
    BuildContext context,
    RestaurantItemResponse item,
    final Function(
      RestaurantItemResponse item, {
      required dynamic selectedSize,
      required List<AdditiveModel> selectedAddons,
      required double discount,
      required bool isPercentageDiscount,
      required String notes,
      required int quantity,
    })
    onConfirm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: ItemCustomizationSheet(
          item: item,
          onConfirm: onConfirm,
          addons: [],
        ),
      ),
    );
  }

  @override
  State<ItemCustomizationSheet> createState() => _ItemCustomizationSheetState();
}

class _ItemCustomizationSheetState extends State<ItemCustomizationSheet> {
  // Temporary state holders
  int _quantity = 1;
  int _selectedSizeIndex = 1; // Default to Medium (وسط)
  final Set<int> _selectedAddonIndices = {};
  bool _isPercentageDiscount = true;
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Mock sizes - Replace with your model properties if available
  // final List<Map<String, dynamic>> widget.item.sizes = [
  //   {'label': 'صغير', 'price': 15.00},
  //   {'label': 'وسط', 'price': 25.00},
  //   {'label': 'كبير', 'price': 35.00},
  // ];

  // Mock addons - Replace with your model properties if available
  // final List<Map<String, dynamic>> widget.addons = [
  //   {'label': 'صوص حار', 'price': 3.00, 'isPopular': true},
  //   {'label': 'جبنة إضافية', 'price': 5.00, 'isPopular': false},
  //   {'label': 'بدون بصل', 'price': 0.00, 'isPopular': false},
  //   {'label': 'سجق مدخن', 'price': 12.00, 'isPopular': false},
  // ];

  double get _currentBasePrice => widget.item.sizes[_selectedSizeIndex].price;

  double get _totalPrice {
    double addonsTotal = 0.0;
    for (var index in _selectedAddonIndices) {
      addonsTotal += widget.item.sizes[index].price;
    }

    double itemTotal = (_currentBasePrice + addonsTotal) * _quantity;

    // Apply discount calculation
    double discountVal = double.tryParse(_discountController.text) ?? 0.0;
    if (_isPercentageDiscount) {
      itemTotal = itemTotal * (1 - (discountVal / 100));
    } else {
      itemTotal = (itemTotal - discountVal).clamp(0.0, double.infinity);
    }

    return itemTotal;
  }

  @override
  void dispose() {
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      widget.item.itemNameAr,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اختر الحجم المناسب والإضافات المرغوبة',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (widget.item.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.item.imagePath!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content Scroll
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Sizes Section
                Text(
                  'حجم المنتج',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(widget.item.sizes.length, (index) {
                    final size = widget.item.sizes[index];
                    final isSelected = _selectedSizeIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSizeIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withOpacity(0.04)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    size.sizeNameAr,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.hintColor.withOpacity(0.5),
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${size.price} ريال',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // 2. Addons Section
                Text(
                  'الإضافات',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(widget.addons.length, (index) {
                  final addon = widget.addons[index];
                  final isSelected = _selectedAddonIndices.contains(index);
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Text(addon.arabicName, style: textTheme.bodyLarge),
                            //if (addon['isPopular']) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.whatshot,
                                    color: theme.colorScheme.secondary,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'شائع',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          //  ],
                        ),
                        subtitle: Text(
                          addon.price > 0 ? '+${addon.price} ر.س' : 'مجاناً',
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAddonIndices.remove(index);
                              } else {
                                _selectedAddonIndices.add(index);
                              }
                            });
                          },
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                }),
                const SizedBox(height: 24),

                // 3. Discount Section
                Text(
                  'خصم خاص',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _isPercentageDiscount = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isPercentageDiscount
                                ? theme.colorScheme.primary.withOpacity(0.04)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isPercentageDiscount
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isPercentageDiscount
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: _isPercentageDiscount
                                    ? theme.colorScheme.primary
                                    : theme.hintColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'نسبة مئوية (%)',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _isPercentageDiscount = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isPercentageDiscount
                                ? theme.colorScheme.primary.withOpacity(0.04)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !_isPercentageDiscount
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                !_isPercentageDiscount
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: !_isPercentageDiscount
                                    ? theme.colorScheme.primary
                                    : theme.hintColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text('قيمة ثابتة', style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'أدخل قيمة الخصم',
                    fillColor: theme.brightness == Brightness.light
                        ? const Color(0xFFF8FAFC)
                        : theme.colorScheme.surface,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 24),

                // 4. Notes Section
                Text(
                  'ملاحظات خاصة',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'مثال: زيادة تسوية، وضع الصوص في علبة خارجية...',
                    fillColor: theme.brightness == Brightness.light
                        ? const Color(0xFFF8FAFC)
                        : theme.colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Fixed Action Panel
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Row(
              children: [
                // Quantity Counter
                Container(
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Add to Cart Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onConfirm(
                        widget.item,
                        selectedSize: widget.item.sizes[_selectedSizeIndex],
                        selectedAddons: _selectedAddonIndices
                            .map((i) => widget.addons[i])
                            .toList(),
                        discount:
                            double.tryParse(_discountController.text) ?? 0.0,
                        isPercentageDiscount: _isPercentageDiscount,
                        notes: _notesController.text,
                        quantity: _quantity,
                      );
                    },
                    child: Text(
                      'أضف للسلة ${_totalPrice.toStringAsFixed(2)} ر.س',
                      style: textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
