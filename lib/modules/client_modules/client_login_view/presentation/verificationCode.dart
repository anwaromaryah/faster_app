import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firstproject001/layout/admin_main_layout/presentation/admin_main_layout.dart';
import 'package:firstproject001/layout/client_main_layout/presentation/client_main_layout.dart';

import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;

import '../../../../shared/component/toastification.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';




class VerificationCode extends StatefulWidget {

  const VerificationCode({super.key,this.phoneNumber});

  final String? phoneNumber ;


  @override
  State<VerificationCode> createState() => _VerificationCode();
}

class _VerificationCode extends State<VerificationCode> {

  String verificationCode = "";
  bool verificationCodeError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ClientLoginCubit,ClientLoginStates>(
        listener: (context,state)=>{

          if(state is ClientLoginStateVerificationCodeCompleted) {

          getx.Get.offAll(
              ()=>const  ClientMainLayout(),
             transition: getx.Transition.circularReveal,
            duration:const Duration(milliseconds: 500),
          )
          },

          if(state is ClientLoginStateVerificationCodeToAdminCompleted) {

            getx.Get.offAll(
                  ()=>const  AdminMainLayout(),
              transition: getx.Transition.circularReveal,
              duration:const Duration(milliseconds: 500),
            )
          },
          if(state is ClientLoginStateVerificationCodeError){
            Navigator.pop(context),
            customeToastification(
                context,
                title: "هنالك خطأ",
                desc: state.showError(),
                icon:const Icon(Icons.close),
                backgroundColor: Colors.red
            )
          },

        },
        builder: (context,state) {
          ClientLoginCubit cubit = ClientLoginCubit.get(context);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: mainColor,
                      child: Image.asset('images/guard-logo.png',width: 45,height: 45,),
                    ),
                    const SizedBox(height:30),
                    Text(
                      "تأكيد رقم الهاتف",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(height:10),
                    Text(
                      "لقد ارسلنا رمز التأكيد على رقم رقم الخاص بك يمكنك ايجاد الرمز بصندوق الرسائل في هاتفك الخاص",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 14
                      ),
                    ),
                    const SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(400),
                              border: Border.all(width: 1,color: Colors.black.withOpacity(0.1))
                          ),
                          child: Icon(Icons.phone_android,size: 12,color: Colors.black.withOpacity(0.6),),
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          '${widget.phoneNumber!.substring(0,7)}****',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height:30),
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: !verificationCodeError ? mainColor : Colors.red)
                          ),
                          textStyle:const TextStyle(
                              fontSize: 20,fontWeight: FontWeight.bold
                          )
                      ),
                      onCompleted: (value){
                        setState(() {
                          verificationCode = value;
                        });
                      },
                    ),
                    const SizedBox(height:30),
                    ConditionalBuilder(
                        condition: state is ClientLoginStateVerificationCodeProcess,
                        builder: (context)=>const Center(
                          child: SpinKitWave(
                            color: mainColor,
                            size: 30,
                          ),
                        ),
                        fallback: (context)=>ElevatedButton(
                          onPressed: () {

                            if(verificationCode.length != 6) {
                              setState(() {
                                verificationCodeError = true;
                              });
                              return;
                            }

                            cubit.verifyVerificationCode(verificationCode);

                          },
                          child: const Text('تأكيد',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 40),
                            backgroundColor: mainColor,
                          ),
                        )
                    )



                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

