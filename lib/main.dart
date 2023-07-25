import 'package:feather/src/data/repository/local/location_manager.dart';
import 'package:feather/src/data/repository/local/location_provider.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';
import 'package:feather/src/data/repository/local/storage_provider.dart';
import 'package:feather/src/data/repository/local/weather_local_repository.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';
import 'package:feather/src/data/repository/remote/weather_remote_repository.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(const FeatherApp());

class FeatherApp extends StatefulWidget {
  const FeatherApp({Key? key}) : super(key: key);

  @override
  State<FeatherApp> createState() => _FeatherAppState();
}

class _FeatherAppState extends State<FeatherApp> {
  final NavigationProvider _navigation = NavigationProvider();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final LocationManager _locationManager = LocationManager(LocationProvider());
  final StorageManager _storageManager = StorageManager(StorageProvider());
  late WeatherLocalRepository _weatherLocalRepository;
  final WeatherRemoteRepository _weatherRemoteRepository =
      WeatherRemoteRepository(WeatherApiProvider());

  @override
  void initState() {
    super.initState();
    _weatherLocalRepository = WeatherLocalRepository(_storageManager);
    WidgetsFlutterBinding.ensureInitialized();
    _navigation.defineRoutes();
    _configureTimeAgo();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(_navigation, _navigatorKey),
        ),
        BlocProvider<MainScreenBloc>(
          create: (context) => MainScreenBloc(
            _locationManager,
            _weatherLocalRepository,
            _weatherRemoteRepository,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: _configureThemeData(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en"),
          Locale("pl"),
        ],
        onGenerateRoute: _navigation.router.generator,
      ),
    );
  }

  ThemeData _configureThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 60.0, color: Colors.white),
        titleLarge: TextStyle(fontSize: 35, color: Colors.white),
        titleSmall: TextStyle(fontSize: 20, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 15, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  void _configureTimeAgo() {
    timeago.setLocaleMessages("pl", timeago.PlMessages());
  }
}
