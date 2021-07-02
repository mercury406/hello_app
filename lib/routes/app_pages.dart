import 'package:covid_getx_app/pages/splash/screen.dart';
import 'package:get/get.dart';
import '../../exports.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen()
    )
  ];
}