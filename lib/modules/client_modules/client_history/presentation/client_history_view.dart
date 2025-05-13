import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';

import '../../../../shared/component/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHistoryView extends StatelessWidget {
  const ClientHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{

          if(state is HistoryError) {
            customeToastification(context,
                title: "فلترة البيانات",
                desc: state.showError(),
                icon: Icon(Icons.close,color: Colors.white,),
                backgroundColor: mainColor.withOpacity(0.8)
            )
          },

          if(state is DeleteHistorySucceed) {
            customeToastification(context,
                title: "السجل",
                desc: "تم حذف السجل بنجاح",
                icon: Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          },

          if(state is RefreshHistorySucceed){
            customeToastification(context,
                title: "تحديث السجل",
                desc: "تم تحديث السجل بالنجاح",
                icon:const Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          }

        },
        builder: (context,state){
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
          return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: cubit.historyData.isNotEmpty,
                          child: IconButton(
                              onPressed: (){
                                cubit.refreshHistory();
                              },
                              icon:const Icon(Icons.refresh)
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red
                          ),
                          child: Text(
                            "${cubit.historyDataFilter.isNotEmpty ? cubit.historyDataFilter.length : cubit.historyData.length}",
                            style:const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        const Text(
                          'السجل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Visibility(
                      visible: cubit.historyData.isNotEmpty,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  cubit.resetFilterHistory();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: cubit.historyFilter.isEmpty ? mainColor : Colors.transparent,
                                      border: Border.all(width: 1,color: mainColor),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(
                                    "#الجميع",
                                    style: TextStyle(
                                        color: cubit.historyFilter.isEmpty ? Colors.white : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  cubit.filterHistory(filter: "day");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: cubit.historyFilter == "day" ? mainColor : Colors.transparent,
                                      border: Border.all(width: 1,color: mainColor),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(
                                    "#اليوم",
                                    style: TextStyle(
                                        color: cubit.historyFilter == "day" ? Colors.white : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  cubit.filterHistory(filter: "weak");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: cubit.historyFilter == "weak" ? mainColor : Colors.transparent,
                                      border: Border.all(width: 1,color: mainColor),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(
                                    "#الاسبوع الاخير",
                                    style: TextStyle(
                                        color: cubit.historyFilter == "weak" ? Colors.white : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  cubit.filterHistory(filter: "month");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: cubit.historyFilter == "month" ? mainColor : Colors.transparent,
                                      border: Border.all(width: 1,color: mainColor),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(
                                    "#الشهر الحالي",
                                    style: TextStyle(
                                        color:cubit.historyFilter == "month"  ? Colors.white : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  cubit.filterHistory(filter: "year");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: cubit.historyFilter == "year" ? mainColor : Colors.transparent,
                                      border: Border.all(width: 1,color: mainColor),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(
                                    "#السنة الحالية",
                                    style: TextStyle(
                                        color:cubit.historyFilter == "year" ? Colors.white : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ConditionalBuilder(
                        condition: cubit.historyData.isNotEmpty,
                        fallback: (context)=>const Expanded(
                          child: Center(
                            child: Text(
                              "لا يوجد سجل",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24
                              ),
                            ),
                          ),
                        ),
                        builder: (context)=>ConditionalBuilder(
                            condition: cubit.historyDataFilter.isNotEmpty,
                            builder: (context)=>Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: cubit.historyDataFilter.length,
                                      separatorBuilder: (context,index)=>Container(
                                        width: double.infinity,
                                        color:Colors.black.withOpacity(0.7),
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      itemBuilder: (context,index) {
                                        return Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(13),
                                          decoration: BoxDecoration(
                                              color:const Color(0xffF4F4F4),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border(
                                                  top: BorderSide(
                                                      color: mainColor,
                                                      width: 4
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["orderInfo"]["time"]}",
                                                    style:const TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.timelapse,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["orderInfo"]["orderNumber"]}",
                                                    style:const TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.numbers,color: mainColor,size: 20,),

                                                ],
                                              ),
                                              const SizedBox(height: 15,),
                                              ////////////
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  ConditionalBuilder(
                                                      condition: cubit.historyDataFilter.isEmpty || cubit.historyDataFilter[index]["driverInfo"]["profilePic"].isEmpty,
                                                      builder: (context) => CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.transparent,
                                                        child: Image.asset("icons/driver.png",width: 30,height: 30,),
                                                      ),
                                                      fallback: (context)=> CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor: Colors.grey.withOpacity(0.4),
                                                        backgroundImage: NetworkImage("${cubit.historyDataFilter[index]["driverInfo"]["profilePic"]}"),
                                                      )
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "السائق",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["driverInfo"]["driverPhoneNumber"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["driverInfo"]["driverName"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: mainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height:12,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.grey.withOpacity(0.4),
                                                    backgroundImage: AssetImage("icons/user-profile.png",),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "مستلم الطرد",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["recipientInfo"]["recipientPhoneNumber"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["recipientInfo"]["recipientName"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: mainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["recipientInfo"]["nameAddress"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.location_on,color: mainColor,size: 20,),

                                                ],
                                              )


                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            ),
                            fallback: (context)=>Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: cubit.historyData.length,
                                      separatorBuilder: (context,index)=>Container(
                                        width: double.infinity,
                                        color:Colors.black.withOpacity(0.7),
                                        margin:const EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      itemBuilder: (context,index) {
                                        return Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(13),
                                          decoration: BoxDecoration(
                                              color:const Color(0xffF4F4F4),
                                              borderRadius: BorderRadius.circular(10),
                                              border:const Border(
                                                  top: BorderSide(
                                                      color: mainColor,
                                                      width: 4
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["orderInfo"]["time"]}",
                                                    style:const TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.timelapse,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["orderInfo"]["orderNumber"]}",
                                                    style:const TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.numbers,color: mainColor,size: 20,),

                                                ],
                                              ),
                                              const SizedBox(height: 15,),
                                              ////////////
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  ConditionalBuilder(
                                                      condition: cubit.historyData.isEmpty || cubit.historyData[index]["driverInfo"]["profilePic"].isEmpty,
                                                      builder: (context) => CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.transparent,
                                                        child: Image.asset("icons/driver.png",width: 30,height: 30,),
                                                      ),
                                                      fallback: (context)=> CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor: Colors.grey.withOpacity(0.4),
                                                        backgroundImage: NetworkImage("${cubit.historyData[index]["driverInfo"]["profilePic"]}"),
                                                      )
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "السائق",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["driverInfo"]["driverPhoneNumber"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["driverInfo"]["driverName"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: mainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              /////////////
                                              const SizedBox(height: 12,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.grey.withOpacity(0.4),
                                                    backgroundImage: AssetImage("icons/user-profile.png",),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "مستلم الطرد",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["recipientInfo"]["recipientPhoneNumber"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: mainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["recipientInfo"]["recipientName"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: mainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["recipientInfo"]["nameAddress"]}",
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.location_on,color: mainColor,size: 20,),

                                                ],
                                              )

                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            )
                        ),
                    ),
                    const SizedBox(height: 10,),
                    Visibility(
                      visible: cubit.historyData.isNotEmpty,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(

                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("هل تريد حذف السجل",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: (){
                                                cubit.deleteHistory();
                                                Navigator.pop(context);
                                              },
                                              child: Text("نعم",style: TextStyle(color: Colors.green),)
                                          ),
                                          SizedBox(width: 20),
                                          TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: Text("الغاء",style: TextStyle(color: Colors.red),)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );

                              }
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: Colors.white,
                          minimumSize:  Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child:const Text('حذف السجل'),
                      ),
                    ),

                  ],
                ),
              )
          );
        },
    );
  }


}
