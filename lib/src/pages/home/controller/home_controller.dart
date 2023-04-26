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

  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;

    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  bool isCategoryLoading = false;
  bool isProductLoading = true;

  RxString searchTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();

    debounce(
      searchTitle,
      (_) => filterByTile(),
      time: const Duration(
        milliseconds: 600,
      ),
    );

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

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(
        true,
        isProduct: true,
      );
    }

    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage,
    };

    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;

      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

    HomeResult<ItemModel> result = await homeRepository.getAllProduct(body);

    setLoading(
      false,
      isProduct: true,
    );

    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;

    getAllProducts(canLoad: false);
  }

  void filterByTile() {
    //Remover produtos de todas categorias
    for (var category in allCategory) {
      //
      category.items.clear();
      category.pagination = 0;

      if (searchTitle.value.isEmpty) {
        allCategory.removeAt(0);
      } else {
        CategoryModel? c = allCategory.firstWhereOrNull((cat) => cat.id == '');

        if (c == null) {
          final allProductsCategories = CategoryModel(
            title: 'Todos',
            id: '',
            items: [],
            pagination: 0,
          );

          allCategory.insert(0, allProductsCategories);
        } else {
          c.items.clear();
          c.pagination = 0;
        }
      }
    }
    currentCategory = allCategory.first;

    update();

    getAllProducts();
  }
}
