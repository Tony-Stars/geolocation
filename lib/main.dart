import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const LocationApp());

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  State<LocationApp> createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  Position? position;

  getLocation() async {
    await Geolocator.requestPermission();
    final Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      position = pos;
    });
  }

  openGoogleMap() async {
    if (position != null) {
      Uri googleUrl = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=${position!.latitude},${position!.longitude}");
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl);
      } else {
        throw ("Не удалось открыть крарту");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get user location',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40.0,
                color: Colors.white,
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: getLocation,
                child: const Text(
                  'Определить местоположение',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: openGoogleMap,
                child: const Text(
                  'Открыть на карте',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30.0),
              if (position != null)
                Text(
                  "Долгота: ${position?.longitude}",
                  style: const TextStyle(color: Colors.white),
                ),
              if (position != null)
                Text(
                  "Широта: ${position?.latitude}",
                  style: const TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
