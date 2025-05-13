

import 'package:firstproject001/layout/delivery_main_layout/cubit/states.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_home_view/presentation/delivery_home_view.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_requests_view/presentaion/delivery_requests_view.dart';
import 'package:firstproject001/modules/delivery_modules/delivery_settings_view/presentation/delivery_settings_view.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latlong2/latlong.dart';

import '../../../shared/component/cloudinary_upload_image.dart';
import '../../../shared/component/getCityNameByCoordinates.dart';
import '../../../shared/component/getLocationPermission.dart';
import 'package:intl/intl.dart';

class DeliveryLayoutCubit extends Cubit<DeliveryLayoutStates> {

  DeliveryLayoutCubit() : super(DeliveryLayoutStatesInitial());

  static DeliveryLayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> deliveryLayoutScreens= [
    DeliveryHomeView(),
    DeliveryRequestsView(),
    DeliverySettingsView(),
  ];

  int bottomNavigationBarIndex = 0;
  var pendingRequests = [];
  Map<dynamic, dynamic> acceptRequest = {};
  LatLng currentUserLocation = LatLng(0, 0);
  Map<String,dynamic> driverInfo = {};
  Map<dynamic,dynamic> orderInformation = {};

  List<dynamic> historyData = [];
  List<dynamic> historyDataFilter = [];
  String historyFilter = "";
  List<dynamic> historyListForHomeScreen = [];

  LatLng userLocation = LatLng(0, 0);

  //general request

  //delivery_layout change bottom navigation bar
  void changeBottomNavigationBarIndex(int index) {
    bottomNavigationBarIndex = index;
    emit(ChangeBottomNavigationBarIndex());
  }

