import 'package:http/http.dart' as http;
import 'dart:convert';

class DataManager {
  Future<List<dynamic>> matchList(String date) async {
    var url = "http://app.fshf.org/json/byDate/$date";
    var response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}