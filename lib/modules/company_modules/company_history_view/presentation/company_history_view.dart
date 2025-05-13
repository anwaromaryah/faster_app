import 'package:firstproject001/layout/company_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../../shared/component/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../shared/component/toastification.dart';

class CompanyHistoryView extends StatefulWidget {
  const CompanyHistoryView({super.key});

  @override
  State<CompanyHistoryView> createState() => _CompanyHistoryViewState();
}

class _CompanyHistoryViewState extends State<CompanyHistoryView> {
  bool finishOrders = true;

  bool pendingOrders = false;

  bool processOrders = false;

  List<dynamic> pendingRequestsEntries = [];
  List<dynamic> acceptRequestsEntries = [];


  @override
  void initState() {
    CompanyLayoutCubit.get(context).refreshHistory();
    CompanyLayoutCubit.get(context).durationMethodModules();


    super.initState();
   // pendingRequests
    DatabaseReference pendingOrdersRef = FirebaseDatabase.instance.ref("fasterApps/companies/${CacheHelper.getString("userId")}/pendingRequests/");
    pendingOrdersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          pendingRequestsEntries = data.values.toList();
        });

      } else {
        setState(() {
          pendingRequestsEntries = [];
        });
      }

    });

    //acceptRequests

    DatabaseReference acceptOrdersRef = FirebaseDatabase.instance.ref("fasterApps/companies/${CacheHelper.getString("userId")}/acceptRequests/");
    acceptOrdersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          acceptRequestsEntries = data.values.toList();
        });

      } else {
        setState(() {
          acceptRequestsEntries = [];
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyLayoutCubit,CompanyLayoutStates>(
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

        },
        builder: (context,state){
          CompanyLayoutCubit cubit = CompanyLayoutCubit.get(context);
          return Stack(
            children: [
              SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        finishOrders = false;
                                        pendingOrders = true;
                                        processOrders = false;
                                      });
                                    },
                                    icon: Image.asset("icons/testing.png",width: 50,height: 50,)
                                ),
                                Text(
                                  "معلقة",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: pendingOrders ? companyMainColor : Colors.black,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 15,),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: (){
                                      cubit.refreshHistory();
                                      setState(() {
                                        finishOrders = true;
                                        pendingOrders = false;
                                        processOrders = false;
                                      });
                                    },
                                    icon: Image.asset("icons/received.png",width: 50,height: 50,)
                                ),
                                Text(
                                  "منتهية",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: finishOrders ? companyMainColor : Colors.black,

                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 15,),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        finishOrders = false;
                                        pendingOrders = false;
                                        processOrders = true;
                                      });
                                    },
                                    icon: Image.asset("icons/delivered.png",width: 50,height: 50,)
                                ),
                                Text(
                                  "الوقت الحالي",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: processOrders ? companyMainColor : Colors.black,

                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 2,
                              color: companyMainColor,
                            ),
                            const SizedBox(width: 20,),
                            Image.asset(
                              processOrders ? "icons/delivered.png":
                              pendingOrders ? "icons/testing.png":
                              "icons/received.png",
                              width: 45,
                              height: 45,
                            ),
                            const SizedBox(width: 20,),
                            Container(
                              width: 60,
                              height: 2,
                              color: companyMainColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: finishOrders && cubit.historyData.isNotEmpty,
                              child: Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(

                                                content: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Row(
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
                                                            child:const Text("نعم",style: TextStyle(color: Colors.green),)
                                                        ),
                                                        const SizedBox(width: 20),
                                                        TextButton(
                                                            onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                            child:const Text("الغاء",style: TextStyle(color: Colors.red),)
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );

                                            }
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
                                            color: mainColor,
                                          ),
                                          child:const Text(
                                            "حذف السجل",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14
                                            ),
                                          )
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      width: 30,
                                      height: 0.4,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: companyMainColor
                              ),
                              child: Text(
                                "${
                                    finishOrders ? cubit.historyData.length :
                                    processOrders ? acceptRequestsEntries.length :
                                    pendingOrders ? pendingRequestsEntries.length:
                                    0
                                }",
                                style:const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            const Text(
                              "عدد الطلبات",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Visibility(
                          visible: finishOrders && cubit.historyData.isNotEmpty,
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
                                          color: cubit.historyFilter.isEmpty ? companyMainColor : Colors.transparent,
                                          border: Border.all(width: 1,color: companyMainColor),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "#الجميع",
                                        style: TextStyle(
                                            color: cubit.historyFilter.isEmpty ? Colors.white : companyMainColor,
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
                                          color: cubit.historyFilter == "day" ? companyMainColor : Colors.transparent,
                                          border: Border.all(width: 1,color: companyMainColor),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "#اليوم",
                                        style: TextStyle(
                                            color: cubit.historyFilter == "day" ? Colors.white : companyMainColor,
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
                                          color: cubit.historyFilter == "weak" ? companyMainColor : Colors.transparent,
                                          border: Border.all(width: 1,color: companyMainColor),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "#الاسبوع الاخير",
                                        style: TextStyle(
                                            color: cubit.historyFilter == "weak" ? Colors.white : companyMainColor,
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
                                          color: cubit.historyFilter == "month" ? companyMainColor : Colors.transparent,
                                          border: Border.all(width: 1,color: companyMainColor),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "#الشهر الحالي",
                                        style: TextStyle(
                                            color:cubit.historyFilter == "month"  ? Colors.white : companyMainColor,
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
                                          color: cubit.historyFilter == "year" ? companyMainColor : Colors.transparent,
                                          border: Border.all(width: 1,color: companyMainColor),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "#السنة الحالية",
                                        style: TextStyle(
                                            color:cubit.historyFilter == "year" ? Colors.white : companyMainColor,
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

                        // processOrders
                        ConditionalBuilder(
                            condition: acceptRequestsEntries.isNotEmpty && processOrders,
                            builder: (context)=>Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: acceptRequestsEntries.isEmpty ? 0 : acceptRequestsEntries.length,
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
                                              border:const Border(
                                                  top: BorderSide(
                                                      color: companyMainColor,
                                                      width: 4
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            children: [
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
                                                    condition: acceptRequestsEntries.isEmpty ||acceptRequestsEntries[index]["driverInfo"]["profilePic"].isEmpty,
                                                    builder: (context) =>const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: AssetImage('icons/driver.png'),
                                                    ),
                                                    fallback: (context)=> CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: NetworkImage('${acceptRequestsEntries[index]["driverInfo"]["profilePic"]}'),
                                                    ),
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
                                                    "${acceptRequestsEntries[index]["driverInfo"]["driverPhoneNumber"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${acceptRequestsEntries[index]["driverInfo"]["driverName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
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
                                                    condition: acceptRequestsEntries.isEmpty || acceptRequestsEntries[index]["clientInfo"]["profilePic"].isEmpty,
                                                    builder: (context) =>const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: AssetImage("icons/user-profile.png"),
                                                    ),
                                                    fallback: (context)=>  CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: NetworkImage("${acceptRequestsEntries[index]["clientInfo"]["profilePic"]}"),
                                                    ),
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
                                                    "مرسل الطرد",
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
                                                    "${acceptRequestsEntries[index]["clientInfo"]["clientPhoneNumber"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${acceptRequestsEntries[index]["clientInfo"]["clientName"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${acceptRequestsEntries[index]["clientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  const CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: AssetImage("icons/user-profile.png"),
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
                                                    "${acceptRequestsEntries[index]["recipientInfo"]["recipientPhoneNumber"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${acceptRequestsEntries[index]["recipientInfo"]["recipientName"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${acceptRequestsEntries[index]["recipientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),

                                                ],
                                              )


                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            ),
                            fallback: (context)=>Visibility(
                                visible: processOrders,
                                child:const Expanded(
                                  child: Center(
                                    child: Text(
                                      "لا يوجد طلبات يتم العمل عليها",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24
                                      ),
                                    ),
                                  ),
                                )
                            )
                        ),

                        //pendingOrders
                        ConditionalBuilder(
                            condition: pendingRequestsEntries.isNotEmpty && pendingOrders,
                            builder: (context)=>Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: pendingRequestsEntries.isEmpty ? 0 : pendingRequestsEntries.length,
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: Colors.red
                                                    ),
                                                    child: IconButton(
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
                                                                      const Text("هل تريد حذف الطلب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                                      const SizedBox(height: 20),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          TextButton(
                                                                              onPressed: (){
                                                                                cubit.deletePendingRequest(orderNumber: pendingRequestsEntries[index]["orderInfo"]["orderNumber"]);
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
                                                        icon: const Icon(Icons.close,color:Colors.white,size: 16,)
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${pendingRequestsEntries[index]["orderInfo"]["time"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.date_range,color: Colors.grey,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${pendingRequestsEntries[index]["orderInfo"]["orderNumber"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.numbers,color: Colors.grey,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 8,),
                                              ////////////
                                              /////////////
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
                                                    condition: pendingRequestsEntries.isEmpty ||pendingRequestsEntries[index]["clientInfo"]["profilePic"].isEmpty,
                                                    builder: (context) =>const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: AssetImage('icons/user-profile.png'),
                                                    ),
                                                    fallback: (context)=> CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: NetworkImage("${pendingRequestsEntries[index]["clientInfo"]["profilePic"]}"),
                                                    ),
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
                                                    "مرسل الطرد",
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
                                                    "${pendingRequestsEntries[index]["clientInfo"]["clientPhoneNumber"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${pendingRequestsEntries[index]["clientInfo"]["clientName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${pendingRequestsEntries[index]["clientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),

                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  const CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors.grey,
                                                    backgroundImage: AssetImage("icons/user-profile.png"),
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
                                                    "${pendingRequestsEntries[index]["recipientInfo"]["recipientPhoneNumber"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${pendingRequestsEntries[index]["recipientInfo"]["recipientName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${pendingRequestsEntries[index]["recipientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),

                                                ],
                                              )


                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            ),
                            fallback: (context)=>Visibility(
                                visible: pendingOrders,
                                child:const Expanded(
                                  child: Center(
                                    child: Text(
                                      "لا يوجد طلبات معلقة حاليا",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24
                                      ),
                                    ),
                                  ),
                                )
                            )
                        ),

                        //finishOrders
                        ConditionalBuilder(
                            condition: finishOrders &&  cubit.historyData.isNotEmpty && cubit.historyDataFilter.isEmpty,
                            builder: (context)=>Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: cubit.historyData.isEmpty ? 0 : cubit.historyData.length,
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
                                                      color: deliveryMainColor,
                                                      width: 4
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["orderInfo"]["time"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.date_range,color: Colors.grey,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["orderInfo"]["orderNumber"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.numbers,color: Colors.grey,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 8,),
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
                                                    builder: (context) =>const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage:AssetImage("icons/driver.png"),
                                                    ),
                                                    fallback: (context)=> CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: NetworkImage("${cubit.historyData[index]["driverInfo"]["profilePic"]}"),
                                                    ),
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

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["driverInfo"]["driverName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
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
                                                      builder: (context) =>const CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: AssetImage("icons/user-profile.png"),
                                                      ),
                                                      fallback: (context)=> CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor: Colors.grey,
                                                        backgroundImage: NetworkImage("${cubit.historyData[index]["clientInfo"]["profilePic"]}"),

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
                                                    "مرسل الطرد",
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
                                                    "${cubit.historyData[index]["clientInfo"]["clientPhoneNumber"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["clientInfo"]["clientName"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["clientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),

                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  const CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: AssetImage("icons/user-profile.png"),
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
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyData[index]["recipientInfo"]["recipientName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyData[index]["recipientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),
                                                ],
                                              )


                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            ),
                            fallback: (context)=>Visibility(
                                visible: finishOrders && cubit.historyDataFilter.isEmpty,
                                child:const Expanded(
                                  child: Center(
                                    child: Text(
                                      "لا يوجد سجل بالوقت الحالي",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24
                                      ),
                                    ),
                                  ),
                                )
                            )
                        ),

                        //finishOrders with filter
                        Visibility(
                            visible: cubit.historyDataFilter.isNotEmpty && finishOrders,
                            child: Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.separated(
                                      itemCount: cubit.historyDataFilter.isEmpty ? 0 : cubit.historyDataFilter.length,
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
                                                      color: deliveryMainColor,
                                                      width: 4
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["orderInfo"]["time"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.date_range,color: Colors.grey,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["orderInfo"]["orderNumber"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.numbers,color: Colors.grey,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 8,),
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
                                                    builder: (context) =>const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage:AssetImage("icons/driver.png"),
                                                    ),
                                                    fallback: (context)=> CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: NetworkImage("${cubit.historyDataFilter[index]["driverInfo"]["profilePic"]}"),
                                                    ),
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

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["driverInfo"]["driverName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
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
                                                      builder: (context) =>const CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: AssetImage("icons/user-profile.png"),
                                                      ),
                                                      fallback: (context)=> CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor: Colors.grey,
                                                        backgroundImage: NetworkImage("${cubit.historyDataFilter[index]["clientInfo"]["profilePic"]}"),

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
                                                    "مرسل الطرد",
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
                                                    "${cubit.historyDataFilter[index]["clientInfo"]["clientPhoneNumber"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["clientInfo"]["clientName"]}",

                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["clientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),

                                                ],
                                              ),
                                              /////////////
                                              const SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 2,
                                                    color: Colors.grey.withOpacity(0.2),
                                                  ),

                                                  const SizedBox(width: 20,),
                                                  const CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: AssetImage("icons/user-profile.png"),
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
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.phone_android,color: companyMainColor,size: 20,),
                                                  const Spacer(),
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["recipientInfo"]["recipientName"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.drive_file_rename_outline,color: companyMainColor,size: 20,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${cubit.historyDataFilter[index]["recipientInfo"]["nameAddress"]}",
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  const Icon(Icons.location_on,color: companyMainColor,size: 20,),
                                                ],
                                              )


                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                )
                            )
                        )


                      ],
                    ),
                  )
              ),
              Visibility(
                visible: state is CompanyDurationMethodModulesProcess,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Container(
                    child:const Center(
                      child: const SpinKitCircle(
                        color: companyMainColor,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              )

            ],
          );
        },
    );
  }
}
