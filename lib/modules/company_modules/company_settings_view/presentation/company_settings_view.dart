import 'dart:io';

import 'package:firstproject001/layout/company_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/main/presentaion/splash_view.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../shared/component/pic_images.dart';
import '../../../../shared/component/shared_preferences.dart';
import '../../company_login_view/presentation/company_login_view.dart';

class CompanySettingsView extends StatefulWidget {
  const CompanySettingsView({super.key});

  @override
  State<CompanySettingsView> createState() => _CompanySettingsViewState();
}

class _CompanySettingsViewState extends State<CompanySettingsView> {


  bool showNotificationSection = false;
  bool showUserInformationSection = false;

  var companyNameController = TextEditingController();
  var companyAddressController = TextEditingController();
  var companyDescriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  File image = File('');

  // carousel Images
  File carouselImageOne = File('');
  File carouselImageTow = File('');
  File carouselImageThree = File('');

  TimeOfDay? workStartTime;
  TimeOfDay? workEndTime;
  Map workTime = {
  'startWork' : {
  'hour' : '',
  'minute': '',
  'amPm':''
  },
  "endWork": {
  'hour' : '',
  'minute': '',
  'amPm':''
  }
  };


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyLayoutCubit,CompanyLayoutStates>(
        listener: (context,state)=>{},
      builder: (context,state){
          CompanyLayoutCubit cubit = CompanyLayoutCubit.get(context);
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
                            const SizedBox(height: 15,),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      gradient:const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          companyMainColor,
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
                                        children: [
                                          Text("${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["companyName"] : ""}",
                                            maxLines: 1,
                                            style:const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),),
                                          const SizedBox(width: 5,),
                                          Text(
                                            "${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["companyPhoneNumber"] : ""}",
                                            maxLines: 1,
                                            style:const TextStyle(
                                                color:Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15,),
                                      ConditionalBuilder(
                                          condition: cubit.companyInfo.isEmpty || cubit.companyInfo["profilePic"].isEmpty,
                                          builder: (context) => CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white.withOpacity(0.7),
                                            backgroundImage:const AssetImage("images/shop.jpg"),
                                          ),
                                          fallback: (context)=> CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage("${cubit.companyInfo["profilePic"]}",),
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
                                          child: Text("${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["notifications"].length : 0}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
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
                                height: cubit.companyInfo.isNotEmpty ? cubit.companyInfo["notifications"].length > 2 ? 150 : (cubit.companyInfo["notifications"].length * 80).toDouble()  :0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: companyMainColor)
                                ),
                                child: ListView.separated(
                                  itemBuilder: (context,index)=> Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${cubit.companyInfo["notifications"][index]}",
                                            textDirection: TextDirection.rtl,
                                            maxLines: 2,
                                            style:const TextStyle(
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Image.asset("icons/message.png",width: 20,height: 20,)
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (context,index)=>Container(width: double.infinity,height: 1,color: Colors.grey.withOpacity(0.2),),
                                  itemCount: cubit.companyInfo.isEmpty ? 0 : cubit.companyInfo["notifications"].length,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showNotificationSection && cubit.companyInfo.isNotEmpty ? cubit.companyInfo["notifications"].length != 0 ? true : false : false,
                              child:ElevatedButton(
                                onPressed: () {
                                  cubit.deleteAllNotifications();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: companyMainColor,
                                  foregroundColor: Colors.white,
                                  minimumSize:  Size(double.infinity, 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child:const  Text('حذف جميع الاشعارات'),
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
                                      const   Icon(Icons.arrow_downward,color: Colors.black,size: 20,),
                                      const  Spacer(),
                                      const  Text(
                                        "معلومات المستخدم",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16
                                        ),
                                      ),
                                      const  SizedBox(width: 5,),
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
                                    border: Border.all(width: 1,color: companyMainColor)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const  Text(
                                              "الصورة الشخصية",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                           const SizedBox(width: 8,),
                                            Image.asset("icons/id-card (2).png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
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
                                                child: Text("تعديل",style: TextStyle(fontWeight: FontWeight.bold,color: companyMainColor),)
                                            ),
                                            const Spacer(),
                                            ConditionalBuilder(
                                                condition: cubit.companyInfo.isEmpty || cubit.companyInfo["profilePic"].isEmpty ,
                                                builder: (context) => CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor: Colors.white.withOpacity(0.7),
                                                  backgroundImage:const AssetImage("images/shop.jpg"),
                                                ),
                                                fallback: (context)=> CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage("${cubit.companyInfo["profilePic"]}",),
                                                )

                                            )


                                          ],
                                        ),
                                        const SizedBox(height: 12,),
                                        /////////////////////////////
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "اضافة صور العرض",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                            const SizedBox(width: 8,),
                                            Image.asset("icons/id-card (2).png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async{
                                                File image = await pickImage(context);
                                                if(image.path.isNotEmpty){
                                                  setState(() {
                                                    carouselImageOne = image;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.grey.withOpacity(0.3),
                                                  image: DecorationImage(
                                                      image: carouselImageOne.path.isNotEmpty ? FileImage(carouselImageOne) : cubit.companyInfo.isEmpty || cubit.companyInfo["carouselImages"]["firstImage"].isEmpty ?
                                                      const AssetImage("images/carousel.jpg") :
                                                      NetworkImage("${cubit.companyInfo["carouselImages"]["firstImage"]}"),

                                                    fit: BoxFit.cover
                                                  )
                                                ),

                                                child:const Center(
                                                  child: Icon(Icons.add,color: Colors.white,size: 25,),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                File image = await pickImage(context);
                                                if(image.path.isNotEmpty){
                                                  setState(() {
                                                    carouselImageTow = image;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.grey.withOpacity(0.3),
                                                    image: DecorationImage(
                                                        image: carouselImageTow.path.isNotEmpty ? FileImage(carouselImageTow) : cubit.companyInfo.isEmpty || cubit.companyInfo["carouselImages"]["secondImage"].isEmpty ?
                                                        const AssetImage("images/carousel.jpg") :
                                                        NetworkImage("${cubit.companyInfo["carouselImages"]["secondImage"]}"),

                                                        fit: BoxFit.cover
                                                    )


                                                ),
                                                child:const Center(
                                                  child: Icon(Icons.add,color: Colors.white,size: 25,),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                File image = await pickImage(context);
                                                if(image.path.isNotEmpty){
                                                  setState(() {
                                                    carouselImageThree = image;
                                                  });
                                                }

                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.grey.withOpacity(0.3),
                                                    image: DecorationImage(
                                                        image: carouselImageThree.path.isNotEmpty ? FileImage(carouselImageThree) : cubit.companyInfo.isEmpty || cubit.companyInfo["carouselImages"]["thirdImage"].isEmpty ?
                                                        const  AssetImage("images/carousel.jpg") :
                                                        NetworkImage("${cubit.companyInfo["carouselImages"]["thirdImage"]}"),

                                                        fit: BoxFit.cover
                                                    )


                                                ),
                                                child:const Center(
                                                  child:  Icon(Icons.add,color: Colors.white,size: 25,),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                        const SizedBox(height: 12,),
                                        /////////////////////////////

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
                                            const SizedBox(width: 8,),
                                            Image.asset("icons/id-card (2).png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        TextFormField(
                                          controller: companyNameController,
                                          keyboardType: TextInputType.text,
                                          textAlignVertical: TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            hintText: "${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["companyName"] : ""}",
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
                                              return "يجب ان يكون حقل الاسم اكبر من 3 خانات واقل من 30 خانة";
                                            }
                                            return null;
                                          },


                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const  Text(
                                              "العنوان",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                            const  SizedBox(width: 8,),
                                            Image.asset("icons/user-location.png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        TextFormField(
                                          controller: companyAddressController,
                                          keyboardType: TextInputType.text,
                                          textAlignVertical: TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            hintText: "${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["address"] : ""}",
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
                                              "الوصف",
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
                                          controller: companyDescriptionController,
                                          keyboardType: TextInputType.text,
                                          textAlignVertical: TextAlignVertical.center,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: "${cubit.companyInfo.isNotEmpty ? cubit.companyInfo["description"] : ""}",
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
                                              return "يجب ان يكون حقل الوصف اكبر من 3 خانات واقل من 30 خانة";
                                            }
                                            return null;
                                          },


                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "ساعات العمل",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                            const SizedBox(width: 8,),
                                            Image.asset("icons/id-card (2).png",width: 25,height: 25,),

                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  const  Text(
                                                    "ساعة نهاية العمل",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4,),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.4),
                                                          borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () async{
                                                          final TimeOfDay? workEnd = await showTimePicker(
                                                              context: context,
                                                              initialTime:const TimeOfDay(hour: 0, minute: 0),
                                                              initialEntryMode: TimePickerEntryMode.dial
                                                          );
                                                          if(workEnd != null) {
                                                            final formattedTime = workEnd.format(context);
                                                            final amPm = formattedTime.substring(formattedTime.length - 2);

                                                            setState(() {
                                                              workEndTime = workEnd;
                                                              Map workTimeNew = {
                                                                "endWork" : {
                                                                  "hour" : "${workEnd.hour > 12 ? (workEnd.hour - 12 == 0) ? 1 : workEnd.hour-12 : workEnd.hour}",
                                                                  "minute":"${workEnd.minute}",
                                                                  "amPm": amPm
                                                                },
                                                                "startWork":{
                                                                  "hour" : workTime["startWork"]["hour"],
                                                                  "minute":workTime["startWork"]["minute"],
                                                                  "amPm": workTime["startWork"]["amPm"]
                                                                }
                                                              };

                                                              workTime = workTimeNew;

                                                              print(workTime);

                                                            });

                                                          }
                                                        },
                                                        child: Text(
                                                          "${workEndTime?.format(context)?? "00:00"}",
                                                          style:const TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                      )

                                                  ),
                                                  const SizedBox(height: 4,),
                                                  Text(
                                                    "${cubit.companyInfo["workTime"]["endWork"]["hour"]}:${cubit.companyInfo["workTime"]["endWork"]["minute"]} ${cubit.companyInfo["workTime"]["endWork"]["amPm"]}",
                                                    style:const TextStyle(
                                                      color: Colors.grey
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 40,),
                                              Column(
                                                children: [
                                                  const Text(
                                                    "ساعة بداية العمل",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4,),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.4),
                                                          borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: TextButton(
                                                        onPressed: ()async{
                                                          final TimeOfDay? workStart = await showTimePicker(
                                                              context: context,
                                                              initialTime:const TimeOfDay(hour: 0, minute: 0),
                                                              initialEntryMode: TimePickerEntryMode.dial
                                                          );
                                                          if(workStart != null) {
                                                            final formattedTime = workStart.format(context);
                                                            final amPm = formattedTime.substring(formattedTime.length - 2);

                                                            setState(() {
                                                              workStartTime = workStart;

                                                              Map workTimeNew = {
                                                                "startWork" : {
                                                                  "hour" : "${workStart.hour > 12 ? (workStart.hour - 12 == 0) ? 1 : workStart.hour-12 : workStart.hour}",
                                                                  "minute":"${workStart.minute}",
                                                                  "amPm": amPm
                                                                },
                                                                "endWork":{
                                                                  "hour" : workTime["endWork"]["hour"],
                                                                  "minute":workTime["endWork"]["minute"],
                                                                  "amPm": workTime["endWork"]["amPm"]
                                                                }
                                                              };

                                                              workTime = workTimeNew;
                                                            });
                                                            print(workTime);

                                                          }
                                                        },
                                                        child: Text(
                                                          "${workStartTime?.format(context)?? "00:00"}",
                                                          style:const TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                      )

                                                  ),
                                                  const SizedBox(height: 4,),
                                                  Text(
                                                    "${cubit.companyInfo["workTime"]["startWork"]["hour"]}:${cubit.companyInfo["workTime"]["startWork"]["minute"]} ${cubit.companyInfo["workTime"]["startWork"]["amPm"]}",
                                                    style:const TextStyle(
                                                        color: Colors.grey
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ]),

                                        const SizedBox(height: 12,),
                                        ElevatedButton(
                                          onPressed: () {
                                            if(formKey.currentState!.validate()){
                                              FocusScope.of(context).unfocus();

                                              // update carousel image
                                              if(carouselImageOne.path.isNotEmpty || carouselImageTow.path.isNotEmpty || carouselImageThree.path.isNotEmpty ) {
                                                cubit.updateCarouselImages(firstImage: carouselImageOne, secondImage: carouselImageTow, thirdImage: carouselImageThree);

                                              }
                                              // update work time
                                              if(workTime["endWork"]["hour"].isNotEmpty && workTime["startWork"]["hour"].isNotEmpty ){
                                                cubit.updateTimeWork(workTime: workTime);
                                              }

                                              // update company information
                                              if(companyNameController.text.isEmpty && companyAddressController.text.isEmpty && companyDescriptionController.text.isEmpty) return;
                                              cubit.updateCompanyInformation(
                                                  companyName: companyNameController.text.isEmpty ? cubit.companyInfo["companyName"] : companyNameController.text,
                                                  companyAddress: companyAddressController.text.isEmpty ? cubit.companyInfo["address"] : companyAddressController.text,
                                                companyDesc: companyDescriptionController.text.isEmpty ? cubit.companyInfo["description"] : companyDescriptionController.text,
                                              );
                                            }

                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: companyMainColor,
                                            foregroundColor: Colors.white,
                                            minimumSize:  Size(double.infinity, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding:const  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          ),
                                          child:  Text('حفظ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
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
                                            child:const Center(child: Text("لا يوجد تحديثات في الوقت الحالي",textAlign: TextAlign.center,))
                                        ),

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
                                      const SizedBox(width: 5,),
                                      Image.asset("icons/loop.png",width: 25,height: 25,)
                                    ],
                                  ),
                                )
                            ),
                            //////////////////
                            //////////////////
                            const SizedBox(height: 15,),
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
                                                          MaterialPageRoute(builder: (context) => const SplashViewBody()),
                                                              (route) => false
                                                      );

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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const  Text(
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
                          visible: state is UpdateCarouselImagesProcess || state is UpdateCompanyInformationProcess || state is UpdateTimeWorkProcess,
                          child: Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                              child:const SpinKitChasingDots(
                                color: companyMainColor,
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
