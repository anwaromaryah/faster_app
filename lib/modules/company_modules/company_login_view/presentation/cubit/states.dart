abstract class  CompanyLoginStates {}

class CompanyLoginStateInitial extends CompanyLoginStates{}



// verification pone number process
class CompanyLoginStateVerificationPhoneNumberProcess extends CompanyLoginStates{}

// verification phone number completed
class CompanyLoginStateVerificationPhoneNumberCompleted extends CompanyLoginStates{}

// verification phone number error
class CompanyLoginStateVerificationPhoneNumberError extends CompanyLoginStates{
  String error = "";
  CompanyLoginStateVerificationPhoneNumberError(this.error);

  String showError() {
    return error;
  }

}



// verification code process
class CompanyLoginStateVerificationCodeProcess extends CompanyLoginStates{}

// send verification code
class CompanyLoginStateSendCodeCompleted extends CompanyLoginStates{}

// verification code completed
class CompanyLoginStateVerificationCodeCompleted extends CompanyLoginStates{}

// verification code error
class CompanyLoginStateVerificationCodeError extends CompanyLoginStates{
  String error = "";
  CompanyLoginStateVerificationCodeError(this.error);

  String showError() {
    return error;
  }

}


// client_login_view with google process
class CompanyLoginStateWithGoogleProcess extends CompanyLoginStates{}

// client_login_view with google with account already exist
class CompanyLoginStateWithGoogleAccountExist extends CompanyLoginStates{}


// client_login_view with google error
class CompanyLoginStateWithGoogleError extends CompanyLoginStates{
  String error = "";
  CompanyLoginStateWithGoogleError(this.error);

  String showError() {
    return error;
  }

}



class CompanySignUpStateWithGoogleProcess extends CompanyLoginStates{}

class CompanySignUpStateWithGoogle extends CompanyLoginStates{}

class CompanySignUpStateWithGoogleSucceed extends CompanyLoginStates{}

class CompanySignUpStateWithGoogleError extends CompanyLoginStates{
  String error = "";
  CompanySignUpStateWithGoogleError(this.error);

  String showError() {
    return error;
  }

}