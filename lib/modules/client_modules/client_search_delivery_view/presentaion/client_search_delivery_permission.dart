import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/client_modules/client_search_delivery_view/presentaion/client_search_delivery_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../shared/component/getCityNameByCoordinates.dart';

class ClientSearchDeliveryPermission extends StatefulWidget {
  const ClientSearchDeliveryPermission({super.key,required this.myLocation});


  final LatLng myLocation;
  @override
  State<ClientSearchDeliveryPermission> createState() => _ClientSearchDeliveryPermissionState();
}

class _ClientSearchDeliveryPermissionState extends State<ClientSearchDeliveryPermission> {

  LatLng location = LatLng(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.myLocation.latitude != 0) {

      Map cityName = getCityNameByCoordinates(widget.myLocation);
      if(cityName["condition"]) {


      }else {
        customeToastification(
            context,
            title: "غير مدعوم",
            desc: "المدينة الخاصة بك ليست مدعومة بالوقت الحالي",
            icon:const Icon(Icons.close,color: Colors.white,),
            backgroundColor: Colors.red
        );
         Future.delayed(const Duration(seconds: 5));
        Navigator.pop(context);
      }


    }


  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{},
        builder: (context,state){
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey,
          body: Stack(
            children: [
              Container(
                width: double.infinity, // Or a specific width
                height: double.infinity, // Or a specific height
                child: Image.asset(
                  'images/location_p.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SpinKitChasingDots(
                  color: mainColor,
                  size: 90
              ),
              Visibility(
                visible: cubit.userLocation.latitude == 0 && cubit.userLocation.longitude == 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 300,
                    height: 132,
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Adjust color and opacity as needed
                          spreadRadius: 5, // How much the shadow spreads
                          blurRadius: 7, // How blurry the shadow is
                          offset:const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.location_on,color: Colors.blueAccent,),
                        const SizedBox(height: 6,),
                        const Text("هل توافق على الوصول للموقع الجغرافي الخاص بك ؟"),
                        const SizedBox(height: 10,),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        const SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child:const Text("غير موافق",style: TextStyle(color: Colors.blueAccent),)
                            ),
                            const Spacer(),
                            const SizedBox(width: 5,),
                            Container(
                              height: 15,
                              width: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            const SizedBox(width: 5,),
                            const Spacer(),
                            TextButton(
                                onPressed: (){
                                  cubit.setUserLocation();
                                  setState(() {
                                    location = cubit.userLocation;
                                  });
                                },
                                child:const Text("موافق",style: TextStyle(color: Colors.blueAccent),)
                            ),
                            const Spacer(),

                          ],
                        )
                      ],
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
}
