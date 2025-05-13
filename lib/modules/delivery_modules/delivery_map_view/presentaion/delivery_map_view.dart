import 'dart:async';

import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/custom_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../shared/component/components.dart';
import '../../../../shared/component/url_launcher.dart';

class DeliveryMapView extends StatefulWidget {
  const DeliveryMapView({super.key});

  @override
  State<DeliveryMapView> createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  LatLng orderLocation = LatLng(0, 0);


  //order box
  bool showDeliveryCodeBox = false;

  //control panel
  bool showControlPanel = false;

  bool showClientInfo = true;
  bool showRecipientInfo = false;

  //driver Delivery Failure
  bool showDriverDeliveryFailureBox = false;
  var deliveryFailureMessageController = TextEditingController();
  bool deliveryFailureMessageShowError = false;
  String deliveryFailureMessageMsgError = "";

  var codeController = TextEditingController();

  //
  Location _locationController = new Location();
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng currentUserLocation = LatLng(0, 0);
  //
  bool stopLocationListen = true;

  @override
  void initState() {
    super.initState();

      stopLocationListen = true;
      if(stopLocationListen){


        _locationSubscription = _locationController.onLocationChanged.listen(
              (LocationData currentLocation) async {
            if (currentLocation.latitude != null && currentLocation.longitude != null) {
              await Future.delayed(const Duration(seconds: 3));
              //   currentUserLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
              if (mounted) {
                DeliveryLayoutCubit.get(context).setCurrentLocation(currentLocation);
              }

            }else {
              currentUserLocation = LatLng(0, 0);

            }
          },
        );


      }

  }