  // get location and cityName
  void setUserLocation() {
    try {
      getLocation().then((location){
        bool permissionDenied = location == null ? true : false;
        if(permissionDenied) return;
        userLocation = LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
       Map userCityMap = getCityNameByCoordinates(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
       String userCityName = userCityMap["cityName"];
        CacheHelper.set("userCity", userCityName);
        // emit(SetUserLocationSucceed());
      });


    }catch(e){
      emit(SetUserLocationError("حدثت مشكلة اثناء الحصول على احداثيات موقع المستخدم"));
    }
  }

// get user info from firestore by userId
 Future<void> getUserInformation()async {
    try{
      emit(GetDriverInformationProcess());
      String? driverId = CacheHelper.getString('userId');
      var snapshot = await FirebaseFirestore.instance.collection("drivers").doc(driverId).get();

      if (snapshot.exists) {
        driverInfo = snapshot.data() as Map<String,dynamic>;
        historyListForHomeScreen = driverInfo["history"].length <= 5 ?  driverInfo["history"]:
        driverInfo["history"].sublist(driverInfo["history"].length - 5);
        historyData = driverInfo["history"];
        CacheHelper.set("companyId", driverInfo["companyId"].toString());

        //emit(GetDriverInformationSuccess());

      } else {
        emit(GetDriverInformationError("هنالك مشكلة في عملية طلب البيانات"));
      }
    }on FirebaseException catch (e){
      emit(GetDriverInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }catch(e){
      emit(GetDriverInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }
 }

 Future<void> getUserInformationForUpdate()async {
    try{
      String? driverId = CacheHelper.getString('userId');
      var snapshot = await FirebaseFirestore.instance.collection("drivers").doc(driverId).get();

      if (snapshot.exists) {
        driverInfo = snapshot.data() as Map<String,dynamic>;
        historyListForHomeScreen = driverInfo["history"].length <= 5 ?  driverInfo["history"]:
        driverInfo["history"].sublist(driverInfo["history"].length - 5);
        historyData = driverInfo["history"];
        CacheHelper.set("companyId", driverInfo["companyId"].toString());

        //emit(GetDriverInformationSuccess());

      } else {
        emit(GetDriverInformationError("هنالك مشكلة في عملية طلب البيانات"));
      }
    }on FirebaseException catch (e){
      emit(GetDriverInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }catch(e){
      emit(GetDriverInformationError("هنالك مشكلة بلأتصال بالشبكة"));

    }
 }
// set current location to realTime database for track driver

  void setCurrentLocation(currentLocation) async{
    currentUserLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    DatabaseReference fasterAppRef = await FirebaseDatabase.instance.ref("fasterApps");

    await fasterAppRef.child("users/${acceptRequest["clientId"]}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}/driverInfo").
    update({
      "driverLatitude" : currentLocation.latitude,
      "driverLongitude" : currentLocation.longitude,
    });
    emit(SetCurrentLocation());

  }

  // duration
  Future<void> durationMethod()async{
    emit(DeliveryDurationMethodProcess());
    await Future.delayed(const Duration(seconds: 5));
    emit(DeliveryDurationMethodFinish());

  }

  Future<void> durationMethodModules()async{
    emit(DeliveryDurationMethodModulesProcess());
      await Future.delayed(const Duration(seconds: 1));
    emit(DeliveryDurationMethodModulesFinish());

  }


// requests screen

// company request
  Future<void> acceptCompanyRequest({
    @required orderInfo,
  }) async {
 emit(AcceptRequestProcess());

    try{
      orderInformation = {
        ...orderInfo,
        "driverInfo":{
          "driverId" : CacheHelper.getString("userId"),
          "driverName": driverInfo["driverName"],
          "driverPhoneNumber": driverInfo["driverPhoneNumber"].substring(3).toString(),
          "profilePic": driverInfo["profilePic"],
          "driverLatitude" : 0,
          "driverLongitude" : 0,
        },
      };
      DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");
      CacheHelper.set("acceptRequest", orderInfo["orderInfo"]["orderNumber"].toString());
      await fasterAppRef.child("companies/${orderInfo["companyInfo"]['companyId']}/acceptRequests/${orderInfo["orderInfo"]["orderNumber"]}/").
      update({...orderInformation}).then((value)async{
        await fasterAppRef.child("companies/${orderInfo["companyInfo"]['companyId']}/pendingRequests/${orderInfo["orderInfo"]["orderNumber"]}/").remove();
        await fasterAppRef.child("users/${orderInfo["clientId"]}/acceptRequests/${orderInfo["orderInfo"]["orderNumber"]}").
        update({...orderInformation}).then((value){
         // for delivery layout
          acceptRequest = orderInformation;

          emit(AcceptRequestCompleted());

        });




      }).
      catchError((error){
        emit(AcceptRequestError("حدثت مشكلة اثناء عملية قبول الطلب"));
        print(error.toString());

      });




    } on FirebaseException catch (e) {
      emit(AcceptRequestError("حدثت مشكلة في عملية الاتصال بقاعدة البيانات"));
      print(e.toString());


    }catch(e){
      emit(AcceptRequestError("حدثت مشكلة في عملية الاتصال بقاعدة البيانات"));
      print(e.toString());

    }


  }
  void theOrderHasBeenDelivered()async{
    try{
      emit(TheOrderHasBeenDeliveredProcess());
      // company
      await FirebaseFirestore.
      instance.
      collection("companies").
      doc(driverInfo["companyId"]).
      update({
        'history': FieldValue.arrayUnion([acceptRequest],),
        'notifications': FieldValue.arrayUnion(["لقد قام السائق ${acceptRequest["driverInfo"]["driverName"]} بأيصال الطلب بنجاح"],),
        'doneOrdersCount': FieldValue.increment(1),

      });

      // client
      await FirebaseFirestore.
      instance.
      collection("clients").
      doc(acceptRequest["clientId"]).
      update({
        'history': FieldValue.arrayUnion([acceptRequest],),
        'notifications': FieldValue.arrayUnion([" لقد تم ايصال طلبك بنجاح ل ${acceptRequest["recipientInfo"]["recipientName"]}"],),
        'completedOrdersCount': FieldValue.increment(1),
      });

      // driver
      await FirebaseFirestore.
      instance.
      collection("drivers").
      doc(acceptRequest["driverInfo"]["driverId"]).
      update({
        'history': FieldValue.arrayUnion([acceptRequest]),
        'completedOrdersCount': FieldValue.increment(1),
      });

     //realTime database
      DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");

      await fasterAppRef.child("users/${acceptRequest["clientId"]}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}").remove();
      await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}").remove();

      if(acceptRequest.containsKey('companyInfo')) {
        await fasterAppRef.child("companies/${acceptRequest["companyInfo"]['companyId']}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}/").remove();
      }


      CacheHelper.removeValue("acceptRequest");
      getUserInformationForUpdate();
      emit(TheOrderHasBeenDeliveredCompleted());
    }on FirebaseException catch(e){
      emit(TheOrderHasBeenDeliveredError("حدثت مشكلة ما في الاتصال"));
      print(e.toString());
    }catch(e){
      print(e.toString());
      emit(TheOrderHasBeenDeliveredError("حدثت مشكلة ما في الاتصال"));

    }
  }
  void getOrderInfoAfterProblemConnection() async {
    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");

      DataSnapshot dataSnapShot = await fasterAppRef.child("companies/${driverInfo["companyId"]}/acceptRequests/${CacheHelper.getString("acceptRequest")}/").get();
      if(dataSnapShot.exists){
        Map<dynamic, dynamic> data = dataSnapShot.value as Map<dynamic, dynamic>;
        acceptRequest = data;
        emit(GetOrderInfoAfterProblemConnectionSuccess());
      }else{
        emit(GetGeneralOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));

      }
    }on FirebaseException catch(e){
      emit(GetOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));
      print(e.toString());
    }catch(e){
      emit(GetOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));
      print(e.toString());

    }



  }



