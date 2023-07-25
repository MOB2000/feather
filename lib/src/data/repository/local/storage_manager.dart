import 'dart:convert';

import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/storage_provider.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/utils/app_logger.dart';

class StorageManager {
  final StorageProvider _storageProvider;

  StorageManager(this._storageProvider);

  Future<bool> saveLocation(GeoPosition geoPosition) async {
    try {
      Log.d("Store location: $geoPosition");
      final result = await _storageProvider.setString(
          Ids.storageLocationKey, json.encode(geoPosition));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<GeoPosition?> getLocation() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageLocationKey);
      Log.d("Returned user location: $jsonData");
      if (jsonData != null) {
        return GeoPosition.fromJson(
            json.decode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeather(WeatherResponse response) async {
    try {
      Log.d("Store weather: ${json.encode(response)}");
      final result = await _storageProvider.setString(
          Ids.storageWeatherKey, json.encode(response));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherResponse?> getWeather() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageWeatherKey);
      Log.d("Returned weather data: $jsonData");
      if (jsonData != null) {
        return WeatherResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeatherForecast(WeatherForecastListResponse response) async {
    try {
      Log.d("Store weather forecast ${json.encode(response)}");
      final result = _storageProvider.setString(
          Ids.storageWeatherForecastKey, json.encode(response));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageWeatherForecastKey);
      Log.d("Returned weather forecast data: $jsonData");
      if (jsonData != null) {
        return WeatherForecastListResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }
}
