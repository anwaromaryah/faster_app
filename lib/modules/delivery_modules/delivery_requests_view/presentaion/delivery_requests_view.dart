import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_map_work_view/presentaion/delivery_map_work_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;

import '../../../../shared/component/custom_map.dart';

class DeliveryRequestsView extends StatefulWidget {
  const DeliveryRequestsView({
    super.key,
    this.deliveryCityName
  });

  final Map? deliveryCityName;

  @override
  State<DeliveryRequestsView> createState() => _DeliveryRequestsViewState();
}

class _DeliveryRequestsViewState extends State<DeliveryRequestsView> {

  bool companyRequestsAppear = true;

  List<dynamic> pendingCompanyRequestsEntries = [];

  @override
  void initState() {
    super.initState();
    DeliveryLayoutCubit.get(context).durationMethodModules();

    // listen to company requests
    DatabaseReference companyRequests = FirebaseDatabase.instance.ref("fasterApps/companies/${CacheHelper.getString("companyId")}/pendingRequests/");
    companyRequests.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          pendingCompanyRequestsEntries = data.values.toList();
        });

      } else {
        setState(() {
          pendingCompanyRequestsEntries = [];
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
        listener: (context,state)=>{
          
          
          if(state is GetGeneralOrderInfoAfterProblemConnectionError){

      customeToastification(
          context,
          title: "اتصال سيء بلانترنت",
          desc: "حاول مرة اخرى في وقت لاحق",
          icon: const Icon(Icons.close),
          backgroundColor: Colors.red
      )
          },
          if(state is GetGeneralOrderInfoAfterProblemConnectionSuccess){

        getx.Get.to(
        () =>
        BlocProvider.value(
          value: BlocProvider.of<
              DeliveryLayoutCubit>(context),
          child: DeliveryMapWorkView(
            driverLocation: DeliveryLayoutCubit.get(context).userLocation,),
        ),
    transition: getx.Transition.rightToLeft,
    duration: const Duration(milliseconds: 500),
    )
            
          }
          
        },
      builder: (context,state){
        DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
        return Stack(
          children: [
            SafeArea(
        child: Scaffold(
        backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration:const BoxDecoration(
                    color: deliveryMainColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    )
                ),
              ),
              const SizedBox(height: 10,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 1,color: deliveryMainColor),
                        color: deliveryMainColor.withOpacity(0.3)
                      ),
                      child: IconButton(
                          onPressed: () {
                            String? acceptedRequest = CacheHelper.getString("acceptRequest");

                            if(acceptedRequest != null) {

                              customeToastification(context,
                                  title: "غير مسموح",
                                  desc: "هنالك طلبية بالفعل لم يتم الانتهاء منها",
                                  icon: const Icon(Icons.close,color: Colors.white,),
                                  backgroundColor: deliveryMainColor
                              );


                            }else {

                              String? acceptedRequest = CacheHelper.getString("generaRequest");
                              if(acceptedRequest != null || acceptedRequest == "accepted"){
                                cubit.getGeneralOrderInfoAfterProblemConnection();

                              }else {
                                getx.Get.to(
                                      () =>
                                      BlocProvider.value(
                                        value: BlocProvider.of<
                                            DeliveryLayoutCubit>(context),
                                        child: DeliveryMapWorkView(
                                          driverLocation: cubit.userLocation,),
                                      ),
                                  transition: getx.Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                );
                              }


                            }

                          },
                          icon: Image.asset("icons/map_776522.png",width: 30,height: 30,)
                      ),
                    ),
                    const Spacer(),
                   const Text(
                      "الطلبات",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    companyRequestsAppear = !companyRequestsAppear;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 15),

                  decoration: BoxDecoration(
                      color: companyRequestsAppear ? deliveryMainColor : Colors.transparent,

                      border: Border.all(width: 1,color: deliveryMainColor),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back,color: companyRequestsAppear ? Colors.white : deliveryMainColor,),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text("${pendingCompanyRequestsEntries.isEmpty ? "0" : pendingCompanyRequestsEntries.length}",style: TextStyle(color: Colors.white),),
                      ),
                     const SizedBox(width: 5,),
                      Text(
                        "طلبات الشركة",
                        style: TextStyle(
                            color: companyRequestsAppear ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Image.asset("icons/express-delivery.png",width: 40,height: 40,)
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: companyRequestsAppear,
                child: ConditionalBuilder(
                    condition: pendingCompanyRequestsEntries.isNotEmpty,
                    builder: (context)=>Expanded(
                        flex: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                          color: Colors.white,
                          child: ListView.separated(
                              itemCount: pendingCompanyRequestsEntries.length,
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
                                            pendingCompanyRequestsEntries[index]["orderInfo"]["orderNumber"],
                                            maxLines: 1,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 3,),
                                          const Icon(Icons.numbers,color: Colors.grey,size: 16,),
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                      const SizedBox(height: 8,),
                                      const Text(
                                        "معلومات مرسل الطرد",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            pendingCompanyRequestsEntries[index]["clientInfo"]["clientPhoneNumber"],
                                            maxLines: 1,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                          const Icon(Icons.phone,color:Colors.grey,size: 17,),
                                          const SizedBox(width: 4,),
                                          const Spacer(),
                                          Text(
                                            pendingCompanyRequestsEntries[index]["clientInfo"]["clientName"],
                                            maxLines: 1,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                          const SizedBox(width: 4,),
                                          const Icon(Icons.drive_file_rename_outline,color:Colors.grey,size: 17,)
                                          // SizedBox(width: 5,),
                                          // CircleAvatar(
                                          //   radius: 20,
                                          //   backgroundImage: AssetImage('images/shop.jpg'),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: (){
                                          _displayBottomSheet(
                                              context,
                                              LatLng(
                                                pendingCompanyRequestsEntries[index]["clientInfo"]["latitudeForClient"],
                                                pendingCompanyRequestsEntries[index]["clientInfo"]["longitudeForClient"],
                                              ),
                                              true
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              pendingCompanyRequestsEntries[index]["clientInfo"]["nameAddress"],
                                              maxLines: 1,
                                              style:const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.red
                                              ),

                                            ),
                                            const SizedBox(width: 4,),
                                            const Icon(Icons.location_on,color:Colors.red,size: 17,)

                                          ],
                                        ),
                                      ),
                                      ///////
                                      const SizedBox(height: 8,),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                      const SizedBox(height: 8,),
                                      const Text(
                                        "معلومات مستلم الطرد",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            pendingCompanyRequestsEntries[index]["recipientInfo"]["recipientPhoneNumber"],
                                            maxLines: 1,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                          const Icon(Icons.phone,color:Colors.grey,size: 17,),
                                          const SizedBox(width: 4,),
                                          const Spacer(),
                                          Text(
                                            pendingCompanyRequestsEntries[index]["recipientInfo"]["recipientName"],
                                            maxLines: 1,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                          const SizedBox(width: 4,),
                                          const  Icon(Icons.drive_file_rename_outline,color:Colors.grey,size: 17,)
                                          // SizedBox(width: 5,),
                                          // CircleAvatar(
                                          //   radius: 20,
                                          //   backgroundImage: AssetImage('images/shop.jpg'),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: (){
                                          _displayBottomSheet(
                                              context,
                                              LatLng(
                                                pendingCompanyRequestsEntries[index]["recipientInfo"]["latitudeForRecipient"],
                                                pendingCompanyRequestsEntries[index]["recipientInfo"]["longitudeForRecipient"],
                                              ),
                                              false
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              pendingCompanyRequestsEntries[index]["recipientInfo"]["nameAddress"],
                                              maxLines: 1,
                                              style:const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.red
                                              ),

                                            ),
                                            const SizedBox(width: 4,),
                                            const Icon(Icons.location_on,color:Colors.red,size: 17,)

                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8,),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                      ////////
                                      const SizedBox(height: 8,),
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
                                                      const Text("هل تريد قبول الطلب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextButton(
                                                              onPressed: (){
                                                                String? acceptedRequest = CacheHelper.getString("acceptRequest");
                                                                String? generalRequest = CacheHelper.getString("generaRequest");

                                                                if(generalRequest != null || acceptedRequest != null) {

                                                                  customeToastification(context,
                                                                      title: "غير مسموح",
                                                                      desc: "هنالك طلبية بالفعل لم يتم الانتهاء منها",
                                                                      icon: const Icon(Icons.close,color: Colors.white,),
                                                                      backgroundColor: deliveryMainColor
                                                                  );
                                                                  Navigator.pop(context);

                                                                }else {
                                                                  cubit.acceptCompanyRequest(orderInfo: pendingCompanyRequestsEntries[index]);
                                                                  Navigator.pop(context);
                                                                }

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
                                          minimumSize: const Size(double.infinity, 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                        ),
                                        child:const  Text('قبول الطلب'),
                                      )


                                    ],
                                  ),
                                );
                              }
                          ),
                        )
                    ),
                    fallback: (context)=>Expanded(
                        flex: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                          color: Colors.white,
                          child:const Center(child: Text('لا يوجد طلبات حاليا',style: TextStyle(fontSize: 20,color: Colors.grey),),),
                        )
                    )
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 40,
                decoration:const BoxDecoration(
                    color: deliveryMainColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                    )
                ),
              ),
            ],
          ),
        ),
        ),
            Visibility(
                visible: state is AcceptRequestProcess,
                child: Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child:const SpinKitCubeGrid(
                      color: deliveryMainColor,
                      size: 50,
                    ),
                  ),
                )),
            Visibility(
              visible: state is DeliveryDurationMethodModulesProcess,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Container(
                  child:const Center(
                    child: const SpinKitCircle(
                      color: deliveryMainColor,
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


  Future _displayBottomSheet(context,orderLocation,isClient) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Stack(
          children: [
            Container(
              height: 400,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)
                      ),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close,color: Colors.red,)
                        ),
                        const Spacer(),
                        const Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "الخريطة",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  CustomMap(setLocation: (value){},
                    location: LatLng(0, 0),

                    secondLocation: isClient ? orderLocation : LatLng(0, 0),
                    thirdLocation: !isClient ? orderLocation : LatLng(0, 0),
                    fourthLocation: LatLng(0, 0),
                    enableSelectLocation: false,),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        )
    );
  }

}
