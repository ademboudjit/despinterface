import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Updated import statement
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DispatcherTest1App());
}

class DispatcherTest1App extends StatelessWidget {
  const DispatcherTest1App({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispatcher Test 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      //backgroundColor: Color.fromARGB(244, 89, 87, 87),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Wrap the Image.asset with GestureDetector
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Image.asset(
                'image/AidNow8.png', // Replace 'AidNow.png' with your image file path
                width: 450, // Adjust width to make the image bigger
                height: 450, // Adjust height to make the image bigger
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 62, 99, 137),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'DISPATCHER LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white), // Text color
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white), // Text color
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DispatcherScreen()),
                    );
                  },
                  style: ButtonStyle(
                    //  surfaceTintColor: Colors.black,
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(62, 92, 55, 91),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DispatcherScreen extends StatefulWidget {
  const DispatcherScreen({super.key});

  @override
  _DispatcherScreenState createState() => _DispatcherScreenState();
}

class _DispatcherScreenState extends State<DispatcherScreen> {
  Position? _currentPosition; // Initialize _currentPosition to null
  final MapController _mapController = MapController();
  double zoom = 20;

  String _currentPage = 'Map';
  Color primary = const Color.fromARGB(255, 62, 99, 137);
  bool _showReceiveCallPage = false;
  // Define a boolean variable to track the visibility of the Discussion section
  bool _showDiscussion = false;

  void _logout(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permission. You can prompt them to go to settings and enable it manually.
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission not granted, exit method
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Adjust map position according to the retrieved location
      if (_mapController != null && _currentPosition != null) {
        _mapController.move(
          LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          _mapController.zoom,
        );
      }
    } catch (e) {
      // Handle exceptions
      print("Error getting location: $e");
      // You can provide feedback to the user here if needed.
    }
  }

  /*
  // Method to get the current location
  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    _mapController.move(
      LatLng(
        _currentPosition!.latitude - 1.0651983,
        _currentPosition!.longitude + 128.7245,
      ),
      _mapController.zoom,
    );
  }
*/
  void _navigateToPage(String page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _receiveCallButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showReceiveCallPage = !_showReceiveCallPage;
          _showDiscussion = _showReceiveCallPage;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
      ),
      child: Text(_showReceiveCallPage ? 'End Call' : 'Receive Call'),
    );
  }

  Widget _endCallButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showReceiveCallPage = false;
          _showDiscussion = false; // Hide discussion area when ending call
          messages.clear();
          _currentMessage = '';
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
      ),
      child: const Text('End Call'),
    );
  }

  Widget _voluntaryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Wrap with Center widget
            child: Row(
              children: [
                Text(
                  '     Voluntaries List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.check_circle, // Choose appropriate icon
                  color: Colors.green, // Choose appropriate color
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        _voluntaryItem(' John Doe'),
        _voluntaryItem(' Jane Smith'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
        _voluntaryItem(' Olivia Martinez'),
      ],
    );
  }

  Widget _voluntaryItem(String name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality to call the voluntary
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(40, 40), // Set the minimum size of the button
            backgroundColor:
                Color.fromRGBO(62, 99, 137, 1), // Set background color
            foregroundColor: Colors.white, // Set foreground color
          ),
          child: Icon(
            Icons.phone,
            size: 20, // Set the size of the phone icon
          ),
        ),
      ],
    );
  }

  String _currentMessage = '';
  List<String> messages = [];
  TextEditingController _messageController =
      TextEditingController(); // Controller for managing the text field

  void _sendMessage(String message) {
    DateTime now = DateTime.now(); // Get the current date and time
    String timestamp = DateFormat('HH:mm a')
        .format(now); // Format the time with AM/PM indicator
    String messageWithTime =
        '$message - $timestamp'; // Concatenate message with time
    setState(() {
      messages.add(messageWithTime);
      _currentMessage = ''; // Clear the text field after sending message
      _messageController.clear(); // Clear the text field using the controller
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _showReceiveCallPage
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Call Information', // Title for the first area
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ReceiveCallPage(_endCallButton()),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Features', // Title for the first area
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            _receiveCallButton(),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },

                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primary,
                                ),
                                child: Text(
                                    'Log Out'), // Change button text to 'Log Out'
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  // Add functionality for the third button
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primary,
                                ),
                                child: Text('Call history'),
                              ),
                            ),
                            /*Expanded(
                              child: TextButton(
                                onPressed: () {
                                  // Add functionality for the fourth button
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primary,
                                ),
                                child: Text('Button 4'),
                              ),
                            ),*/
                          ],
                        ),
                ),
                if (!_showReceiveCallPage)
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        'image/AidNow8.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_showReceiveCallPage) // Render the VerticalDivider only if _showReceiveCallPage is true
            const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 2,
            child: content(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: _showDiscussion ? 3 : 6,
                  child: ListView(
                    children: [
                      _voluntaryList(),
                    ],
                  ),
                ),
                if (_showReceiveCallPage) // Render the VerticalDivider only if _showReceiveCallPage is true
                  const Divider(thickness: 1, height: 1),
                Expanded(
                  flex: _showDiscussion ? 6 : 3,
                  child: _showDiscussion
                      ? Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Discussion',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(62, 99, 137, 1),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            messages[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentMessage = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Type your message here...',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      _sendMessage(_currentMessage);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(62, 99, 137, 1),
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                    child: Text('Send'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ),
                SizedBox(height: 20), // Add spacing between the widgets
                // Add the other three buttons here
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  Widget content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Map',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(62, 99, 137, 1)),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _currentPosition != null
                      ? LatLng(
                          _currentPosition!.latitude - 1.0651983,
                          _currentPosition!.longitude + 128.7245,
                        )
                      : const LatLng(28.0289837, 1.6666663),
                  zoom: zoom,
                  interactionOptions: const InteractionOptions(
                    flags: ~InteractiveFlag.doubleTapDragZoom,
                  ),
                ),
                children: [
                  openStreetMapTileLayer,
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition != null
                            ? LatLng(
                                _currentPosition!.latitude - 1.0651983,
                                _currentPosition!.longitude + 128.7245,
                              )
                            : const LatLng(28.0289837, 1.6666663),
                        width: 60,
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: const Icon(
                          Icons.location_pin,
                          size: 60,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _zoomIn,
                      backgroundColor: primary,
                      foregroundColor: Color.fromARGB(255, 205, 205, 205),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8.0),
                    FloatingActionButton(
                      onPressed: _zoomOut,
                      backgroundColor: primary,
                      foregroundColor: Color.fromARGB(255, 205, 205, 205),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiveCallPage extends StatelessWidget {
  final Widget endCallButton;

  const ReceiveCallPage(this.endCallButton, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(62, 99, 137, 1)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Name: John Doe',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Phone Number: 123-456-7890',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  Text(
                    'Blood Type: O+',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  Text(
                    'Age: 30',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  Text(
                    'Gender: Male',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  Text(
                    'Birthday: January 1, 1994',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  Text(
                    'Address: 123 Main St, City, Country',
                    style: TextStyle(
                        color: Colors.white), // Text color changed to white
                  ),
                  // Add more user information fields as needed...
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 4, // Number of columns in the grid
              crossAxisSpacing: 10, // Spacing between columns
              mainAxisSpacing: 10, // Spacing between rows
              shrinkWrap: true, // Wrap the grid inside SingleChildScrollView
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_police),
                  color: Colors.white,
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_fire_department),
                  color: Color.fromRGBO(62, 99, 137, 1),
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_hospital),
                  color: Colors.white,
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.report),
                  color: Color.fromRGBO(62, 99, 137, 1),
                  iconSize: 36,
                ),
              ],
            ),
            const SizedBox(height: 20),
            endCallButton,
          ],
        ),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
