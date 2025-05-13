abstract class  ClientLayoutStates {}

class ClientLayoutStatesInitial extends ClientLayoutStates{}

class ChangeBottomNavigationBarIndex extends ClientLayoutStates{}

class ClientDurationMethodProcess extends ClientLayoutStates{}
class ClientDurationMethodFinish extends ClientLayoutStates{}

class ClientDurationMethodModulesProcess extends ClientLayoutStates{}
class ClientDurationMethodModulesFinish extends ClientLayoutStates{}

// set user location
class SetUserLocationSucceed extends ClientLayoutStates{}
class SetUserLocationError extends ClientLayoutStates{
  String error = "";
  SetUserLocationError(this.error);

  String showError() {
    return error;
  }
}

//get client information
class GetClientInformationProcess extends ClientLayoutStates{}
class GetClientInformationSuccess extends ClientLayoutStates{}
class GetClientInformationError extends ClientLayoutStates{
  String error = "";
  GetClientInformationError(this.error);

  String showError() {
    return error;
  }
}

//get companies data
class FetchAllCompaniesDataProcess extends ClientLayoutStates{}
class FetchAllCompaniesDataSucceed extends ClientLayoutStates{}
class FetchAllCompaniesDataError extends ClientLayoutStates{
  String error = "";
  FetchAllCompaniesDataError(this.error);

  String showError() {
    return error;
  }
}


//get company drivers
class GetAllDriversProcess extends ClientLayoutStates{}
class GetAllDriversSuccess extends ClientLayoutStates{}

class CompaniesDataExist extends ClientLayoutStates{}

//send and get Specific request
class SendSpecificRequestToRealTimeDatabaseSucceed extends ClientLayoutStates{}
class SendSpecificRequestToRealTimeDatabaseError extends ClientLayoutStates{
  String error = "";
  SendSpecificRequestToRealTimeDatabaseError(this.error);

  String showError() {
    return error;
  }
}

class GetSpecificRequestToRealTimeDatabaseSucceed extends ClientLayoutStates{}
class GetSpecificRequestToRealTimeDatabaseError extends ClientLayoutStates{
  String error = "";
  GetSpecificRequestToRealTimeDatabaseError(this.error);

  String showError() {
    return error;
  }
}


//send and get General request
class SendGeneralRequestToRealTimeDatabaseSucceed extends ClientLayoutStates{}
class SendGeneralRequestToRealTimeDatabaseError extends ClientLayoutStates{
  String error = "";
  SendGeneralRequestToRealTimeDatabaseError(this.error);

  String showError() {
    return error;
  }
}

//select offer from general offers
class SelectOfferFromGeneralRequestsSucceed extends ClientLayoutStates{}
class SelectOfferFromGeneralRequestsError extends ClientLayoutStates{
  String error = "";
  SelectOfferFromGeneralRequestsError(this.error);

  String showError() {
    return error;
  }
}

class GetGeneralRequestToRealTimeDatabaseSucceed extends ClientLayoutStates{}
class GetGeneralRequestToRealTimeDatabaseError extends ClientLayoutStates{
  String error = "";
  GetGeneralRequestToRealTimeDatabaseError(this.error);

  String showError() {
    return error;
  }
}




//fetch accepted requests
class GetAcceptedRequestComplete extends ClientLayoutStates{}
class GetAcceptedRequestError extends ClientLayoutStates{
  String error = "";
  GetAcceptedRequestError(this.error);

  String showError() {
    return error;
  }

}



// favorite company
class SetFavoriteCompanySuccess extends ClientLayoutStates{}
class RemoverFavoriteCompanySuccess extends ClientLayoutStates{}
class FavoriteCompanyError extends ClientLayoutStates{
  String error = "";
  FavoriteCompanyError(this.error);

  String showError() {
    return error;
  }
}






//map
class ClientNavigateToMapProcess extends ClientLayoutStates{}
class ClientNavigateToMapFinish extends ClientLayoutStates{}

class SearchOnDeliveryDriverProcess extends ClientLayoutStates{}
class SearchOnDeliveryDriverSuccess extends ClientLayoutStates{}
class SearchOnDeliveryDriverError extends ClientLayoutStates{
  String error = "";
  SearchOnDeliveryDriverError(this.error);

  String showError() {
    return error;
  }
}


//  history
class DeleteHistorySucceed extends ClientLayoutStates{}
class FilterHistorySucceed extends ClientLayoutStates{}
class ResetFilterHistorySucceed extends ClientLayoutStates{}
class RefreshHistorySucceed extends ClientLayoutStates{}

class HistoryError extends ClientLayoutStates{
  String error = "";
  HistoryError(this.error);

  String showError() {
    return error;
  }
}


//settings screen
class DeleteAllNotificationsSuccess extends ClientLayoutStates{}

class UpdateProfilePictureProcess extends ClientLayoutStates{}
class UpdateProfilePictureSuccess extends ClientLayoutStates{}

class UpdateClientInformationProcess extends ClientLayoutStates{}
class UpdateClientInformationSuccess extends ClientLayoutStates{}

class ClientSignOutSuccess extends ClientLayoutStates{}


class SettingsScreenError extends ClientLayoutStates{
  String error = "";
  SettingsScreenError(this.error);

  String showError() {
    return error;
  }
}

