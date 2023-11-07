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
        body: Container(
          color: Colors.blue, // Set the background color to blue
          child: WeatherPage(),
        ),
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
  String description ='';
  double temperature = 0;
  int humidity = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20), // Add padding for spacing
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 300,
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              width: 300,
              child: TextField(
                controller: countryCodeController,
                decoration: InputDecoration(
                  labelText: 'Country Code',
                ),
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
            Text(
              'Humidity: $humidity %',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Description: $description',
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
      ),
    );
  }

  void fetchWeather() async {
    final apiKey = 'qazwsxedc';
    final city = cityController.text;
    final countryCode = countryCodeController.text;

    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        temperature = data['main']['temp'] as double;
        humidity = data['main']['humidity'] as int;
        description = data['weather'][0]['description'] as String;
        cityName = data['name'] as String;
      });
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load weather data');
    }
  }
}
