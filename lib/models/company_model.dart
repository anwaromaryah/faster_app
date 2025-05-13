class CompanyModel {
 String? companyId = "";
 String? companyPhoneNumber = "";
 String? companyName = "";
 String? address = "";
 String? createdAt = "";
 List<String>? notifications = [
   "مرحبا بك 🎈🎈 ,  نتمنى ان يساعدك التطبيق على تسهيل حياتك وجعلها افضل ",
 ];
 String? companyAuth = "restricted";
 List<Map>? history = [];
 List<Map>? drivers = [];
 String? profilePic ="";
 Map? workTime ={
   'startWork' : {
     'hour' : '',
     'minute': '',
     'amPm':''
   },
   "endWork": {
     'hour' : '',
     'minute': '',
     'amPm':''
   }
 };
 String? email ="";
 String? displayName = "";
 String? description = "";
 int? doneOrdersCount = 0;
 Map? carouselImages = {
   "firstImage" : "",
   "secondImage": "",
   "thirdImage" : "",
 };


 CompanyModel({
     this.companyId,
     this.companyPhoneNumber,
     this.companyName,
     this.address,
     this.createdAt,
     this.email,
     this.displayName,
     this.workTime,
     this.description
});


  Map<String,dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyPhoneNumber': companyPhoneNumber,
      'companyName': companyName,
      'address': address,
      'createdAt': createdAt,
      'notifications': notifications,
      'history': history,
      'drivers': drivers,
      'workTime': workTime,
      'profilePic': profilePic,
      'userAuth': companyAuth,
      "description":description,
      'email':email,
      'displayName':displayName,
      'doneOrdersCount': doneOrdersCount,
      'carouselImages':carouselImages,

    };
  }

}