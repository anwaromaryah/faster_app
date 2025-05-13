import 'package:firstproject001/modules/client_modules/client_login_view/cubit/states.dart';
import 'package:firstproject001/modules/client_modules/client_login_view/presentation/verificationCode.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;

import '../cubit/cubit.dart';

class LoginView extends StatefulWidget {
   const LoginView({super.key,});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();


    String? validatorFunction(value) {

        if(value!.isEmpty){
          return "لا يمكن ترك رقم الهاتف فارغ ";
        }
        if(value.length != 10) {
          return "لا يمكن ان يكون رقم الهاتف اقل او اكثر من 10 خانات";
        }
        return null;
      }




  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ClientLoginCubit(),
      child: BlocConsumer<ClientLoginCubit,ClientLoginStates>(
          listener: (context,state) => {

            if(state is ClientLoginStateVerificationCodeSendCompleted) {
          getx.Get.to(
          () => BlocProvider.value(
    value: BlocProvider.of<ClientLoginCubit>(context),
    child: VerificationCode(phoneNumber: phoneController.text),
    ),
    transition: getx.Transition.rightToLeft,
    duration:const Duration(milliseconds: 500),
    )
            }

          },
        builder: (context,state) {
          ClientLoginCubit cubit = ClientLoginCubit.get(context);
          return Scaffold(
              backgroundColor: mainColor,
              body: Stack(
                  children:[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration:const BoxDecoration(
                              color: Color(0xFFF6F5F5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 20),
                            child: Column(

                              mainAxisAlignment: MainAxisAlignment.end,
                              children:[
                                 CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: Image.asset("icons/handAndBox.png",width: 40,height: 40,),

                                ),
                                const   SizedBox(
                                  height: 20,
                                ),
                                const Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(
                                      "ارسل طرودك بشكل أمن وسريع",
                                      style: TextStyle(
                                        color: mainColor,
                                        fontSize: 24,
                                      ),
                                                                     ),
                                   ],
                                 ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "عند تقديم طلبك حدد خيار الدفع قبل الاستلام وسيترك موظف البريد الطلب عند الباب",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: mainColor.withOpacity(0.6)
                                  ),
                                ),
                                const   SizedBox(
                                  height: 25,
                                ),

                                const  SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: formKey,
                                  child: CustomInputWithIcon(
                                      icon: Icons.phone_android,
                                      hintText: 'رقم الهاتف',
                                      backgroundColor: mainColor.withOpacity(0.1),
                                      iconColor: Colors.white,
                                      iconBackgroundColor: mainColor,
                                      borderColor: mainColor,
                                      keyboardType: TextInputType.phone,
                                      controller: phoneController,
                                      validatorFunc: validatorFunction,
                                  ),
                                ),
                               const SizedBox(height: 10,),
                                ConditionalBuilder(
                                    condition: state is ClientLoginStateVerificationPhoneNumberProcess,
                                    builder: (context)=>const  Center(
                                      child: SpinKitWave(
                                        color: mainColor,
                                        size: 30,
                                      ),
                                    ),
                                    fallback: (context)=> TextButton(
                                        onPressed: (){

                                          if(formKey.currentState!.validate()){
                                            ClientLoginCubit.get(context).loginWithPhoneNumber(
                                                phoneNumberWithDialCode: "+97${phoneController.text}"
                                            );
                                          }
                                        },
                                        child:Container(
                                          width: double.infinity,
                                          child:const Text(
                                            "تسجيل دخول",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: mainColor
                                            ),
                                          ),
                                        )
                                    )
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 45,
                        left: 14,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black,
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 20,)),
                        )
                    )
                  ]
              )
          );
        },
      ),
    );
  }
}
