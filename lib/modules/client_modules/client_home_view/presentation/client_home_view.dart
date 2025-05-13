import 'dart:async';

import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/client_modules/client_search_delivery_view/presentaion/client_search_delivery_view.dart';
import 'package:firstproject001/modules/client_modules/client_send_specific_request/presentaion/client_company_info.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;
import 'package:intl/intl.dart' as intlx;
import 'package:firebase_database/firebase_database.dart';

import '../../../../shared/component/shared_preferences.dart';


class ClientHomeView extends StatefulWidget {
  const ClientHomeView({super.key});

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<ClientHomeView> {
  @override

  DateTime timeNow = DateTime.now();
  var searchQueryController = TextEditingController();
  DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");


  @override
  void initState() {
    super.initState();
     ClientLayoutCubit.get(context).fetchAllCompanies();
     ClientLayoutCubit.get(context).durationMethodModules();

  }

  List<Map<dynamic, dynamic>> searchCompaniesData = [];

  List<String> filterLastWeekDates(List<String> dates) {
    final now = DateTime.now();
    final lastWeekStart = now.subtract(Duration(days: now.weekday));
    final lastWeekEnd = lastWeekStart.add(Duration(days: 6));

    return dates.where((dateString) {
      final date = DateTime.parse(dateString);
      return date.isAfter(lastWeekStart) && date.isBefore(lastWeekEnd);
    }).toList();

  }



  Widget build(BuildContext context) {
    return  BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state) =>{},
      builder: (context,state) {
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);


        return Stack(

          children: [
            ConditionalBuilder(
                condition: state is FetchAllCompaniesDataSucceed && (cubit.companiesData.isNotEmpty || cubit.favoriteCompaniesData.isNotEmpty) || state is CompaniesDataExist || cubit.companiesData.isNotEmpty || cubit.favoriteCompaniesData.isNotEmpty,
                builder: (context) => Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                              child:  Text(
                                'الصفحة الرئيسية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: searchQueryController,
                              onChanged: (value){
                                if(value.isNotEmpty || value.length > 1) {
                                  setState(() {
                                    searchCompaniesData = [...cubit.favoriteCompaniesData,...cubit.companiesData].where(
                                            (item)=> item["companyName"].toLowerCase().startsWith(value.toLowerCase())  ).toList();
                                  });
                                }else {
                                  setState(() {
                                    searchCompaniesData = [];
                                  });
                                }
                              },
                              keyboardType: TextInputType.text,
                              textDirection: TextDirection.rtl,
                              decoration:  InputDecoration(
                                prefixIcon:const Padding(
                                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                  child:Icon(Icons.search),
                                ),
                                hintText: 'بحث',
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.2)
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(color: Colors.red),

                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(color: Colors.grey,width: 2),
                                ),
                                focusedErrorBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(color: Colors.red,width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                              ),


                            ),
                            const SizedBox(height: 2,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: searchQueryController.text.isNotEmpty,
                                  child: const Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text("نتائج البحث :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible: searchQueryController.text.isNotEmpty,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 1/1.3,
                                      children: List.generate(
                                          searchCompaniesData.length,
                                              (index) => Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:  GestureDetector(
                                              onTap: (){
                                                cubit.getAllDrivers(companyId: searchCompaniesData[index]['companyId']);

                                                getx.Get.to(
                                                      () => BlocProvider.value(
                                                    value: BlocProvider.of<ClientLayoutCubit>(context),
                                                    child: ClientCompanyInfo( companyInfo: searchCompaniesData[index],),
                                                  ),
                                                  transition: getx.Transition.rightToLeft,
                                                  duration:const Duration(milliseconds: 500),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.05),
                                                    borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10)
                                                    )
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ConditionalBuilder(
                                                      condition: searchCompaniesData.isEmpty || searchCompaniesData[index]['profilePic'].isEmpty,
                                                      builder: (context)=>const Image(
                                                        image:AssetImage('images/shop.jpg') ,
                                                        height: 113,fit: BoxFit.cover,
                                                      ),
                                                      fallback: (context)=>Image(
                                                        image: NetworkImage('${searchCompaniesData[index]["profilePic"]}') ,
                                                        height: 113,width: double.infinity,fit: BoxFit.cover,),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 10,right: 5,bottom: 10,left: 2),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            searchCompaniesData[index]['companyName'],
                                                            maxLines: 1,
                                                            style:const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontSize: 14
                                                            ),

                                                          ),
                                                         const SizedBox(height: 3,),
                                                          Text(
                                                            searchCompaniesData[index]['address'],
                                                            maxLines: 1,
                                                            style:const TextStyle(
                                                                color: Colors.grey,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontSize: 12
                                                            ),
                                                          ),
                                                          SizedBox(height: 3,),
                                                          Text(
                                                        isCompanyOpen(searchCompaniesData[index]["workTime"]) ? "يعمل لان" : "مغلقة",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: isCompanyOpen(searchCompaniesData[index]["workTime"]) ? Colors.green : Colors.red,
                                                        ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Visibility(
                                  visible: cubit.favoriteCompaniesData.isNotEmpty && searchQueryController.text.isEmpty,
                                  child: const Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text("الشركات المفضلة",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible: cubit.favoriteCompaniesData.isNotEmpty && searchQueryController.text.isEmpty,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 1/1.3,
                                      children: List.generate(
                                          cubit.favoriteCompaniesData.length,
                                              (index) => Padding(
                                            padding: const EdgeInsets.all(5),
                                            child:  GestureDetector(
                                              onTap: (){
                                                cubit.getAllDrivers(companyId: cubit.favoriteCompaniesData[index]['companyId']);

                                                getx.Get.to(
                                                      () => BlocProvider.value(
                                                    value: BlocProvider.of<ClientLayoutCubit>(context),
                                                    child: ClientCompanyInfo(companyInfo: cubit.favoriteCompaniesData[index],),
                                                  ),
                                                  transition: getx.Transition.rightToLeft,
                                                  duration:const Duration(milliseconds: 500),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.05),
                                                    borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10)
                                                    )
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ConditionalBuilder(
                                                      condition: cubit.favoriteCompaniesData.isEmpty || cubit.favoriteCompaniesData[index]['profilePic'].isEmpty,
                                                      builder: (context)=>const Image(
                                                        image:AssetImage('images/shop.jpg') ,
                                                        height: 113,fit: BoxFit.cover,
                                                      ),
                                                      fallback: (context)=>Image(
                                                        image: NetworkImage('${cubit.favoriteCompaniesData[index]["profilePic"]}') ,
                                                        height: 113,width: double.infinity,fit: BoxFit.cover,),
                                                    ),
                                                    Padding(
                                                      padding:const EdgeInsets.only(top: 10,right: 5,bottom: 10,left: 2),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            cubit.favoriteCompaniesData[index]['companyName'],
                                                            maxLines: 1,
                                                            style:const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontSize: 14
                                                            ),

                                                          ),
                                                          SizedBox(height: 3,),
                                                          Text(
                                                            cubit.favoriteCompaniesData[index]['address'],
                                                            maxLines: 1,
                                                            style:const TextStyle(
                                                                color: Colors.grey,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontSize: 12
                                                            ),
                                                          ),
                                                          SizedBox(height: 3,),
                                                          Text(
                                                            isCompanyOpen(cubit.favoriteCompaniesData[index]["workTime"]) ? "يعمل لان" : " مغلق",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: isCompanyOpen(cubit.favoriteCompaniesData[index]["workTime"]) ? Colors.green : Colors.red,
                                                            ),
                                                          )


                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Visibility(
                                  visible: cubit.companiesData.isNotEmpty && searchQueryController.text.isEmpty,
                                  child: const Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text("جميع الشركات",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible: cubit.companiesData.isNotEmpty && searchQueryController.text.isEmpty,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 1/1.3,
                                      children: List.generate(
                                          cubit.companiesData.length,
                                              (index){
                                            return Padding(
                                              padding: const EdgeInsets.all(5),
                                              child:  GestureDetector(
                                                onTap: (){
                                                  cubit.getAllDrivers(companyId: cubit.companiesData[index]['companyId']);
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //       builder: (newContext) => BlocProvider.value(
                                                  //           value: BlocProvider.of<ClientLayoutCubit>(context),
                                                  //           child: ClientCompanyInfo(
                                                  //             companyInfo: cubit.companiesData[index],
                                                  //           )),
                                                  //     )
                                                  // );

                                                  getx.Get.to(
                                                        () => BlocProvider.value(
                                                      value: BlocProvider.of<ClientLayoutCubit>(context),
                                                      child: ClientCompanyInfo(companyInfo: cubit.companiesData[index],),
                                                    ),
                                                    transition: getx.Transition.rightToLeft,
                                                    duration:const Duration(milliseconds: 500),
                                                  );

                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.05),
                                                      borderRadius: const BorderRadius.only(
                                                          bottomLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10)
                                                      )
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ConditionalBuilder(
                                                        condition: cubit.companiesData.isEmpty || cubit.companiesData[index]['profilePic'].isEmpty,
                                                        builder: (context)=>const Image(
                                                          image:AssetImage('images/shop.jpg') ,
                                                          height: 113,fit: BoxFit.cover,
                                                        ),
                                                        fallback: (context)=>Image(
                                                          image: NetworkImage('${cubit.companiesData[index]["profilePic"]}') ,
                                                          height: 113,width: double.infinity,fit: BoxFit.cover,),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 10,right: 5,bottom: 10,left: 2),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              cubit.companiesData[index]['companyName'],
                                                              maxLines: 1,
                                                              style:const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  fontSize: 14
                                                              ),

                                                            ),
                                                           const SizedBox(height: 3,),
                                                            Text(
                                                              cubit.companiesData[index]['address'],
                                                              maxLines: 1,
                                                              style:const TextStyle(
                                                                  color: Colors.grey,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  fontSize: 12
                                                              ),
                                                            ),
                                                            const SizedBox(height: 3,),
                                                             Directionality(
                                                              textDirection: TextDirection.rtl,
                                                              child: Text(
                                                                isCompanyOpen(cubit.companiesData[index]["workTime"]) ? "يعمل لان" : " مغلق",
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: isCompanyOpen(cubit.companiesData[index]["workTime"]) ? Colors.green : Colors.red,
                                                                ),
                                                              )
                                                              ,
                                                            )

                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                              }
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: ()async{

                      DataSnapshot dataSnapshot =  await fasterAppRef.child("users/${CacheHelper.getString("userId")}/general/acceptRequests").get();

                      if(dataSnapshot.exists){
                        customeToastification(context,
                            title: "غير مسموح",
                            desc: "هنالك طلبية جاري العمل عليها بالفعل",
                            icon: const Icon(Icons.close),
                            backgroundColor: companyMainColor
                        );
                      }else {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: BlocProvider.of<ClientLayoutCubit>(context),
                                  child: ClientSearchDeliveryView(myLocation: cubit.userLocation,),
                                )
                            )
                        );
                        cubit.navigateToMapView();
                      }



                    },
                    backgroundColor: mainColor,
                    child: Image.asset("icons/delivery-bike.png",width: 30,height: 30,),
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
                ),
                fallback: (context)=>const Center(
                  child: Text(
                    'لا يوجد بيانات حاليا',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                )
            ),
            Visibility(
              visible: state is ClientDurationMethodModulesProcess,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Container(
                  child:const Center(
                    child: const SpinKitCircle(
                      color: mainColor,
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


  bool isCompanyOpen(workTime) {
    final now = DateTime.now();

    DateTime startWorkTime = _convertToDateTime(
      workTime["startWork"]["hour"],
      workTime["startWork"]["minute"],
      workTime["startWork"]["amPm"],
    );

    DateTime endWorkTime = _convertToDateTime(
      workTime["endWork"]["hour"],
      workTime["endWork"]["minute"],
      workTime["endWork"]["amPm"],
    );

    return now.isAfter(startWorkTime) && now.isBefore(endWorkTime);
  }

  DateTime _convertToDateTime(String hour, String minute, String amPm) {
    final int hour24 = amPm == "PM" && hour != "12"
        ? int.parse(hour) + 12
        : (amPm == "AM" && hour == "12" ? 0 : int.parse(hour));
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour24,
      int.parse(minute),
    );
  }



}
