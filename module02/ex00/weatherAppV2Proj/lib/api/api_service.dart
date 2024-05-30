import 'package:http/http.dart' as http;

class ApiService {
  final String  apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41";

  Future<http.Response> fetchWeatherData() async {
    return await http.get(Uri.parse(apiUrl));
  }
}