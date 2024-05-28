class WeatherModel {
  final num  latitude;
  final num  longitude;
  final String? temperatureUnit;
  final int?    forecastDays;
  final String? current;

  WeatherModel({
    required this.latitude, 
    required this.longitude,
    this.temperatureUnit,
    this.forecastDays,
    this.current
  });

  // factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
  //   latitude: json["latitude"],
  //   longitude: json["longitude"],
  //   temperatureUnit: json["temperature_unit"],
  //   forecastDays: json["forecast_days"],
  //   current: json["current"]
  // );
}