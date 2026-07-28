import 'package:apex_restaurant/featchers/pos/presentation/widgets/custom_pos_app_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Dummy Data Models (Replace with your existing domain models)
// -----------------------------------------------------------------------------

class PosClient {
  final String id;
  final String name;
  final String phone;
  final String avatarInitials;
  final int orderCount;
  final String tag;
  final Color tagBackgroundColor;
  final Color tagTextColor;

  PosClient({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarInitials,
    required this.orderCount,
    required this.tag,
    required this.tagBackgroundColor,
    required this.tagTextColor,
  });
}

// -----------------------------------------------------------------------------
// Main Widget: SelectCustomerWidget
// -----------------------------------------------------------------------------

class SelectCustomerWidget extends StatefulWidget {
  const SelectCustomerWidget({
    super.key,
    this.onClientSelected,
    this.onAddNewClient,
  });

  /// Callback when a customer card is selected
  final ValueChanged<PosClient>? onClientSelected;

  /// Callback when "إضافة عميل جديد" is tapped
  final VoidCallback? onAddNewClient;

  @override
  State<SelectCustomerWidget> createState() => _SelectCustomerWidgetState();
}

class _SelectCustomerWidgetState extends State<SelectCustomerWidget> {
  int _selectedFilterIndex = 0;
  String? _selectedClientId = '1'; // Default selected customer ID (محمد سالم)

  final List<String> _filters = [
    'الكل',
    'العملاء الأخيرين',
    'VIP',
    'ديون معلقة',
  ];

  // Sample Customer List matching the UI
  final List<PosClient> _clients = [
    PosClient(
      id: '1',
      name: 'محمد سالم',
      phone: '+966 50 123 4567',
      avatarInitials: 'م س',
      orderCount: 24,
      tag: 'عميل VIP',
      tagBackgroundColor: const Color(0xFFFDF3E3),
      tagTextColor: const Color(0xFFC88A22),
    ),
    PosClient(
      id: '2',
      name: 'سارة العمري',
      phone: '+966 55 987 6543',
      avatarInitials: 'س ع',
      orderCount: 5,
      tag: 'مسجل حديثاً',
      tagBackgroundColor: const Color(0xFFE8F1F8),
      tagTextColor: const Color(0xFF5386AC),
    ),
    PosClient(
      id: '3',
      name: 'خالد كمال',
      phone: '+966 54 444 2211',
      avatarInitials: 'خ ك',
      orderCount: 12,
      tag: 'دفع معلق',
      tagBackgroundColor: const Color(0xFFFDEAEB),
      tagTextColor: const Color(0xFFD9534F),
    ),
    PosClient(
      id: '4',
      name: 'فاطمة منصور',
      phone: '+966 56 111 0000',
      avatarInitials: 'ف م',
      orderCount: 42,
      tag: 'دائم',
      tagBackgroundColor: const Color(0xFFEEF0F5),
      tagTextColor: const Color(0xFF728096),
    ),
    PosClient(
      id: '5',
      name: 'عبدالله الشريف',
      phone: '+966 50 000 9999',
      avatarInitials: 'ع ش',
      orderCount: 2,
      tag: 'نادر',
      tagBackgroundColor: const Color(0xFFEEF0F5),
      tagTextColor: const Color(0xFF728096),
    ),
    PosClient(
      id: '6',
      name: 'ليلى جاسم',
      phone: '+966 59 888 7777',
      avatarInitials: 'ل ج',
      orderCount: 18,
      tag: 'VIP',
      tagBackgroundColor: const Color(0xFFFDF3E3),
      tagTextColor: const Color(0xFFC88A22),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005DB9);
    const backgroundColor = Color(0xFFF7F9FC);

    return Directionality(
      textDirection: TextDirection.rtl, // RTL Layout for Arabic UI
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomPosAppBar(
          title: S.of(context).customerSelection,
          onMenuPressed: () {
            // Handle menu tap
          },
          onSearchPressed: () {
            // Handle search tap
          },
          onNotificationPressed: () {
            // Handle notifications tap
          },
        ),
        body: Column(
          children: [
            // Search & Top Actions Container
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'البحث عن عميل بالاسم أو رقم الهاتف...',
                      hintStyle: const TextStyle(
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                      suffixIcon: const Icon(Icons.search, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Add New Customer Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: widget.onAddNewClient,
                      icon: const Icon(
                        Icons.person_add_alt_1_outlined,
                        size: 20,
                      ),
                      label: const Text(
                        'إضافة عميل جديد',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Category Filter Chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedFilterIndex == index;
                        return ChoiceChip(
                          label: Text(_filters[index]),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilterIndex = index);
                            }
                          },
                          selectedColor: primaryColor,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? primaryColor
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Customers List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  final client = _clients[index];
                  final isSelected = _selectedClientId == client.id;

                  return _CustomerCard(
                    client: client,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedClientId = client.id);
                      widget.onClientSelected?.call(client);
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // Floating Action Button for Quick Add
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onAddNewClient,
          backgroundColor: const Color(0xFFF3A446),
          elevation: 4,
          child: const Icon(Icons.person_add_alt_1, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Individual Customer Card Widget
// -----------------------------------------------------------------------------

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.client,
    required this.isSelected,
    required this.onTap,
  });

  final PosClient client;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005DB9);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Selection Checkmark
                if (isSelected) ...[
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Customer Name & Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        client.phone,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                        textDirection: TextDirection
                            .ltr, // Keep phone number properly aligned
                      ),
                    ],
                  ),
                ),

                // Initials Circle Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F1F8),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    client.avatarInitials,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 8),

            // Card Footer: Order Count & VIP Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${client.orderCount} طلب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: client.tag == 'دفع معلق'
                        ? const Color(0xFFD9534F)
                        : primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: client.tagBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    client.tag,
                    style: TextStyle(
                      color: client.tagTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
