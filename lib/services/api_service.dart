
import 'dart:developer';
import 'package:projectyp/pages.dart';
import 'package:projectyp/dependencies.dart';
import 'package:http/http.dart' as http;


class ApiService {
  Future<List<YugiohModel>?> getUsers() async {
    // This method fetches a list of users from the API.
    // It returns a Future because HTTP calls are asynchronous.
    try
    {
      // Combine the base URL and endpoint (e.g. "https://.../users")
      var url = Uri.parse(ApiConstants.baseURL + ApiConstants.usersEndPoint);
      //Send the GET request
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // If status code is 200 (OK), decode the JSON into a list of UserModel
        List<YugiohModel> _model = yuGiOhModelFromJson(response.body);

       //return list
        return _model;
      }
    }
    // If status code isn't 200, just return null (or you can throw an error)

    catch (e) {
      log(e.toString());
    }
  }
}
