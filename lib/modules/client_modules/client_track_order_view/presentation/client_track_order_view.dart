import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/get_random_color.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../../shared/component/custom_map.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../shared/component/shared_preferences.dart';

class ClientTrackOrderView extends StatefulWidget {
  const ClientTrackOrderView({super.key});

  @override
  State<ClientTrackOrderView> createState() => _ClientTrackOrderViewState();
}

class _ClientTrackOrderViewState extends State<ClientTrackOrderView> {

  List<dynamic> acceptedRequests = [];
  List<dynamic> acceptedGeneralRequests = [];

  bool showAcceptedRequests = true;
  bool showAcceptedGeneralRequests = false;


  @override
  void initState() {
    super.initState();


    //listen to accepted requests
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/acceptRequests/");
    ordersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          acceptedRequests = data.values.toList();
        });
      } else {
        setState(() {
          acceptedRequests = [];
        });
      }

    });


    DatabaseReference generalOrdersRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/acceptRequests/");
    generalOrdersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          acceptedGeneralRequests = data.values.toList();

        });
      } else {
        setState(() {
          acceptedGeneralRequests = [];
        });
      }

    });




  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{},
      builder: (context,state){
          ClientLayoutCubit cubit  = ClientLayoutCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: mainColor,
                        child: IconButton(
                            onPressed: (){Navigator.pop(context);},
                            icon: Icon(Icons.arrow_back,color: Colors.white,)
                        ),
                      ),
                     const Spacer(),
                     const Text(
                        "تتبع طلباتك",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(


                          decoration: BoxDecoration(
                            color: showAcceptedGeneralRequests ? mainColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1,color: mainColor),
                          ),
                          child: TextButton(
                            onPressed: (){
                              setState(() {
                                showAcceptedRequests = false;
                                showAcceptedGeneralRequests = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: showAcceptedGeneralRequests ? Colors.black : mainColor,
                                  child: Center(
                                    child: Text(
                                      "${acceptedGeneralRequests.length}",
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 13
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 3,),
                                Text(
                                  "الطلبات العامة",
                                  style: TextStyle(
                                      color: showAcceptedGeneralRequests ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                      const SizedBox(width: 7,),
                      Container(
                        decoration: BoxDecoration(
                          color: showAcceptedRequests ? mainColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1,color: mainColor),
                        ),
                        child: TextButton(
                            onPressed: (){
                              setState(() {
                                showAcceptedRequests = true;
                                showAcceptedGeneralRequests = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: showAcceptedRequests ? Colors.black : mainColor,
                                  child: Center(
                                    child: Text(
                                      "${acceptedRequests.length}",
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 3,),
                                Text(
                                  "الطلبات الخاصة",
                                  style: TextStyle(
                                      color: showAcceptedRequests ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                        )
                      ),

                    ],
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: showAcceptedRequests,
                    child: ConditionalBuilder(
                        condition: acceptedRequests.isNotEmpty && showAcceptedRequests,
                        builder: (context) => Expanded(
                          child: ListView.separated(
                            itemCount: acceptedRequests.length ,
                            itemBuilder: (context,index){

                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:const Border(
                                    top: BorderSide(
                                        color: mainColor,
                                        width: 5
                                    ),

                                  ),
                                  color: mainColor.withOpacity(0.8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "${acceptedRequests[index]["orderInfo"]["time"]}",
                                            style:const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)
                                        ),
                                        const Spacer(),
                                        Text("${acceptedRequests[index]["orderInfo"]["orderNumber"]}",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 3,),
                                        const Icon(Icons.numbers,color: Colors.black,),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${acceptedRequests[index]["companyInfo"]["companyName"]}",
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Image.asset("icons/market-location.png",width: 30,height: 30,),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Text(
                                            "معلومات مستلم الطرد",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(
                                                "${acceptedRequests[index]["clientInfo"]["clientPhoneNumber"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const  SizedBox(width: 4,),
                                              const Icon(Icons.phone,color:Colors.white,size: 17,),
                                              const Spacer(),
                                              Text(
                                                "${acceptedRequests[index]["clientInfo"]["clientName"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.drive_file_rename_outline,color:Colors.white,size: 17,)
                                              // SizedBox(width: 5,),
                                              // CircleAvatar(
                                              //   radius: 20,
                                              //   backgroundImage: AssetImage('images/shop.jpg'),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${acceptedRequests[index]["clientInfo"]["nameAddress"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),

                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.location_on,color:Colors.white,size: 17,)

                                            ],
                                          ),
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Text(
                                            "معلومات السائق",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(
                                                "${acceptedRequests[index]["driverInfo"]["driverPhoneNumber"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const  SizedBox(width: 4,),
                                              const Icon(Icons.phone,color:Colors.white,size: 17,),
                                              const Spacer(),
                                              Text(
                                                "${acceptedRequests[index]["driverInfo"]["driverName"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.drive_file_rename_outline,color:Colors.white,size: 17,)
                                              // SizedBox(width: 5,),
                                              // CircleAvatar(
                                              //   radius: 20,
                                              //   backgroundImage: AssetImage('images/shop.jpg'),
                                              // ),
                                            ],
                                          ),
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          ElevatedButton(
                                            onPressed: () {
                                              _displayBottomSheet(context,
                                                deliveryLocation: LatLng(acceptedRequests[index]["driverInfo"]["driverLatitude"], acceptedRequests[index]["driverInfo"]["driverLongitude"]),
                                                clientLocation: LatLng(acceptedRequests[index]["clientInfo"]["latitudeForClient"], acceptedRequests[index]["clientInfo"]["longitudeForClient"]),
                                                recipientLocation: LatLng(acceptedRequests[index]["recipientInfo"]["latitudeForRecipient"], acceptedRequests[index]["recipientInfo"]["longitudeForRecipient"]),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white,
                                              minimumSize:  Size(double.infinity, 35),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            ),
                                            child: const Text('تتبع السائق'),
                                          )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context,index)=>const SizedBox(height: 5,),
                          ),
                        ) ,
                        fallback: (context)=>const Expanded(child:  Center(child: Text("لا يوجد طلبات حاليا",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.grey),)))
                    ),
                  ),


                  Visibility(
                    visible: showAcceptedGeneralRequests,
                    child: ConditionalBuilder(
                        condition: acceptedGeneralRequests.isNotEmpty && showAcceptedGeneralRequests,
                        builder: (context) => Expanded(
                          child: ListView.separated(
                            itemCount: acceptedGeneralRequests.length ,
                            itemBuilder: (context,index){

                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:const Border(
                                    top: BorderSide(
                                        color: mainColor,
                                        width: 5
                                    ),

                                  ),
                                  color: mainColor.withOpacity(0.8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "${acceptedGeneralRequests[index]["orderInfo"]["time"]}",
                                            style:const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)
                                        ),
                                        const Spacer(),
                                        Text("${acceptedGeneralRequests[index]["orderInfo"]["orderNumber"]}",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 3,),
                                        const Icon(Icons.numbers,color: Colors.black,),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${acceptedGeneralRequests[index]["companyInfo"]["companyName"]}",
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Image.asset("icons/market-location.png",width: 30,height: 30,),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Text(
                                            "معلومات مستلم الطرد",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(
                                                "${acceptedGeneralRequests[index]["clientInfo"]["clientPhoneNumber"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const  SizedBox(width: 4,),
                                              const Icon(Icons.phone,color:Colors.white,size: 17,),
                                              const Spacer(),
                                              Text(
                                                "${acceptedGeneralRequests[index]["clientInfo"]["clientName"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.drive_file_rename_outline,color:Colors.white,size: 17,)
                                              // SizedBox(width: 5,),
                                              // CircleAvatar(
                                              //   radius: 20,
                                              //   backgroundImage: AssetImage('images/shop.jpg'),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${acceptedGeneralRequests[index]["clientInfo"]["nameAddress"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),

                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.location_on,color:Colors.white,size: 17,)

                                            ],
                                          ),
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Text(
                                            "معلومات السائق",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(
                                                "${acceptedGeneralRequests[index]["driverInfo"]["driverPhoneNumber"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const  SizedBox(width: 4,),
                                              const Icon(Icons.phone,color:Colors.white,size: 17,),
                                              const Spacer(),
                                              Text(
                                                "${acceptedGeneralRequests[index]["driverInfo"]["driverName"]}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.white
                                                ),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Icon(Icons.drive_file_rename_outline,color:Colors.white,size: 17,)
                                              // SizedBox(width: 5,),
                                              // CircleAvatar(
                                              //   radius: 20,
                                              //   backgroundImage: AssetImage('images/shop.jpg'),
                                              // ),
                                            ],
                                          ),
                                          //////////////////////////////
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 10,),
                                          ElevatedButton(
                                            onPressed: () {
                                              _displayBottomSheet(context,
                                                deliveryLocation: LatLng(acceptedGeneralRequests[index]["driverInfo"]["driverLatitude"], acceptedGeneralRequests[index]["driverInfo"]["driverLongitude"]),
                                                clientLocation: LatLng(acceptedGeneralRequests[index]["clientInfo"]["latitudeForClient"], acceptedGeneralRequests[index]["clientInfo"]["longitudeForClient"]),
                                                recipientLocation: LatLng(acceptedGeneralRequests[index]["recipientInfo"]["latitudeForRecipient"], acceptedGeneralRequests[index]["recipientInfo"]["longitudeForRecipient"]),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white,
                                              minimumSize:const  Size(double.infinity, 35),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            ),
                                            child: const Text('تتبع السائق'),
                                          )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context,index)=>const SizedBox(height: 5,),
                          ),
                        ),
                        fallback: (context)=>const Expanded(child:  Center(child: Text("لا يوجد طلبات حاليا",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.grey),)))
                    ),
                  )



                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future _displayBottomSheet(
  context,{
    @required clientLocation,
        @required deliveryLocation,
          @required recipientLocation
  }
  ) {
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
                          padding:  EdgeInsets.only(right: 20),
                          child:const Text(
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
                    location:  LatLng(0, 0),
                    secondLocation: clientLocation ,
                    thirdLocation:  recipientLocation,
                    fourthLocation: deliveryLocation,
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
