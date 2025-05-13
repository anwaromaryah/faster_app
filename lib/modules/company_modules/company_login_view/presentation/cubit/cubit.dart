
import 'package:firstproject001/models/company_model.dart';
import 'package:firstproject001/models/driver_model.dart';
import 'package:firstproject001/modules/company_modules/company_login_view/presentation/cubit/states.dart';
import 'package:firstproject001/shared/component/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class CompanyLoginCubit extends Cubit<CompanyLoginStates> {

  CompanyLoginCubit() : super(CompanyLoginStateInitial());

  static CompanyLoginCubit get(context) => BlocProvider.of(context);

  //variables
  var _verificationId;
  var _driverPhoneId;
  Map<String,dynamic>? _getUserDataFromCheckFunc;
  Map<String,dynamic> _companyUser = {};
  Map<String,dynamic> companyInfo = {};


  //methods

  void loginWithGoogle() async{

    await GoogleSignIn().signOut();

    emit(CompanyLoginStateWithGoogleProcess());

     try{

       final googleSignIn  = await GoogleSignIn().signIn();

       final googleAuth = await googleSignIn?.authentication;

       final credential = GoogleAuthProvider.credential(idToken: googleAuth?.idToken,accessToken: googleAuth?.accessToken);

       await FirebaseAuth.instance.signInWithCredential(credential).then((value){
         checkIfUserExist(docName: value.user!.uid, collectionName: "companies").then((exist){

           if(exist){
              if(companyInfo["userAuth"] == "active") {
                CacheHelper.set("userId", value.user!.uid);
                CacheHelper.set("userType", "company");
                emit(CompanyLoginStateWithGoogleAccountExist());
              }else if(companyInfo["userAuth"] == "disabled") {
                emit(CompanyLoginStateWithGoogleError("تم حظر الحساب الخاص بك"));
              }else {
                emit(CompanyLoginStateWithGoogleError("الحساب الخاص بك قيد المراجعة"));
              }

           }else{

             _companyUser = {
               "companyId": value.user!.uid,
               "email":value.user!.email,
               "displayName":value.user!.displayName
             };

             emit(CompanySignUpStateWithGoogle());
           }
         });
       });


     }catch(e){
       emit(CompanyLoginStateWithGoogleError("هنالك مشكلة بلاتصال حاول مرة اخرى في وقت لاحق"));
     }
      return null;
  }

  void signupWithGoogle(
  {
    @required companyPhoneNumber,
    @required companyName,
    @required address,
    @required desc,
    @required workTime,

  }
) async{
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    emit(CompanySignUpStateWithGoogleProcess());
    try {
      CompanyModel companyModel = CompanyModel(
        companyId: _companyUser["companyId"],
        companyName: companyName,
        companyPhoneNumber: companyPhoneNumber,
        address: address,
        email: _companyUser["email"],
        displayName: _companyUser["displayName"],
        workTime: workTime,
        description: desc,
        createdAt:DateTime.now().toString(),
      );


      firebase.collection('companies').doc(_companyUser["companyId"]).set(companyModel.toMap())
      .then((value){
        // String companyId = _companyUser["companyId"];
        // CacheHelper.set("userId", companyId);
        // CacheHelper.set("userType", "company");

        emit(CompanySignUpStateWithGoogleSucceed());
      }).catchError((error){
        emit(CompanySignUpStateWithGoogleError('هنالك مشكلة ما في عملية انشاء الحساب'));
        print('firestore_mj${error}');
      });


    }on FirebaseException catch (e){
          emit(CompanySignUpStateWithGoogleError("توجد مشكلة في عملية الاتصال بقاعدة البيانات"));
          print('firebaseEx_mj${e}');

    } catch(e){
          emit(CompanySignUpStateWithGoogleError("هنالك مشكلة ما بلأتصال حاول مرة اخرى في وقت لاحق"));
          print('catch_mj${e}');
    }

   }

  void loginWithPhoneNumber({
   required phoneNumberWithDialCode,
  }) async {
  emit(CompanyLoginStateVerificationPhoneNumberProcess());

    try {

      checkIfUserExist(docName: phoneNumberWithDialCode,collectionName: "driversPhoneNumbers").then((value) async {

        if(!value){
          emit(CompanyLoginStateVerificationPhoneNumberError('الرقم المدخل غير مرتبط بأي حساب.'));
        }else {

          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumberWithDialCode,
              verificationCompleted: (PhoneAuthCredential) async {
                await FirebaseAuth.instance.signInWithCredential(
                    PhoneAuthCredential
                );
              },
              verificationFailed: (error) {
                emit(CompanyLoginStateVerificationPhoneNumberError('هنالك مشكلة ما حاول مرة اخرى في وقت لاحق'));
              },
              codeSent: (verificationId, forceResendToken) {
                _verificationId = verificationId;
                emit(CompanyLoginStateSendCodeCompleted());
              },
              codeAutoRetrievalTimeout: (phoneNumberId) {}

          );

        }


      });

    } on FirebaseException catch (e) {
      emit(CompanyLoginStateVerificationPhoneNumberError('هنالك مشكلة ما حاول مرة اخرى في وقت لاحق'));

    } catch(e) {
      emit(CompanyLoginStateVerificationPhoneNumberError('يوجد لديك مشكلة بلأتصال بلانترنت'));

    }
  }


  void verifyVerificationCode(String verificationCode) async {
    // emit(RegisterLoadingState());
    emit(CompanyLoginStateVerificationCodeProcess());


    try {

      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: verificationCode
      );

      var driver = (await FirebaseAuth.instance.signInWithCredential(credential))
          .user;


      if (driver != null) {

        checkIfUserExist(docName: driver.uid, collectionName: "drivers").then((exist) async{

          if(!exist){

            await FirebaseFirestore.instance.collection("companies").doc(_getUserDataFromCheckFunc!['companyId']).update({'drivers': FieldValue.arrayUnion([driver.uid])});

            DriverModel driverModel = DriverModel(
              driverId: driver.uid,
              companyId: _getUserDataFromCheckFunc!['companyId'],
              driverName:_getUserDataFromCheckFunc!['driverName'],
              driverAddress: _getUserDataFromCheckFunc!['driverAddress'],
              driverPhoneNumber: _getUserDataFromCheckFunc!['driverPhoneNumber'],
              companyName: _getUserDataFromCheckFunc!['companyName'],
              createdAt:DateTime.now().toString(),
            );

            await FirebaseFirestore.
            instance.
            collection('drivers').
            doc(driver.uid).
            set(driverModel.toMap()).catchError((error) => emit(CompanyLoginStateVerificationCodeError(error.toString('هنالك مشكلة في أنشاء الحساب حاول مرة اخرى في وقت لاحق'))));
            CacheHelper.set("userId", driver.uid);
            CacheHelper.set("userType", "driver");

            emit(CompanyLoginStateVerificationCodeCompleted());


          }else{

            if(companyInfo["userAuth"] == "active"){
              CacheHelper.set("userId", driver.uid);
              CacheHelper.set("userType", "driver");
              emit(CompanyLoginStateVerificationCodeCompleted());
            }else if(companyInfo["userAuth"] == "disabled"){
              emit(CompanyLoginStateVerificationCodeError('تم حظر حسابك'));
            }


          }


        });



      }else {
        emit(CompanyLoginStateVerificationCodeError('هنالك مشكلة ما حاول مرة'));
      }

    }on FirebaseException catch (e) {
      emit(CompanyLoginStateVerificationCodeError('يوجد لديك مشكلة بلأتصال بلانترنت'));
    }


  }



  Future<bool> checkIfUserExist(
      {
      @required docName, // user id
       @required collectionName // copm...
      }
      ) async {

    var snapshot = await FirebaseFirestore.instance.collection(collectionName).doc(docName).get();

    if (snapshot.exists) {
      _getUserDataFromCheckFunc = snapshot.data();
      companyInfo = snapshot.data() as Map<String,dynamic>;
      return true;

    } else {
      return false;
    }
  }


  Future<void> addValueToArray(String collection,String documentId,String arrayName, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update({
        'arrayName': FieldValue.arrayUnion([value]),
      });
      print('Value added to array successfully!');
    } catch (e) {
      print('Error adding value to array: $e');
    }
  }



}











