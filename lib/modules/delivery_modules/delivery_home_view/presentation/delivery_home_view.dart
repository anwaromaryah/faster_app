import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_history/presentation/delivery_history_view.dart';
import 'package:flutter/material.dart';

import '../../../../shared/component/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:get/get.dart' as getx;

class DeliveryHomeView extends StatelessWidget {
  const DeliveryHomeView({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
      listener: (context,state)=>{},
      builder: (context,state){
        DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
        return Scaffold(
          backgroundColor: deliveryMainColor,
          body:  SafeArea(
              child:Column(
                children: [

                  Stack(
                    children: [
                      Container(
                        height: 270,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.topLeft,
                            colors: [
                              deliveryMainColor,
                              deliveryMainColor.withOpacity(0.6),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${cubit.driverInfo["driverName"]}",
                                  maxLines: 1,
                                  style:const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 22,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ),
                               const SizedBox(width: 5,),
                               const Text(
                                  'مرحبا بك',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 25

                                  ),
                                ),
                              ],
                            ),
                            /////////////////
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${cubit.driverInfo["companyName"]}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                                      const SizedBox(width: 5,),
                                      Image.asset("icons/market-location.png",width: 25,height: 25,)
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Text("${cubit.driverInfo["completedOrdersCount"]}",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      ),
                                      const SizedBox(width: 5,),
                                      const Text("الطلبات المنجزة",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                                      const SizedBox(width: 5,),
                                      Image.asset("icons/delivery-man.png",width: 25,height: 25,)
                                    ],
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration:const BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)
                              )
                          ),
                        ),
                      ),
                     const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      ConditionalBuilder(
                          condition: cubit.driverInfo.isEmpty || cubit.driverInfo["profilePic"].isEmpty,
                          builder: (context)=> Positioned(
                            left: 0,
                            right: 0,
                            bottom:4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('images/default_profile_picture.png'),
                                          fit: BoxFit.cover
                                      ),
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          fallback: (context)=> Positioned(
                            left: 0,
                            right: 0,
                            bottom:4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage("${cubit.driverInfo["profilePic"]}"),
                                          fit: BoxFit.cover
                                      ),
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),

                    ],
                  ),
                  Visibility(
                    visible: cubit.historyListForHomeScreen.isNotEmpty,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){



                                getx.Get.to(
                                      () => BlocProvider.value(
                                    value: BlocProvider.of<DeliveryLayoutCubit>(context),
                                    child:const DeliveryHistoryView(),
                                  ),
                                  transition: getx.Transition.fadeIn,
                                  duration:const Duration(milliseconds: 500),
                                );

                              },
                              child: const Text(
                                'المزيد',
                                style: TextStyle(
                                  color: deliveryMainColor,
                                ),
                              )
                          ),
                          Spacer(),
                          Text(
                            'الطلبات السابقة',
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                          SizedBox(width: 15,),

                        ],
                      ),
                    ),
                  ),
                  ConditionalBuilder(
                      condition: cubit.historyListForHomeScreen.isNotEmpty,
                      builder: (context)=>Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.white,
                            child: ListView.separated(
                                itemCount: cubit.historyListForHomeScreen.length <= 10 ? cubit.historyListForHomeScreen.length : 6,
                                separatorBuilder: (context,index)=>Container(
                                  height: 1,
                                  width: double.infinity,
                                  color:Colors.black.withOpacity(0.1),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                itemBuilder: (context,index) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color:const Color(0xffF4F4F4),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${cubit.historyListForHomeScreen[index]["orderInfo"]["orderNumber"]}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Text(
                                              '#',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                fontSize: 17
                                              ),
                                            ),
                                            const SizedBox(width: 10,),

                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text(
                                                '${cubit.historyListForHomeScreen[index]["driverInfo"]["driverPhoneNumber"]}'
                                            ),
                                            Spacer(),
                                            Text(
                                                '${cubit.historyListForHomeScreen[index]["driverInfo"]["driverName"]}'
                                            ),
                                            SizedBox(width: 5,),
                                            ConditionalBuilder(
                                                condition: cubit.driverInfo.isEmpty ||cubit.driverInfo["profilePic"].isEmpty,
                                                builder: (context) => CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: Colors.white.withOpacity(0.7),
                                                  child: Image.asset("icons/driver.png",width: 28,height: 28,),
                                                ),
                                                fallback: (context)=> CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white.withOpacity(0.7),
                                                  backgroundImage: NetworkImage("${cubit.driverInfo["profilePic"]}"),
                                                ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${cubit.historyListForHomeScreen[index]["clientInfo"]["clientName"]}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 5,),
                                            const Text(
                                                ':اسم المرسل',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${cubit.historyListForHomeScreen[index]["recipientInfo"]["recipientName"]}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                           const SizedBox(width: 5,),
                                            const Text(
                                                ':اسم المستلم',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                       const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${cubit.historyListForHomeScreen[index]["recipientInfo"]["nameAddress"]}',
                                                 maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 5,),
                                            const Text(
                                                ':عنوان الطلب',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  );
                                }
                            ),
                          )
                      ),
                      fallback: (context)=>Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              "لا يوجد سجل في الوقت الحالي",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24
                              ),
                            ),
                          ),
                        ),
                      )
                  )

                ],
              )
          ),
        );
      },
    );
  }
}
