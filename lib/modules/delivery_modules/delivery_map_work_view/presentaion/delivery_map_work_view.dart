import 'dart:async';


import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/custom_map.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;
import 'package:firebase_database/firebase_database.dart';

import '../../../../shared/component/url_launcher.dart';

class DeliveryMapWorkView extends StatefulWidget {
  const DeliveryMapWorkView({super.key,required this.driverLocation});

  final LatLng driverLocation;
  @override
  State<DeliveryMapWorkView> createState() => _DeliveryMapWorkViewState();
}

class _DeliveryMapWorkViewState extends State<DeliveryMapWorkView> {
  LatLng clientLocation = LatLng(0, 0);
  LatLng orderLocation = LatLng(0, 0);
  List<dynamic> pendingRequests = [];
  bool showControlPanel = false;
  bool showReportOrderBox = false;
  bool showClientInfo = true;
  bool showRecipientInfo = false;

  var deliveryFailureMessageController = TextEditingController();
  var keyForm = GlobalKey<FormState>();
  // listen
  Location _locationController = new Location();
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng currentUserLocation = LatLng(0, 0);
  //
  bool stopLocationListen = true;

  late DatabaseReference pendingRequestRef;
  StreamSubscription? pendingRequestSubscription;


  @override
  void initState() {
    DeliveryLayoutCubit.get(context).navigateToMapView();

    super.initState();
  String? cityName = CacheHelper.getString("userCity");

    if(widget.driverLocation.latitude == 0 || widget.driverLocation.longitude == 0 || cityName == null) {
      Navigator.pop(context);

    }


    stopLocationListen = true;
    if(stopLocationListen){


      _locationSubscription = _locationController.onLocationChanged.listen(
            (LocationData currentLocation) async {
          if (currentLocation.latitude != null && currentLocation.longitude != null) {
            await Future.delayed(const Duration(seconds: 3));
            //   currentUserLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);

            String? acceptedRequest = CacheHelper.getString("generaRequest");

            if(mounted){

              if(acceptedRequest != null || acceptedRequest == "accepted") {
                DeliveryLayoutCubit.get(context).setCurrentLocationInWorkMapAfter(currentLocation);
                print(currentLocation);
              }else {
                DeliveryLayoutCubit.get(context).setCurrentLocationInWorkMapBefore(currentLocation);
                print(currentLocation);
              }


            }

          }else {
            currentUserLocation = LatLng(0, 0);

          }
        },
      );


    }

    //listen

     pendingRequestRef = FirebaseDatabase.instance.ref("fasterApps/drivers/${CacheHelper.getString("userId")}/general/pendingRequests");
    pendingRequestSubscription = pendingRequestRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
         pendingRequests = data.values.toList();
        });
      } else {
        setState(() {
          pendingRequests = [];
        });
      }

    });

  }

  @override
  void dispose() async{
    super.dispose();
    _locationSubscription!.cancel();
    pendingRequestSubscription?.cancel();

    DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");
    await fasterAppRef.child("general/${CacheHelper.getString("userCity")}/drivers/${CacheHelper.getString("userId")}/").remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
      listener: (context,state)=>{

        if(state is ReportAboutDeliveryProcessSuccess) {
          Navigator.pop(context)
        },
        if(state is TheOrderHasBeenDeliveredCompleted){
          Navigator.pop(context)
        }

      },
      builder: (context,state){
        DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
        return Scaffold(
          body:Stack(
            children: [


              // map
              Container(
                child: Column(
                  children: [
                    CustomMap(
                      setLocation: (value){},
                      location: LatLng(0, 0),
                      secondLocation: cubit.orderInformation.isNotEmpty && showClientInfo ?
                      LatLng(cubit.orderInformation["clientInfo"]["latitudeForClient"], cubit.orderInformation["clientInfo"]["longitudeForClient"]) :
                       clientLocation.latitude != 0 ? LatLng(clientLocation.latitude, clientLocation.longitude) : LatLng(0,0),
                      thirdLocation:cubit.orderInformation.isNotEmpty && showRecipientInfo ?
                      LatLng(cubit.orderInformation["recipientInfo"]["latitudeForRecipient"], cubit.orderInformation["recipientInfo"]["longitudeForRecipient"]) :
                      orderLocation.latitude != 0 ? LatLng(orderLocation.latitude, orderLocation.longitude) : LatLng(0, 0),
                      fourthLocation: cubit.userLocation,
                      enableSelectLocation: false,
                    ),
                  ],
                ),
              ),

              // driver info board
              Visibility(
                visible: pendingRequests.isEmpty && cubit.orderInformation.isEmpty,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        border: Border.all(width: 2,color: deliveryMainColor),
                        borderRadius:const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${DeliveryLayoutCubit.get(context).driverInfo["driverName"].isEmpty ? "" : DeliveryLayoutCubit.get(context).driverInfo["driverName"]}",
                                  style:const TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 4,),
                                Text(
                                  "${DeliveryLayoutCubit.get(context).driverInfo["driverPhoneNumber"].isEmpty ? "" : DeliveryLayoutCubit.get(context).driverInfo["driverPhoneNumber"]}",
                                  style:const TextStyle(
                                      color: Colors.grey
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(width: 10,),
                            ConditionalBuilder(
                              condition: DeliveryLayoutCubit.get(context).driverInfo.isNotEmpty && DeliveryLayoutCubit.get(context).driverInfo["profilePic"].isNotEmpty ,
                              builder: (context)=>CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage("${DeliveryLayoutCubit.get(context).driverInfo["profilePic"]}"),
                              ),
                              fallback: (context)=>const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage("icons/driver.png"),
                              ),
                            ),

                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("متصل",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                            const SizedBox(width: 2,),
                            Text("انت لان",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),

              ),

              //show offers board
              ConditionalBuilder(
                  condition: cubit.orderInformation.isEmpty,
                  //show offers
                  builder: (context) => Visibility(
                    visible: pendingRequests.isNotEmpty && cubit.orderInformation.isEmpty,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 35,
                            decoration: const BoxDecoration(
                                color: deliveryMainColor,
                                borderRadius:const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                )
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.white.withOpacity(0.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.red
                                  ),
                                  child: Text(
                                    '${pendingRequests.length}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),

                                ),
                                const SizedBox(width: 4,),
                                const Text(
                                  "عدد الطلبات",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 12,bottom: 12,left: 12),
                            height: pendingRequests.length <= 1 ? 260 : 500,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                            ),
                            child: ListView.separated(
                                itemCount: pendingRequests.length,
                                separatorBuilder: (context,index)=>Container(
                                  height: 1,
                                  width: double.infinity,
                                  color:Colors.black.withOpacity(0.1),
                                  // margin:const EdgeInsets.only(bottom: 5),
                                ),
                                itemBuilder: (context,index) {
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: (){
                                                  if(orderLocation.longitude == 0) {
                                                    setState(() {
                                                      orderLocation = LatLng(
                                                          pendingRequests[index]['recipientInfo']['latitudeForRecipient'],
                                                          pendingRequests[index]['recipientInfo']['longitudeForRecipient']);
                                                      clientLocation = LatLng(
                                                          pendingRequests[index]['clientInfo']['latitudeForClient'],
                                                          pendingRequests[index]['clientInfo']['longitudeForClient']);

                                                    });
                                                  }else {
                                                    setState(() {
                                                      orderLocation = LatLng(0, 0);
                                                      clientLocation= LatLng(0, 0);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.info,size: 30,)
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: Colors.red
                                              ),
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16
                                                ),
                                              ),

                                            ),
                                            const SizedBox(width: 4,),
                                            const Text(
                                              "الطلب رقم",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ConditionalBuilder(
                                              condition: pendingRequests.isNotEmpty && pendingRequests[index]["clientInfo"]["profilePic"].isNotEmpty,
                                              builder: (context)=> CircleAvatar(
                                                radius: 22,
                                                backgroundColor: Colors.grey,
                                                backgroundImage: NetworkImage('${pendingRequests[index]["clientInfo"]["profilePic"]}'),
                                              ),
                                              fallback: (context)=> const CircleAvatar(
                                                radius: 22,
                                                backgroundColor: Colors.grey,
                                                backgroundImage: AssetImage('icons/user (1).png'),
                                              ),
                                            )

                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${pendingRequests[index]["clientInfo"]["clientPhoneNumber"]}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 3,),
                                            const Icon(Icons.phone_android),


                                            const Spacer(),
                                            Text(
                                              "${pendingRequests[index]["clientInfo"]["clientName"]}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 3,),
                                            const CircleAvatar(
                                              radius: 12,
                                              backgroundImage: AssetImage('icons/id-card.png'),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text(
                                                pendingRequests[index]["orderInfo"]["urgent"] ? "مستعجل" : "غير مستعجل"
                                            ),
                                            const SizedBox(width: 3,),
                                            const Icon(Icons.speed),
                                            const Spacer(),
                                            Text(
                                                pendingRequests[index]["orderInfo"]["payMethod"] ? "تم دفع" : "الدفع عند الاستسلام"
                                            ),
                                            const SizedBox(width: 3,),
                                            const Icon(Icons.attach_money),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            const Spacer(),
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
                                                                Text("هل تريد رفض الطلب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 20),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                TextButton(
                                                                    onPressed: (){
                                                                      cubit.driverRejectGeneralRequest(orderInfo: pendingRequests[index]);
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
                                                width: 120,
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.red
                                                ),
                                                child: const Center(
                                                  child:  Text(
                                                    "رفض",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
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
                                                                Text("هل تريد قبول الطلب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 20),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                TextButton(
                                                                    onPressed: (){
                                                                      cubit.driverAcceptGeneralRequest(orderInfo: pendingRequests[index]);
                                                                      showControlPanel =true;
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
                                                width: 120,
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.green
                                                ),
                                                child:const Center(
                                                  child: Text(
                                                    "قبول",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //show offer information
                  fallback: (context)=>Visibility(
                    visible: cubit.orderInformation.isNotEmpty && showControlPanel,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        // padding: const EdgeInsets.all(12),
                        height: showClientInfo && showRecipientInfo ? (390 + 90 * 2) :showClientInfo ? 240 + 90 :
                        showRecipientInfo ? 340+ 90 : 230,
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
                                SizedBox(width: 10,),
                                const Text(
                                  'لوحة التحكم',
                                  style:const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),
                                ),
                                const SizedBox(width: 10,),
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
                                        const Text("مرسل الطرد",style: TextStyle(color: deliveryMainColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                        const  SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text(cubit.orderInformation["clientInfo"]["clientPhoneNumber"],maxLines: 1,style:const TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                            const SizedBox(width: 5,),
                                            Image.asset("icons/phone-brown.png",width: 20,height: 20,),
                                            const Spacer(),
                                            Text(cubit.orderInformation["clientInfo"]["clientName"],maxLines: 1,style:const TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                            const SizedBox(width: 5,),
                                            Image.asset("icons/id-card-brown.png",width: 20,height: 20,)
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
                                                    launchUrlSms(phoneNumber: "+97${cubit.orderInformation["clientInfo"]["clientPhoneNumber"]}");
                                                  }
                                                  , child:const Text("رسالة",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
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
                                                    launchUrlTel(phoneNumber: "+97${cubit.orderInformation["clientInfo"]["clientPhoneNumber"]}");
                                                  }
                                                  , child:const Text("اتصال",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                              ),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: showClientInfo && showRecipientInfo,
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.symmetric(vertical: 10),
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
                                            Text(cubit.orderInformation["recipientInfo"]["recipientPhoneNumber"],maxLines: 1,style:const TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                            const SizedBox(width: 5,),
                                            Image.asset("icons/phone-brown.png",width: 20,height: 20,),
                                            const Spacer(),
                                            Text(cubit.orderInformation["recipientInfo"]["recipientName"],maxLines: 1,style:const TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                            const SizedBox(width: 5,),
                                            Image.asset("icons/id-card-brown.png",width: 20,height: 20,)
                                          ],
                                        ),
                                        const  SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(cubit.orderInformation["recipientInfo"]["nameAddress"],maxLines: 1,style:const TextStyle(color: deliveryMainColor,overflow: TextOverflow.ellipsis),),
                                            const SizedBox(width: 5,),
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
                                                    launchUrlSms(phoneNumber: "+97${cubit.orderInformation["recipientInfo"]["recipientPhoneNumber"]}");
                                                  }
                                                  , child:Text("رسالة",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
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
                                                    launchUrlTel(phoneNumber: "+97${cubit.orderInformation["recipientInfo"]["recipientPhoneNumber"]}");
                                                  }
                                                  , child:const Text("اتصال",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                              ),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(height: 7,),
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Visibility(
                              visible: showRecipientInfo,
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
                                              const Text("هل تم تسليم الطرد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: (){
                                                        _locationSubscription!.cancel();
                                                        cubit.driverDeliveredTheGeneralOrder();
                                                        setState(() {
                                                          clientLocation = LatLng(0, 0);
                                                          orderLocation = LatLng(0, 0);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("نعم",style: TextStyle(color: Colors.green),)
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(180, 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                ),
                                child:  Text('تم تسليم الطرد',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              ),
                            ),
                            const SizedBox(height: 5,),
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
              ),

              //problem with order
              Visibility(
                visible: cubit.orderInformation.isNotEmpty && showReportOrderBox,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // padding: const EdgeInsets.all(12),
                    height: 350,
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
                              'مشكلة بتسليم الطلب',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Container(
                              width: 20,
                              height: 1,
                              color: Colors.black.withOpacity(0.2),

                            ),

                          ],
                        ),
                        const SizedBox(height: 10,),
                        Form(
                          key: keyForm,
                          child: Padding(
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
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
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
                                        borderSide:const BorderSide(color: deliveryMainColor ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(color: Colors.red),

                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(color: deliveryMainColor,width: 2),
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
                                ),
                                const SizedBox(height: 5,),

                                ConditionalBuilder(
                                  condition: state is ReportAboutDeliveryProcess,
                                  builder: (context)=> const Center(
                                    child: SpinKitWave(
                                      color: companyMainColor,
                                      size: 30,
                                    ),
                                  ),
                                  fallback: (context)=>ElevatedButton(
                                    onPressed: () {
                                      if(keyForm.currentState!.validate()){
                                        _locationSubscription!.cancel();
                                        cubit.reportAboutDeliveryProcess(orderType: "general",msg: deliveryFailureMessageController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      minimumSize:const Size(double.infinity, 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding:const  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                    child: const Text('ارسال',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                  ),
                                ),

                              ],
                            ),
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

              //top decoration
              Visibility(
                visible: true,
                child: Stack(
                  children: [
                    Container(
                      height: 90,

                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration:const BoxDecoration(
                          color: deliveryMainColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width / 2.3,
                      child:const SpinKitPulse(
                          color: Colors.red,
                          size: 50
                      ),
                    ),
                  ],
                ),
              ),

              //top buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 70),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
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
                      Visibility(
                        visible: cubit.orderInformation.isNotEmpty,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset:const Offset(0, 3),
                                ),
                              ]
                          ),
                          child: IconButton(onPressed: (){
                            setState(() {
                              showReportOrderBox = !showReportOrderBox;
                              showControlPanel = false;
                            });

                          },
                              icon: Image.asset("icons/cancel-order.png",width: 30,height: 30,)),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Visibility(
                        visible: cubit.orderInformation.isNotEmpty,
                        child: Container(
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
                              showControlPanel = !showControlPanel;
                              showReportOrderBox = false;
                            });

                          },
                              icon: Image.asset("icons/delivery.png",width: 30,height: 30,)),
                        ),
                      ),



                    ],
                  ),
                ),
              ),

              // loading first time
              Visibility(
                  visible: state is DeliveryNavigateToMapProcess,
                  child:Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: mainColor.withOpacity(0.2),
                    child: const SpinKitChasingDots(
                        color: deliveryMainColor,
                        size: 90
                    ),
                  )
              ),
              // loading when order been delivered
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
