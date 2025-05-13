
import 'package:firstproject001/layout/company_main_layout/presentation/company_main_layout.dart';
import 'package:firstproject001/layout/delivery_main_layout/presentation/delivery_main.layout.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/company_signup_view.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/company_verification_code.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/cubit/cubit.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/cubit/states.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as getx;

import '../../../../shared/component/constants.dart';
import '../../../../shared/component/toastification.dart';

class CompanyLoginView extends StatefulWidget {
  const CompanyLoginView({super.key});

  @override
  State<CompanyLoginView> createState() => _CompanyLoginViewState();
}

class _CompanyLoginViewState extends State<CompanyLoginView> {

  var phoneNumberController = TextEditingController();
  var keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CompanyLoginCubit(),
      child: BlocConsumer<CompanyLoginCubit,CompanyLoginStates>(
          listener: (context,state)=>{

            if(state is CompanyLoginStateSendCodeCompleted) {

              getx.Get.to(
                    () => BlocProvider.value(
                  value: BlocProvider.of<CompanyLoginCubit>(context),
                  child: CompanyVerificationCode(phoneNumber: phoneNumberController.text),
                ),
                transition: getx.Transition.rightToLeft,
                duration:const Duration(milliseconds: 500),
              )

            },

            if(state is CompanyLoginStateWithGoogleAccountExist){


              getx.Get.offAll(
                    ()=>const  CompanyMainLayout(),
                transition: getx.Transition.circularReveal,
                duration:const Duration(milliseconds: 500),
              )

            },

            if(state is CompanySignUpStateWithGoogle) {

              getx.Get.to(
                    () => BlocProvider.value(
                  value: BlocProvider.of<CompanyLoginCubit>(context),
                  child:const CompanySignupView(),
                ),
                transition: getx.Transition.rightToLeft,
                duration:const Duration(milliseconds: 500),
              )

            },
            if(state is CompanyLoginStateVerificationPhoneNumberError){
              customeToastification(
                  context,
                  title: "خطأ بالرقم المدخل",
                  desc: state.showError(),
                  icon:const Icon(Icons.error,color: Colors.white,),
                  backgroundColor: Colors.red
              )
            },

            if(state is CompanyLoginStateWithGoogleError ){
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
            CompanyLoginCubit cubit = CompanyLoginCubit.get(context);
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: companyMainColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Image.asset("icons/companyAndBuilding.png",width: 60,height: 60,),
                          ),
                          SizedBox(height: 25,),
                          Text(
                            'معنى شركتك على الطلب دائما',
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23

                                ),
                              ),
                              const SizedBox(height: 30,),
                              Form(
                                key: keyForm,
                                child: CustomInputWithIcon(
                                  icon: Icons.phone_android,
                                  hintText: "رقم الهاتف",
                                  backgroundColor: Colors.transparent,
                                  iconColor: Colors.white,
                                  iconBackgroundColor: companyMainColor,
                                  borderColor: companyMainColor,
                                  keyboardType: TextInputType.phone,
                                  validatorFunc: (value){
                                    if(value!.isEmpty){
                                      return "لا يمكن ترك رقم الهاتف فارغ";
                                    }
                                    if(value.length != 10) {
                                      return "لا يمكن ان يكون رقم الهاتف اقل او اكثر من 10 خانات";
                                    }
                                    return null;
                                  },
                                  controller: phoneNumberController,
                                ),
                              ),
                              const SizedBox(height: 10,),

                              ConditionalBuilder(
                                  condition: state is CompanyLoginStateVerificationPhoneNumberProcess,
                                  builder: (context)=> const Center(
                                    child: SpinKitWave(
                                      color: companyMainColor,
                                      size: 30,
                                    ),
                                  ),
                                  fallback: (context)=>    ElevatedButton(
                                    onPressed: () {
                                      if(keyForm.currentState!.validate()){
                                        cubit.loginWithPhoneNumber(
                                            phoneNumberWithDialCode: "+97${phoneNumberController.text}"
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: companyMainColor,
                                      foregroundColor: Colors.white,
                                      minimumSize:  Size(double.infinity,45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),

                                    ),
                                    child:  Text('تسجيل دخول'),
                                  ),
                              ),

                              const SizedBox(height: 10,),
                              const Text(' - او -',style: TextStyle(fontSize: 16),),
                              const SizedBox(height: 5,),
                              const Text(' قم بتسجيل الدخول بأستخدام',style: TextStyle(fontSize: 16),),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  cubit.loginWithGoogle();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(width: 1,color: Colors.black.withOpacity(0.04)),
                                  ),
                                  child: Image.asset('images/google-logo.png',width: 37,height: 37,),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text('جوجل',style: TextStyle(fontSize: 14),),
                              const SizedBox(height: 15,),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  'ملاحظة: في حال كنت صاحب شركة وتريد تسجيل الدخول او تسجيل حساب جديد قم بأستخدام جوجل',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),






                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: state is CompanyLoginStateWithGoogleProcess,
                    child: Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child:const SpinKitCubeGrid(
                          color: companyMainColor,
                          size: 50,
                        ),
                      ),
                    )),
                Positioned(
                    top: 45,
                    left: 14,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: mainColor,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 20,)),
                    )
                )
              ],
            ),
          );
        },

      ),
    );
  }
}
