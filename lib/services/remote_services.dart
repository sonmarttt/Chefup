import 'package:chefup/models/fruit_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'constants.dart';

class ApiServices {
  Future<List<Fruits>> getFruits() async {
    try {
      var url = Uri.parse(ApiConstant.baseURL);
      var response = await http.get(url);

      log("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<Fruits> model = fruitFromJson(response.body);
        return model;
      } else {
        log("FAILED RESPONSE: ${response.body}");
      }
    } catch (e) {
      log('ERROR: ${e.toString()}');
    }

    return [];
  }
}
