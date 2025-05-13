import 'package:firstproject001/layout/company_main_layout/cubit/cubit.dart';
import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/shared/component/components.dart';
import 'package:firstproject001/shared/component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:toastification/toastification.dart';


class CompanyDrivers extends StatefulWidget {
  const CompanyDrivers({super.key});

  @override
  State<CompanyDrivers> createState() => _CompanyDriversState();
}

class _CompanyDriversState extends State<CompanyDrivers> {

  bool buttonsAppear = true;

  //dropDown value
  String dropDownMenuValue= "";
  String dropDownMenuValueId= "";
  String dropDownMenuValuePhoneNumber= "";

  bool dropDownMenuAppearError= false;


//add section
  bool addUserAppear = false;

  var driverNameInAddSectionController = TextEditingController();
  var phoneNumberInAddSectionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool showMsgErrorDriverName = false;
  String msgErrorDriverName ="";

  bool showMsgErrorPhoneNumber = false;
  String msgErrorPhoneNumber ="";



//send msg section
  bool sendMsgToUserAppear = false;

  var msgController = TextEditingController();

  bool showMsgError= false;
  String msgError ="";

// delete section
  bool deleteUserAppear = false;

  List<Map> itemsCity = [
    {
      "valueName":"قلقيلية",
      "valueId":"0"
    },
    {
      "valueName":"نابلس",
      "valueId":"1"
    },
    {
      "valueName":"طولكرم",
      "valueId":"2"
    },
    {
      "valueName":"جنين",
      "valueId":"3"
    },
    {
      "valueName":"رام الله",
      "valueId":"4"
    },
    {
      "valueName":"جنين",
      "valueId":"5"
    },
  ];


