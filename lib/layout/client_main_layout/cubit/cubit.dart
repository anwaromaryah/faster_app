
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:firstproject001/models/company_model.dart';
import 'package:firstproject001/modules/client_modules/client_history/presentation/client_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firstproject001/layout/client_main_layout/cubit/states.dart';

import '../../../modules/client_modules/client_home_view/presentation/client_home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../../modules/client_modules/client_settings_view/presentation/client_settings_view.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../shared/component/cloudinary_upload_image.dart';
import '../../../shared/component/getLocationPermission.dart';
import '../../../shared/component/shared_preferences.dart';
import 'package:intl/intl.dart';

class ClientLayoutCubit extends Cubit<ClientLayoutStates> {

  ClientLayoutCubit() : super(ClientLayoutStatesInitial());

  static ClientLayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> clientLayoutScreens= [
    const ClientHomeView(),
    const ClientHistoryView(),
    const ClientSettingsView(),
  ];

  int bottomNavigationBarIndex = 0;
  List<Map<dynamic, dynamic>> companiesData = [];
  List<Map<dynamic, dynamic>> favoriteCompaniesData = [];
  List<Map> drivers = [];
  List<dynamic> acceptedRequests = [];
  Map<String,dynamic> clientInfo = {};
  Map<dynamic,dynamic> orderInfoForCancelButton = {};
  List<dynamic> historyData = [];
  List<dynamic> historyDataFilter = [];
  String historyFilter = "";
  bool generalOrderAcceptOrRejectByDriver = false;

  LatLng userLocation = LatLng(0, 0);



  void changeBottomNavigationBarIndex(int index) {
    bottomNavigationBarIndex = index;
    emit(ChangeBottomNavigationBarIndex());
  }

  Future<void> durationMethod()async{
    emit(ClientDurationMethodProcess());
    await Future.delayed(const Duration(seconds: 5));
    emit(ClientDurationMethodFinish());

  }

  Future<void> durationMethodModules()async{
    emit(ClientDurationMethodModulesProcess());
    if(companiesData.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }else {
      await Future.delayed(const Duration(seconds: 5));
    }

    emit(ClientDurationMethodModulesFinish());

  }

  void setUserLocation() {
    try {
      getLocation().then((location){
        bool permissionDenied = location == null ? true : false;
        if(permissionDenied) return;
        userLocation = LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
        // emit(SetUserLocationSucceed());
      });
    }catch(e){
      emit(SetUserLocationError("حدثت مشكلة اثناء الحصول على احداثيات موقع المستخدم"));
    }
  }