// general request
  void navigateToMapView() async{
    emit(DeliveryNavigateToMapProcess());
    await Future.delayed(const Duration(seconds: 2));
    emit(DeliveryNavigateToMapFinish());
  }

  void setCurrentLocationInWorkMapBefore(currentLocation) async{
    //test 
    DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");

    await fasterAppRef.child("general/${CacheHelper.getString("userCity")}/drivers/${driverInfo["driverId"]}/").
    update({
      "driverInfo":{
        "driverId":"${driverInfo["driverId"]}",
        "driverName":"${driverInfo["driverName"]}",
        "driverPhoneNumber":"${driverInfo["driverPhoneNumber"]}",
        "profilePic": "${driverInfo["profilePic"]}",
        "driverLatitude" : currentLocation.latitude,
        "driverLongitude" : currentLocation.longitude,
      }
    });
    userLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    emit(SetCurrentLocation());
  }

  void setCurrentLocationInWorkMapAfter(currentLocation) async{
    //test
    DatabaseReference fasterAppRef =  FirebaseDatabase.instance.ref("fasterApps");

    await fasterAppRef.child("users/${orderInformation["clientInfo"]["clientId"]}/general/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}").
    update({
      ...orderInformation,
      "driverInfo":{
        ...orderInformation["driverInfo"],
        "driverLatitude" : currentLocation.latitude,
        "driverLongitude" : currentLocation.longitude,
      }
    });
    userLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    emit(SetCurrentLocation());
  }

  void driverAcceptGeneralRequest({@required orderInfo}) async{
    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");

      Map<dynamic,dynamic> companyInfo = {};
      CacheHelper.set('generaRequest', "accepted");

      var snapshot = await FirebaseFirestore.instance.collection("companies").doc(driverInfo["companyId"]).get();

      if (snapshot.exists) {
      companyInfo = snapshot.data() as Map<String,dynamic>;

      orderInformation = {
        ...orderInfo,
        "companyInfo":{
          "address":companyInfo["address"],
          "companyId":companyInfo["companyId"],
          "companyName":companyInfo["companyName"],
          "companyPhoneNumber":companyInfo["companyPhoneNumber"],
          "email":companyInfo["email"]
        }
      };

      await fasterAppRef.child("users/${orderInfo["clientInfo"]["clientId"]}/general/acceptRequests/${orderInfo["orderInfo"]["orderNumber"]}").update(
          {
            ...orderInfo,
            "companyInfo":{
              "address":companyInfo["address"],
              "companyId":companyInfo["companyId"],
              "companyName":companyInfo["companyName"],
              "companyPhoneNumber":companyInfo["companyPhoneNumber"],
              "email":companyInfo["email"]
            }
          }
      );
      await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/general/acceptRequests/${orderInfo["orderInfo"]["orderNumber"]}").update(
          {
            ...orderInfo,
            "companyInfo":{
              "address":companyInfo["address"],
              "companyId":companyInfo["companyId"],
              "companyName":companyInfo["companyName"],
              "companyPhoneNumber":companyInfo["companyPhoneNumber"],
              "email":companyInfo["email"]
            }
          }
      );


      await fasterAppRef.child("companies/${companyInfo["companyId"]}/acceptRequests/${orderInfo["orderInfo"]["orderNumber"]}/").
      update({
        ...orderInformation
      });

      }


      await fasterAppRef.child("drivers/${orderInfo["driverInfo"]["driverId"]}/general/pendingRequests").remove();
      await fasterAppRef.child("general/${CacheHelper.getString("userCity")}/drivers/${driverInfo["driverId"]}/").remove();



      emit(DriverAcceptGeneralRequestSuccess());
    }on FirebaseException catch(e){
      emit(DriverAcceptGeneralRequestError("هنالك مشكلة في عملية الاتصال بالشبكة"));

      print(e.toString());
    }catch(e){
      emit(DriverAcceptGeneralRequestError("هنالك مشكلة في عملية الاتصال بالشبكة"));
      print(e.toString());
    }

  }

  void driverRejectGeneralRequest({@required orderInfo}) async{
    // acceptedRequestsRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/acceptedRequests");
    // rejectedRequestsRef = FirebaseDatabase.instance.ref("fasterApps/users/${CacheHelper.getString("userId")}/general/rejectedRequests");
    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");
      await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/general/pendingRequests/${orderInfo["orderInfo"]["orderNumber"]}").remove();


      await fasterAppRef.child("users/${orderInfo["clientInfo"]["clientId"]}/general/rejectedRequests/${orderInfo["orderInfo"]["orderNumber"]}").update(
          {
            ...orderInfo
          }
      );
      emit(DriverRejectGeneralRequestSuccess());

    }on FirebaseException catch(e){
      emit(DriverRejectGeneralRequestError("هنالك مشكلة في عملية الاتصال بالشبكة"));
      print(e.toString());
    }catch(e){
      emit(DriverRejectGeneralRequestError("هنالك مشكلة في عملية الاتصال بالشبكة"));
      print(e.toString());
    }

  }

  void getGeneralOrderInfoAfterProblemConnection() async {
    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");

      DataSnapshot dataSnapShot = await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/general/acceptRequests/").get();
      if(dataSnapShot.exists){
        Map<dynamic, dynamic> data = dataSnapShot.value as Map<dynamic, dynamic>;
        var orderInfo = data.values.first;
     orderInformation = orderInfo;
     emit(GetGeneralOrderInfoAfterProblemConnectionSuccess());
      }else{
        emit(GetGeneralOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));

      }
    }on FirebaseException catch(e){
      emit(GetGeneralOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));
         print(e.toString());
    }catch(e){
      emit(GetGeneralOrderInfoAfterProblemConnectionError("حصلت مشكلة ما في عملية الاتصال"));
      print(e.toString());

    }



  }

  void driverDeliveredTheGeneralOrder()async{
    try{
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");



      emit(TheOrderHasBeenDeliveredProcess());
      // company
      await FirebaseFirestore.
      instance.
      collection("companies").
      doc(driverInfo["companyId"]).
      update({
        'history': FieldValue.arrayUnion([orderInformation],),
        'notifications': FieldValue.arrayUnion(["لقد قام السائق ${orderInformation["driverInfo"]["driverName"]} بأيصال الطلب بنجاح"],),
        'doneOrdersCount': FieldValue.increment(1),

      });

      // client
      await FirebaseFirestore.
      instance.
      collection("clients").
      doc(orderInformation["clientInfo"]["clientId"]).
      update({
        'history': FieldValue.arrayUnion([orderInformation],),
        'notifications': FieldValue.arrayUnion([" لقد تم ايصال طلبك بنجاح ل ${orderInformation["recipientInfo"]["recipientName"]}"],),
        'completedOrdersCount': FieldValue.increment(1),
      });

      // driver
      await FirebaseFirestore.
      instance.
      collection("drivers").
      doc(orderInformation["driverInfo"]["driverId"]).
      update({
        'history': FieldValue.arrayUnion([orderInformation]),
        'completedOrdersCount': FieldValue.increment(1),
      });

      //realTime database
      await fasterAppRef.child("companies/${orderInformation["companyInfo"]['companyId']}/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}/").remove();

      await fasterAppRef.child("users/${orderInformation["clientInfo"]["clientId"]}/general/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}").remove();

      await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/general/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}").remove();

      CacheHelper.removeValue('generaRequest');
      orderInformation = {};

      getUserInformationForUpdate();

      emit(TheOrderHasBeenDeliveredCompleted());

    }on FirebaseException catch(e){
      print(e.toString());
      emit(TheOrderHasBeenDeliveredError("حدثت مشكلة ما في الاتصال"));

    }catch(e){
      print(e.toString());
      emit(TheOrderHasBeenDeliveredError("حدثت مشكلة ما في الاتصال"));

    }
  }


  void reportAboutDeliveryProcess({@required orderType,@required msg}) async {


    try {
      emit(ReportAboutDeliveryProcess());
      DatabaseReference fasterAppRef = FirebaseDatabase.instance.ref("fasterApps");
      if(orderType == 'general') {

        await fasterAppRef.child("companies/${orderInformation["companyInfo"]['companyId']}/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}/").remove();
        await fasterAppRef.child("users/${orderInformation["clientInfo"]["clientId"]}/general/acceptedRequests/${orderInformation["orderInfo"]["orderNumber"]}").remove();
        await fasterAppRef.child("drivers/${CacheHelper.getString("userId")}/general/acceptRequests/${orderInformation["orderInfo"]["orderNumber"]}").remove();


        await FirebaseFirestore.
        instance.
        collection("companies").
        doc(orderInformation["clientInfo"]["clientId"]).
        update({
          'notifications': FieldValue.arrayUnion([" حدثت مشكلة اثناء عملية توصيل الطرد تواصل مع شركة التوصيل للمزيد من المعلومات ${driverInfo["companyName"]}"],),
        });

        orderInformation = {};
        CacheHelper.removeValue("generaRequest");
      }else {
        await fasterAppRef.child(
            "companies/${acceptRequest["companyInfo"]['companyId']}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}/")
            .remove();
        await fasterAppRef.child(
            "users/${acceptRequest["clientId"]}/acceptRequests/${acceptRequest["orderInfo"]["orderNumber"]}")
            .remove();
        await FirebaseFirestore.
        instance.
        collection("companies").
        doc(acceptRequest["clientInfo"]["clientId"]).
        update({
          'notifications': FieldValue.arrayUnion([
            " حدثت مشكلة اثناء عملية توصيل الطرد تواصل مع شركة التوصيل للمزيد من المعلومات ${driverInfo["companyName"]}"
          ],),
        });

        acceptRequest = {};
        CacheHelper.removeValue("acceptRequest");


      }

      await FirebaseFirestore.
      instance.
      collection("companies").
      doc(driverInfo["companyId"]).
      update({
        'notifications': FieldValue.arrayUnion(["  ${driverInfo["driverName"]}: ${msg}"],),
      });


      emit(ReportAboutDeliveryProcessSuccess());

    }on FirebaseException catch(e){
emit(ReportAboutDeliveryProcessError("حدثت مشكلة في عملية الاتصال"));

    }catch(e){
      emit(ReportAboutDeliveryProcessError("حدثت مشكلة في عملية الاتصال"));

    }


  }


