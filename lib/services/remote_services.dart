import 'package:chefup/models/fruit_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiServices {
  Future<List<Welcome>> getFruits() async {
    try {
      var url = Uri.parse('http://www.fruityvice.com/api/fruit/all');
      var response = await http.get(url);

      log("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<Welcome> model = fruitFromJson(response.body);
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
