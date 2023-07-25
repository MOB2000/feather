import 'package:equatable/equatable.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MainScreenNavigationEvent extends NavigationEvent {}

class ForecastScreenNavigationEvent extends NavigationEvent {
  final WeatherForecastHolder holder;

  ForecastScreenNavigationEvent(this.holder);
}
