
import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_map_view/presentaion/delivery_map_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;

import '../../../shared/component/toastification.dart';

class DeliveryMainLayout extends StatefulWidget {
  const DeliveryMainLayout({super.key});

  @override
  State<DeliveryMainLayout> createState() => _DeliveryMainLayoutState();
}

class _DeliveryMainLayoutState extends State<DeliveryMainLayout> {

  int pendingRequestsLength = 0;
  int pendingGeneralRequestsLength = 0;
  int offersLength = 0;

  @override
  void initState() {

    super.initState();
    // listen to general requests
    String? driverCityName = CacheHelper.getString("cityName");

    if(driverCityName != "") {
      DatabaseReference generalRequests = FirebaseDatabase.instance.ref(
          "fasterApps/general/${driverCityName}/pendingRequests/");
      generalRequests.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            pendingGeneralRequestsLength = data.values
                .toList()
                .length;
          });
        } else {
          setState(() {
            pendingGeneralRequestsLength = 0;
          });
        }
      });
    }
    // get order from company
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref("fasterApps/companies/${CacheHelper.getString("companyId")}/pendingRequests/");
    ordersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          pendingRequestsLength = data.length;
        });

      } else {
       setState(() {
         pendingRequestsLength = 0;
       });
      }

    });

    // get offers
    DatabaseReference offersRef = FirebaseDatabase.instance.ref("fasterApps/drivers/${CacheHelper.getString("userId")}/pendingOffers/");
    offersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          offersLength = data.values.toList().length;
        });
      } else {
        setState(() {
          offersLength = 0;
        });
      }

    });


  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeliveryLayoutCubit()..getUserInformation()..setUserLocation()..durationMethod(),
      child: BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
        listener: (context,state)=>{


           if(state is AcceptRequestCompleted) {

            Navigator.of(context).push(
            MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
                value: BlocProvider.of<DeliveryLayoutCubit>(context),
                child:const DeliveryMapView()
            ),
          )
           )

           },




          if(state is GetOrderInfoAfterProblemConnectionError){

            customeToastification(
                context,
                title: "اتصال سيء بلانترنت",
                desc: "حاول مرة اخرى في وقت لاحق",
                icon: const Icon(Icons.close),
                backgroundColor: Colors.red
            )
          },
          if(state is GetOrderInfoAfterProblemConnectionSuccess){
      //
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
                value: BlocProvider.of<DeliveryLayoutCubit>(context),
                child:const DeliveryMapView()
            ),
          )
      )

          }


        },
        builder: (context,state) {
          DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
          return ConditionalBuilder(
              condition: state is DeliveryLayoutStatesInitial ||state is GetDriverInformationProcess || state is DeliveryDurationMethodProcess,
              builder: (context)=>Container(
                width: double.infinity,
                height: double.infinity,
                color: deliveryMainColor,
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
                body: Stack(
                  children: [
                    cubit.deliveryLayoutScreens[cubit.bottomNavigationBarIndex],
                    Visibility(
                      visible: CacheHelper.getString("acceptRequest") != null ,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50,right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                            ),
                            child: TextButton(
                                onPressed: (){
                                  String? acceptedRequest = CacheHelper.getString("acceptRequest");
                                  if(acceptedRequest != null){
                                    cubit.getOrderInfoAfterProblemConnection();
                                  }else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (newContext) => BlocProvider.value(
                                              value: BlocProvider.of<DeliveryLayoutCubit>(context),
                                              child:const DeliveryMapView()
                                          ),
                                        )
                                    );
                                  }


                                },
                                child: Text("الخريطة",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),)
                            ),
                          ),
                        ),
                      ),
                    )
                  ],),
                bottomNavigationBar: Directionality(
                  textDirection: TextDirection.rtl,
                  child: BottomNavigationBar(
                      currentIndex: cubit.bottomNavigationBarIndex,
                      selectedItemColor: deliveryMainColor,
                      showSelectedLabels: true,
                      onTap: (index){
                        cubit.changeBottomNavigationBarIndex(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Image.asset('icons/home.png',width: 25,height: 25,),
                            label: "الرئيسية"
                        ),

                        BottomNavigationBarItem(
                            icon: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.blue,
                                ),
                                Center(
                                  child: Image.asset('icons/order-history.png',width: 25,height: 25,),
                                ),
                                Positioned(
                                  top: 0,
                                  left:(pendingRequestsLength + pendingGeneralRequestsLength) <= 10 ? 30 :
                                  (pendingRequestsLength + pendingGeneralRequestsLength) <= 99 ? 24 :
                                  (pendingRequestsLength + pendingGeneralRequestsLength) <= 999 ? 17 :
                                  (pendingRequestsLength + pendingGeneralRequestsLength) <= 9999 ? 10 : 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.red
                                    ),
                                    child: Text("${pendingRequestsLength + pendingGeneralRequestsLength}",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),),
                                  ),
                                ),

                              ],
                            ),
                            label: "الطلبات"

                        ),

                        BottomNavigationBarItem(
                          icon: Image.asset('icons/settings.png',width: 25,height: 25,),
                          label: "الحساب",
                        ),

                      ]


                  ),
                ),

              ),
          );
        },

      ),
    );
  }


  void getUserLocation2() async {

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      // Check if location services are enabled
      serviceEnabled = await Location.instance.serviceEnabled();
      if (!serviceEnabled) {
        await Location.instance.requestService();
        serviceEnabled = await Location.instance.serviceEnabled();
        if (!serviceEnabled) {
          print("Location services are disabled. Please enable them.");
          return;
        }
      }

      // Check for permission
      permissionGranted = await Location.instance.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        // Request permission
        permissionGranted = await Location.instance.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("Location permission denied");
          return;
        }
      }

      // Get the user's location
      try {
        LocationData locationData = await Location.instance.getLocation();
        // Use locationData.latitude and locationData.longitude
        print("Location acquired: ${locationData.latitude}, ${locationData.longitude}");
      } catch (e) {
        print("Error getting location: $e");
      }
    }


}