// history screen
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
      if(driverInfo.isNotEmpty){

        driverInfo["history"] = [];
        historyData = [];
        historyListForHomeScreen = [];
        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(driverInfo["driverId"])
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
      await getUserInformation();
      emit(RefreshHistorySucceed());
    }on FirebaseException catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(HistoryError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }


//settings screen
  void deleteAllNotifications()async{
    try{
      if(driverInfo.isNotEmpty){
        driverInfo["notifications"] = [];
        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(driverInfo["driverId"])
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
          print("error");
          return null;
        }

        await FirebaseFirestore.instance
            .collection("drivers")
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

  void updateDriverInformation({@required driverName,@required driverAddress})async {
    try{
      emit(UpdateDriverInformationProcess());
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverInfo["driverId"])
          .update({
        'driverName': driverName,
        "driverAddress": driverAddress,
      }).then((value){
        getUserInformation().then((value){
          emit(UpdateDriverInformationSuccess());
        });
      });
    }on FirebaseException catch(e){
      emit(UpdateDriverInformationError("هنالك مشكلة بالأتصال بلانترنت"));

    }catch(e){
      emit(UpdateDriverInformationError("هنالك مشكلة بالأتصال بلانترنت"));
    }
  }

  void signOut()async{
    try{
      CacheHelper.removeValue("userId");
      CacheHelper.removeValue("userType");
      emit(DriverSignOutSuccess());

    }catch(e){
      emit(DriverSignOutError("حاول مرة اخرى"));
    }
  }

//

void reset() {
  CacheHelper.removeValue('generaRequest');
  CacheHelper.removeValue("acceptRequest");
}

}