  void setValueToDropDownMenu(valueName,valueId,valuePhoneNumber) {
    valuePhoneNumber = valuePhoneNumber ?? "";
      dropDownMenuValue = valueName;
      dropDownMenuValueId= valueId;
      dropDownMenuValuePhoneNumber = valuePhoneNumber;
  }




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyLayoutCubit,CompanyLayoutStates>(
        listener: (context,state)=>{

          if(state is CompanyAddNewDriverSucceed) {
      toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('تم اضافة سائق جديد بنجاح',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      description: RichText(text: const TextSpan(text: 'سيتم تفعيل الحساب اثناء عملية تسجيل الدخول',style: TextStyle(fontSize: 12))),
      alignment: Alignment.bottomRight,
      direction: TextDirection.rtl,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check,color: Colors.white,),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.green,
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    )
          }



        },
      builder: (context,state) {
          CompanyLayoutCubit cubit = CompanyLayoutCubit.get(context);
          
        return  Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('السائقين',textAlign: TextAlign.end,)
              ],
            ),
          ),
          body:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Visibility(
                        visible: !buttonsAppear,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: IconButton(
                              onPressed: (){
                                setState(() {
                                  deleteUserAppear = false;
                                  sendMsgToUserAppear = false;
                                  addUserAppear = false;
                                  dropDownMenuAppearError = false;
                                  dropDownMenuValue = "";
                                  buttonsAppear = true;
                                  msgError = "";
                                  showMsgError = false;
                                  showMsgErrorDriverName = false;
                                  msgErrorDriverName ="";
                                  showMsgErrorPhoneNumber = false;
                                  msgErrorPhoneNumber ="";
                                });
                              },
                              icon: Icon(Icons.close,color: Colors.white,size: 18,)
                          ),

                        )
                    ),
                    Spacer(),
                    Visibility(visible: addUserAppear,child:Image.asset("icons/add-user.png",width: 35,height: 35,)),
                    Visibility(visible: sendMsgToUserAppear,child:Image.asset("icons/mail.png",width: 35,height: 35,)),
                    Visibility(visible: deleteUserAppear,child:Image.asset("icons/bin.png",width: 35,height: 35,)),
                  ],
                ),
              ),
              // main buttons
              Visibility(
                visible: buttonsAppear,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: (){
                                  setState(() {
                                    addUserAppear = true;
                                    buttonsAppear = false;
                                  });
                                },
                                icon: Image.asset("icons/add-user.png",width: 45,height: 45,)
                            ),
                            Text('اضافة')
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: (){
                                  setState(() {
                                    sendMsgToUserAppear = true;
                                    buttonsAppear = false;

                                  });
                                },
                                icon: Image.asset("icons/mail.png",width: 45,height: 45,)
                            ),
                            Text('ارسال رسالة')
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  deleteUserAppear = true;
                                  buttonsAppear = false;
                                });
                              },
                              icon: Image.asset("icons/bin.png",width: 45,height: 45,),
                            ),
                            Text('حذف')

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              ///////////
              //delete section
              Visibility(
                visible: deleteUserAppear,
                child:Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CustomDropDown(
                        items: cubit.drivers.isNotEmpty ? cubit.drivers.map((driver) =>{"valueName":driver['driverName'],"valueId":driver['driverId'],"driverPhoneNumber":driver['driverPhoneNumber']}).toList() : [],
                        initialValue: '- قم بأختيار السائق -',
                        onTapFunc: setValueToDropDownMenu,
                        borderColor: dropDownMenuAppearError ? Colors.red : Colors.black.withOpacity(0.1),
                      ),
                      Visibility(
                        visible: dropDownMenuAppearError,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'يجب عليك اختيار السائق',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 5,),
                      ConditionalBuilder(
                          condition: state is CompanyDeleteDriverProcess,
                          builder: (context)=> const Center(
                            child: SpinKitWave(
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          fallback: (context) =>  ElevatedButton(
                            onPressed: () {
                              if(dropDownMenuValue == ""){
                                setState(() {
                                  dropDownMenuAppearError = true;
                                });
                              }else {
                                dropDownMenuAppearError = false;
                                dropDownMenuValue = '- قم بأختيار السائق -';
                                cubit.companyDeleteDriverUser(
                                    driverID: dropDownMenuValueId,
                                    driverPhoneNumber: dropDownMenuValuePhoneNumber
                                );
                              }


                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize:  Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child:  Text('حذف'),
                          )
                      )

                    ],
                  ),
                ),

              ),
              //send section
              Visibility(
                visible: sendMsgToUserAppear,
                child:Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CustomDropDown(
                        items: cubit.drivers.isNotEmpty ? cubit.drivers.map((driver) =>{"valueName":driver['driverName'],"valueId":driver['driverId']}).toList() : [],
                        initialValue: '- قم بأختيار السائق -',
                        onTapFunc: setValueToDropDownMenu,
                        borderColor: dropDownMenuAppearError ? Colors.red : Colors.black.withOpacity(0.1),

                      ),
                      Visibility(
                        visible: dropDownMenuAppearError,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'يجب عليك اختيار السائق',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: msgController,
                          keyboardType: TextInputType.text,
                          textDirection: TextDirection.rtl,
                          textAlignVertical: TextAlignVertical.center,
                          maxLines: 4,
                          // style:  TextStyle(fontSize: textFontSize,),
                          decoration: InputDecoration(
                            hintText: 'الرسالة....',
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.3)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: showMsgError ? Colors.red : Colors.black.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:  BorderSide(color: showMsgError ? Colors.red : Colors.black.withOpacity(0.1),width: 2),
                            ),

                            contentPadding:const EdgeInsets.all(10.0),
                          ),
                          // validator: validatorFunc,

                        ),
                      ),
                      Visibility(
                        visible: showMsgError,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              msgError,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      ConditionalBuilder(
                          condition: state is CompanySendMsgToDriverProcess,
                          builder: (context)=> const Center(
                            child: SpinKitWave(
                              color: Colors.orange,
                              size: 30,
                            ),
                          ),
                          fallback: (context) =>ElevatedButton(
                            onPressed: () {

                              setState(() {

                                if(msgController.text.isEmpty) {
                                  msgError = "لا يمكن ترك الرسالة فارغة";
                                  showMsgError = true;
                                }else if (msgController.text.length < 10 && msgController.text.length < 50) {
                                  msgError = "يجب ان تكون الرسالة اكثر من 10 خانات واقل من 50 خانة";
                                  showMsgError = true;
                                }else{
                                  msgError = "";
                                  showMsgError = false;

                                }


                                if(dropDownMenuValue == ""){
                                  setState(() {
                                    dropDownMenuAppearError = true;
                                  });
                                }else {
                                  dropDownMenuAppearError = false;
                                }



                              });

                              if(!dropDownMenuAppearError && !showMsgError) {
                                cubit.sendMsgFromCompanyToDriver(
                                    driverID: dropDownMenuValueId,
                                    msg: msgController.text
                                );
                                 setState(() {
                                   msgController.text = "";
                                   dropDownMenuValue = "- قم بأختيار السائق -";

                                 });
                                  msgError = "";
                                  showMsgError = false;
                                  dropDownMenuAppearError = false;
                                  dropDownMenuValueId = "";
                                  dropDownMenuValue = "";

                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              minimumSize:  Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child:  Text('ارسال',style: TextStyle(fontWeight: FontWeight.bold),),
                          )
                      )
                    ],
                  ),
                ),

              ),
              //add section
              Visibility(
                visible: addUserAppear,
                child:Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropDown(
                                items: itemsCity,
                                initialValue: '-المدينة-',
                                onTapFunc: setValueToDropDownMenu,
                                borderColor: dropDownMenuAppearError ? Colors.red : Colors.black.withOpacity(0.1),
                                width: 100,

                              ),
                            ),
                            SizedBox(width: 5,),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Expanded(
                                flex: 2,
                                child: SizedBox(
                                  child: TextFormField(
                                    controller: driverNameInAddSectionController,
                                    keyboardType: TextInputType.text,
                                    textDirection: TextDirection.rtl,
                                    textAlignVertical: TextAlignVertical.center,
                                    // style:  TextStyle(fontSize: textFontSize,),
                                    decoration: InputDecoration(
                                      hintText: 'اسم السائق',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: showMsgErrorDriverName ? Colors.red : Colors.black.withOpacity(0.1)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(color: Colors.red),

                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide:  BorderSide(color: showMsgErrorDriverName ? Colors.red : Colors.black.withOpacity(0.1),width: 2),
                                      ),
                                      focusedErrorBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(color: Colors.red,width: 2),
                                      ),
                                      contentPadding:const EdgeInsets.all(10.0),
                                    ),

                                    // validator: validatorFunc,

                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                       const SizedBox(height: 5,),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: phoneNumberInAddSectionController,
                            keyboardType: TextInputType.phone,
                            textDirection: TextDirection.rtl,
                            textAlignVertical: TextAlignVertical.center,
                            // style:  TextStyle(fontSize: textFontSize,),
                            decoration: InputDecoration(
                              hintText: 'رقم الهاتف',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.3)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: showMsgErrorPhoneNumber ? Colors.red : Colors.black.withOpacity(0.1)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.red),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:  BorderSide(color: showMsgErrorPhoneNumber ? Colors.red : Colors.black.withOpacity(0.1),width: 2),
                              ),
                              focusedErrorBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.red,width: 2),
                              ),
                              contentPadding:const EdgeInsets.all(10.0),
                            ),

                          ),
                        ),
                       const SizedBox(height: 5,),
                        ConditionalBuilder(
                          condition: state is CompanyAddNewDriverProcess,
                          builder: (context)=>const Center(
                            child: SpinKitWave(
                              color: Color(0xff00afff),
                              size: 30,
                            ),
                          ),
                          fallback: (context)=> ElevatedButton(
                            onPressed: () {

                              setState(() {

                                if(driverNameInAddSectionController.text.isEmpty){
                                  showMsgErrorDriverName= true;
                                  msgErrorDriverName = "لا يمكن ترك خانة الاسم فارغة";
                                }else if(driverNameInAddSectionController.text.length <= 6 && driverNameInAddSectionController.text.length >= 20){
                                  showMsgErrorDriverName= true;
                                  msgErrorDriverName = "يجب ان يكون الاسم اكبر من 6 خانات واصغر من 20 خانة";
                                }else {
                                  showMsgErrorDriverName= false;
                                  msgErrorDriverName = "";
                                }

                                if(dropDownMenuValue == ""){
                                  dropDownMenuAppearError = true;
                                }else{
                                  dropDownMenuAppearError = false;
                                }


                                if(phoneNumberInAddSectionController.text.isEmpty){
                                  showMsgErrorPhoneNumber= true;
                                  msgErrorPhoneNumber = "لا يمكن ترك رقم الهاتف فارغ فارغة";
                                } else if(phoneNumberInAddSectionController.text.length != 10){
                                  showMsgErrorPhoneNumber= true;
                                  msgErrorPhoneNumber = "يجب ان يكون الرقم من 10 خانات";
                                }else {
                                  showMsgErrorPhoneNumber= false;
                                  msgErrorPhoneNumber = "";
                                }



                              });


                              if(!showMsgErrorDriverName && !showMsgErrorPhoneNumber && !dropDownMenuAppearError) {
                                CompanyLayoutCubit.get(context).createDriverAccount(
                                    phoneNumber: "+97${phoneNumberInAddSectionController.text}",
                                    driverName: driverNameInAddSectionController.text,
                                    driverAddress: dropDownMenuValue
                                );

                                msgError = "";
                                showMsgError = false;
                                showMsgErrorDriverName = false;
                                msgErrorDriverName ="";
                                showMsgErrorPhoneNumber = false;
                                msgErrorPhoneNumber ="";
                              }


                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff00afff),
                              foregroundColor: Colors.white,
                              minimumSize:  Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child:  Text('اضافة',style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Visibility(
                          visible: showMsgErrorDriverName,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                msgErrorDriverName,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12
                                ),
                              ),

                            ],
                          ),
                        ),
                        Visibility(
                          visible: showMsgErrorPhoneNumber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Text(
                                msgErrorPhoneNumber,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12
                                ),
                              ),

                            ],
                          ),
                        ),
                        Visibility(
                          visible: dropDownMenuAppearError,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'لا يمكن ترك المدينة فارغة',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ),
              // list of drivers
              ConditionalBuilder(
                  condition: cubit.drivers.isNotEmpty,
                  builder: (context) => Expanded(
                    child: ListView.builder(
                        itemCount: cubit.drivers.length ?? 0,
                        itemBuilder: (context,index) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                            margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                            decoration: BoxDecoration(
                                color:const Color(0xffF4F4F4),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${cubit.drivers[index]["driverName"]}'
                                      ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text('${cubit.drivers[index]["driverPhoneNumber"]}',textAlign: TextAlign.end,style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              SizedBox(width: 4,),
                                              Icon(Icons.phone,color: Colors.grey,size: 12,),

                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text('${cubit.drivers[index]["driverAddress"]}',textAlign: TextAlign.end,style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              SizedBox(width: 4,),
                                              Icon(Icons.location_on,color: Colors.grey,size: 12,),

                                            ],
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 5,),
                                ConditionalBuilder(
                                    condition: cubit.drivers.isEmpty || cubit.drivers[index]["profilePic"].isEmpty,
                                    builder: (context) => CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.white.withOpacity(0.7),
                                      child: Image.asset("icons/driver.png",width: 38,height: 38,),
                                    ),
                                    fallback: (context)=> CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.white.withOpacity(0.7),
                                      backgroundImage: NetworkImage("${cubit.drivers[index]["profilePic"]}",),
                                    )
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                  )
                  , fallback: (context) => Expanded(
                child: Center(
                  child: Text(
                     "لما يتم اضافة سائقينن",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24
                    ),
                  ),
                ),
              )
              )
            ],
          ),
        );
      },

    );
  }
}
