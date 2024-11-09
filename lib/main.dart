import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/WeatherApp/Api/WeatherAppState.dart';
import 'package:weatherapp/WeatherApp/Views/CurrentTempTile/CurrentTempTile.dart';
import 'package:weatherapp/WeatherApp/Views/TodayWeatherTile/TodayWeatherTile.dart';
import 'package:weatherapp/WeatherApp/home/ViewModel/WeatherViewModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/WeatherApp/utilities/view/extensions/ColorExtension.dart';



void main() {
  runApp(
    
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel())
      ],
        child: const MyApp(),
      )
  );
 /*
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: HexColor.fromHex("#03C3EB"),
  ));
  */

  /*
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: []
  );
  */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double _lat = 0.0;
  double _long = 0.0;

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false ;
    }

    _getCurrentLocation();

    return true ;
  }


  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _lat = position.latitude;
      _long = position.longitude;
    });
    fetchWeather();
  }


  void fetchWeather() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
     Provider.of<WeatherViewModel>(context, listen: false).fetchWeather('$_lat', '$_long', '');
    });
  }

  @override
  void initState() {

    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {

    WeatherAppState appState = Provider.of<WeatherViewModel>(context).weatherAppState;

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor.fromHex("#0C0926"),
        body:
        Column(
          children: [
            if(appState.status == Status.LOADING)
              const Center(
                child: CircularProgressIndicator(semanticsLabel: "Please wait....", color: Colors.white),
              )
              else
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: const Alignment(0, 0.8),
                      colors: <Color> [
                        HexColor.fromHex("#03C3EB"),
                        HexColor.fromHex("#06BEE6"),
                        HexColor.fromHex("#0ABBE3"),
                        HexColor.fromHex("#0AB3E1"),
                        HexColor.fromHex("#068EE6"),
                        HexColor.fromHex("#0847F1"),
                        HexColor.fromHex("#0847F1"),
                        HexColor.fromHex("#0847F1"),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
                ),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\u00B0C", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                              Icon(Icons.more_vert_outlined, size: 25, color: Colors.white)
                            ],
                          )
                      ),
                      Center(
                        child: TextButton.icon(
                            onPressed: () {},
                            label: Text("${appState.data?.name ?? ""}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                            icon: const Icon(Icons.location_pin, color: Colors.white, size: 20),
                        ),
                      ),
                       const Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:
                           Image(image: AssetImage("assets/cloudy.png"), width: 100)
                       ),
                       Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                               Text("${appState.data?.main.temp ?? "0"}\u00B0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70, color: Colors.white)),
                              Text("${appState.data?.weather[0].main ?? ""}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 45, color: Colors.yellow)),
                              Text(DateFormat("EEEE, d MMM").format(DateTime.now()), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400))
                            ],
                          )
                      ),
                       Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                        child: Column(
                          children: [
                            Divider(color: Colors.white),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CurrentTempTile(itemIcon: Icons.ac_unit_sharp, title: "Wind", value: "${appState.data?.wind.speed ?? "0"} km/h"),
                                CurrentTempTile(itemIcon: Icons.water_drop_outlined, title: "Humidity", value: "${appState.data?.main.humidity ?? "0"}%"),
                                CurrentTempTile(itemIcon: Icons.cloudy_snowing, title: "Chance of rain", value: "82%")
                              ],
                            )
                          ],
                        ))
                    ],
                  ),
                )
              ),
            ),
            Container(
              color: HexColor.fromHex("#0C0926"),
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                        TextButton.icon(
                          onPressed: () {
                            // Handle button press
                          },
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(Icons.chevron_right_outlined, size: 24, color: Colors.white),
                          ),
                          label: const Text("7 Days", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300)),
                          iconAlignment: IconAlignment.end,
                        )
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TodayWeatherTile(percentage: "24%", image: Icons.cloud, time: "10:00"),
                      TodayWeatherTile(percentage: "24%", image: Icons.cloud_circle_sharp, time: "11:00"),
                      TodayWeatherTile(percentage: "24%", image: Icons.thunderstorm_sharp, time: "12:00"),
                      TodayWeatherTile(percentage: "24%", image: Icons.cloudy_snowing, time: "1:00"),
                    ]
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
