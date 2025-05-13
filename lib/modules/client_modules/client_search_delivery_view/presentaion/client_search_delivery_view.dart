import 'dart:async';

import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/custom_map.dart';
import 'package:firstproject001/shared/component/getCityNameByCoordinates.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../shared/component/components.dart';

import 'package:get/get.dart' as getx;

class ClientSearchDeliveryView extends StatefulWidget {
  const ClientSearchDeliveryView({super.key,required this.myLocation});

  final LatLng myLocation;

  @override
  State<ClientSearchDeliveryView> createState() => _ClientSearchDeliveryViewState();
}

class _ClientSearchDeliveryViewState extends State<ClientSearchDeliveryView> {

  String userCityName = "";

  LatLng orderLocation = LatLng(0, 0);
  int driversLength = 0;

  String lastBordWasOpen = "";
  bool showOrderBord = true;
  bool showRecipientBord = false;

  var orderLocationNameController = TextEditingController();
  var recipientNameController = TextEditingController();
  var recipientPhoneNumberController = TextEditingController();
  bool payOnDelivery = false;
  bool urgentOrder = false;


  //
  bool locationAreaNameError = false;
  bool recipientNameError = false;
  bool recipientPhoneNumberError = false;
  bool orderLocationError = false;

  //listen
  late DatabaseReference driversCount;
  StreamSubscription? driversSubscription;

