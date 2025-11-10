import 'package:get/get.dart';

import '../data/repositories/authentication/authentication_repository.dart';
import '../data/repositories/personalization/profile_repository.dart';
import '../data/services/network_service/network_manager.dart';
import '../features/personalization/controller/pin_controller.dart';
import '../features/personalization/controller/profile_form_controller.dart';
import '../features/personalization/controller/location_controller.dart';
import '../features/home_action_menu/controller/category_controller.dart';
import '../features/home_action_menu/controller/branch_controller.dart';
import '../features/admin/controller/orders_controller.dart';
import '../features/dispatcher/controller/dispatcher_controller.dart';
import '../utils/theme/theme_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.put(NetworkManager());
    Get.put(PinController());
    Get.put(AuthenticationRepository());
    Get.put(ProfileRepository());
    Get.put(ThemeController());
    Get.put(LocationController());
    Get.put(CategoryController());
    Get.put(BranchController());
    Get.put(OrdersController());
    Get.put(DispatcherController());
    Get.put(ProfileFormController(), permanent: true);
  }
}
