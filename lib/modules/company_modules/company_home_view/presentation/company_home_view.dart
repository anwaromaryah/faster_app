import 'package:firstproject001/layout/company_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyHomeView extends StatelessWidget {
  const CompanyHomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CompanyLayoutCubit,CompanyLayoutStates>(
        listener: (context,state)=>{},
        builder: (context,state){
          CompanyLayoutCubit cubit = CompanyLayoutCubit.get(context);
          return Scaffold(
            body:  SafeArea(
                child:Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 275,
                        ),
                        Container(
                          padding:const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 24),
                          width: double.infinity,
                          height: 250,
                          decoration:const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffFBBC05),
                                Color(0xfff3d98e),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              //title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    cubit.companyInfo.isNotEmpty ?cubit.companyInfo['companyName'] : "",
                                    maxLines: 1,
                                    style:const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  const SizedBox(width: 4,),
                                  const Text(
                                    ',مرحبا',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height:10,),
                              // company profile image
                              ConditionalBuilder(
                                  condition:cubit.companyInfo.isNotEmpty && cubit.companyInfo["profilePic"].isNotEmpty,
                                  builder: (context)=> CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage('${cubit.companyInfo["profilePic"]}'),
                                  ),
                                  fallback: (context)=> const CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundImage: AssetImage('images/shop.jpg'),
                                    ),
                                  ),
                              ),

                              const SizedBox(height:10,),
                               Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'الطلبات',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          Image.asset("icons/box-white.png",width: 25,height: 25,)

                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        '${cubit.companyInfo.isNotEmpty ?cubit.companyInfo['doneOrdersCount'] : ""}',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'السائقين',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Image.asset("icons/delivery-man-white.png",width: 25,height: 25,)

                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(cubit.companyInfo.isNotEmpty ? cubit.companyInfo['drivers'].length.toString() : "0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                                    ],
                                  ),


                                ],
                              ),

                            ],
                          ),
                        ),
                        Positioned(
                            left: MediaQuery.of(context).size.width * 0.5 - 150,
                            bottom: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 300,
                              height: 43,
                              decoration: BoxDecoration(
                                  color: Color(0xff535353),

                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: (){
                                        cubit.changeBottomNavigationBarIndex(3);
                                      },
                                      child:const Text(
                                        'قم بتعديل معلومات الصفحة الخاصة بك',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),
                                      ),

                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'السائقين',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        SizedBox(width: 15,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //drivers cards
                    ConditionalBuilder(
                        condition: state is GetAllDriversProcess,
                        builder: (context)=>const Center(child: Text('لا يوجد سائقين حاليا',style: TextStyle(color: Colors.grey,fontSize: 20),),),
                        fallback: (context)=>Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            height: 108,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: cubit.drivers.length,
                              separatorBuilder:(context,index) =>const SizedBox(width: 12,),
                              itemBuilder: (context,index) {
                                return  Container(
                                  key: Key('driver_item_$index'),
                                  width: 120,
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color:const Color(0xffF4F4F4),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                  ConditionalBuilder(
                                  condition: cubit.drivers[index]["profilePic"].isEmpty ,
                                      builder: (context) => CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white.withOpacity(0.7),
                                        child: Image.asset("icons/driver.png",width: 30,height: 30,),
                                      ),
                                      fallback: (context)=> CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white.withOpacity(0.7),
                                        backgroundImage: NetworkImage("${cubit.drivers[index]["profilePic"]}"),
                                      )
                                  ),
                                     const SizedBox(height: 10,),
                                      Text(
                                        cubit.drivers[index]['driverName'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )

                                    ],
                                  ),
                                );
                              },

                            ),
                          ),
                        ),
                    ),
                    const SizedBox(height: 10,),
                    Center(
                      child: Container(
                        width: 250,
                        height: 0.2,
                        color: Colors.grey,
                      ),
                    ),
                    const  SizedBox(height: 10,),
                    Visibility(
                      visible: cubit.orderListForHomeScreen.isNotEmpty,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){
                                cubit.changeBottomNavigationBarIndex(2);
                              },
                              child:const Text(
                                'المزيد',
                                style: TextStyle(
                                  color: companyMainColor,
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
                    Visibility(visible: cubit.orderListForHomeScreen.isNotEmpty,child: const  SizedBox(height: 10,)),
                    ConditionalBuilder(
                        condition: cubit.orderListForHomeScreen.isNotEmpty,
                        builder: (context)=>Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: ListView.separated(
                                  itemCount: cubit.orderListForHomeScreen.length ?? 0,
                                  separatorBuilder: (context,index)=>Container(
                                    height: 1,
                                    width: double.infinity,
                                    color:Colors.black.withOpacity(0.1),
                                    margin:const EdgeInsets.symmetric(vertical: 5),
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
                                            children: [
                                              Text("${cubit.orderListForHomeScreen[index]["orderInfo"]["time"]}"),
                                              const SizedBox(width: 5,),
                                              const Icon(Icons.date_range,color: Colors.grey,size: 16,),
                                              const Spacer(),
                                              Text("${cubit.orderListForHomeScreen[index]["orderInfo"]["orderNumber"]}"),
                                              const SizedBox(width: 5,),
                                              const Icon(Icons.numbers,color: Colors.grey,size: 16,),
                                            ],
                                          ),
                                          const SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Text(
                                                  '${cubit.orderListForHomeScreen[index]["driverInfo"]["driverPhoneNumber"]}'
                                              ),
                                             const Spacer(),
                                              Text(
                                                  '${cubit.orderListForHomeScreen[index]["driverInfo"]["driverName"]}'
                                              ),
                                              const SizedBox(width: 5,),
                                              ConditionalBuilder(
                                                  condition: cubit.orderListForHomeScreen[index]["driverInfo"]["profilePic"].isEmpty,
                                                  builder: (context) => CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor: Colors.white.withOpacity(0.7),
                                                    child: Image.asset("icons/driver.png",width: 28,height: 28,),
                                                  ),
                                                  fallback: (context)=> CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor: Colors.white.withOpacity(0.7),
                                                    backgroundImage: NetworkImage("${cubit.orderListForHomeScreen[index]["driverInfo"]["profilePic"]}"),
                                                  )
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  '${cubit.orderListForHomeScreen[index]["clientInfo"]["clientName"]}'
                                              ),
                                              SizedBox(width: 5,),
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
                                                  '${cubit.orderListForHomeScreen[index]["recipientInfo"]["recipientName"]}'
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
                                                  '${cubit.orderListForHomeScreen[index]["recipientInfo"]["nameAddress"]}'
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
                        fallback: (context)=>const Expanded(
                          child: Center(
                            child: Text(
                              "لا يوجد سجل في الوقت الحالي",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24
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
