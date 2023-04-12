import 'package:get/get.dart';
import 'package:quitanda/src/models/category_model.dart';
import 'package:quitanda/src/models/item_model.dart';
import 'package:quitanda/src/pages/home/repository/home_repository.dart';
import 'package:quitanda/src/pages/home/result/home_result.dart';
import 'package:quitanda/src/services/utils_service.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final homeRepository = HomeRepository();
  final utilsServices = UtilsServices();

  List<CategoryModel> allCategory = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  bool isCategoryLoading = false;
  bool isProductLoading = true;

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }

    update();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();

    if (currentCategory!.items.isNotEmpty) return;

    getAllProducts();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(
      success: (data) {
        allCategory.assignAll(data);

        if (allCategory.isEmpty) return;

        selectCategory(allCategory.first);
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }

  Future<void> getAllProducts() async {
    setLoading(
      true,
      isProduct: true,
    );

    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      "itemsPerPage": itemsPerPage,
    };

    HomeResult<ItemModel> result = await homeRepository.getAllProduct(body);

    setLoading(
      false,
      isProduct: true,
    );

    result.when(
      success: (data) {
        print(data);
        currentCategory!.items = data;

        if (allCategory.isEmpty) return;

        selectCategory(allCategory.first);
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }
}
