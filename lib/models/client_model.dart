class ClientModel {

  String? clientId = "";
  String? clientPhoneNumber = "";
  String? clientName = "";
  String? clientAddress = "";
  String? createdAt = "";
  List<String>? notifications = [
    "مرحبا بك 🎈🎈 ,  نتمنى ان يساعدك التطبيق على تسهيل حياتك وجعلها افضل",
  ];
  String? clientAuth = "active";
  List<Map>? history = [];
  String? profilePic ="";
  int? completedOrdersCount = 0;
  List? favoriteCompanies = [];


  ClientModel({
    this.clientId,
    this.clientPhoneNumber,
    this.createdAt,
  });


  Map<String,dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientPhoneNumber': clientPhoneNumber,
      'clientName': clientName,
      'clientAddress': clientAddress,
      'createdAt': createdAt,
      'notifications': notifications,
      'history': history,
      'userAuth': clientAuth,
      'profilePic': profilePic,
      "completedOrdersCount":completedOrdersCount,
      "favoriteCompanies":favoriteCompanies
    };
  }

}