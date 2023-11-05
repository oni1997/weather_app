import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: WeatherPage(),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController cityController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  String cityName = '';
  String countryCode = '';
  double temperature = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: 'City',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: countryCodeController,
            decoration: InputDecoration(
              labelText: 'Country Code',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'City: $cityName',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Temperature: $temperature °C',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              fetchWeather();
            },
            child: Text('Get Weather'),
          ),
        ],
      ),
    );
  }

  void fetchWeather() async {
    final apiKey = 'ApiKey';
    final city = cityController.text;
    final countryCode = countryCodeController.text;

    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid=$apiKey&units=metric';
    print(apiUrl); //test if it returns working link
    final response = await http.get(Uri.parse(apiUrl));
    print(response);//returned reponse

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data); //Testing
      setState(() {
        temperature = data['main']['temp'] as double;
        print(temperature); //Testing
        cityName = data['name'] as String;
      });
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load weather data');
    }
  }
}
