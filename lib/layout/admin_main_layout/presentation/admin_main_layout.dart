import 'package:firstproject001/layout/admin_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/admin_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/admin_modules/admin_clients_view/presentation/admin_clients_view.dart';
import 'package:firstproject001/modules/admin_modules/admin_companys_view/presentation/admin_companys_view.dart';
import 'package:firstproject001/modules/admin_modules/admin_deliverys_view/presentation/admin_deliverys_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as getx;
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../modules/main/presentaion/splash_view.dart';

class AdminMainLayout extends StatelessWidget {
  const AdminMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double firstContainerHeight = screenHeight * 0.2;
    double secondContainerHeight = firstContainerHeight * 0.2;
    double reducedWidth = screenWidth * 0.9;
    return BlocProvider(
      create: (context)=> AdminLayoutCubit()..getDataFromFirebase()..durationMethod(),
      child: BlocConsumer<AdminLayoutCubit,AdminLayoutStates>(
         listener: (context,state)=>{},
          builder: (context,state){
           AdminLayoutCubit cubit = AdminLayoutCubit.get(context);
           return ConditionalBuilder(
               condition: state is UpdateAccountAuthProcess || state is AdminDurationMethodProcess ,
               builder: (context)=>Container(
                 width: double.infinity,
                 height: double.infinity,
                 color: Colors.black.withOpacity(0.4),
                 child: Container(
                   child:const Center(
                     child: const SpinKitDoubleBounce(
                       color: Colors.white,
                       size: 50,
                     ),
                   ),
                 ),
               ),
               fallback: (context)=> Scaffold(
                 backgroundColor:const Color(0xffebeff7),
                 body: SizedBox.expand(
                   child: Stack(
                     children: [
                       Positioned(
                         top: 0,
                         left: 0,
                         right: 0,
                         height: firstContainerHeight,
                         child: Container(
                           color: const Color(0xff181C14),
                           child: Align(
                             alignment: Alignment.bottomCenter,
                             child: Container(
                               height: secondContainerHeight,
                               width: reducedWidth,
                               decoration:const BoxDecoration(
                                   color:  Color(0xffebeff7),
                                   borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(8),
                                     topRight: Radius.circular(8),
                                   )
                               ),
                             ),
                           ),
                         ),
                       ),
                       Positioned(
                         top: firstContainerHeight - 1,
                         left: (screenWidth - reducedWidth) / 2, // توسيط العنصر
                         width: reducedWidth,
                         bottom: 0, // يمتد حتى نهاية الشاشة
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           color: const Color(0xffebeff7),
                           child: Column(
                             children: [
                               GestureDetector(
                                 onTap: (){
                                   getx.Get.to(
                                         () => BlocProvider.value(
                                       value: BlocProvider.of<AdminLayoutCubit>(context),
                                       child: const AdminCompanysView(),
                                     ),
                                     transition: getx.Transition.rightToLeft,
                                     duration:const Duration(milliseconds: 500),
                                   );
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(12)
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const Text(
                                         "الشركات",
                                         style: TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                         ),
                                       ),
                                       const SizedBox(height: 10,),
                                       Image.asset("icons/companyAndBuilding.png",width: 80,height: 80,fit: BoxFit.fill,),
                                       const SizedBox(height: 10,),
                                       Text(
                                         "${cubit.companysPendingList.length}: عدد الطلبات المعلقة ",
                                         style: const TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                         ),
                                       ),
                                       const SizedBox(height: 10,),
                                       Text(
                                         "${cubit.companysList.length}: عدد الشركات ",
                                         style:const TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               GestureDetector(
                                 onTap: (){
                                   getx.Get.to(
                                         () => BlocProvider.value(
                                       value: BlocProvider.of<AdminLayoutCubit>(context),
                                       child: const AdminDeliverysView(),
                                     ),
                                     transition: getx.Transition.rightToLeft,
                                     duration:const Duration(milliseconds: 500),
                                   );
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(12)
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const Text(
                                         "السائقين",
                                         style: TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                         ),
                                       ),
                                       const SizedBox(height: 10,),
                                       Image.asset("icons/delivery-man2.png",width: 80,height: 80,fit: BoxFit.fill,),
                                       const SizedBox(height: 10,),
                                       Text(
                                         "${cubit.driversList.length}: عدد السائقين ",
                                         style:const TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               GestureDetector(
                                 onTap: (){
                                   getx.Get.to(
                                         () => BlocProvider.value(
                                       value: BlocProvider.of<AdminLayoutCubit>(context),
                                       child: const AdminClientsView(),
                                     ),
                                     transition: getx.Transition.rightToLeft,
                                     duration:const Duration(milliseconds: 500),
                                   );
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 15),
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(12)
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const Text(
                                         "الزبائن",
                                         style: TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                         ),
                                       ),
                                       const SizedBox(height: 10,),
                                       Image.asset("icons/user (1).png",width: 80,height: 80,fit: BoxFit.fill,),
                                       const SizedBox(height: 10,),
                                       Text(
                                         "${cubit.clientsList.length}: عدد الزبائن ",
                                         style:const TextStyle(
                                           color: Colors.grey,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               TextButton(
                                   onPressed: (){
                                     showDialog(
                                         context: context,
                                         builder: (context) {
                                           return AlertDialog(

                                             content: Column(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               mainAxisSize: MainAxisSize.min,
                                               children: [
                                                 const Text("هل تريد تسجيل الخروج",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                 const SizedBox(height: 20),
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     TextButton(
                                                         onPressed: (){
                                                           cubit.signOut();
                                                           Navigator.of(context).pushAndRemoveUntil(
                                                               MaterialPageRoute(builder: (context) => const SplashViewBody()),
                                                                   (route) => false
                                                           );

                                                         },
                                                         child:const Text("نعم",style: TextStyle(color: Colors.green),)
                                                     ),
                                                     const SizedBox(width: 20),
                                                     TextButton(
                                                         onPressed: (){
                                                           Navigator.pop(context);
                                                         },
                                                         child: const Text("الغاء",style: TextStyle(color: Colors.red),)
                                                     ),
                                                   ],
                                                 ),
                                               ],
                                             ),
                                           );

                                         }
                                     );
                                   },
                                   child:Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.all(8),
                                     decoration: BoxDecoration(
                                         color: Colors.red,
                                         borderRadius: BorderRadius.circular(15)
                                     ),
                                     child:const Text(
                                       "تسجيل خروج",
                                       textAlign: TextAlign.center,
                                       style: TextStyle(
                                           color: Colors.white
                                       ),
                                     ),
                                   )
                               )
                             ],
                           ),
                         ),
                       ),
                       const Positioned(
                           top: 60,
                           left: 0,
                           right: 0,
                           child: Center(child: Text("لوحة التحكم",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),))
                       )

                     ],
                   ),
                 ),
               )
           );
         },
      ),
    );
  }
}