  Future<void> getUserInformation()async {
    try{
      emit(GetClientInformationProcess());
      String? userId = CacheHelper.getString('userId');
      var snapshot = await FirebaseFirestore.instance.collection("clients").doc(userId).get();
      if (snapshot.exists) {
        clientInfo = snapshot.data() as Map<String,dynamic>;
        historyData = clientInfo["history"];
        // emit(GetClientInformationSuccess());
      } else {
        emit(GetClientInformationError("هنالك مشكلة في عملية طلب البيانات"));
      }
    }on FirebaseException catch (e){
      emit(GetClientInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }catch(e){
      emit(GetClientInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }
  }

 // home screen
  void fetchAllCompanies()async{
    if(companiesData.isNotEmpty) {
      emit(CompaniesDataExist());
    }else {
      emit(FetchAllCompaniesDataProcess());
      await Future.delayed(Duration(milliseconds: 2000));
      try {

        QuerySnapshot<Map<String, dynamic>> querySnapshot = await  FirebaseFirestore.instance.collection('companies').get();

        final companies = querySnapshot.docs.map((doc) => doc.data() as Map).toList();

        if(companies.isNotEmpty){

          companiesData = companies.where(
                  (companyInfo) => !clientInfo["favoriteCompanies"].contains("${companyInfo["companyId"]}")
          ).toList();

          favoriteCompaniesData = companies.where(
              (companyInfo) => clientInfo["favoriteCompanies"].contains("${companyInfo["companyId"]}")
          ).toList();

          // emit(FetchAllCompaniesDataSucceed());
        }else {
          emit(FetchAllCompaniesDataError("هنالك مشكلة في الاتصال بقاعدة البيانات"));
        }

      } on FirebaseException catch(e) {
        emit(FetchAllCompaniesDataError("هنالك مشكلة في الاتصال بقاعدة البيانات"));
      }catch(e){
        emit(FetchAllCompaniesDataError("حدث خطأ ما حاول مرة اخرى في مرة اخرى"));

      }

    }


  }
  void setFavoriteCompany({@required companyId})async{

    bool isItemExist = clientInfo["favoriteCompanies"].contains(companyId);
try{

  if(isItemExist){
    clientInfo["favoriteCompanies"].remove(companyId);
    Map companyInfo = favoriteCompaniesData.firstWhere((item) => item["companyId"] == companyId);


    companiesData.add(companyInfo);
    favoriteCompaniesData.remove(companyInfo);



    await FirebaseFirestore.
    instance.
    collection("clients").
    doc(CacheHelper.getString("userId")).
    update({
      'favoriteCompanies': FieldValue.arrayRemove([companyId]),
    }).then((value){
      emit(RemoverFavoriteCompanySuccess());

    });

  }else {
    clientInfo["favoriteCompanies"].add(companyId);

    Map companyInfo = companiesData.firstWhere((item) => item["companyId"] == companyId);


    companiesData.remove(companyInfo);
    favoriteCompaniesData.add(companyInfo);

    companiesData.map((item){
      if(item["companyId"] == companyId){
        favoriteCompaniesData.add(item);
        companiesData.remove(item);
      }
    });

    await FirebaseFirestore.
    instance.
    collection("clients").
    doc(CacheHelper.getString("userId")).
    update({
      'favoriteCompanies': FieldValue.arrayUnion([companyId]),
    }).then((value){
      emit(SetFavoriteCompanySuccess());
    });
  }

}on FirebaseException catch(e){
  emit(FavoriteCompanyError("حدثت مشكلة في عملية اضافة الشركة للمفضلة"));
  print(e.toString());
}catch(e){
  emit(FavoriteCompanyError("حدثت مشكلة في عملية اضافة الشركة للمفضلة"));
  print(e.toString());
}

  }


  Future<void> sendSpecificRequest({
    @required companyInfo,
    @required recipientInfo,
    @required userInfo
}) async {


    try{
      userInfo["profilePic"] = clientInfo["profilePic"];

      final random = Random();
      int randomNumber = random.nextInt(90000) + 10000;
      String currentTime = DateTime.now().toString().split(' ')[0]; // "2024-12-01 04:57:58.418773" after split() => "2024-12-01"
      String  randomNumberWithDate = currentTime.replaceAll("-", "") + randomNumber.toString();

      DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");

      await fasterAppRef.child("companies/${companyInfo['companyId']}/pendingRequests/${randomNumberWithDate}/").update(
          {
            "clientId":CacheHelper.getString("userId"),
            "companyInfo":{
              "address":companyInfo["address"],
              "companyId":companyInfo["companyId"],
              "companyName":companyInfo["companyName"],
              "companyPhoneNumber":companyInfo["companyPhoneNumber"],
              "email":companyInfo["email"],
            },
            "clientInfo":userInfo,
            "recipientInfo":recipientInfo,
            "orderInfo":{
              "orderNumber": randomNumberWithDate,
              "time":DateTime.now().toString().split(' ')[0],
            }
          }

      ).then((value){
        emit(SendSpecificRequestToRealTimeDatabaseSucceed());
      }).catchError((e){
        emit(SendSpecificRequestToRealTimeDatabaseError("هنالك مشكلة بلأتصال حاول مرة اخرى في وقت لاحق"));
      });

    } on FirebaseException catch (e) {
      emit(SendSpecificRequestToRealTimeDatabaseError("هنالك مشكلة بلأتصال حاول مرة اخرى في وقت لاحق"));
    }catch(e){
      emit(SendSpecificRequestToRealTimeDatabaseError("هنالك مشكلة بلأتصال حاول مرة اخرى في وقت لاحق"));

    }

  }
  Future<void> getAllDrivers({@required companyId}) async{
    drivers = [];
    emit(GetAllDriversProcess());
    try{
      DocumentSnapshot companySnapshot = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();

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
      emit(GetAllDriversSuccess());
    } on FirebaseException catch (e) {
      print(e.toString());
      //
    }catch(e){
      ///
      print(e.toString());
      ///
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
      if(clientInfo.isNotEmpty){

        clientInfo["history"] = [];
        historyData = [];

        await FirebaseFirestore.instance
            .collection("clients")
            .doc(clientInfo["clientId"])
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
     getUserInformation();
     emit(RefreshHistorySucceed());
    }on FirebaseException catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  //



  //settings screen
  void deleteAllNotifications()async{
    try{
      if(clientInfo.isNotEmpty){
        clientInfo["notifications"] = [];
        await FirebaseFirestore.instance
            .collection("clients")
            .doc(clientInfo["clientId"])
            .update({
          'notifications': []}).then((value){
          emit(DeleteAllNotificationsSuccess());
        });
      }
    }on FirebaseException catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));

    }
  }

  void updateProfilePic({@required profileImg})async {
    try{

      emit(UpdateProfilePictureProcess());

    await uploadImage(profileImg).then((value) async{


      if(value.isEmpty){
        emit(SettingsScreenError("هنالك مشكلة حاول مرة اخرى بوقت لاحق"));
        print("error");
        return null;
      }

      await FirebaseFirestore.instance
          .collection("clients")
          .doc(CacheHelper.getString("userId"))
          .update({
        'profilePic': value}).then((value){
        getUserInformation();
        emit(UpdateProfilePictureSuccess());
      });

    });


    }on FirebaseException catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));
      print(e.toString());
    }catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));
      print(e.toString());

    }
  }

  void updateClientInformation({@required clientName,@required clientAddress})async {
    try{
      emit(UpdateClientInformationProcess());
      await FirebaseFirestore.instance
          .collection("clients")
          .doc(clientInfo["clientId"])
          .update({
        'clientName': clientName,
        "clientAddress": clientAddress,
      }).then((value){
        getUserInformation().then((value){
          emit(UpdateClientInformationSuccess());
        });
      });
    }on FirebaseException catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(SettingsScreenError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void signOut()async{
    try{
      CacheHelper.removeValue("userId");
      CacheHelper.removeValue("userType");

      emit(ClientSignOutSuccess());

    }catch(e){
      emit(SettingsScreenError("حاول مرة اخرى"));
    }
  }

//

// general request
void navigateToMapView() async{
  emit(ClientNavigateToMapProcess());
  await Future.delayed(const Duration(seconds: 1));
  emit(ClientNavigateToMapFinish());
}

void findTheNearestDriver(
    {
    @required orderInfo
    }) async{
  DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");


    try{
      print("test1");
      emit(SearchOnDeliveryDriverProcess());


      DataSnapshot dataSnapshot =  await fasterAppRef.child("general/${orderInfo["cityName"]}/drivers").get();
      print("test2");

      if (dataSnapshot.exists) {
        Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
        List<dynamic> mapList  = data.values.toList();

          print("test3");
          if(mapList.isEmpty) {
            emit(SearchOnDeliveryDriverError("لا يوجد سائقين متاحين بالمدينة الخاصة بك في الوقت الحالي"));
            return;
          };
          print("test4");


          for(int i = mapList.length ; i > 0 ; i--){
            await findNearestDriverGeolocator(userLocation.latitude,userLocation.longitude,mapList).then(
                    (driver)async{
                     await sendOfferToDriver(driver: driver,orderInfo: orderInfo);
                }
            );

            if(generalOrderAcceptOrRejectByDriver){
              emit(SearchOnDeliveryDriverSuccess());
              return;
            }

          }
        emit(SearchOnDeliveryDriverError("لم يوافق اي سائق على طلبك"));


          // no driver accept the request
          print("test5");
          if(mapList.isEmpty){
            emit(SearchOnDeliveryDriverError("لا يوجد سائق وافق على طلبك"));
          }


        } else {
        emit(SearchOnDeliveryDriverError("لا يوجد سائقين متاحين بالمدينة الخاصة بك في الوقت الحالي"));
      }


    }on FirebaseException catch(e){
      emit(SearchOnDeliveryDriverError("هنالك مشكلة ما بلأتصال"));
      print(e.toString());
    }catch(e){
      emit(SearchOnDeliveryDriverError("هنالك مشكلة ما بلأتصال"));
      print(e.toString());
    }
}

  Future<void> sendOfferToDriver({@required driver,@required orderInfo})async {
  DataSnapshot orderInfoFromSearch;

  DatabaseReference acceptedRequestsRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/acceptRequests");
  DatabaseReference rejectedRequestsRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/rejectedRequests");
  late StreamSubscription acceptedListener;
  late StreamSubscription rejectedListener;

  Timer? timer;
  final random = Random();
  int randomNumber = random.nextInt(90000) + 10000;
  String currentTime = DateTime.now().toString().split(' ')[0]; // "2024-12-01 04:57:58.418773" after split() => "2024-12-01"
  String  randomNumberWithDate = currentTime.replaceAll("-", "") + randomNumber.toString();
  final completer = Completer<bool?>();
  try {
      DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");

      print("test4-2");

      await fasterAppRef.child("drivers/${driver["driverInfo"]["driverId"]}/general/pendingRequests/${randomNumberWithDate}").update(
          {
            "orderType":"general",
            'clientId':clientInfo["clientId"],
            "driverInfo":{
              ...driver["driverInfo"],
              "driverPhoneNumber":driver["driverInfo"]["driverPhoneNumber"].substring(3),
            },
            "clientInfo":{
              'clientId':clientInfo["clientId"],
              "clientName":clientInfo["clientName"],
              "profilePic":clientInfo["profilePic"],
              "clientPhoneNumber": clientInfo["clientPhoneNumber"].substring(3),
              "latitudeForClient":orderInfo["latitudeForClient"],
              "longitudeForClient":orderInfo["longitudeForRecipient"],
              "nameAddress": "غير محدد"
            },
            "orderInfo":{
              "orderNumber":randomNumberWithDate,
              "time":DateTime.now().toString().split(" ")[0],
              "urgent":orderInfo["isUrgentOrder"],
              'payMethod': orderInfo["payMethod"]
            },
            "recipientInfo": {
              "recipientName": orderInfo["recipientName"],
              "recipientPhoneNumber": orderInfo["recipientPhoneNumber"],
              "nameAddress": orderInfo["orderAreaLocationName"],
              "latitudeForRecipient": orderInfo["latitudeForRecipient"],
              "longitudeForRecipient": orderInfo["longitudeForRecipient"],
            }
          }
      );
      orderInfoForCancelButton = {
        "orderNumber":randomNumberWithDate,
        'driverId':driver["driverInfo"]["driverId"],
      };


      acceptedListener = acceptedRequestsRef.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.exists && snapshot.value != null ) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

          if(data.isNotEmpty) {
            generalOrderAcceptOrRejectByDriver = true;
            completer.complete(true);
            acceptedListener.cancel();
            rejectedListener.cancel();
            return;
          }

        }
      });

      rejectedListener = rejectedRequestsRef.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.exists && snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          if(data.isNotEmpty) {
            generalOrderAcceptOrRejectByDriver = false;
            completer.complete(false); // Complete with false
            acceptedListener.cancel();
            rejectedListener.cancel();
            print("rejected");
            return;
          }
        }
      });

      await Future.any<dynamic>([
        completer.future,
        Future.delayed(const Duration(seconds: 15)),
      ]);

      if (!completer.isCompleted) {
        await fasterAppRef.child("drivers/${driver["driverInfo"]["driverId"]}/general/pendingRequests/${randomNumberWithDate}").remove();
        generalOrderAcceptOrRejectByDriver = false;
        completer.complete(null);
        print("Time out");
      }

      acceptedListener.cancel();
      rejectedListener.cancel();
      return;

        // await Future.delayed(const Duration(seconds: 15));

        await fasterAppRef.child("drivers/${driver["driverInfo"]["driverId"]}/general/pendingRequests/${randomNumberWithDate}").remove();
         return ;

    }on FirebaseException catch(e) {


    }catch(e) {


    }


}

void cancelSearchForDriver() async{
    try {
      DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");
      await fasterAppRef.child("drivers/${orderInfoForCancelButton["driverId"]}/general/pendingRequests/${orderInfoForCancelButton["orderNumber"]}").remove();

    }on FirebaseException catch(e){

    }catch(e){

    }

}

  Future<dynamic> findNearestDriverGeolocator(
      double customerLat, double customerLon, dynamic drivers) async {
    Map nearestDriver = {};
    double shortestDistance = double.infinity;

    for (var driver in drivers) {
     String driverLat = driver["driverInfo"]["driverLatitude"].toString();
     String driverLong = driver["driverInfo"]["driverLongitude"].toString();

        double distance = Geolocator.distanceBetween(
          customerLat,
          customerLon,
          double.parse(driverLat),
          double.parse(driverLong),
        );

        if (distance < shortestDistance) {
          shortestDistance = distance;
          nearestDriver = driver;
        }


    }
   return nearestDriver;
  }


}