import 'package:feather/src/data/model/internal/forecast_navigation_params.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/forecast/weather_forecast_screen.dart';
import 'package:feather/src/ui/main/main_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class NavigationProvider {
  final router = FluroRouter();

  final _mainScreenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MainScreen();
    },
  );

  final _forecastScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    WeatherForecastHolder? holder;
    if (context?.arguments != null) {
      final ForecastNavigationParams navigationParams =
          context!.arguments! as ForecastNavigationParams;
      holder = navigationParams.weatherForecastHolder;
    }
    if (holder != null) {
      return WeatherForecastScreen(holder);
    } else {
      throw ArgumentError("WeatherForecastHolder can't be null");
    }
  });

  void defineRoutes() {
    router.define("/", handler: _mainScreenHandler);
    router.define("/forecast", handler: _forecastScreenHandler);
  }

  void navigateToPath(
    String path,
    GlobalKey<NavigatorState> navigatorKey, {
    RouteSettings? routeSettings,
  }) {
    router.navigateTo(
      navigatorKey.currentState!.context,
      path,
      routeSettings: routeSettings,
      transition: TransitionType.material,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
