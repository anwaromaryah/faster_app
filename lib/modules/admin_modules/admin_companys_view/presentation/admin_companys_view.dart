import 'package:firstproject001/layout/admin_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/admin_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminCompanysView extends StatefulWidget {
  const AdminCompanysView({super.key});

  @override
  State<AdminCompanysView> createState() => _AdminCompanysViewState();
}

class _AdminCompanysViewState extends State<AdminCompanysView> {

  bool showCompanysAccounts = true;
  bool showPendingRequests = false;

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
                         GestureDetector(
                           onTap: (){
                             setState(() {
                               showPendingRequests = true;
                               showCompanysAccounts = false;
                             });
                           },
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                             margin: const EdgeInsets.only(top: 5),
                             decoration: BoxDecoration(
                                 color:showPendingRequests ? companyMainColor : Colors.grey.withOpacity(0.4),
                                 borderRadius: BorderRadius.circular(8)
                             ),
                             child:  Image.asset("icons/wall-clock.png",width: 25,height: 25,fit: BoxFit.fill,),
                           ),
                         ),
                         const SizedBox(width: 7,),
                         Container(
                           width: 40,
                           height: 1,
                           color: companyMainColor,
                         ),
                         const SizedBox(width: 3,),
                         Image.asset("icons/quality.png",width: 60,height: 60,fit: BoxFit.fill,),
                         const SizedBox(width: 3,),
                         Container(
                           width: 40,
                           height: 1,
                           color: companyMainColor,
                         ),
                         const SizedBox(width: 7,),
                         GestureDetector(
                           onTap: (){
                             setState(() {
                               showPendingRequests = false;
                               showCompanysAccounts = true;
                             });
                           },
                           child: Container(
                               padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                               margin: const EdgeInsets.only(top: 5),
                               decoration: BoxDecoration(
                                   color:showCompanysAccounts ? companyMainColor : Colors.grey.withOpacity(0.4),
                                   borderRadius: BorderRadius.circular(8)
                               ),
                               child:  Image.asset("icons/account_m.png",width: 25,height: 25,fit: BoxFit.fill,)
                           ),
                         ),

                       ],
                     ),
                     const SizedBox(height: 10,),
                     Container(
                       width: double.infinity,
                       height: 1,
                       color: companyMainColor,
                     ),
                     const SizedBox(height: 10,),

                     // list
                     ConditionalBuilder(
                         condition: showCompanysAccounts && cubit.companysList.isNotEmpty,
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
                                             condition: cubit.companysList.isNotEmpty && cubit.companysList[index]["profilePic"].isNotEmpty,
                                               builder: (context)=> Image(image: NetworkImage("${cubit.companysList[index]["profilePic"]}",),width: 55,height: 55,fit: BoxFit.fill,),
                                             fallback: (context)=>Image.asset("icons/building.png",width: 55,height: 55,fit: BoxFit.fill,),
                                         ),
                                         const SizedBox(width: 5,),
                                         Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               "${cubit.companysList[index]["companyName"].length >= 18 ? cubit.companysList[index]["companyName"].substring(0,20) : cubit.companysList[index]["companyName"]}${cubit.companysList[index]["companyName"].length >= 18 ? "..." : ""}",
                                               maxLines: 1,
                                               style: const TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 14,
                                                 overflow: TextOverflow.ellipsis,
                                               ),
                                             ),
                                             const SizedBox(height: 3),
                                             Text(
                                               "${cubit.companysList[index]["companyPhoneNumber"]}",
                                               style: const TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 12,
                                               ),
                                             ),
                                           ],
                                         ),
                                         const Spacer(),
                                         IconButton(
                                             onPressed: (){
                                               cubit.updateAccountAuth("companies", cubit.companysList[index]["companyId"], cubit.companysList[index]["userAuth"] == "disabled" ? "active" : "disabled");
                                             },
                                             icon: Icon(cubit.companysList[index]["userAuth"] == "disabled" || cubit.companysList[index]["userAuth"] == "rejected"? Icons.play_circle : Icons.stop_circle,
                                               color: cubit.companysList[index]["userAuth"] == "disabled"  || cubit.companysList[index]["userAuth"] == "rejected"? Colors.green : Colors.red,
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
                                                                     cubit.deleteAccount("companies", cubit.companysList[index]["companyId"]);
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
                                   itemCount: cubit.companysList.length
                               ),
                             )
                         ),
                         fallback: (context)=> Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Visibility(
                               visible: !showPendingRequests,
                               child:const Text(
                                 "لا يوجد حسابات خاصة بشركات",
                                 style: TextStyle(
                                     fontSize: 25,
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                             )
                           ],
                         )
                     ),


                     ConditionalBuilder(
                         condition: showPendingRequests && cubit.companysPendingList.isNotEmpty,
                         builder: (context)=> Expanded(
                             child:Container(
                               padding: const EdgeInsets.all(10),
                               width: double.infinity,
                               child: ListView.separated(
                                   itemBuilder: (context,index)=> Container(
                                     padding: const EdgeInsets.all(10),
                                     width: double.infinity,
                                     color: Colors.grey.withOpacity(0.04),
                                     child: Column(
                                       children: [
                                         CircleAvatar(
                                           radius: 13,
                                           backgroundColor: companyMainColor,
                                           child: Text("${index + 1}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                                         ),
                                         const SizedBox(height: 3,),
                                         // name title
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               ": اسم الشركة",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 14
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 2,),
                                          Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               "${cubit.companysPendingList[index]["companyName"]}",
                                               maxLines: 1,
                                               style:const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                           ],
                                         ),

                                         // phone title
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               ": رقم الشركة",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 14
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 2,),
                                          Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               "${cubit.companysPendingList[index]["companyPhoneNumber"]}",
                                               maxLines: 1,
                                               style:const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                           ],
                                         ),

                                         // address title
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               ": عنوان الشركة",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 14
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 2,),
                                          Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               "${cubit.companysPendingList[index]["address"]}",
                                               maxLines: 1,
                                               style:const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                           ],
                                         ),

                                         // dsec title
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               ": وصف الشركة",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 14
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 2,),
                                          Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Expanded(
                                               child: Text(
                                                 "${cubit.companysPendingList[index]["description"]}",
                                                 maxLines: 3,
                                                 textAlign: TextAlign.right,
                                                 style:const TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.grey,
                                                     fontSize: 12,
                                                     overflow: TextOverflow.ellipsis
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),

                                         // time title
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               ": وقت عمل الشركة",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 14
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 2,),
                                          Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Text(
                                               "${cubit.companysPendingList[index]["workTime"]["endWork"]["hour"]}:${cubit.companysPendingList[index]["workTime"]["endWork"]["minute"]} ${cubit.companysPendingList[index]["workTime"]["endWork"]["amPm"]}",
                                               maxLines: 3,
                                               style:const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                             const SizedBox(width: 3,),
                                             const Text(
                                                 "حتى",
                                               style: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                             const SizedBox(width: 3,),
                                             Text(
                                               "${cubit.companysPendingList[index]["workTime"]["startWork"]["hour"]}:${cubit.companysPendingList[index]["workTime"]["startWork"]["minute"]} ${cubit.companysPendingList[index]["workTime"]["startWork"]["amPm"]}",
                                               maxLines: 3,
                                               style:const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.grey,
                                                   fontSize: 12,
                                                   overflow: TextOverflow.ellipsis
                                               ),
                                             ),
                                           ],
                                         ),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             TextButton(
                                                 onPressed: (){
                                                   cubit.updateAccountAuth("companies", cubit.companysPendingList[index]["companyId"], "rejected");
                                                 },
                                                 child: Container(
                                                   padding: const EdgeInsets.all(7),
                                                   width: 80,
                                                   decoration: BoxDecoration(
                                                       color: Colors.red,
                                                       borderRadius: BorderRadius.circular(12)
                                                   ),
                                                   child: const Text(
                                                     "رفض",
                                                     textAlign: TextAlign.center,
                                                     style: TextStyle(
                                                         fontWeight: FontWeight.bold,
                                                         color: Colors.white
                                                     ),
                                                   ),
                                                 )
                                             ),
                                             TextButton(
                                                 onPressed: (){
                                                   cubit.updateAccountAuth("companies", cubit.companysPendingList[index]["companyId"], "active");

                                                 },
                                                 child: Container(
                                                   padding: const EdgeInsets.all(7),
                                                   width: 80,
                                                   decoration: BoxDecoration(
                                                       color: Colors.green,
                                                       borderRadius: BorderRadius.circular(12)
                                                   ),
                                                   child: const Text(
                                                     "قبول",
                                                     textAlign: TextAlign.center,
                                                     style: TextStyle(
                                                         fontWeight: FontWeight.bold,
                                                         color: Colors.white
                                                     ),
                                                   ),
                                                 )
                                             ),
                                           ],
                                         )


                                       ],
                                     ),
                                   ),
                                   separatorBuilder: (context,index)=> const SizedBox(height: 4,),
                                   itemCount: cubit.companysPendingList.length
                               ),
                             )
                         ),
                         fallback: (context)=> Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Visibility(
                               visible: !showCompanysAccounts,
                               child: Text(
                                 "لا يوجد طلبات معلقة حاليا",
                                 style: TextStyle(
                                     fontSize: 25,
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold
                                 ),
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
                       color: companyMainColor,
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
