import 'package:url_launcher/url_launcher.dart';


Future<void> launchUrlSms({required phoneNumber}) async {

  final Uri smsLauncherUri = Uri(
     scheme: "sms",
     path: phoneNumber,
    queryParameters: <String,String>{
       'body': Uri.encodeComponent('Example'),
    },
  );
  launchUrl(smsLauncherUri);

  }

Future<void> launchUrlTel({required phoneNumber}) async {

  final Uri telephoneLauncherUri = Uri(
    scheme: "tel",
    path: phoneNumber,
    queryParameters: <String,String>{
      'body': Uri.encodeComponent('Example'),
    },
  );
  launchUrl(telephoneLauncherUri);

}