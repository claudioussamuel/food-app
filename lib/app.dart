import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'features/navigation_menu/navigation_menu.dart';
import 'utils/theme/theme.dart';
import 'utils/theme/theme_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme controller
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          title: TTexts.appName,
          theme: TAppTheme.lightTheme,
          themeMode: themeController.themeMode,
          darkTheme: TAppTheme.darkTheme,
          initialBinding: GeneralBindings(),
          debugShowCheckedModeBanner: false,
          // To implement Deep Linking use getPages approach
          // getPages: [],
          // initialRoute: ,
          // unknownRoute: ,

          // Use Local to implement Multilingual App
          // locale: Get.deviceLocale,
          // translations: Languages(), // => lib => localization => languages
          // fallbackLocale: const Locale('en', 'US'),

          // You can add a Circular Loader here if you are redirecting the user using Repository in => main.dart
          home: const NavigationMenu(),
        ));
  }
}
