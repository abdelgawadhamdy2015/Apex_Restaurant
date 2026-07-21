// cart_state.dart
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart'; // Holds OrderItem
import 'package:equatable/equatable.dart';

enum OrderType { takeaway, dineIn, delivery, deliveryCompany }

enum DiscountType { coupon, direct }

class CartState extends Equatable {
  final OrderType selectedOrderType;
  final DiscountType selectedDiscountType;
  final List<OrderItem> items;
  final List<dynamic> waiters;
  final List<dynamic> deliveryAgents;
  final List<DeliveryCompanyModel> deliveryCompanies;
  final DeliveryCompanyModel? selectedDeliveryCompany;
  final String? selectedWaiterId;
  final String? selectedAgentId;
  final double discountAmount;
  final double deliveryFee;
  final double vatPercentage;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const CartState({
    this.selectedOrderType = OrderType.dineIn,
    this.selectedDiscountType = DiscountType.coupon,
    this.items = const [],
    this.waiters = const [],
    this.deliveryAgents = const [],
    this.deliveryCompanies = const [],
    this.selectedDeliveryCompany,
    this.selectedWaiterId,
    this.selectedAgentId,
    this.discountAmount = 0.0,
    this.deliveryFee = 6.00,
    this.vatPercentage = 0.15,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get netSubtotal =>
      (subtotal - discountAmount) > 0 ? (subtotal - discountAmount) : 0.0;
  double get vatAmount => netSubtotal * vatPercentage;

  double get grandTotal {
    double total = netSubtotal + vatAmount;
    if (selectedOrderType == OrderType.delivery ||
        selectedOrderType == OrderType.deliveryCompany) {
      total += deliveryFee;
    }
    return total < 0 ? 0.0 : total;
  }

  CartState copyWith({
    OrderType? selectedOrderType,
    DiscountType? selectedDiscountType,
    List<OrderItem>? items,
    List<dynamic>? waiters,
    List<dynamic>? deliveryAgents,
    List<DeliveryCompanyModel>? deliveryCompanies,
    DeliveryCompanyModel? selectedDeliveryCompany,
    String? selectedWaiterId,
    String? selectedAgentId,
    double? discountAmount,
    double? deliveryFee,
    double? vatPercentage,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
  }) {
    return CartState(
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      selectedDiscountType: selectedDiscountType ?? this.selectedDiscountType,
      items: items ?? this.items,
      waiters: waiters ?? this.waiters,
      deliveryAgents: deliveryAgents ?? this.deliveryAgents,
      deliveryCompanies: deliveryCompanies ?? this.deliveryCompanies,
      selectedDeliveryCompany:
          selectedDeliveryCompany ?? this.selectedDeliveryCompany,
      selectedWaiterId: selectedWaiterId ?? this.selectedWaiterId,
      selectedAgentId: selectedAgentId ?? this.selectedAgentId,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      vatPercentage: vatPercentage ?? this.vatPercentage,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedOrderType,
    selectedDiscountType,
    items,
    waiters,
    deliveryAgents,
    deliveryCompanies,
    selectedDeliveryCompany,
    selectedWaiterId,
    selectedAgentId,
    discountAmount,
    deliveryFee,
    vatPercentage,
    isLoading,
    isSubmitting,
    errorMessage,
    successMessage,
  ];
}
