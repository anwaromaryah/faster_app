import 'package:firstproject001/layout/delivery_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryHistoryView extends StatelessWidget {
  const DeliveryHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryLayoutCubit,DeliveryLayoutStates>(
        listener: (context,state)=>{

          if(state is RefreshHistorySucceed){
            customeToastification(context,
                title: "تحديث السجل",
                desc: "تم تحديث السجل بالنجاح",
                icon:const Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          }

        },
      builder: (context,state){
          DeliveryLayoutCubit cubit = DeliveryLayoutCubit.get(context);
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: (){ Navigator.pop(context); },
                        icon:const Icon(Icons.arrow_back,color: Colors.red,size: 24,),
                    ),
                    Visibility(
                      visible: cubit.historyData.isNotEmpty,
                      child: IconButton(
                          onPressed: (){
                            cubit.refreshHistory();
                          },
                          icon:const Icon(Icons.refresh)
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red
                      ),
                      child: Text(
                        "${cubit.historyData.length}",
                        style:const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                    const SizedBox(width: 7,),
                    const Text(
                      'السجل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            cubit.resetFilterHistory();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                            decoration: BoxDecoration(
                                color: cubit.historyFilter.isEmpty ? deliveryMainColor : Colors.transparent,
                                border: Border.all(width: 1,color: deliveryMainColor),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              "#الجميع",
                              style: TextStyle(
                                  color: cubit.historyFilter.isEmpty ? Colors.white : deliveryMainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            cubit.filterHistory(filter: "day");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                            decoration: BoxDecoration(
                                color: cubit.historyFilter == "day" ? deliveryMainColor : Colors.transparent,
                                border: Border.all(width: 1,color: deliveryMainColor),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              "#اليوم",
                              style: TextStyle(
                                  color: cubit.historyFilter == "day" ? Colors.white : deliveryMainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            cubit.filterHistory(filter: "weak");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                            decoration: BoxDecoration(
                                color: cubit.historyFilter == "weak" ? deliveryMainColor : Colors.transparent,
                                border: Border.all(width: 1,color: deliveryMainColor),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              "#الاسبوع الاخير",
                              style: TextStyle(
                                  color: cubit.historyFilter == "weak" ? Colors.white : deliveryMainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            cubit.filterHistory(filter: "month");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                            decoration: BoxDecoration(
                                color: cubit.historyFilter == "month" ? deliveryMainColor : Colors.transparent,
                                border: Border.all(width: 1,color: deliveryMainColor),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              "#الشهر الحالي",
                              style: TextStyle(
                                  color:cubit.historyFilter == "month"  ? Colors.white : deliveryMainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            cubit.filterHistory(filter: "year");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
                            decoration: BoxDecoration(
                                color: cubit.historyFilter == "year" ? deliveryMainColor : Colors.transparent,
                                border: Border.all(width: 1,color: deliveryMainColor),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              "#السنة الحالية",
                              style: TextStyle(
                                  color:cubit.historyFilter == "year" ? Colors.white : deliveryMainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ConditionalBuilder(
                  condition: cubit.historyData.isNotEmpty,
                  fallback: (context)=>const Expanded(
                    child: Center(
                      child: Text(
                        "لا يوجد سجل",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24
                        ),
                      ),
                    ),
                  ),
                  builder: (context)=>ConditionalBuilder(
                      condition: cubit.historyDataFilter.isNotEmpty,
                      builder: (context)=>Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.separated(
                                itemCount: cubit.historyDataFilter.length,
                                separatorBuilder: (context,index)=>Container(
                                  width: double.infinity,
                                  color:Colors.black.withOpacity(0.7),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                itemBuilder: (context,index) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color:const Color(0xffF4F4F4),
                                        borderRadius: BorderRadius.circular(10),
                                        border:const Border(
                                            top: BorderSide(
                                                color: deliveryMainColor,
                                                width: 4
                                            )
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyDataFilter[index]["orderInfo"]["time"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.timelapse,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyDataFilter[index]["orderInfo"]["orderNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.numbers,color: deliveryMainColor,size: 20,),

                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        ////////////
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                            const SizedBox(width: 20,),
                                            ConditionalBuilder(
                                                condition: cubit.historyDataFilter.isEmpty || cubit.historyDataFilter[index]["clientInfo"]["profilePic"].isEmpty,
                                                builder: (context) => CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.transparent,

                                                  child: Image.asset("icons/user-profile.png",width: 34,height: 34,),
                                                ),
                                                fallback: (context)=> CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white.withOpacity(0.7),
                                                  backgroundImage: NetworkImage("${cubit.historyDataFilter[index]["clientInfo"]["profilePic"]}"),
                                                )
                                            ),
                                            const SizedBox(width: 20,),
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "مرسل الطرد",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${cubit.historyDataFilter[index]["clientInfo"]["clientPhoneNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.phone_android,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyDataFilter[index]["clientInfo"]["clientName"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                           const Icon(Icons.drive_file_rename_outline,color: deliveryMainColor,size: 20,),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyDataFilter[index]["clientInfo"]["nameAddress"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.location_on,color: deliveryMainColor,size: 20,),

                                          ],
                                        ),
                                        /////////////
                                        const SizedBox(height:12,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                            const SizedBox(width: 20,),
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.grey.withOpacity(0.4),
                                              backgroundImage:const AssetImage("icons/user-profile.png",),
                                            ),

                                            const SizedBox(width: 20,),
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "مستلم الطرد",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${cubit.historyDataFilter[index]["recipientInfo"]["recipientPhoneNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.phone_android,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyDataFilter[index]["recipientInfo"]["recipientName"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.drive_file_rename_outline,color: deliveryMainColor,size: 20,),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyDataFilter[index]["recipientInfo"]["nameAddress"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.location_on,color: deliveryMainColor,size: 20,),

                                          ],
                                        )


                                      ],
                                    ),
                                  );
                                }
                            ),
                          )
                      ),
                      fallback: (context)=>Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.separated(
                                itemCount: cubit.historyData.length,
                                separatorBuilder: (context,index)=>Container(
                                  width: double.infinity,
                                  color:Colors.black.withOpacity(0.7),
                                  margin:const EdgeInsets.symmetric(vertical: 5),
                                ),
                                itemBuilder: (context,index) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color:const Color(0xffF4F4F4),
                                        borderRadius: BorderRadius.circular(10),
                                        border:const Border(
                                            top: BorderSide(
                                                color: deliveryMainColor,
                                                width: 4
                                            )
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyData[index]["orderInfo"]["time"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.timelapse,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyData[index]["orderInfo"]["orderNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.numbers,color: deliveryMainColor,size: 20,),

                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        /////////////
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                            const SizedBox(width: 20,),
                                            ConditionalBuilder(
                                                condition: cubit.historyData.isEmpty || cubit.historyData[index]["clientInfo"]["profilePic"].isEmpty,
                                                builder: (context) => CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.transparent,

                                                  child: Image.asset("icons/user-profile.png",width: 34,height: 34,),
                                                ),
                                                fallback: (context)=> CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white.withOpacity(0.7),
                                                  backgroundImage: NetworkImage("${cubit.historyData[index]["clientInfo"]["profilePic"]}"),
                                                )
                                            ),
                                            const SizedBox(width: 20,),
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "مرسل الطرد",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${cubit.historyData[index]["clientInfo"]["clientPhoneNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.phone_android,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyData[index]["clientInfo"]["clientName"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.drive_file_rename_outline,color: deliveryMainColor,size: 20,),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyData[index]["clientInfo"]["nameAddress"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.location_on,color: deliveryMainColor,size: 20,),

                                          ],
                                        ),
                                        /////////////
                                        const SizedBox(height: 6,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),

                                            const SizedBox(width: 20,),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.transparent,
                                              child: Image.asset("icons/user-profile.png",width: 34,height: 34,),
                                            ),


                                            const SizedBox(width: 20,),
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: Colors.grey.withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "مستلم الطرد",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${cubit.historyData[index]["recipientInfo"]["recipientPhoneNumber"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.phone_android,color: deliveryMainColor,size: 20,),
                                            const Spacer(),
                                            Text(
                                              "${cubit.historyData[index]["recipientInfo"]["recipientName"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.drive_file_rename_outline,color: deliveryMainColor,size: 20,),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${cubit.historyData[index]["recipientInfo"]["nameAddress"]}",
                                              style:const TextStyle(
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            const  Icon(Icons.location_on,color: deliveryMainColor,size: 20,),

                                          ],
                                        )


                                      ],
                                    ),
                                  );
                                }
                            ),
                          )
                      )
                  ),
                ),

                const SizedBox(height: 10,),
                Visibility(
                  visible: cubit.historyData.isNotEmpty,
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
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text("هل تريد حذف السجل",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                     ],
                                   ),
                                   const SizedBox(height: 20),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       TextButton(
                                           onPressed: (){
                                             cubit.deleteHistory();
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
                      backgroundColor: deliveryMainColor,
                      foregroundColor: Colors.white,
                      minimumSize:  Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child:  Text('حذف السجل'),
                  ),
                ),
          
              ],
            ),
          ),
        ),
      );
      },

    );
  }
}
