
import 'dart:async';

import 'package:firstproject001/layout/admin_main_layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../shared/component/shared_preferences.dart';

class AdminLayoutCubit extends Cubit<AdminLayoutStates> {

  AdminLayoutCubit() : super(AdminLayoutStatesInitial());

  static AdminLayoutCubit get(context) => BlocProvider.of(context);

  List<dynamic> clientsList = [];
  List<dynamic>  companysList = [];
  List<dynamic>  companysPendingList = [];
  List<dynamic>  driversList = [];

  Future<void> durationMethod()async{
    emit(AdminDurationMethodProcess());
    await Future.delayed(const Duration(seconds: 3));
    emit(AdminDurationMethodFinish());

  }

  Future<void> getDataFromFirebase() async{
    emit(GetDataFromFirebaseProcess());
    try{
      // companies data
      CollectionReference companysRef = FirebaseFirestore.instance.collection("companies");

      QuerySnapshot companysSnapshot = await companysRef.get();

      for (var doc in companysSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data.isNotEmpty){
          if(data["userAuth"] == "restricted"){
            companysPendingList.add(data);
          }else {
            companysList.add(data);
          }

        }
      }

      // clients data
      CollectionReference clientsRef = FirebaseFirestore.instance.collection("clients");

      QuerySnapshot clientsSnapshot = await clientsRef.get();

      for (var doc in clientsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data.isNotEmpty){
          clientsList.add(data);
        }
      }

      // drivers data
      CollectionReference driversRef = FirebaseFirestore.instance.collection("drivers");

      QuerySnapshot driversSnapshot = await driversRef.get();

      for (var doc in driversSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data.isNotEmpty){
          driversList.add(data);
        }
      }

      emit(GetDataFromFirebaseSuccess());
    } on FirebaseException catch (e) {
      print(e.toString());
      emit(GetDataFromFirebaseError("هنالك مشكلة ما بلأتصال"));
    }catch(e){
      ///
      print(e.toString());
      emit(GetDataFromFirebaseError("هنالك مشكلة ما بلأتصال"));

    }
  }

  void updateAccountAuth(collectionName,userId,state) async{
    try{
      emit(UpdateAccountAuthProcess());
      await FirebaseFirestore.instance.collection(collectionName).doc(userId).update({'userAuth': state,}).catchError((error)=>emit(UpdateAccountAuthError("حاول مرة اخرى")));


      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collectionRef.get();

      //clear list
      if(collectionName == "companies"){
          companysPendingList = [];
          companysList = [];
      }else if(collectionName == "clients") {
        clientsList = [];
      }else {
        driversList = [];
      }


      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data.isNotEmpty){

          if(collectionName == "companies"){

            if(data["userAuth"] == "restricted"){
              companysPendingList.add(data);
            }else {
              companysList.add(data);
            }

          }else if(collectionName == "clients") {
            clientsList.add(data);
          }else {
            driversList.add(data);
          }

        }
      }

      emit(UpdateAccountAuthSuccess());

    } on FirebaseException catch (e) {
      print(e.toString());
      emit(UpdateAccountAuthError("هنالك مشكلة ما بلأتصال"));
    }catch(e){
      ///
      print(e.toString());
      emit(UpdateAccountAuthError("هنالك مشكلة ما بلأتصال"));

    }
  }

  void deleteAccount(collectionName,userId) async{
    try{
      emit(DeleteAccountProcess());
      await FirebaseFirestore.instance.collection(collectionName).doc(userId).delete().catchError((error)=>emit(DeleteAccountError("حاول مرة اخرى")));


      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collectionRef.get();

      //clear list
      if(collectionName == "companies"){
          companysPendingList = [];
          companysList = [];
      }else if(collectionName == "clients") {
        clientsList = [];
      }else {
        driversList = [];
      }


      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data.isNotEmpty){

          if(collectionName == "companies"){

            if(data["userAuth"] == "restricted"){
              companysPendingList.add(data);
            }else {
              companysList.add(data);
            }

          }else if(collectionName == "clients") {
            clientsList.add(data);
          }else {
            driversList.add(data);
          }

        }
      }

      emit(DeleteAccountSuccess());

    } on FirebaseException catch (e) {
      print(e.toString());
      emit(DeleteAccountError("هنالك مشكلة ما بلأتصال"));
    }catch(e){
      ///
      print(e.toString());
      emit(DeleteAccountError("هنالك مشكلة ما بلأتصال"));

    }
  }

  void signOut()async{
    try{
      CacheHelper.removeValue("userId");
      CacheHelper.removeValue("userType");
      emit(AdminSignOutSuccess());

    }catch(e){
      emit(AdminSignOutError());
    }
  }

}