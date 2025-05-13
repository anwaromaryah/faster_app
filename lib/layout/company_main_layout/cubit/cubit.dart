



import 'package:firstproject001/layout/company_main_layout/cubit/states.dart';
import 'package:firstproject001/models/driver_model.dart';
import 'package:firstproject001/modules/company_modules/company_drivers_view/company_drivers.dart';
import 'package:firstproject001/modules/company_modules/company_history_view/presentation/company_history_view.dart';
import 'package:firstproject001/modules/company_modules/company_home_view/presentation/company_home_view.dart';
import 'package:firstproject001/modules/company_modules/company_settings_view/presentation/company_settings_view.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

import '../../../shared/component/cloudinary_upload_image.dart';

import 'package:intl/intl.dart';


class CompanyLayoutCubit extends Cubit<CompanyLayoutStates> {

  CompanyLayoutCubit() : super(CompanyLayoutStatesInitial());

  static CompanyLayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> companyLayoutScreens= [
    const CompanyHomeView(),
    const CompanyDrivers(),
    const CompanyHistoryView(),
    const CompanySettingsView(),

  ];

  List<Map> drivers = [];
  Map<String,dynamic> companyInfo = {};
  List<dynamic> orderListForHomeScreen = [];
  List<dynamic> historyData = [];
  List<dynamic> historyDataFilter = [];
  String historyFilter = "";
  int bottomNavigationBarIndex = 0;



  void changeBottomNavigationBarIndex(int index) {
    bottomNavigationBarIndex = index;
    emit(CompanyBottomNavigationBarIndex());
  }

  Future<void> durationMethod()async{
    emit(CompanyDurationMethodProcess());
    await Future.delayed(const Duration(seconds: 5));
    emit(CompanyDurationMethodFinish());

  }

  Future<void> durationMethodModules()async{
    emit(CompanyDurationMethodModulesProcess());
    await Future.delayed(const Duration(seconds: 1));
    emit(CompanyDurationMethodModulesFinish());

  }

  Future<void> getUserInformation()async {
    try{
      emit(GetCompanyInformationProcess());
      String? companyId = CacheHelper.getString('userId');
      var snapshot = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();

      if (snapshot.exists) {
        companyInfo = snapshot.data() as Map<String,dynamic>;
        orderListForHomeScreen = companyInfo["history"].length <= 5 ?  companyInfo["history"]:
        companyInfo["history"].sublist(companyInfo["history"].length - 5);
        historyData = companyInfo["history"];
        CacheHelper.set('companyId', companyInfo['companyId'].toString());
        // emit(GetCompanyInformationSuccess());
      } else {
        emit(GetCompanyInformationError("هنالك مشكلة في عملية طلب البيانات"));

      }
    }on FirebaseException catch (e){
      emit(GetCompanyInformationError("هنالك مشكلة بلأتصال بالشبكة"));
      print(e.toString());

    }catch(e){
      emit(GetCompanyInformationError("هنالك مشكلة بلأتصال بالشبكة"));
      print(e.toString());
    }
  }


  Future<void> getAllDrivers() async{
    emit(GetAllDriversProcess());
    try{
      DocumentSnapshot companySnapshot = await FirebaseFirestore.instance.collection('companies').doc(CacheHelper.getString("userId")).get();

      if (companySnapshot.exists) {

        List<dynamic> driversList= companySnapshot.get("drivers");

        List<Future<DocumentSnapshot>> driverFutures = driversList.map((driverId) {
          return FirebaseFirestore.instance
              .collection('drivers')
              .doc(driverId)
              .get();
        }).toList();

        List<DocumentSnapshot> driverSnapshots = await Future.wait(driverFutures);

        for (DocumentSnapshot userSnapshot in driverSnapshots) {
          if (userSnapshot.exists) {
            drivers.add(userSnapshot.data() as Map<String, dynamic>);

          } else {
            print('User not found');
          }

        }
      } else {
        print('Company not found');
      }
      // emit(GetAllDriversSuccess());
    } on FirebaseException catch (e) {
      print(e.toString());
     emit(GetAllDriversError("هنالك مشكلة ما بلأتصال"));
    }catch(e){
      ///
      print(e.toString());
      emit(GetAllDriversError("هنالك مشكلة ما بلأتصال"));

    }
  }


