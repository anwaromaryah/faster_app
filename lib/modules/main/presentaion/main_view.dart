import 'package:firstproject001/modules/client_modules/client_login_view/presentation/login_view.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/company_login_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final LinearGradient _gradient = const LinearGradient(
      colors: [
        mainColor,
        companyMainColor,
      ]
  );

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 370,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                child: FadeInImage(
                  placeholder: const AssetImage('images/placeholder.jpg'), // صورة مؤقتة
                  image: const AssetImage("images/Online_Shoping.jpg"),
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ShaderMask(
                        shaderCallback:(Rect rect) {
                          return _gradient.createShader(rect);
                        },
                      child:Text(
                        "Faster App",
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 40,fontStyle: FontStyle.italic)
                      ),
                    )


                  ],
                ),
              ),

            ],
          ),
          const SizedBox(height: 40,),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to( ()=> const LoginView(),transition: Transition.rightToLeft );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(230, 35),
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child:Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1,color: Colors.white)
                        ),
                        child: Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 16,),
                      ),
                      const Spacer(),
                      const Text(
                        'الزبون',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) =>const CompanyLoginView()),
                    // );
                    Get.to( ()=> const CompanyLoginView(),transition: Transition.rightToLeft );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: companyMainColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(230, 35),
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child:Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1,color: Colors.white)
                        ),
                        child:const Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 16,),
                      ),
                      const Spacer(),
                      const Text(
                        'الشركة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
          const SizedBox(height: 25,),

        ],
      ),
    );
  }
}

