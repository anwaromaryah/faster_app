import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/client_modules/client_track_order_view/presentation/client_track_order_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';



class ClientMainLayout extends StatefulWidget {
  const ClientMainLayout({super.key});

  @override
  State<ClientMainLayout> createState() => _ClientMainLayoutState();
}

class _ClientMainLayoutState extends State<ClientMainLayout> {

  int acceptedRequests = 0;
  int acceptedGeneralRequests = 0;
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
          acceptedRequests = data.values.toList().length;
        });
      } else {
       setState(() {
         acceptedRequests = 0;

       });
      }

    });

    //listen to accepted requests
    DatabaseReference ordersRefT = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/acceptRequests/");
    ordersRefT.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          acceptedRequests = data.values.toList().length;
        });
      } else {
        setState(() {
          acceptedRequests = 0;

        });
      }

    });


  }


  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
          create: (context) => ClientLayoutCubit()..setUserLocation()..getUserInformation()..fetchAllCompanies()..durationMethod(),
          child: BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
              listener: (context,state) =>{

                if(state is SendSpecificRequestToRealTimeDatabaseSucceed || state is SendGeneralRequestToRealTimeDatabaseSucceed) {
                  customeToastification(context,
                      title: "الطلب الخاص بك",
                      desc: "تم اعداد وارسال طلبك الخاص بنجاح",
                      icon:const Icon(Icons.check_circle,color: Colors.white,),
                      backgroundColor: Colors.green
                  )
                }

              },
               builder: (context,state) {
                ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
              return ConditionalBuilder(
                  condition: state is GetClientInformationProcess || state is FetchAllCompaniesDataProcess || state is ClientLayoutStatesInitial || state is ClientDurationMethodProcess,
                  builder: (context) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: mainColor,
                    child: Container(
                      child:const Center(
                        child: const SpinKitDoubleBounce(
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => Scaffold(
                    body: Stack(
                      children: [
                        cubit.clientLayoutScreens[cubit.bottomNavigationBarIndex],
                        Visibility(
                          visible: acceptedRequests >= 1 ,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50,left: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset:const Offset(0, 3),
                                      ),
                                    ]
                                ),
                                child: TextButton(
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (newContext) => BlocProvider.value(
                                                value: BlocProvider.of<ClientLayoutCubit>(context),
                                                child:const ClientTrackOrderView()
                                            ),
                                          )
                                      );
                                    },
                                    child:const Text("طلباتك",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Directionality(
                      textDirection: TextDirection.rtl,
                      child: BottomNavigationBar(
                        currentIndex: cubit.bottomNavigationBarIndex,
                        onTap: (index){
                          cubit.changeBottomNavigationBarIndex(index);
                        },
                        selectedItemColor: mainColor,
                        items:  [
                          BottomNavigationBarItem(
                              icon: Image.asset('icons/home.png',width: 25,height: 25,),
                              label: "الرئيسية"
                          ),
                          BottomNavigationBarItem(
                              icon: Image.asset('icons/order-history.png',width: 30,height: 30,),
                              label: "السجل"
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset('icons/settings.png',width: 25,height: 25,),
                            label: "الحساب",
                          ),

                        ],
                      ),
                    ),
                  )
              );


               },

          ),
      ) ;

  }


}