  void createDriverAccount(
  {
    @required phoneNumber,
    @required driverName,
    @required driverAddress,
}
      ) async {
    try {
      emit(CompanyAddNewDriverProcess());

      checkIfUserExist(docName: phoneNumber, collectionName: "driversPhoneNumbers").then((exist){
             if(exist) {
               emit(CompanyAddNewDriverAlreadyExist());
             }else {
               DriverModel driverModel = DriverModel(
                 driverId: phoneNumber,
                 companyId:  companyInfo['companyId'],
                 driverName: driverName,
                 driverAddress: driverAddress,
                 driverPhoneNumber: phoneNumber,
                 companyName: companyInfo['companyName'],
                 createdAt:DateTime.now().toString(),
               );

               FirebaseFirestore.
               instance.
               collection('driversPhoneNumbers').
               doc(phoneNumber).
               set(driverModel.toMap()).
               then((value) => emit(CompanyAddNewDriverSucceed())).
               catchError((error) => emit(CompanyDriversViewError(error.toString('هنالك مشكلة في أنشاء الحساب حاول مرة اخرى في وقت لاحق'))));
             }
      });

    }on FirebaseException catch (e) {
      emit(CompanyDriversViewError('هنالك مشكلة في أنشاء الحساب حاول مرة اخرى في وقت لاحق'));
    }catch(e){
      emit(CompanyDriversViewError('هنالك مشكلة في أنشاء الحساب حاول مرة اخرى في وقت لاحق'));
    }


  }

void sendMsgFromCompanyToDriver(
  {
    @required driverID,
    @required msg
}
    ) async{
  try {
emit(CompanySendMsgToDriverProcess());
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(driverID)
        .update({
        'notifications': FieldValue.arrayUnion([msg]),
    }).then((value){
      emit(CompanySendMsgToDriverSucceed());
    }).catchError((error){
      emit(CompanyDriversViewError('هنالك مشكلة في عملية ارسال الرسالة حاول مرة اخرى في وقت لاحق'));
    });

  }on FirebaseException catch (e) {
    emit(CompanyDriversViewError('هنالك مشكلة في عملية ارسال الرسالة حاول مرة اخرى في وقت لاحق'));
  }catch(e){
    emit(CompanyDriversViewError('هنالك مشكلة في عملية ارسال الرسالة حاول مرة اخرى في وقت لاحق'));
  }
}

void companyDeleteDriverUser(
      {
        @required driverID,
        @required driverPhoneNumber
      }
      )async{

    try {
emit(CompanyDeleteDriverProcess());
      await FirebaseFirestore.instance.collection('drivers').doc(driverID).delete().then((value)async{

        await FirebaseFirestore.instance.collection('driversPhoneNumbers').doc(driverPhoneNumber).delete().then((value){
            drivers = [];
            getAllDrivers();
            emit(CompanyDeleteDriverSucceed());

        });

      });

    }on FirebaseException catch (e) {
      emit(CompanyDriversViewError('هنالك مشكلة في عملية حذف السائق حاول مرة اخرى في وقت لاحق'));
    }catch(e){
      emit(CompanyDriversViewError('هنالك مشكلة في عملية حذف السائق حاول مرة اخرى في وقت لاحق'));
    }
  }



