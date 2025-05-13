abstract class  CompanyLayoutStates {}

class CompanyLayoutStatesInitial extends CompanyLayoutStates{}

class CompanyBottomNavigationBarIndex extends CompanyLayoutStates{}

class CompanyDurationMethodProcess extends CompanyLayoutStates{}
class CompanyDurationMethodFinish extends CompanyLayoutStates{}

class CompanyDurationMethodModulesProcess extends CompanyLayoutStates{}
class CompanyDurationMethodModulesFinish extends CompanyLayoutStates{}


class GetAllDriversProcess extends CompanyLayoutStates{}
class GetAllDriversSuccess extends CompanyLayoutStates{}
class GetAllDriversError extends CompanyLayoutStates{
  String error = "";
  GetAllDriversError(this.error);

  String showError() {
    return error;
  }
}

// ##drivers view

//company add driver process
class CompanyAddNewDriverProcess extends CompanyLayoutStates{}
//company add driver succeed
class CompanyAddNewDriverSucceed extends CompanyLayoutStates{}
//company add driver already exist
class CompanyAddNewDriverAlreadyExist extends CompanyLayoutStates{}

// company send msg to driver process
class CompanySendMsgToDriverProcess extends CompanyLayoutStates{}
// company send msg to driver success
class CompanySendMsgToDriverSucceed extends CompanyLayoutStates{}

// company delete driver process
class CompanyDeleteDriverProcess extends CompanyLayoutStates{}
// company delete driver success
class CompanyDeleteDriverSucceed extends CompanyLayoutStates{}


class CompanyDriversViewError extends CompanyLayoutStates{
  String error = "";
  CompanyDriversViewError(this.error);

  String showError() {
    return error;
  }
}

//get driver information
class GetCompanyInformationProcess extends CompanyLayoutStates{}
class GetCompanyInformationSuccess extends CompanyLayoutStates{}
class GetCompanyInformationError extends CompanyLayoutStates{
  String error = "";
  GetCompanyInformationError(this.error);

  String showError() {
    return error;
  }
}

//history screen
class DeleteHistorySucceed extends CompanyLayoutStates{}
class RefreshHistorySucceed extends CompanyLayoutStates{}
class FilterHistorySucceed extends CompanyLayoutStates{}
class ResetFilterHistorySucceed extends CompanyLayoutStates{}
class DeletePendingRequestsSucceed extends CompanyLayoutStates{}

class HistoryError extends CompanyLayoutStates{
  String error = "";
  HistoryError(this.error);

  String showError() {
    return error;
  }
}


//settings screen
class DeleteAllNotificationsSuccess extends CompanyLayoutStates{}
class DeleteAllNotificationsError extends CompanyLayoutStates{

  String error = "";
  DeleteAllNotificationsError(this.error);

  String showError() {
    return error;
  }
}

// update profile pic
class UpdateProfilePictureProcess extends CompanyLayoutStates{}
class UpdateProfilePictureSuccess extends CompanyLayoutStates{}
class UpdateProfilePictureError extends CompanyLayoutStates{
  String error = "";
  UpdateProfilePictureError(this.error);

  String showError() {
    return error;
  }
}


// update carousel images
class UpdateCarouselImagesProcess extends CompanyLayoutStates{}
class UpdateCarouselImagesSuccess extends CompanyLayoutStates{}
class UpdateCarouselImagesError extends CompanyLayoutStates{
  String error = "";
  UpdateCarouselImagesError(this.error);

  String showError() {
    return error;
  }
}

// update time work
class UpdateTimeWorkProcess extends CompanyLayoutStates{}
class UpdateTimeWorkSuccess extends CompanyLayoutStates{}
class UpdateTimeWorkError extends CompanyLayoutStates{
  String error = "";
  UpdateTimeWorkError(this.error);

  String showError() {
    return error;
  }
}

class UpdateCompanyInformationProcess extends CompanyLayoutStates{}
class UpdateCompanyInformationSuccess extends CompanyLayoutStates{}
class UpdateCompanyInformationError extends CompanyLayoutStates{
  String error = "";
  UpdateCompanyInformationError(this.error);

  String showError() {
    return error;
  }
}

class CompanySignOutSuccess extends CompanyLayoutStates{}
class CompanySignOutError extends CompanyLayoutStates{
  String error = "";
  CompanySignOutError(this.error);

  String showError() {
    return error;
  }

}