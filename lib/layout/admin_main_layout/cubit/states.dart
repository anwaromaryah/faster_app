abstract class  AdminLayoutStates {}

class AdminLayoutStatesInitial extends AdminLayoutStates{}



class AdminDurationMethodProcess extends AdminLayoutStates{}
class AdminDurationMethodFinish extends AdminLayoutStates{}


class GetDataFromFirebaseProcess extends AdminLayoutStates{}
class GetDataFromFirebaseSuccess extends AdminLayoutStates{}
class GetDataFromFirebaseError extends AdminLayoutStates{
  String error = "";
  GetDataFromFirebaseError(this.error);

  String showError() {
    return error;
  }

}


class UpdateAccountAuthProcess extends AdminLayoutStates{}
class UpdateAccountAuthSuccess extends AdminLayoutStates{}
class UpdateAccountAuthError extends AdminLayoutStates{
  String error = "";
  UpdateAccountAuthError(this.error);

  String showError() {
    return error;
  }

}


class DeleteAccountProcess extends AdminLayoutStates{}
class DeleteAccountSuccess extends AdminLayoutStates{}
class DeleteAccountError extends AdminLayoutStates{
  String error = "";
  DeleteAccountError(this.error);

  String showError() {
    return error;
  }

}


class AdminSignOutSuccess extends AdminLayoutStates{}
class AdminSignOutError extends AdminLayoutStates{}
