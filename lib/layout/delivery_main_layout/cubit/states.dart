abstract class  DeliveryLayoutStates {}

class DeliveryLayoutStatesInitial extends DeliveryLayoutStates{}

class ChangeBottomNavigationBarIndex extends DeliveryLayoutStates{}

class DeliveryLayoutStatesStart extends DeliveryLayoutStates{}


//get driver information
class GetDriverInformationProcess extends DeliveryLayoutStates{}
class GetDriverInformationSuccess extends DeliveryLayoutStates{}
class GetDriverInformationError extends DeliveryLayoutStates{
  String error = "";
  GetDriverInformationError(this.error);

  String showError() {
    return error;
  }
}

// set user location
class SetUserLocationSucceed extends DeliveryLayoutStates{}
class SetCurrentLocation extends DeliveryLayoutStates{}
class SetUserLocationError extends DeliveryLayoutStates{
  String error = "";
  SetUserLocationError(this.error);

  String showError() {
    return error;
  }
}

//duration
class DeliveryDurationMethodProcess extends DeliveryLayoutStates{}
class DeliveryDurationMethodFinish extends DeliveryLayoutStates{}

class DeliveryDurationMethodModulesProcess extends DeliveryLayoutStates{}
class DeliveryDurationMethodModulesFinish extends DeliveryLayoutStates{}

// delete history
class DeleteHistorySucceed extends DeliveryLayoutStates{}
class FilterHistorySucceed extends DeliveryLayoutStates{}
class ResetFilterHistorySucceed extends DeliveryLayoutStates{}
class RefreshHistorySucceed extends DeliveryLayoutStates{}
class HistoryError extends DeliveryLayoutStates{
  String error = "";
  HistoryError(this.error);

  String showError() {
    return error;
  }
}

//accept company request
class AcceptRequestProcess extends DeliveryLayoutStates{}
class AcceptRequestCompleted extends DeliveryLayoutStates{}
class AcceptRequestError extends DeliveryLayoutStates{
  String error = "";
  AcceptRequestError(this.error);

  String showError() {
    return error;
  }
}

//the order has been delivered => company request
class TheOrderHasBeenDeliveredProcess extends DeliveryLayoutStates{}
class TheOrderHasBeenDeliveredCompleted extends DeliveryLayoutStates{}
class TheOrderHasBeenDeliveredError extends DeliveryLayoutStates{
  String error = "";
  TheOrderHasBeenDeliveredError(this.error);

  String showError() {
    return error;
  }
}


// general requests

class DeliveryNavigateToMapProcess extends DeliveryLayoutStates{}
class DeliveryNavigateToMapFinish extends DeliveryLayoutStates{}

// accept
class DriverAcceptGeneralRequestProcess extends DeliveryLayoutStates{}
class DriverAcceptGeneralRequestSuccess extends DeliveryLayoutStates{}
class DriverAcceptGeneralRequestError extends DeliveryLayoutStates{
  String error = "";
  DriverAcceptGeneralRequestError(this.error);

  String showError() {
    return error;
  }
}

//reject
class DriverRejectGeneralRequestProcess extends DeliveryLayoutStates{}
class DriverRejectGeneralRequestSuccess extends DeliveryLayoutStates{}
class DriverRejectGeneralRequestError extends DeliveryLayoutStates{
  String error = "";
  DriverRejectGeneralRequestError(this.error);

  String showError() {
    return error;
  }
}

class GetGeneralOrderInfoAfterProblemConnectionSuccess extends DeliveryLayoutStates{}
class GetGeneralOrderInfoAfterProblemConnectionError extends DeliveryLayoutStates{
  String error = "";
  GetGeneralOrderInfoAfterProblemConnectionError(this.error);

  String showError() {
    return error;
  }

}

class GetOrderInfoAfterProblemConnectionSuccess extends DeliveryLayoutStates{}
class GetOrderInfoAfterProblemConnectionError extends DeliveryLayoutStates{
  String error = "";
  GetOrderInfoAfterProblemConnectionError(this.error);

  String showError() {
    return error;
  }

}

class DriverCloseMapInGeneralOrderSuccess extends DeliveryLayoutStates{}
class DriverCloseMapInGeneralOrderError extends DeliveryLayoutStates{
  String error = "";
  DriverCloseMapInGeneralOrderError(this.error);

  String showError() {
    return error;
  }
}

class ReportAboutDeliveryProcess extends DeliveryLayoutStates{}
class ReportAboutDeliveryProcessSuccess extends DeliveryLayoutStates{}
class ReportAboutDeliveryProcessError extends DeliveryLayoutStates{
  String error = "";
  ReportAboutDeliveryProcessError(this.error);

  String showError() {
    return error;
  }
}


//settings screen
class DeleteAllNotificationsSuccess extends DeliveryLayoutStates{}
class DeleteAllNotificationsError extends DeliveryLayoutStates{

  String error = "";
  DeleteAllNotificationsError(this.error);

  String showError() {
    return error;
  }
}

class UpdateProfilePictureProcess extends DeliveryLayoutStates{}
class UpdateProfilePictureSuccess extends DeliveryLayoutStates{}
class UpdateProfilePictureError extends DeliveryLayoutStates{
  String error = "";
  UpdateProfilePictureError(this.error);

  String showError() {
    return error;
  }
}

class UpdateDriverInformationProcess extends DeliveryLayoutStates{}
class UpdateDriverInformationSuccess extends DeliveryLayoutStates{}
class UpdateDriverInformationError extends DeliveryLayoutStates{
  String error = "";
  UpdateDriverInformationError(this.error);

  String showError() {
    return error;
  }
}

class DriverSignOutSuccess extends DeliveryLayoutStates{}
class DriverSignOutError extends DeliveryLayoutStates{
  String error = "";
  DriverSignOutError(this.error);

  String showError() {
    return error;
  }

}