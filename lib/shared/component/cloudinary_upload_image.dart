import 'dart:convert';

import 'package:http/http.dart' as http;


Future<String> uploadImage(imagePath) async {
  final url = Uri.parse('https://api.cloudinary.com/v1_1/dwjd4s45g/upload'); // Assuming correct URL
  final request = http.MultipartRequest('POST', url);

  const String folderPath = 'clients/';

  final publicId = folderPath + imagePath.path.split('/').last.split('.')[0];

  request.fields['upload_preset'] = 'fasterApp001';
  request.fields['public_id'] = publicId;

  var multipartFile = await http.MultipartFile.fromPath('file', imagePath.path);
  request.files.add(multipartFile);

  try {
    final response = await request.send();
    if(response.statusCode == 200){
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      final url = jsonMap['url'];
      return url;
    }else {
      return "";
      // if the statusCode not 200
    }

  }catch(e){
    return "";
  }
}
