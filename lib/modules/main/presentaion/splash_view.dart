import 'package:firstproject001/modules/main/presentaion/main_view.dart';
import 'package:flutter/material.dart';

import '../../../layout/admin_main_layout/presentation/admin_main_layout.dart';
import '../../../layout/client_main_layout/presentation/client_main_layout.dart';
import '../../../layout/company_main_layout/presentation/company_main_layout.dart';
import '../../../layout/delivery_main_layout/presentation/delivery_main.layout.dart';
import '../../../shared/component/shared_preferences.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? fadingAnimation;


  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this , duration:Duration(seconds: 1));
    fadingAnimation = Tween<double>(begin: .1,end:1).animate(animationController!)..addListener(() {
      setState(() {
        if(animationController!.isCompleted) {
          animationController?.repeat(reverse: true);
        }
      });
    });

    animationController?.forward();


    Future.delayed(const Duration(seconds: 4), () {

      String? userId = CacheHelper.getString('userId');
      String? userType = CacheHelper.getString('userType');

      if(mounted){

        if(userId == null || userId.isEmpty) {
          return
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()));
        }else if(userType == "client"){
          return
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientMainLayout()));

        }else if(userType == "driver"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DeliveryMainLayout()));
        }else if(userType == "company"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CompanyMainLayout()));
        }else if(userType == "admin"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminMainLayout()));
        }


      }


    });


  }

  @override
  void deactivate() {
    super.deactivate();
    animationController?.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Opacity(
                  opacity: fadingAnimation?.value,
                  child: Center(
                    child: Container(
                        width: 100,
                        child: Image.asset('images/logo-x2.png')),
                  ),
                ),
                const SizedBox(height: 15,),

              ],
            )// Your app's main content widgets here
        ),
      ),
    );
  }


}