  Future<bool> checkIfUserExist(
      {
        @required docName,
        @required collectionName
      }
      ) async {

    var snapshot = await FirebaseFirestore.instance.collection(collectionName).doc(docName).get();

    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

//history
  void filterHistory({@required filter}) async {
    try{
      // current time
      final now = DateTime.now();
      final currentTime = now.toString().split(' ')[0];
      final lastWeekStart = now.subtract(Duration(days: now.weekday));

      DateTime todayDate = DateTime.parse(currentTime);

      int year = todayDate.year;
      int month = todayDate.month;
      int day = todayDate.day;

      DateFormat formatter = DateFormat('yyyy-MM-dd');


      if(filter == "day"){

        historyDataFilter = historyData.where((item){
          DateTime timeFromDatabase = formatter.parse(item["orderInfo"]["time"]);
          return timeFromDatabase.month == month &&
              timeFromDatabase.year == year &&
              timeFromDatabase.day == day;
        }).toList();

      }else if(filter == "month") {

        historyDataFilter = historyData.where((item){
          DateTime timeFromDatabase = formatter.parse(item["orderInfo"]["time"]);
          return timeFromDatabase.month == month &&
              timeFromDatabase.year == year
          ;
        }).toList();

      }else if(filter == "year"){
        historyDataFilter = historyData.where((item){
          DateTime timeFromDatabase = formatter.parse(item["orderInfo"]["time"]);
          return timeFromDatabase.year == year;
        }).toList();
      }else {
        historyDataFilter = historyData.where((item){
          DateTime timeFromDatabase = formatter.parse(item["orderInfo"]["time"]);
          return timeFromDatabase.isAfter(lastWeekStart) &&
              timeFromDatabase.isBefore(now);
        }).toList();
      }

      if(historyDataFilter.isNotEmpty) {
        historyFilter = filter;
        emit(FilterHistorySucceed());

      }else {
        historyFilter = "";
        emit(HistoryError("لا يوجد بيانات"));
      }


    }catch(e){
      emit(HistoryError("حاول مرة اخرى"));
    }

  }
  void resetFilterHistory(){
    try{
      historyDataFilter = [];
      historyFilter = "";

      emit(ResetFilterHistorySucceed());
    }catch(e){

    }
  }
  void deleteHistory()async{
    try{
      if(companyInfo.isNotEmpty){

        companyInfo["history"] = [];
        historyData = [];

        await FirebaseFirestore.instance
            .collection("companies")
            .doc(companyInfo["companyId"])
            .update({
          'history': []}).then((value){
          emit(DeleteHistorySucceed());
        });
      }
    }on FirebaseException catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }
  void refreshHistory()async{
    try{
        historyFilter = "";
        historyDataFilter = [];
        String? companyId = CacheHelper.getString('userId');
        var snapshot = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();

        if (snapshot.exists) {
          companyInfo = snapshot.data() as Map<String,dynamic>;
          orderListForHomeScreen = companyInfo["history"].length <= 5 ?  companyInfo["history"]:
          companyInfo["history"].sublist(companyInfo["history"].length - 5);
          historyData = companyInfo["history"];
          CacheHelper.set('companyId', companyInfo['companyId'].toString());

        } else {
          emit(HistoryError("هنالك مشكلة في عملية طلب البيانات"));

        }
          emit(RefreshHistorySucceed());

    }on FirebaseException catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }
  void deletePendingRequest({@required orderNumber}) async{

    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");

      await fasterAppRef.child("companies/${CacheHelper.getString("userId")}/pendingRequests/${orderNumber}").remove();
      emit(DeletePendingRequestsSucceed());


    }on FirebaseException catch(e) {
      emit(HistoryError("حدثت مشكلة ما حاول مرة اخرى"));
    }catch(e) {
      emit(HistoryError("حدثت مشكلة ما حاول مرة اخرى"));
    }

  }

//settings screen
  void deleteAllNotifications()async{
    try{
      if(companyInfo.isNotEmpty){
        companyInfo["notifications"] = [];
        await FirebaseFirestore.instance
            .collection("companies")
            .doc(companyInfo["companyId"])
            .update({
          'notifications': []}).then((value){
          emit(DeleteAllNotificationsSuccess());
        });
      }
    }on FirebaseException catch(e){
      emit(DeleteAllNotificationsError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(DeleteAllNotificationsError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void updateProfilePic({@required profileImg})async {
    try{
      emit(UpdateProfilePictureProcess());

      await uploadImage(profileImg).then((value) async{

        if(value.isEmpty){
          emit(UpdateProfilePictureError("هنالك مشكلة حاول مرة اخرى بوقت لاحق"));
          return null;
        }

        await FirebaseFirestore.instance
            .collection("companies")
            .doc(CacheHelper.getString("userId"))
            .update({
          'profilePic': value}).then((value){
            getUserInformation();
          emit(UpdateProfilePictureSuccess());
        });

      });

    }on FirebaseException catch(e){
      emit(UpdateProfilePictureError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(UpdateProfilePictureError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void updateTimeWork({@required workTime})async {
    try{
      emit(UpdateTimeWorkProcess());


        await FirebaseFirestore.instance
            .collection("companies")
            .doc(CacheHelper.getString("userId"))
            .update({
          'workTime': workTime}).then((value){
          emit(UpdateTimeWorkSuccess());
        });


    }on FirebaseException catch(e){
      emit(UpdateTimeWorkError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(UpdateTimeWorkError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void updateCarouselImages({
    @required firstImage,
    @required secondImage,
    @required thirdImage,
  })async {
    try{
      emit(UpdateCarouselImagesProcess());

      bool updateImages = false;

      //first image
      if(firstImage.path.isNotEmpty) {
        await uploadImage(firstImage).then((value)=> companyInfo["carouselImages"] = {...companyInfo["carouselImages"],"firstImage":value});
         updateImages = true;
      }

      //first image
      if(secondImage.path.isNotEmpty) {
        await uploadImage(secondImage).then((value)=> companyInfo["carouselImages"] = {...companyInfo["carouselImages"],"secondImage":value});
        updateImages = true;

      }

      //first image
      if(thirdImage.path.isNotEmpty) {
        await uploadImage(thirdImage).then((value)=> companyInfo["carouselImages"] = {...companyInfo["carouselImages"],"thirdImage":value});
        updateImages = true;

      }



   if(updateImages) {


     await FirebaseFirestore.instance
         .collection("companies")
         .doc(CacheHelper.getString("userId"))
         .update(
         {
           'carouselImages':companyInfo["carouselImages"]
         }
     ).then((value){
       emit(UpdateCarouselImagesSuccess());


     });

   }else {
     emit(UpdateCarouselImagesSuccess());
   }

    }on FirebaseException catch(e){
      emit(UpdateCarouselImagesError("هنالك مشكلة بالأتصال بلانترنت"));
      print(e.toString());

    }catch(e){
      emit(UpdateCarouselImagesError("هنالك مشكلة بالأتصال بلانترنت"));
      print(e.toString());

    }
  }


  void updateCompanyInformation({@required companyName,@required companyAddress,@required companyDesc})async {
    try{
      emit(UpdateCompanyInformationProcess());
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(companyInfo["companyId"])
          .update({
        'companyName': companyName,
        "address": companyAddress,
        "description": companyDesc
      }).then((value){
        getUserInformation().then((value){
          emit(UpdateCompanyInformationSuccess());
        });
      });
    }on FirebaseException catch(e){
      emit(UpdateCompanyInformationError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(UpdateCompanyInformationError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void signOut()async{
    try{
      CacheHelper.removeValue("userId");
      CacheHelper.removeValue("userType");

      emit(CompanySignOutSuccess());

    }catch(e){
      emit(CompanySignOutError("حاول مرة اخرى"));
    }
  }

//


}