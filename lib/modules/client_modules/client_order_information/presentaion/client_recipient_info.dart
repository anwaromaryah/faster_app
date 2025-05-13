import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/layout/client_main_layout/presentation/client_main_layout.dart';
import 'package:firstproject001/modules/client_modules/client_login_view/presentation/verificationCode.dart';
import 'package:firstproject001/modules/client_modules/client_order_information/presentaion/client_info.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/custom_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart' as getx;

class ClientRecipientInfo extends StatefulWidget {

  const ClientRecipientInfo({
    super.key,
    this.companyInfo,
    this.orderType = "specific",
    this.orderInfo ,

  });
  // specific order
  final Map? companyInfo;
  // general order
  final Map? orderInfo;


  final String? orderType;


  @override
  State<ClientRecipientInfo> createState() => _ClientRecipientInfoState();
}

class _ClientRecipientInfoState extends State<ClientRecipientInfo> {

  var formKey = GlobalKey<FormState>();
  var recipientNameController = TextEditingController();
  var recipientPhoneNumberController = TextEditingController();

  LatLng orderLocation = LatLng(0, 0);
  var orderLocationNameController = TextEditingController();
  bool locationFieldErrorShow = false;
  List<String> validationErrors = [];

  Map recipientInfo = {};

  void setValueOrderLocation(location){
    setState(() {
      orderLocation = location;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state) =>{},
        builder: (context,state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const  Image(
                  image: AssetImage('images/d1.png'),
                  height: 200,
                  width: double.infinity,

                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "معلومات المستلم",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const  SizedBox(height: 20,),
                        CustomInputWithIconTow(
                          topLeftIcon: false,
                          icon: Icons.drive_file_rename_outline,
                          hintText: 'اسم المستلم',
                          backgroundColor: Colors.white,
                          iconColor: Colors.grey,
                          borderColor: Colors.grey,
                          keyboardType: TextInputType.text,
                          validFunc: (value){

                            if(value.isEmpty){
                              return "لا يمكن ترك اسم المستلم فارغ";
                            }
                            if(value.length < 5 || value.length > 30){
                              return "يجب ان يكون الاسم اكبر من 5 خانات واصغر من 30";
                            }
                            return null;


                          },
                          controller: recipientNameController,
                        ),
                        const  SizedBox(height: 20,),
                        CustomInputWithIconTow(
                          topLeftIcon: false,
                          icon: Icons.phone_android,
                          hintText: 'رقم هاتف المستلم',
                          backgroundColor: Colors.white,
                          iconColor: Colors.grey,
                          borderColor: Colors.grey,
                          keyboardType: TextInputType.phone,
                          validFunc: (value){

                            if(value.isEmpty){
                              return "لا يمكن ترك رقم هات المستلم فارغ";
                            }
                            if(value.length != 10){
                              return "يجب ان يكون رقم الهاتف مكون من 10 خانات";
                            }
                            return null;

                          },
                          controller: recipientPhoneNumberController,
                        ),
                        const SizedBox(height: 20,),
                        Visibility(
                          visible: widget.orderType == "specific",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: (){
                                    //test
                                    if(ClientLayoutCubit.get(context).userLocation.latitude == 0) {
                                      ClientLayoutCubit.get(context).setUserLocation();
                                    }
                                    
                                    if(orderLocation.latitude != 0  ) {
                                      orderLocation = orderLocation;
                                      _displayBottomSheet(context);
                                    }else if(ClientLayoutCubit.get(context).userLocation.latitude != 0) {
                                      orderLocation = ClientLayoutCubit.get(context).userLocation;
                                      _displayBottomSheet(context);
                                    }else {
                                      orderLocation = LatLng(32.157, 35.1535);
                                      _displayBottomSheet(context);
                                    }
                                    
                                  },
                                  child: const Text(
                                    'تعديل',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 14
                                    ),
                                  )
                              ),
                             const Spacer(),
                              Text(
                                orderLocation.latitude == 0 && orderLocation.longitude == 0 ? 'الخريطة - غير محدد' : "تم تحديد الموقع",
                                style: TextStyle(color: locationFieldErrorShow && orderLocation.latitude !=0  ? Colors.red : Colors.grey),),
                              const SizedBox(width: 10,),
                              Image.asset("icons/order-location.png",width: 20,height: 20,)
                            ],
                          ),
                        ),
                        Visibility(visible: widget.orderType == "specific",child: const SizedBox(height: 10,)),
                        Visibility(
                          visible: widget.orderType == "specific",
                          child: CustomInputWithIconTow(
                            topLeftIcon: false,
                            icon: Icons.location_on,
                            hintText: 'قم بكتابةاسم المنطقة او الشارع ',
                            backgroundColor: Colors.white,
                            iconColor: Colors.grey,
                            borderColor: locationFieldErrorShow && orderLocationNameController.text.isEmpty ? Colors.red : Colors.grey,
                            keyboardType: TextInputType.text,
                            validFunc: (value){},
                            controller: orderLocationNameController,
                          ),
                        ),
                        Visibility(visible: widget.orderType == "specific",child: const SizedBox(height: 10,)),
                        Visibility(
                            visible: validationErrors.isNotEmpty && widget.orderType == "specific",
                            child: Container(
                              width: double.infinity,
                              height: validationErrors.length * 30,
                              child: ListView.separated(
                                  itemCount: validationErrors.length,
                                  separatorBuilder: (context,index)=>const SizedBox(height: 5,),
                                  itemBuilder: (context,index)=> Text(validationErrors[index],textDirection: TextDirection.rtl,textAlign: TextAlign.right,style: TextStyle(color: Colors.red),)
                              ),
                            )
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {

                            if(widget.orderType == "specific") {

                              if(formKey.currentState!.validate()){

                                setState(() {
                                  validationErrors = [];
                                  locationFieldErrorShow = false;
                                  if(orderLocation.latitude == 0 && orderLocation.longitude == 0 ){
                                    validationErrors.add("يجب عليك اختيار مكان التوصيل من الخريطة");
                                    locationFieldErrorShow = true;
                                  }
                                  if(orderLocationNameController.text.isEmpty) {
                                    validationErrors.add("يجب عليك كتابة اسم المنطقة او الشارع");
                                    locationFieldErrorShow = true;
                                  }
                                });

                                if(!locationFieldErrorShow) {

                                  recipientInfo = {
                                    "recipientName": recipientNameController.text,
                                    "recipientPhoneNumber" : recipientPhoneNumberController.text,
                                    "latitudeForRecipient":orderLocation.latitude,
                                    "longitudeForRecipient":orderLocation.longitude,
                                    "nameAddress" : orderLocationNameController.text
                                  };


                                  getx.Get.to(
                                        () => BlocProvider.value(
                                      value: BlocProvider.of<ClientLayoutCubit>(context),
                                      child: ClientInfo(
                                        companyInfo: widget.companyInfo,
                                        recipientInfo: recipientInfo,
                                        orderType: widget.orderType,
                                      ),
                                    ),
                                    transition: getx.Transition.rightToLeft,
                                    duration:const Duration(milliseconds: 500),
                                  );

                                }
                              }

                            }else {

                    if(formKey.currentState!.validate()){

                      recipientInfo = {
                        "recipientName": recipientNameController.text,
                        "recipientPhoneNumber" : recipientPhoneNumberController.text,
                        "latitudeForRecipient":widget.orderInfo!["latitude"],
                        "longitudeForRecipient":widget.orderInfo!["longitude"],
                        "nameAddress" : widget.orderInfo!["locationName"]
                      };




                      getx.Get.to(
                            () => BlocProvider.value(
                          value: BlocProvider.of<ClientLayoutCubit>(context),
                          child: ClientInfo(
                            companyInfo: widget.companyInfo,
                            recipientInfo: recipientInfo,
                            orderType: widget.orderType,
                          ),
                        ),
                        transition: getx.Transition.rightToLeft,
                        duration:const Duration(milliseconds: 500),
                      );

                    }



                    }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize:  Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          ),
                          child:  Text('تأكيد معلومات المستلم'),
                        )
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
    );
  }

  Future _displayBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Stack(
          children: [
            Container(
              height: 400,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)
                      ),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close,color: Colors.red,)
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "الخريطة",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  CustomMap(setLocation: setValueOrderLocation,
                    location: orderLocation,
                    secondLocation: LatLng(0, 0),
                    thirdLocation: LatLng(0, 0),
                    fourthLocation: LatLng(0, 0),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        )
    );
  }


}
