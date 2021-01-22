import 'package:get_it/get_it.dart';
import 'package:shop_app/services/user_service.dart';
import 'package:shop_app/services/login_service.dart';

GetIt locator = GetIt.asNewInstance();

void setUpLocator(){
  locator.registerSingleton(UserService());
  locator.registerFactory<LoginService>(() => LoginService());
}