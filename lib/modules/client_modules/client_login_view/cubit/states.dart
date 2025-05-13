abstract class  ClientLoginStates {}

class ClientLoginStatesInitial extends ClientLoginStates{}



// verification hone number process
class ClientLoginStateVerificationPhoneNumberProcess extends ClientLoginStates{}

// verification phone number completed
class ClientLoginStateVerificationPhoneNumberCompleted extends ClientLoginStates{}

// verification phone number error
class ClientLoginStateVerificationPhoneNumberError extends ClientLoginStates{
  String error = "";
  ClientLoginStateVerificationPhoneNumberError(this.error);

  String showError() {
    return error;
  }

}



// verification code process
class ClientLoginStateVerificationCodeProcess extends ClientLoginStates{}

// send verification code
class ClientLoginStateVerificationCodeSendCompleted extends ClientLoginStates{}

// verification code completed
class ClientLoginStateVerificationCodeCompleted extends ClientLoginStates{}
class ClientLoginStateVerificationCodeToAdminCompleted extends ClientLoginStates{}

// verification code error
class ClientLoginStateVerificationCodeError extends ClientLoginStates{
  String error = "";
  ClientLoginStateVerificationCodeError(this.error);

  String showError() {
    return error;
  }

}




