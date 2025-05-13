
import 'package:firstproject001/layout/company_main_layout/presentation/company_main_layout.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/cubit/cubit.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/cubit/states.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/toastification.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../shared/component/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanySignupView extends StatefulWidget {
  const CompanySignupView({super.key});

  @override
  State<CompanySignupView> createState() => _CompanySignupViewState();
}

class _CompanySignupViewState extends State<CompanySignupView> {

  var companyNameController = TextEditingController();

  var descController = TextEditingController();

  var phoneNumberController = TextEditingController();

  var addressController = TextEditingController();

  var keyForm = GlobalKey<FormState>();

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

   String workTimeError = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyLoginCubit,CompanyLoginStates>(
    listener: (context,state)=>{

      if(state is CompanySignUpStateWithGoogleSucceed) {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => CompanyMainLayout()),
        //         (route) => false
        // )
        Navigator.pop(context),
        customeToastification(
            context,
            title: "طلبك قيد المراجعة",
            desc: "سيتم مراجعة طلب الانضمام الخاص بك بأقرب وقت",
            icon:const Icon(Icons.timelapse),
            backgroundColor: companyMainColor
        )
      }

    },
      builder: (context,state) {
        CompanyLoginCubit cubit = CompanyLoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Form(
                key: keyForm,
                child: Column(
                  children: [
                   const Text(
                      'تسجيل حساب جديد',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(height: 8,),
                   const Text(
                      "حسابك هو خطوتك الأولى لزيادة أرباح شركتك، ابدأ الآن!",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 25,),
                    CustomInputWithIconTow(
                      topLeftIcon: false,
                      icon: Icons.person,
                      hintText: 'اسم الشركة',
                      backgroundColor: companyMainColor.withOpacity(0.2),
                      iconColor: Colors.black,
                      borderColor: Colors.white,
                      keyboardType: TextInputType.text,
                      validFunc: (value){
                        if(value!.isEmpty) {
                          return "لا يمكن ترك خانة الاسم فارغة";
                        }
                        if(value.length < 5 || value.length > 30){
                          return "يجب ان تكون عدد الخانات بين 5 الى 30 خانة";
                        }
                        return null;
                      },
                      controller: companyNameController,
                    ),
                    const SizedBox(height: 10,),
                    CustomInputWithIconTow(
                      topLeftIcon: false,
                      icon: Icons.phone,
                      hintText: 'رقم الهاتف',
                      backgroundColor: companyMainColor.withOpacity(0.2),
                      iconColor: Colors.black,
                      borderColor: Colors.white,
                      keyboardType: TextInputType.phone,
                      validFunc: (value){
                        if(value!.isEmpty) {
                          return "لا يمكن ترك خانة الرقم فارغة";
                        }
                        return null;


                      },
                      controller: phoneNumberController,
                    ),
                    const SizedBox(height: 10,),
                    CustomInputWithIconTow(
                      topLeftIcon: false,
                      icon: Icons.location_on,
                      hintText: 'العنوان',
                      backgroundColor: companyMainColor.withOpacity(0.2),
                      iconColor: Colors.black,
                      borderColor: Colors.white,
                      keyboardType: TextInputType.text,
                      validFunc: (value){
                        if(value!.isEmpty) {
                          return "لا يمكن ترك خانة العنوان فارغة";
                        }
                        if(value.length < 5 || value.length > 30){
                          return "يجب ان تكون عدد الخانات بين 5 الى 30 خانة";
                        }
                        return null;
                      },
                      controller: addressController,
                    ),
                    const SizedBox(height: 10,),
                    CustomInputWithIconTow(
                      topLeftIcon: false,
                      icon: Icons.description,
                      hintText: 'الوصف...',
                      backgroundColor: companyMainColor.withOpacity(0.2),
                      iconColor: Colors.transparent,
                      borderColor: Colors.white,
                      maxLines: 4,
                      minLines: 4,
                      keyboardType: TextInputType.text,
                      validFunc: (value){
                        if(value!.isEmpty) {
                          return "لا يمكن ترك خانة الوصف فارغة";
                        }
                        if(value.length < 5 || value.length > 30){
                          return "يجب ان تكون عدد الخانات بين 5 الى 50 خانة";
                        }
                        return null;
                      },
                      controller: descController,
                    ),
                    SizedBox(height: 10,),
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
                    const SizedBox(height: 10,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                             const Text(
                                "ساعة نهاية العمل",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Container(
                                  decoration: BoxDecoration(
                                      color: companyMainColor.withOpacity(0.2),
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

                              )
                            ],
                          ),
                          SizedBox(width: 40,),
                          Column(
                            children: [
                              const  Text(
                                "ساعة بداية العمل",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Container(
                                  decoration: BoxDecoration(
                                      color: companyMainColor.withOpacity(0.2),
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

                              )
                            ],
                          ),
                        ]),
                    const SizedBox(height: 5,),
                    Visibility(
                      visible: workTimeError.isNotEmpty,
                      child: Text(
                        workTimeError,
                        style:const TextStyle(
                          color: Colors.red
                        ),
                      ),
                    ),
                    const SizedBox(height: 25,),
                    ConditionalBuilder(
                        condition: state is CompanySignUpStateWithGoogleProcess,
                        builder: (context) =>const SpinKitWave(
                          color: companyMainColor,
                          size: 30,
                        ),
                      fallback: (context)=>  ElevatedButton(
                          onPressed: () {
                            if(keyForm.currentState!.validate()){
                              workTimeError = "";

                              if(workTime["endWork"]["hour"].isNotEmpty && workTime["startWork"]["hour"].isNotEmpty ){
                                cubit.signupWithGoogle(
                                    companyPhoneNumber: phoneNumberController.text,
                                    companyName: companyNameController.text,
                                    address: addressController.text,
                                    workTime: workTime,
                                    desc:descController.text
                                );
                              }else {
                                setState(() {
                                  workTimeError = "يجب عليك تحديد ساعات العمل";
                                });
                              }


                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: companyMainColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding:const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          child:const Text('تسجيل حساب جديد',
                            style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
