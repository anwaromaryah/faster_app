
import 'package:firstproject001/layout/admin_main_layout/presentation/admin_main_layout.dart';
import 'package:firstproject001/layout/client_main_layout/presentation/client_main_layout.dart';
import 'package:firstproject001/layout/company_main_layout/presentation/company_main_layout.dart';
import 'package:firstproject001/layout/delivery_main_layout/presentation/delivery_main.layout.dart';
import 'package:firstproject001/modules/admin_modules/admin_companys_view/presentation/admin_companys_view.dart';
import 'package:firstproject001/shared/component/bloc_observer.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

import 'modules/main/presentaion/main_view.dart';
import 'modules/main/presentaion/splash_view.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // connect app with firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashViewBody()
    );
  }
//
// Widget pageView() {
//   String? userId = CacheHelper.getString('userId');
//   String? userType = CacheHelper.getString('userType');
//
//   if (userId == null || userId.isEmpty) {
//     return const MainView();
//   } else if (userType == "client") {
//     return const ClientMainLayout();
//   } else if (userType == "driver") {
//     return const DeliveryMainLayout();
//   }else if (userType == "admin") {
//     return const AdminMainLayout();
//   } else {
//     return const CompanyMainLayout();
//   }
// }

}
