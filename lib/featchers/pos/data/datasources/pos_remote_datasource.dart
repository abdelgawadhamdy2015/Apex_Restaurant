import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';

abstract class PosRemoteDataSource {
  Future<List<FloorModel>> getFloors({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  });
  Future<List<TableModel>> getTables({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  });
  Future<List<CategoryModel>> getMenuCategories();
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
  });
  Future<void> submitOrder(Map<String, dynamic> orderData);
  Future<void> sendToKitchen(Map<String, dynamic> orderData);
}

class PosRemoteDataSourceImpl implements PosRemoteDataSource {
  final ApiService _apiService;

  PosRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CategoryModel>> getMenuCategories() async {
    return _apiService.getAllCategories().then((response) {
      return response.data ?? [];
    });
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
  }) async {
    return await _apiService
        .getItemsByCategory(
          pageNumber: request?.pageNumber,
          pageSize: request?.pageSize,
          statues: request?.status,
          name: request?.name,
          categories: request?.categories,
          isRestaurantItem: request?.isRestaurantItem,
          isRestaurantIngrediant: request?.isRestaurantIngrediant,
        )
        .then((response) {
          return response.data ?? [];
        });
  }

  @override
  Future<void> submitOrder(Map<String, dynamic> orderData) async {
    // await _apiService.post('/orders', data: orderData);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> sendToKitchen(Map<String, dynamic> orderData) async {
    // await _dio.post('/orders/kitchen', data: orderData);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // List<MenuCategoryModel> _mockCategories() {
  //   return [
  //     MenuCategoryModel(
  //       id: 'main',
  //       name: 'الوجبات الرئيسية',
  //       icon: 'restaurant',
  //       items: [
  //         MenuItemModel(
  //           id: '1',
  //           name: 'برجر لحم فاخر',
  //           description: 'لحم أنجوس، جبنة، خس',
  //           price: 45.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
  //           categoryId: 'main',
  //         ),
  //         MenuItemModel(
  //           id: '2',
  //           name: 'باستا ألفريدو',
  //           description: 'كريمة، دجاج، فطر',
  //           price: 52.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400',
  //           categoryId: 'main',
  //         ),
  //         MenuItemModel(
  //           id: '3',
  //           name: 'كلوب ساندوتش',
  //           description: 'دجاج، بيض، جبن، توست',
  //           price: 38.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
  //           categoryId: 'main',
  //         ),
  //         MenuItemModel(
  //           id: '4',
  //           name: 'ستيك ريب آي',
  //           description: '٣٥٠ جرام، خضار مشوية',
  //           price: 95.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
  //           categoryId: 'main',
  //         ),
  //         MenuItemModel(
  //           id: '5',
  //           name: 'بيتزا مارجريتا',
  //           description: 'عجينة ناعمة، ريحان',
  //           price: 48.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
  //           categoryId: 'main',
  //         ),
  //       ],
  //     ),
  //     MenuCategoryModel(
  //       id: 'appetizers',
  //       name: 'المقبلات',
  //       icon: 'dining',
  //       items: [
  //         MenuItemModel(
  //           id: '6',
  //           name: 'حمص بالطحينة',
  //           description: 'حمص طازج، زيت زيتون',
  //           price: 22.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1541014741259-de529411b96a?w=400',
  //           categoryId: 'appetizers',
  //         ),
  //         MenuItemModel(
  //           id: '7',
  //           name: 'سلطة سيزر',
  //           description: 'خس روماني، صوص سيزر',
  //           price: 28.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
  //           categoryId: 'appetizers',
  //         ),
  //         MenuItemModel(
  //           id: '8',
  //           name: 'شوربة الطماطم',
  //           description: 'طماطم طازجة، كريمة',
  //           price: 25.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
  //           categoryId: 'appetizers',
  //         ),
  //       ],
  //     ),
  //     MenuCategoryModel(
  //       id: 'drinks',
  //       name: 'المشروبات',
  //       icon: 'local_bar',
  //       items: [
  //         MenuItemModel(
  //           id: '9',
  //           name: 'عصير برتقال طازج',
  //           description: 'برتقال طازج طبيعي',
  //           price: 18.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400',
  //           categoryId: 'drinks',
  //         ),
  //         MenuItemModel(
  //           id: '10',
  //           name: 'قهوة لاتيه',
  //           description: 'إسبريسو مزدوج، حليب',
  //           price: 22.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1561882468-9110d70767e5?w=400',
  //           categoryId: 'drinks',
  //         ),
  //       ],
  //     ),
  //     MenuCategoryModel(
  //       id: 'desserts',
  //       name: 'الحلويات',
  //       icon: 'icecream',
  //       items: [
  //         MenuItemModel(
  //           id: '11',
  //           name: 'كيك الشوكولا',
  //           description: 'شوكولا بلجيكية، كريمة',
  //           price: 32.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
  //           categoryId: 'desserts',
  //         ),
  //         MenuItemModel(
  //           id: '12',
  //           name: 'كنافة نابلسية',
  //           description: 'جبنة، قطر، فستق',
  //           price: 28.0,
  //           imageUrl:
  //               'https://images.unsplash.com/photo-1596797038530-2c107229654b?w=400',
  //           categoryId: 'desserts',
  //         ),
  //       ],
  //     ),
  //   ];
  // }

  @override
  Future<List<FloorModel>> getFloors({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  }) {
    return _apiService
        .getAllFloors(
          pageNumber: pageNumber,
          pageSize: pageSize,
          id: id,
          name: name,
          branchId: branchId,
        )
        .then((response) => response.data ?? []);
  }

  @override
  Future<List<TableModel>> getTables({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  }) {
    return _apiService
        .getAllFoodTables(
          pageNumber: pageNumber,
          pageSize: pageSize,
          id: id,
          name: name,
          floorID: floorID,
          forPOS: forPOS,
        )
        .then((response) => response.data ?? []);
  }
}
