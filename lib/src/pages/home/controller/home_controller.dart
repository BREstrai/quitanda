import 'package:get/get.dart';
import 'package:quitanda/src/models/category_model.dart';
import 'package:quitanda/src/pages/home/repository/home_repository.dart';
import 'package:quitanda/src/pages/home/result/home_result.dart';
import 'package:quitanda/src/services/utils_service.dart';

class HomeController extends GetxController {
  final homeRepository = HomeRepository();
  final utilsServices = UtilsServices();
  List<CategoryModel> allCategory = [];
  CategoryModel? currentCategory;
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllCategories();
  }

  void setLoading(bool value) {
    isLoading = value;

    update();
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

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
  }
}
