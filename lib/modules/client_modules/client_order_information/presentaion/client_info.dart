import 'dart:io';

import 'package:firstproject001/layout/client_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';
import 'package:firstproject001/layout/client_main_layout/presentation/client_main_layout.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:firstproject001/shared/component/getCityNameByCoordinates.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as getx;

import '../../../../shared/component/custom_map.dart';
import '../../../../shared/component/pic_images.dart';

class ClientInfo extends StatefulWidget {
  const ClientInfo(
      {
        super.key,
        this.companyInfo,
        this.recipientInfo,
        this.orderType,
        this.orderInfo
      });

  final Map? companyInfo;
  final Map? orderInfo;

  final Map? recipientInfo;

  final String? orderType;


  @override
  State<ClientInfo> createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  Map clientInfo = {};

  var formKey= GlobalKey<FormState>();

  var clientNameController= TextEditingController();

  var clientPhoneNumberController = TextEditingController();

  LatLng orderLocation = LatLng(0, 0);
  var orderLocationNameController = TextEditingController();
  bool locationFieldErrorShow = false;
  String locationErrorMsg = "";

  List<String> validationErrors = [];

  File image = File("");

  void setValueOrderLocation(location){
    setState(() {
      orderLocation = location;
    });
  }
  @override
  void initState() {
    print(widget.recipientInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientLayoutCubit,ClientLayoutStates>(
        listener: (context,state)=>{

          if(state is SendSpecificRequestToRealTimeDatabaseSucceed || state is SendGeneralRequestToRealTimeDatabaseSucceed) {

            getx.Get.offAll(
                  ()=>const  ClientMainLayout(),
              transition: getx.Transition.zoom,
              duration:const Duration(milliseconds: 500),
            )

          },


        },
        builder: (context,state){
          ClientLayoutCubit cubit = ClientLayoutCubit.get(context);
          return  Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      'معلومات المرسل'
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          image = await pickImage(context);

                          if(image.path.isNotEmpty  ) {
                            cubit.updateProfilePic(profileImg: image);
                          }

                        },
                        child: ConditionalBuilder(
                          // condition: image.path.isEmpty,
                            condition:cubit.clientInfo.isNotEmpty && cubit.clientInfo["profilePic"].isNotEmpty,
                            builder: (context) => Center(
                              child: Container(
                                width: 150,
                                height: 120,
                                child: Stack(
                                  children: [
                                     Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage("${cubit.clientInfo["profilePic"]}"),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      left: 60,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        child: Icon(Icons.camera_alt,color: Colors.white,size: 16,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            fallback: (context)=> Center(
                              child: Container(
                                width: 150,
                                height: 120,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey,
                                        child: Center(child: Image.asset("icons/user (1).png",width: 60,height: 60,)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 60,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        child: Icon(Icons.camera_alt,color: Colors.white,size: 16,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomInputWithIconTow(
                        topLeftIcon: false,
                        icon: Icons.drive_file_rename_outline,
                        hintText: cubit.clientInfo["clientName"].isEmpty ? 'اسم المرسل' : cubit.clientInfo["clientName"],
                        backgroundColor: Colors.white,
                        iconColor: Colors.grey,
                        borderColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        validFunc: (value){

                          if(value.isEmpty){
                            return "لا يمكن ترك اسم المرسل فارغ";
                          }
                          if(value.length < 5 || value.length > 30){
                            return "يجب ان يكون الاسم اكبر من 5 خانات واصغر من 30";
                          }
                          return null;

                        },
                        controller: clientNameController,
                      ),
                      const SizedBox(height: 15,),
                      CustomInputWithIconTow(
                        topLeftIcon: false,
                        icon: Icons.phone_android,
                        hintText: cubit.clientInfo["clientPhoneNumber"].substring(3),
                        backgroundColor: Colors.white,
                        iconColor: Colors.grey,
                        borderColor: Colors.grey,
                        keyboardType: TextInputType.phone,
                        validFunc: (value){
                          if(value.isEmpty){
                            return "لا يمكن ترك رقم هاتف المرسل فارغ";
                          }
                          if(value.length != 10){
                            return "يجب ان يكون رقم الهاتف مكون من 10 خانات";
                          }
                          return null;
                        },
                        controller: clientPhoneNumberController,
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'موقع التوصيل',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          Visibility(
                              visible: locationFieldErrorShow,
                              child: const Text("*",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                          )

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){
                                if(cubit.userLocation.latitude == 0) {
                                  cubit.setUserLocation();
                                }

                                if(orderLocation.latitude != 0  ) {
                                  orderLocation = orderLocation;
                                  _displayBottomSheet(context,LatLng(0, 0));
                                }else if(cubit.userLocation.latitude != 0) {
                                  orderLocation = cubit.userLocation;
                                  _displayBottomSheet(context,LatLng(0, 0));
                                }else {
                                  _displayBottomSheetSelectCity(context);
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
                          Spacer(),
                          Text(
                            orderLocation.latitude == 0 && orderLocation.longitude == 0 ? 'الخريطة - غير محدد' : "تم تحديد الموقع",
                            style: TextStyle(color: locationFieldErrorShow && orderLocation.latitude !=0  ? Colors.red : Colors.grey),),
                          const SizedBox(width: 10,),
                          Image.asset("icons/order-location.png",width: 20,height: 20,)
                        ],
                      ),

                      const SizedBox(height: 10,),
                      CustomInputWithIconTow(
                        topLeftIcon: false,
                        icon: Icons.location_on,
                        hintText: 'قم بكتابة اسم المنطقة او الشارع ',
                        backgroundColor: Colors.white,
                        iconColor: Colors.grey,
                        borderColor: locationFieldErrorShow && orderLocationNameController.text.isEmpty ? Colors.red : Colors.grey,
                        keyboardType: TextInputType.text,
                        validFunc: (value){},
                        controller: orderLocationNameController,
                      ),
                      const SizedBox(height: 10,),
                      Visibility(
                          visible: validationErrors.isNotEmpty,
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

                          if(clientNameController.text.isEmpty && cubit.clientInfo["clientName"].isNotEmpty){
                             clientNameController.text = cubit.clientInfo["clientName"];
                          }

                          if(clientPhoneNumberController.text.isEmpty && cubit.clientInfo["clientPhoneNumber"].isNotEmpty) {
                            clientPhoneNumberController.text = cubit.clientInfo["clientPhoneNumber"].substring(3);
                          }


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

                          clientInfo = {
                            "clientName": clientNameController.text,
                            "clientPhoneNumber" : clientPhoneNumberController.text,
                            "latitudeForClient":orderLocation.latitude,
                            "longitudeForClient":orderLocation.longitude,
                            "nameAddress" : orderLocationNameController.text
                          };



                            cubit.sendSpecificRequest(
                                companyInfo: widget.companyInfo,
                                recipientInfo: widget.recipientInfo,
                                userInfo: clientInfo
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
                          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('تأكيد الطلب'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }

  Future _displayBottomSheet(context,LatLng userCity) {
    LatLng selectedCity = LatLng(32.3045,35.0258);

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
                    // location: orderLocation,
                    location: userCity.latitude != 0 ? userCity : orderLocation ,
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

  Future _displayBottomSheetSelectCity(context) {

    const List<Map<String,dynamic>> cities = [
      {
        "cityName" : "طولكرم",
        "latLng" : LatLng(32.3118,35.03111)
      },
      {
        "cityName" : "قلقيلية",
        "latLng" : LatLng(32.18735,34.96897)
      },
      {
        "cityName" : "نابلس",
        "latLng" : LatLng(32.2157,35.2572)
      },
      {
        "cityName" : "رام الله",
        "latLng" : LatLng(31.90248,35.19522)
      },
      {
        "cityName" : "بديا",
        "latLng" : LatLng(32.11497,35.07802)
      },
      {
        "cityName" : "عزون",
        "latLng" : LatLng(32.17532,35.0584)
      },
      {
        "cityName" : "كفر ثلث",
        "latLng" : LatLng(32.15352,35.04707)
      },
      {
        "cityName" : "حبلة",
        "latLng" : LatLng(32.16428,34.97862)
      },
    ];
    LatLng selectedCity = LatLng(32.3045,35.0258);

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

                      ],
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      height: 350,
                      child: GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(
                              cities.length,(index){
                            return Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    _displayBottomSheet(context,cities[index]["latLng"]);
                                  },
                                  child: Text(
                                    cities[index]["cityName"],
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  )
                              ),
                            );
                          }
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}
