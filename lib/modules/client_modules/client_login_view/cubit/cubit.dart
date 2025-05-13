
import 'package:firstproject001/models/client_model.dart';
import 'package:firstproject001/modules/client_modules/client_login_view/cubit/states.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientLoginCubit extends Cubit<ClientLoginStates> {

  ClientLoginCubit() : super(ClientLoginStatesInitial());

  static ClientLoginCubit get(context) => BlocProvider.of(context);

  //variables
  var _verificationId;
  var _userPhoneId;
  Map<String,dynamic> userInfo = {};

  //methods

  void loginWithPhoneNumber({
   required phoneNumberWithDialCode,
    phoneNumber
  }) async {

  emit(ClientLoginStateVerificationPhoneNumberProcess());

    try {
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumberWithDialCode,
              verificationCompleted: (PhoneAuthCredential) async {
                await FirebaseAuth.instance.signInWithCredential(
                    PhoneAuthCredential);
              },
              verificationFailed: (error) {
                emit(ClientLoginStateVerificationPhoneNumberError('هنالك مشكلة ما حاول مرة اخرى في وقت لاحق'));
              },
              codeSent: (verificationId, forceResendToken) {
                _verificationId = verificationId;
                emit(ClientLoginStateVerificationCodeSendCompleted());
              },
              codeAutoRetrievalTimeout: (phoneNumberId) {}
          );

    } on FirebaseException catch (e) {
      emit(ClientLoginStateVerificationPhoneNumberError('هنالك مشكلة ما حاول مرة اخرى في وقت لاحق'));

    } catch(e) {
      emit(ClientLoginStateVerificationPhoneNumberError('يوجد لديك مشكلة بلأتصال بلانترنت'));

    }
  }


  void verifyVerificationCode(String verificationCode) async {
    // emit(RegisterLoadingState());

    emit(ClientLoginStateVerificationCodeProcess());

    try {

      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: verificationCode
      );

      var user = (await FirebaseAuth.instance.signInWithCredential(credential))
          .user;


      if (user != null) {

        _userPhoneId = user.uid;

       checkIfUserExist(docName: _userPhoneId, collectionName: "clients").then((exist)async{

         if(!exist) {

           ClientModel clientModel = ClientModel(
             clientId: user.uid, // user id
             clientPhoneNumber: user.phoneNumber,// user phone number,
             createdAt:DateTime.now().toString(), // get current time
           );

           await FirebaseFirestore.
           instance.
           collection('clients').
           doc(user.uid).
           set(clientModel.toMap()).catchError((error) => emit(ClientLoginStateVerificationCodeError(error.toString('هنالك مشكلة في أنشاء الحساب حاول مرة اخرى في وقت لاحق'))));
           CacheHelper.set("userId", user.uid);
           CacheHelper.set("userType", "client");


           emit(ClientLoginStateVerificationCodeCompleted());


         }else {

           if(userInfo["userAuth"] == "active"){
             CacheHelper.set("userId", user.uid);
             CacheHelper.set("userType", "client");
             emit(ClientLoginStateVerificationCodeCompleted());
           }else if(userInfo["userAuth"] == "disabled"){
             emit(ClientLoginStateVerificationCodeError('تم حظر حسابك'));
           }else if (userInfo["userAuth"]== "admin"){
             emit(ClientLoginStateVerificationCodeToAdminCompleted());
             CacheHelper.set("userId", user.uid);
             CacheHelper.set("userType", "admin");
           }


         }

       });



      }else {
        emit(ClientLoginStateVerificationCodeError('هنالك مشكلة ما حاول مرة'));
      }

    }on FirebaseException catch (e) {
      emit(ClientLoginStateVerificationCodeError('يوجد لديك مشكلة بلأتصال بلانترنت'));
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
       userInfo = snapshot.data() as Map<String,dynamic>;
      return true;
    } else {
      return false;
    }
  }




}











