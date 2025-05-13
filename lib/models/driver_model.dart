class DriverModel {
 String? driverId = "";
 String? companyId = "";
 String? driverPhoneNumber = "";
 String? driverName = "";
 String? driverAddress = "";
 String? createdAt = "";
 List<String>? notifications = [
   "مرحبا بك 🎈🎈 ,  نتمنى ان يساعدك التطبيق على تسهيل حياتك وجعلها افضل",
 ];
 String? driverAuth = "active";
 List<Map>? history = [];
 String? profilePic ="";
 String? companyName = "";
 int? completedOrdersCount = 0;

 DriverModel({
   this.driverId,
   this.companyId,
   this.driverPhoneNumber,
   this.driverName,
   this.driverAddress,
   this.createdAt,
   this.companyName
});



  Map<String,dynamic> toMap() {
    return {
      'driverId': driverId,
      'companyId': companyId,
      'driverName': driverName,
      'driverPhoneNumber': driverPhoneNumber,
      'driverAddress': driverAddress,
      'createdAt': createdAt,
      'notifications': notifications,
      'history': history,
      'userAuth': driverAuth,
      'profilePic': profilePic,
      'companyName': companyName,
      'completedOrdersCount': completedOrdersCount,
    };
  }

}