  @override
  void initState() {
    super.initState();

    //check if can access to user location

    if(widget.myLocation.latitude != 0) {

      Map userCityNameMap = getCityNameByCoordinates(widget.myLocation);

      if(userCityNameMap["condition"]) {
        userCityName = userCityNameMap["cityName"];


        // listen to drivers requests
         driversCount = FirebaseDatabase.instance.ref("fasterApps/general/${userCityName}/drivers");
        driversSubscription = driversCount.onValue.listen((event) {
          DataSnapshot snapshot = event.snapshot;

          if (snapshot.exists) {
            Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
            setState(() {
              driversLength = data.values.toList().length;
            });

          } else {
            setState(() {
              driversLength = 0;
            });
          }
        });


      }else {
        toastificationWithWaitTime(
            context,
            title:"غير مدعوم",
            desc: "المدينة الخاصة بك غير مدعومة بالوقت الحالي",
            icon:const Icon(Icons.close,color: Colors.white,),
            backgroundColor: Colors.red
        );
        Navigator.pop(context);

      }


    }else {

      toastificationWithWaitTime(
        context,
        title:"صلاحية الوصول",
        desc: "هنالك مشكلة في الوصول للموقع الجغرافي الخاص بك",
        icon:const Icon(Icons.close,color: Colors.white,),
        backgroundColor: Colors.red
      );
      Navigator.pop(context);

    }





  }
  @override
  void dispose() {
    driversSubscription?.cancel();
    super.dispose();

  }

void setLocation(location){
    setState(() {
      orderLocation = location;
    });
}
  void setValuePayOnDelivery(bool value) {
    setState(() {
      payOnDelivery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
      listener: (context,state)=>{

        if(state is SearchOnDeliveryDriverError){
          customeToastification(
              context,
              title: "حدثت مشكلة",
              desc: state.showError(),
              icon:const Icon(Icons.close,color:Colors.white),
              backgroundColor: Colors.red)
        },

        if(state is SearchOnDeliveryDriverSuccess) {
          customeToastification(
              context,
              title: "",
              desc: "تم ايجاد سائق ورحلة بدأت",
              icon:const Icon(Icons.check,color:Colors.white),
              backgroundColor: Colors.green),
          Navigator.pop(context)

        }

      },
      builder: (context,state){
        ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
        return Scaffold(
          body:Stack(
            children: [
              //if the user location not found
              Visibility(
                visible: widget.myLocation.latitude == 0,
                child: Container(
                  width: double.infinity, // Or a specific width
                  height: double.infinity, // Or a specific height
                  child: Image.asset(
                    'images/location_p.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Visibility(
                visible: widget.myLocation.latitude == 0,
                child: const SpinKitChasingDots(
                    color: mainColor,
                    size: 90
                ),
              ),
              //

              //the map
              Visibility(
                visible: widget.myLocation.latitude != 0,
                child: Container(
                  child: Column(
                    children: [
                      CustomMap(
                        setLocation: setLocation,
                        location: LatLng(0, 0),
                        secondLocation:widget.myLocation,
                        thirdLocation:LatLng(0, 0),
                        fourthLocation: LatLng(0, 0),
                        enableSelectLocation: showRecipientBord ?  true : false,
                      ),
                    ],
                  ),
                ),
              ),

              //top buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ]
                          ),
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          },
                            icon: Icon(Icons.arrow_back,color: deliveryMainColor,),
                          )),
                     const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: IconButton(onPressed: (){
                         setState(() {
                           if(showOrderBord){
                             lastBordWasOpen = "showOrderBord";
                             showOrderBord = false;
                           }else if(showRecipientBord) {
                             lastBordWasOpen = "showRecipientBord";
                             showRecipientBord = false;
                           }else if (lastBordWasOpen == "showOrderBord" || lastBordWasOpen.isEmpty) {
                             lastBordWasOpen = "";
                             showOrderBord = true;
                           }else {
                             lastBordWasOpen = "";
                             showRecipientBord = true;
                           }

                         });

                        },
                            icon: Image.asset("icons/handAndBox.png",width: 30,height: 30,)),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration:const BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft:Radius.circular(15),
                          topLeft:Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("${driversLength}",style:const TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white,
                                fontSize: 20
                            ),),
                          ),
                          const SizedBox(height: 7,),
                          Image.asset('icons/driver.png',width: 40,height: 40,),
                        ],
                      ),
                    ),
                  )
              ),

              //boards

              Visibility(
                visible: showOrderBord,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        color: Colors.white.withOpacity(0.9)
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      "قم بأعداد طلبك الخاص",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey.withOpacity(0.8)
                                      ),
                                    )
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: (){
                                          setState(() {
                                            showOrderBord = false;
                                            showRecipientBord = true;
                                          });
                                        },
                                        child:const Text(
                                          "تعديل",
                                          style: TextStyle(
                                            color: mainColor
                                          ),
                                        )
                                    ),
                                    const Spacer(),
                                     Text(
                                      'معلومات مستلم الطرد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: orderLocationError || locationAreaNameError || recipientNameError ? Colors.red : Colors.black
                                      ),
                                    ),
                                    Visibility(
                                      visible: orderLocationError || locationAreaNameError || recipientNameError,
                                      child: const SizedBox(width: 3,),
                                    ),
                                    Visibility(
                                      visible: orderLocationError || locationAreaNameError || recipientNameError,
                                      child: const Text(
                                        "*",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                const SizedBox(height: 10,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                     Text(
                                      'حالة الطرد',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                    Visibility(
                                      // visible: locationFieldErrorShow,
                                        visible: false,
                                        child: const Text("*",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                                    )

                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          urgentOrder = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: urgentOrder ? mainColor.withOpacity(0.4) : Colors.grey.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child:const Text(
                                          "مستعجل",
                                          textAlign: TextAlign.center,
                                        ),

                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          urgentOrder = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                        width: 110,
                                        decoration: BoxDecoration(
                                            color: urgentOrder ? Colors.grey.withOpacity(0.4) : mainColor.withOpacity(0.4) ,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child:const Center(
                                          child:  Text(
                                            "غير مستعجل"
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    CustomSwitch(payOnDeliverySetValue: setValuePayOnDelivery,),
                                    const Spacer(),
                                    const Text(
                                      'الدفع عند الاستلام',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),


                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            orderLocationError = false;
                            locationAreaNameError = false;
                            recipientNameError = false;
                            recipientPhoneNumberError = false;

                            if(orderLocationNameController.text.isEmpty || orderLocationNameController.text.length > 15) {
                              setState(() {
                                locationAreaNameError = true;
                              });
                            }
                            if(recipientNameController.text.isEmpty || recipientNameController.text.length > 15) {
                              setState(() {
                                recipientNameError = true;
                              });
                            }
                            if(recipientPhoneNumberController.text.length != 10) {
                              setState(() {
                                recipientPhoneNumberError = true;
                              });
                            }
                            if(orderLocation.latitude == 0 || orderLocation.longitude == 0){
                              setState(() {
                                orderLocationError = true;
                              });
                            }

                            Map orderInfo = {
                              "cityName": userCityName,
                              "orderAreaLocationName": orderLocationNameController.text,
                              "latitudeForClient":widget.myLocation.latitude,
                                "longitudeForClient":widget.myLocation.longitude,
                              "isUrgentOrder": urgentOrder,
                              "latitudeForRecipient":orderLocation.latitude,
                                "longitudeForRecipient":orderLocation.longitude,
                              "payMethod": payOnDelivery,
                              "recipientName": recipientNameController.text,
                              "recipientPhoneNumber": recipientPhoneNumberController.text
                            };

                            if(!orderLocationError && !locationAreaNameError && !recipientNameError && !recipientPhoneNumberError) {
                              cubit.findTheNearestDriver(
                                orderInfo:  orderInfo
                              );
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            minimumSize:const  Size(double.infinity, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          ),
                          child: const Text('البحث عن سائق'),
                        )

                      ],
                    ),
                  ),
                ),
              ),
              // recipient info
              Visibility(
                visible: showRecipientBord,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        color: Colors.white.withOpacity(0.9)
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      "معلومات مستلم الطرد",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey.withOpacity(0.8)
                                      ),
                                    )
                                ),
                                const SizedBox(height: 10,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'اسم مستلم الطرد',
                                      style: const TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    Visibility(
                                        // visible: locationFieldErrorShow,
                                        visible: false,
                                        child: const Text("*",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                                    )

                                  ],
                                ),
                                const SizedBox(height: 10,),
                                CustomInputWithIconTow(
                                  topLeftIcon: false,
                                  icon: Icons.drive_file_rename_outline,
                                  hintText: 'الاسم',
                                  backgroundColor: Colors.transparent,
                                  iconColor: Colors.grey,
                                  borderColor: recipientNameError ? Colors.red : Colors.grey,
                                  keyboardType: TextInputType.text,
                                  validFunc: (value){},
                                  controller: recipientNameController,
                                ),
                                const SizedBox(height: 10,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                     Text(
                                      'رقم هاتف مستلم الطرد',
                                      style:  TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    Visibility(
                                      // visible: locationFieldErrorShow,
                                        visible: false,
                                        child:  Text("*",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                                    )

                                  ],
                                ),
                                const SizedBox(height: 10,),
                                CustomInputWithIconTow(
                                  topLeftIcon: false,
                                  icon: Icons.phone_android,
                                  hintText: 'رقم الهاتف',
                                  backgroundColor: Colors.transparent,
                                  iconColor: Colors.grey,
                                  borderColor: recipientPhoneNumberError ? Colors.red : Colors.grey,
                                  keyboardType: TextInputType.phone,
                                  validFunc: (value){},
                                  controller: recipientPhoneNumberController,
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      orderLocation.latitude == 0 && orderLocation.longitude == 0 ? 'الخريطة - غير محدد' : "تم تحديد الموقع",
                                      style: TextStyle(color: orderLocationError ? Colors.red : Colors.black),),
                                    const SizedBox(width: 10,),
                                    Image.asset("icons/order-location.png",width: 20,height: 20,)
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                CustomInputWithIconTow(
                                  topLeftIcon: false,
                                  icon: Icons.location_on,
                                  hintText: 'قم بكتابة اسم المنطقة او الشارع ',
                                  backgroundColor: Colors.transparent,
                                  iconColor: Colors.grey,
                                  borderColor: locationAreaNameError? Colors.red : Colors.grey,
                                  keyboardType: TextInputType.text,
                                  validFunc: (value){},
                                  controller: orderLocationNameController,
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            orderLocationError = false;
                            locationAreaNameError = false;
                             recipientNameError = false;
                             recipientPhoneNumberError = false;

                            if(orderLocationNameController.text.isEmpty || orderLocationNameController.text.length > 15) {
                              setState(() {
                                locationAreaNameError = true;
                              });
                            }
                            if(recipientNameController.text.isEmpty || recipientNameController.text.length > 15) {
                              setState(() {
                                recipientNameError = true;
                              });
                            }
                            if(recipientPhoneNumberController.text.length != 10) {
                              setState(() {
                                recipientPhoneNumberError = true;
                              });
                            }
                            if(orderLocation.latitude == 0 || orderLocation.longitude == 0){
                              setState(() {
                                orderLocationError = true;
                              });
                            }

                            if(!orderLocationError && !locationAreaNameError && !recipientNameError && !recipientPhoneNumberError) {
                              setState(() {
                                showRecipientBord = false;
                                showOrderBord = true;
                              });
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            minimumSize:const  Size(double.infinity, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          ),
                          child: const Text('تأكيد'),
                        )

                      ],
                    ),
                  ),
                ),
              ),


              //loading
              Visibility(
                visible: state is ClientNavigateToMapProcess,
                  child:Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: mainColor.withOpacity(0.2),
                    child: const SpinKitChasingDots(
                        color: mainColor,
                        size: 90
                    ),
                  )
              ),
              ////
              //loading -search on driver
              Visibility(
                  visible: state is SearchOnDeliveryDriverProcess,
                  child:Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.2),
                    child: const SpinKitPulsingGrid(
                        color: Colors.white,
                        size: 90
                    ),
                  )
              ),
              Visibility(
                visible: state is SearchOnDeliveryDriverProcess,
                child:const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Text(
                      "جاري البحث عن سائق",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                         fontSize: 30
                       ),
                    ),
                  ),
                ),
              ),
              //exist button
              Visibility(
                visible: state is SearchOnDeliveryDriverProcess,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:const EdgeInsets.only(top: 250),
                    child:  ElevatedButton(
                      onPressed: () {
                        cubit.cancelSearchForDriver();
                        // getx.Get.off(
                        //       () => BlocProvider.value(
                        //     value: BlocProvider.of<ClientLayoutCubit>(context),
                        //     child: ClientSearchDeliveryView(myLocation: cubit.userLocation),
                        //   ),
                        // );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize:const  Size(130,40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),

                      ),
                      child:const Text('الغاء',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ),
              )



            ],
          ),
        );
      },
    );
  }

  void toastificationWithWaitTime(context,{
    @required title,
    @required desc,
    @required icon,
    @required backgroundColor
}) async{
      customeToastification(
          context,
          title: title,
          desc: desc,
          icon: icon,
          backgroundColor: backgroundColor
      );
      await Future.delayed(const Duration(seconds: 5));
  }


}
