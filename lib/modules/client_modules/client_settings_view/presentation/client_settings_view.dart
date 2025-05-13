import 'dart:io';

import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/main/presentaion/splash_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../shared/component/pic_images.dart';
import '../../../../shared/component/shared_preferences.dart';
import '../../../../shared/component/toastification.dart';

class ClientSettingsView extends StatefulWidget {
  const ClientSettingsView({super.key});

  @override
  State<ClientSettingsView> createState() => _ClientSettingsViewState();
}

class _ClientSettingsViewState extends State<ClientSettingsView> {

  bool showNotificationSection = false;
  bool showUserInformationSection = false;

  var clientNameController = TextEditingController();
  var clientAddressController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  File image = File('');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{


          if(state is DeleteAllNotificationsSuccess) {
            customeToastification(context,
                title: "الاشعارات",
                desc: "تم حذف الاشعارات بنجاح",
                icon:const Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          },

          if(state is UpdateProfilePictureSuccess) {
            customeToastification(context,
                title: "الصورة",
                desc: "تم تحديث الصورة الشخصية بنجاح",
                icon:const Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          },

          if(state is UpdateClientInformationSuccess) {
            customeToastification(context,
                title: "البيانات الشخصية",
                desc: "تم تحديث بياناتك الشخصية بنجاح",
                icon:const Icon(Icons.check,color: Colors.white,),
                backgroundColor: Colors.green
            )
          },

          if(state is SettingsScreenError) {
            customeToastification(context,
                title: "صفحة الاعدادات",
                desc: state.showError(),
                icon:const Icon(Icons.close,color: Colors.white,),
                backgroundColor: Colors.red
            )
          },




        },
        builder: (context,state){
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
          return Scaffold(
            body: SafeArea(
                child:SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("الاعدادات",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                              ],
                            ),
                            const  SizedBox(height: 15,),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: double.infinity ,
                                  height: 120,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      gradient:const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          mainColor,
                                          Colors.grey,
                                        ],
                                      ),

                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 25,top: 4),
                                    child: CircleAvatar(
                                      radius: 47,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                              visible: cubit.clientInfo.isNotEmpty && cubit.clientInfo["clientName"].isNotEmpty,
                                              child: Text("${cubit.clientInfo.isNotEmpty ? cubit.clientInfo["clientName"] : ""}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis
                                                ),)
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            "${cubit.clientInfo.isNotEmpty ? cubit.clientInfo["clientPhoneNumber"] : ""}",
                                            maxLines: 1,
                                            style:const TextStyle(
                                                color:Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15,),
                                      ConditionalBuilder(
                                          condition: cubit.clientInfo.isEmpty || cubit.clientInfo["profilePic"].isEmpty,
                                          builder: (context) => CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.transparent,
                                            child: Image.asset("icons/user-profile.png",fit: BoxFit.contain,),
                                          ),
                                          fallback: (context)=>  CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage("${cubit.clientInfo["profilePic"]}",),
                                          )
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                            const SizedBox(height: 10,),
                            //////////////////
                            TextButton(
                                onPressed: (){
                                  setState(() {
                                    showUserInformationSection = false;
                                    showNotificationSection = !showNotificationSection;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_downward,color: Colors.black,size: 20,),
                                      const SizedBox(width: 10,),
                                      Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.red
                                          ),
                                          child: Text("${cubit.clientInfo.isNotEmpty ? cubit.clientInfo["notifications"].length : 0}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                      const Spacer(),
                                      const Text(
                                        "الاشعارات",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Image.asset("icons/notification-bell.png",width: 25,height: 25,)
                                    ],
                                  ),
                                )
                            ),
                            Visibility(
                              visible: showNotificationSection,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 5),
                                height: cubit.clientInfo.isNotEmpty ? cubit.clientInfo["notifications"].length > 2 ? 150 : (cubit.clientInfo["notifications"].length * 80).toDouble()  :0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: mainColor)
                                ),
                                child: ListView.separated(
                                  itemBuilder: (context,index)=> Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${cubit.clientInfo["notifications"][index]}",
                                            textDirection: TextDirection.rtl,
                                            maxLines: 2,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Image.asset("icons/message.png",width: 20,height: 20,)
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (context,index)=>Container(width: double.infinity,height: 1,color: Colors.grey.withOpacity(0.2),),
                                  itemCount: cubit.clientInfo.isEmpty ? 0 : cubit.clientInfo["notifications"].length,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showNotificationSection && cubit.clientInfo.isNotEmpty ? cubit.clientInfo["notifications"].length != 0 ? true : false : false,
                              child:ElevatedButton(
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
                                                   Text("هل تريد حذف جميع الاشعارات",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                                 ],
                                               ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: (){
                                                        cubit.deleteAllNotifications();
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
                                  backgroundColor: mainColor,
                                  foregroundColor: Colors.white,
                                  minimumSize:const  Size(double.infinity, 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child:  Text('حذف جميع الاشعارات'),
                              )
                              ,
                            ),
                            //////////////////
                            const SizedBox(height: 10,),
                            TextButton(
                                onPressed: (){
                                  setState(() {
                                    showNotificationSection = false;
                                    showUserInformationSection = !showUserInformationSection;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const  Icon(Icons.arrow_downward,color: Colors.black,size: 20,),
                                      const  Spacer(),
                                      const Text(
                                        "معلومات المستخدم",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Image.asset("icons/user (1).png",width: 25,height: 25,)
                                    ],
                                  ),
                                )
                            ),
                            Visibility(
                              visible: showUserInformationSection,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: mainColor)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            TextButton(
                                                onPressed: ()async{
                                                  //تعديل
                                                  image = await pickImage(context);
                                                  if(image.path.isNotEmpty){
                                                    cubit.updateProfilePic(profileImg: image);
                                                  }
                                                },
                                                child: Text("تعديل",style: TextStyle(fontWeight: FontWeight.bold,color: mainColor),)
                                            ),
                                            const Spacer(),
                                            ConditionalBuilder(
                                                condition: cubit.clientInfo.isEmpty || cubit.clientInfo["profilePic"].isEmpty,
                                                builder: (context) => CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor: Colors.transparent,
                                                  child: Image.asset("icons/user-profile.png",fit: BoxFit.contain,),
                                                ),
                                                fallback: (context)=> CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage("${cubit.clientInfo["profilePic"]}",),
                                                )
                                            )

                                          ],
                                        ),
                                        const SizedBox(height: 12,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "الاسم",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                            const  SizedBox(width: 8,),
                                            Image.asset("icons/id-card (2).png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        TextFormField(
                                          controller: clientNameController,
                                          keyboardType: TextInputType.text,
                                          textAlignVertical: TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            hintText: "${cubit.clientInfo.isNotEmpty ? cubit.clientInfo["clientName"] : ""}",
                                            hintTextDirection: TextDirection.rtl,
                                            hintStyle:const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4) ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(color: Colors.red),

                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide:  BorderSide(color:  Colors.grey.withOpacity(0.4),width: 2),
                                            ),
                                            focusedErrorBorder:OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(color: Colors.red,width: 2),
                                            ),
                                            contentPadding:const EdgeInsets.symmetric(horizontal: 10),
                                          ),
                                          validator: (value){
                                            if((value!.length <= 3 && value.length > 1) || value.length >= 30){
                                              return "يجب ان يكون حقل العنوان اكبر من 3 خانات واقل من 30 خانة";
                                            }
                                            return null;
                                          },


                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "العنوان",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                            const SizedBox(width: 8,),
                                            Image.asset("icons/user-location.png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        TextFormField(
                                          controller: clientAddressController,
                                          keyboardType: TextInputType.text,
                                          textAlignVertical: TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            hintText: "${cubit.clientInfo.isNotEmpty ? cubit.clientInfo["clientAddress"] : ""}",
                                            hintTextDirection: TextDirection.rtl,
                                            hintStyle:const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4) ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(color: Colors.red),

                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide:  BorderSide(color:  Colors.grey.withOpacity(0.4),width: 2),
                                            ),
                                            focusedErrorBorder:OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(color: Colors.red,width: 2),
                                            ),
                                            contentPadding:const EdgeInsets.symmetric(horizontal: 10),
                                          ),
                                          validator: (value){

                                            if((value!.length <= 3 && value.length > 1) || value.length >= 30){
                                              return "يجب ان يكون حقل العنوان اكبر من 3 خانات واقل من 30 خانة";
                                            }
                                            return null;

                                          },


                                        ),
                                        const SizedBox(height: 12,),
                                        ElevatedButton(
                                          onPressed: () {
                                            if(formKey.currentState!.validate()){
                                              if(clientNameController.text.isEmpty && clientAddressController.text.isEmpty) return;


                                              cubit.updateClientInformation(
                                                  clientName: clientNameController.text.isEmpty ? cubit.clientInfo["clientName"] : clientNameController.text,
                                                  clientAddress: clientAddressController.text.isEmpty ? cubit.clientInfo["clientAddress"] : clientAddressController.text
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor,
                                            foregroundColor: Colors.white,
                                            minimumSize:  Size(double.infinity, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          ),
                                          child:const  Text('حفظ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //////////////////
                            const SizedBox(height: 10,),
                            TextButton(
                                onPressed: ()async{

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                            height: 60,
                                            child: const Center(child: Text("لا يوجد تحديثات في الوقت الحالي",textAlign: TextAlign.center,))
                                        )
                                        ,

                                      );
                                    },
                                  );

                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      const  Text(
                                        "تحديث",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16
                                        ),
                                      ),
                                      const  SizedBox(width: 5,),
                                      Image.asset("icons/loop.png",width: 25,height: 25,)
                                    ],
                                  ),
                                )
                            ),
                            //////////////////
                            const SizedBox(height: 20,),
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
                                            const Text("هل تريد تسجيل الخروج",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: (){
                                                      CacheHelper.removeValue("userId");
                                                      Navigator.of(context).pushAndRemoveUntil(
                                                          MaterialPageRoute(builder: (context) =>const SplashViewBody()),
                                                              (route) => false
                                                      );

                                                    },
                                                    child:const Text("نعم",style: TextStyle(color: Colors.green),)
                                                ),
                                                SizedBox(width: 20),
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
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "تسجيل خروج",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                 const SizedBox(width: 5,),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white
                                    ),
                                    child: Image.asset("icons/logout (1).png",width: 22,height: 22,),
                                  ),
                                ],
                              ),
                            )


                          ],
                        ),
                      ),
                      Visibility(
                          visible: state is UpdateProfilePictureProcess || state is UpdateClientInformationProcess ,
                          child: Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              child:const SpinKitChasingDots(
                                color: mainColor,
                                size: 50,
                              ),
                            ),
                          ))

                    ],
                  ),
                )
            ),
          );

        },
    );
  }
}