  @override
  void dispose() {
    _locationSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
        listener: (context,state)=>{

          if(state is TheOrderHasBeenDeliveredCompleted){
            Navigator.pop(context)
          },

          if(state is ReportAboutDeliveryProcessSuccess) {
            Navigator.pop(context)
          }

        },
        builder: (context,state){
          DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
          return Scaffold(
            body:Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      CustomMap(
                        setLocation: (value){},
                        location: orderLocation,
                        secondLocation:
                        showClientInfo ? LatLng(cubit.acceptRequest["clientInfo"]["latitudeForClient"], cubit.acceptRequest["clientInfo"]["longitudeForClient"]) : LatLng(0, 0),
                        thirdLocation:
                        showRecipientInfo ? LatLng(cubit.acceptRequest["recipientInfo"]["latitudeForRecipient"], cubit.acceptRequest["recipientInfo"]["longitudeForRecipient"]) : LatLng(0, 0),
                        fourthLocation: cubit.currentUserLocation,
                        enableSelectLocation: false,
                      ),
                    ],
                  ),
                ),
                // control panel
                Visibility(
                  visible: showControlPanel,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: const EdgeInsets.all(12),
                      height: showClientInfo && showRecipientInfo ? (380 + 90 * 2) :showRecipientInfo || showClientInfo ? 320 + 90 : 280,
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
                            width: double.infinity,
                            height: 30,
                            decoration:const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                color: deliveryMainColor
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            const  SizedBox(width: 10,),
                             const Text(
                                'لوحة التحكم',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.2),

                              ),


                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 1,color: showRecipientInfo ? Colors.white : deliveryMainColor),
                                  color: showRecipientInfo ? deliveryMainColor : Colors.transparent,
                                ),
                                child: TextButton(
                                    onPressed: (){
                                      setState(() {
                                        showRecipientInfo = !showRecipientInfo;
                                      });
                                    },
                                    child: Text("مستلم الطرد",style: TextStyle(color: showRecipientInfo ? Colors.white : deliveryMainColor,fontWeight: FontWeight.bold,fontSize: 12),)
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 1,color: showClientInfo ? Colors.white : deliveryMainColor),
                                  color: showClientInfo ? deliveryMainColor : Colors.transparent,
                                ),
                                child: TextButton(
                                    onPressed: (){
                                      setState(() {
                                        showClientInfo = !showClientInfo;
                                      });
                                    },
                                    child: Text("مرسل الطرد",style: TextStyle(color: showClientInfo ? Colors.white : deliveryMainColor,fontWeight: FontWeight.bold,fontSize: 12),)
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: showClientInfo,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 7,),
                                    const  Text("مرسل الطرد",style: TextStyle(color: deliveryMainColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                      const  SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(cubit.acceptRequest["clientInfo"]["clientPhoneNumber"],maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                         const SizedBox(width: 5,),
                                          Image.asset("icons/phone-brown.png",width: 20,height: 20,),
                                         const Spacer(),
                                          Text(cubit.acceptRequest["clientInfo"]["clientName"],maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                         const SizedBox(width: 5,),
                                          Image.asset("icons/id-card-brown.png",width: 20,height: 20,)
                                        ],
                                      ),
                                      const  SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(cubit.acceptRequest["clientInfo"]["nameAddress"],maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                          SizedBox(width: 5,),
                                          Image.asset("icons/user-location-brown.png",width: 20,height: 20,)
                                        ],
                                      ),
                                      const  SizedBox(height: 7,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                                onPressed: (){
                                                  launchUrlSms(phoneNumber: "+97${cubit.acceptRequest["clientInfo"]["clientPhoneNumber"]}");
                                                }
                                                , child:Text("رسالة",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                                onPressed: (){
                                                  launchUrlTel(phoneNumber: "+97${cubit.acceptRequest["clientInfo"]["clientPhoneNumber"]}");
                                                }
                                                , child:Text("اتصال",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                            ),
                                          ),

                                        ],
                                      ),
                                      const  SizedBox(height: 7,),

                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: showClientInfo && showRecipientInfo,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ),
                                Visibility(
                                  visible: showRecipientInfo,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("مستلم الطرد",style: TextStyle(color: deliveryMainColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                      const  SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(cubit.acceptRequest["recipientInfo"]["recipientPhoneNumber"],maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                          SizedBox(width: 5,),
                                          Image.asset("icons/phone-brown.png",width: 20,height: 20,),
                                         const Spacer(),
                                          Text(cubit.acceptRequest["recipientInfo"]["recipientName"],maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                         const SizedBox(width: 5,),
                                          Image.asset("icons/id-card-brown.png",width: 20,height: 20,)
                                        ],
                                      ),
                                      const  SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cubit.acceptRequest["recipientInfo"]["nameAddress"] != null ? cubit.acceptRequest["recipientInfo"]["nameAddress"] :
                                            cubit.acceptRequest["orderInfo"]["locationName"] != null ? cubit.acceptRequest["orderInfo"]["locationName"] :
                                                ""
                                            ,maxLines: 1,style: TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                          SizedBox(width: 5,),
                                          Image.asset("icons/order-location-brown.png",width: 20,height: 20,)
                                        ],
                                      ),
                                      const  SizedBox(height: 7,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                                onPressed: (){
                                                  launchUrlSms(phoneNumber: "+97${cubit.acceptRequest["recipientInfo"]["recipientPhoneNumber"]}");
                                                }
                                                , child:Text("رسالة",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                                onPressed: (){
                                                  launchUrlTel(phoneNumber: "+97${cubit.acceptRequest["recipientInfo"]["recipientPhoneNumber"]}");
                                                }
                                                , child:Text("اتصال",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                            ),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(height: 7,),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showControlPanel = false;
                                      showDeliveryCodeBox = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    minimumSize:  Size(double.infinity, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child:  Text('وصلت الى الوجهة'),
                                )

                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            height: 30,
                            color: deliveryMainColor,
                          )


                        ],
                      ),
                    ),
                  ),
                ),
                // order
                Visibility(
                  visible: showDeliveryCodeBox,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: const EdgeInsets.all(12),
                      height: 260,
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
                            width: double.infinity,
                            height: 30,
                            decoration:const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                color: deliveryMainColor
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.1),
                              ),
                              const SizedBox(width: 10,),
                             const Text(
                                'تسليم الطرد',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.2),

                              ),

                            ],
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                            child: Column(
                              children: [

                                ElevatedButton(
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
                                                const Text("هل تم تسليم الطلب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: (){
                                                          _locationSubscription!.cancel();
                                                          cubit.theOrderHasBeenDelivered();
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
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    minimumSize:  Size(double.infinity, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child:  Text('تم تسليم الطرد بنجاح',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ),
                                const SizedBox(height: 8,),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showDeliveryCodeBox = false;
                                      showDriverDeliveryFailureBox = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.orange,
                                    minimumSize:  Size(double.infinity, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child:  Text('لم يتم تسليم الطلب',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ),

                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            height: 30,
                            color: deliveryMainColor,
                          )


                        ],
                      ),
                    ),
                  ),
                ),
                // problem with order
                Visibility(
                  visible: showDriverDeliveryFailureBox,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: const EdgeInsets.all(12),
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          color: Colors.white.withOpacity(0.9)
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                color: deliveryMainColor
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.1),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                'مشكلة بتسليم الطلب',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 20,
                                height: 1,
                                color: Colors.black.withOpacity(0.2),

                              ),

                            ],
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                            child: Column(
                              children: [
                                const  Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                     Text(
                                      "الرسالة",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                    ),
                                     SizedBox(width: 5,),
                                     Icon(Icons.text_format,color: Colors.black,)
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                TextFormField(
                                  controller: deliveryFailureMessageController,
                                  maxLines: 4,
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    hintText: "ما المشكلة التي واجهتك .....",
                                    hintTextDirection: TextDirection.rtl,
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.3)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: deliveryMainColor ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(color: Colors.red),

                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:  BorderSide(color: deliveryMainColor,width: 2),
                                    ),
                                    focusedErrorBorder:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(color: Colors.red,width: 2),
                                    ),
                                    contentPadding:const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "لا يمكن ترك حقل الرسالة فارغ";
                                    }
                                    if(value.length < 5 || value.length > 40){
                                      return "يجب ان يكون حقل الرسالة بين 5 خانات و 40 خانة";
                                    }
                                    return null;
                                  },
                                ),
                                Visibility(
                                  visible: deliveryFailureMessageShowError,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                    deliveryFailureMessageMsgError,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 13
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      deliveryFailureMessageShowError = false;
                                      deliveryFailureMessageMsgError = "";

                                      if(deliveryFailureMessageController.text.length < 3 || deliveryFailureMessageController.text.length > 40){
                                        deliveryFailureMessageShowError = true;
                                        deliveryFailureMessageMsgError = "يجب ان يكون حقل الرسالة اكبر من 3 خانات واقل من 40 خانة";
                                      }

                                      if(deliveryFailureMessageController.text.isEmpty){
                                        deliveryFailureMessageShowError = true;
                                        deliveryFailureMessageMsgError = "لا يمكن ترك حقل الرسالة فارغ";
                                      }



                                    });

                                    if(!deliveryFailureMessageShowError){
                                      print("sucss");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    minimumSize:  Size(double.infinity, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child:  Text('ارسال',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ),

                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            height: 30,
                            color: deliveryMainColor,
                          )


                        ],
                      ),
                    ),
                  ),
                ),

                //buttons
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
                                  offset: Offset(0, 3),
                                ),
                              ]
                          ),
                          child: IconButton(onPressed: (){
                            setState(() {
                              showDeliveryCodeBox = false;
                              showDriverDeliveryFailureBox = false;
                              showControlPanel = !showControlPanel;
                            });
                          },
                              icon: Image.asset("icons/sliders.png",width: 30,height: 30,)),
                        ),
                        const SizedBox(width: 10,),
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

                            setState(() {
                              showControlPanel = false;
                              showDriverDeliveryFailureBox = false;
                              showDeliveryCodeBox = !showDeliveryCodeBox;
                            });

                          },
                              icon: Image.asset("icons/delivery.png",width: 30,height: 30,)),
                        ),
                      ],
                    ),
                  ),
                ),

                Visibility(
                    visible: state is TheOrderHasBeenDeliveredProcess,
                    child: Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child:const SpinKitCubeGrid(
                          color: deliveryMainColor,
                          size: 50,
                        ),
                      ),
                    )),

              ],
            ),
          );
        },
    );
  }
  void _startListeningToLocation() async {
    _locationSubscription = _locationController.onLocationChanged.listen(
          (LocationData currentLocation) async {
        if (currentLocation.latitude != null && currentLocation.longitude != null) {
          // await Future.delayed(Duration(milliseconds: 10000));
          currentUserLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(currentUserLocation);
        }else {
          currentUserLocation = LatLng(0, 0);

        }
      },
    );
  }

}
