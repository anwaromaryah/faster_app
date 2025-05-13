import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../layout/admin_main_layout/cubit/cubit.dart';
import '../../../../layout/admin_main_layout/cubit/states.dart';
class AdminDeliverysView extends StatelessWidget {
  const AdminDeliverysView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminLayoutCubit,AdminLayoutStates>(
      listener: (context,state)=>{},
      builder: (context,state){
        AdminLayoutCubit cubit = AdminLayoutCubit.get(context);
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                color:deliveryMainColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child:  Image.asset("icons/account_m.png",width: 25,height: 25,fit: BoxFit.fill,)
                        ),
                        const SizedBox(width: 7,),
                        Container(
                          width: 40,
                          height: 1,
                          color: deliveryMainColor,
                        ),
                        const SizedBox(width: 3,),
                        Image.asset("icons/quality.png",width: 60,height: 60,fit: BoxFit.fill,),

                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: deliveryMainColor,
                    ),
                    const SizedBox(height: 10,),

                    // list
                    ConditionalBuilder(
                        condition: cubit.driversList.isNotEmpty ,
                        builder: (context)=> Expanded(
                            child:Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              child: ListView.separated(
                                  itemBuilder: (context,index)=> Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(0.04),
                                    child: Row(
                                      children: [
                                        ConditionalBuilder(
                                          condition: cubit.driversList.isNotEmpty && cubit.driversList[index]["profilePic"].isNotEmpty,
                                          builder: (context)=> Image(image: NetworkImage("${cubit.driversList[index]["profilePic"]}",),width: 55,height: 55,fit: BoxFit.fill,),
                                          fallback: (context)=>Image.asset("icons/driver-2.png",width: 55,height: 55,fit: BoxFit.fill,),
                                        ),

                                        const SizedBox(width: 5,),
                                        Column(
                                          children: [
                                            Text(
                                              "${ cubit.driversList[index]["driverName"].length >= 18 ? cubit.driversList[index]["driverName"].substring(0,18) : cubit.driversList[index]["driverName"]}${cubit.driversList[index]["driverName"].length >= 18 ? "..." : ""}",
                                              maxLines: 1,
                                              style:const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              "${cubit.driversList[index]["driverPhoneNumber"]}",
                                              style:const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: (){
                                              cubit.updateAccountAuth("drivers", cubit.driversList[index]["driverId"], cubit.driversList[index]["userAuth"] == "disabled" ? "active" : "disabled");
                                            },
                                            icon: Icon(cubit.driversList[index]["userAuth"] == "disabled" || cubit.driversList[index]["userAuth"] == "rejected"? Icons.play_circle : Icons.stop_circle,
                                              color: cubit.driversList[index]["userAuth"] == "disabled"  || cubit.driversList[index]["userAuth"] == "rejected"? Colors.green : Colors.red,
                                            )
                                        ),
                                        IconButton(
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
                                                          const Text("هل تريد حذف الحساب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                          const SizedBox(height: 20),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              TextButton(
                                                                  onPressed: (){
                                                                    cubit.deleteAccount("drivers", cubit.driversList[index]["driverId"]);
                                                                  },
                                                                  child:const Text("نعم",style: TextStyle(color: Colors.green),)
                                                              ),
                                                              const SizedBox(width: 20),
                                                              TextButton(
                                                                  onPressed: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text("الغاء",style: TextStyle(color: Colors.red),)
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                  }
                                              );
                                            },
                                            icon:const Icon(Icons.delete,color: Colors.red,)
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 4,),
                                  itemCount: cubit.driversList.length
                              ),
                            )
                        ),
                        fallback: (context)=> const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "لا يوجد حسابات خاصة بالزبائن",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        )
                    ),



                  ],
                ),
              ),
            ),
            Visibility(
                visible: state is UpdateAccountAuthProcess || state is DeleteAccountProcess ,
                child: Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child:const SpinKitChasingDots(
                      color: deliveryMainColor,
                      size: 50,
                    ),
                  ),
                ))

          ],
        );
      },
    );
  }
}
