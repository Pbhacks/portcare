import 'package:flutter/material.dart';
import 'dart:async'; // For the delay to navigate to the main page
import 'welcome_page.dart'; // Import your existing WelcomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcomePage(); // Call the navigation method on splash screen load
  }

  // Function to navigate to the WelcomePage after a delay
  void _navigateToWelcomePage() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 214, 10, 10)!, // Deep Red
              const Color.fromARGB(255, 0, 0, 0)!, // Deep Gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite, // Example icon (can replace with your logo)
                color: Colors.white,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'PortC4re', // Replace with your custom app name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Let the heartbeats unite!', // Optional tagline or description
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
