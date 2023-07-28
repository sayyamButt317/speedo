import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../Controller/getxcontroller.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

const kGoogleApiKey = "AIzaSyCvyBRaARkJ7h9nNDFxWYuXXvAjBzpP0To";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  final Controller getxcontroller = Get.put<Controller>(Controller());
  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  bool showSourceField = false;
  Position? currentPosition;
  late LatLng destination;
  late LatLng source;
  late Uint8List markIcons;
  List<User> busList = [];
  int? arrival_time;
  String? distance;
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
  late GoogleMapController googleMapController;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: getxcontroller.markers,
            polylines: getxcontroller.polyline,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          buildCurrentLocationIcon(),
          buildCupertinoTextFieldForDestination(),
          buildSearchPeopleIcon(),
          showSourceField ? buildCupertinoTextFieldForSource() : Container(),
        ],
      ),
    );
  }

  Widget buildSearchPeopleIcon() {
    return Positioned(
      bottom: 100,
      right: 10,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Icon(LineAwesomeIcons.bus, color: Colors.red),
      ),
    );
  }

  buildCurrentLocationIcon() {
    return Positioned(
      bottom: 20,
      right: 55,
      child: FloatingActionButton(
        onPressed: () async {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          LatLng latLng = LatLng(position.latitude, position.longitude);
          googleMapController.animateCamera(CameraUpdate.newLatLng(latLng));

          // Update current location marker
          final currentLocationMarker = getxcontroller.markers.firstWhere(
            (marker) => marker.markerId == const MarkerId('current_location'),
            orElse: () => Marker(
              markerId: const MarkerId('current_location'),
              position: latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: const InfoWindow(
                title: 'Current Location',
                snippet: 'Your current location',
              ),
            ),
          );

          getxcontroller.markers.remove(currentLocationMarker);
          getxcontroller.markers.add(currentLocationMarker);
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.green),
      ),
    );
  }

  Widget buildCupertinoTextFieldForDestination() {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(0),
        ),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            String selectedPlace = await showGoogleAutoComplete();
            destinationController.text = selectedPlace;
            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);
            destination =
                LatLng(locations.first.latitude, locations.first.longitude);
            getxcontroller.markers.removeWhere(
              (marker) => marker.markerId == const MarkerId('destination'),
            );
            getxcontroller.markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: destination,
                icon: BitmapDescriptor.fromBytes(markIcons),
                infoWindow: InfoWindow(
                  title: 'Destination: $selectedPlace',
                ),
              ),
            );

            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14),
              ),
            );
            setState(() {
              showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xffA7A7A7),
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xffA7A7A7),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildCupertinoTextFieldForSource() {
    return Positioned(
      top: 95,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(0),
        ),
        child: TextFormField(
          controller: sourceController,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xffA7A7A7),
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Location',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xffA7A7A7),
            ),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                showSourceField = true;
              });
            } else {
              setState(() {
                showSourceField = false;
              });
            }
          },
          onTap: () async {
            String place = await showGoogleAutoComplete();
            sourceController.text = place;
            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(place);
            source =
                LatLng(locations.first.latitude, locations.first.longitude);
            if (getxcontroller.markers.length >= 2) {
              getxcontroller.markers.remove(getxcontroller.markers.last);
            }

            getxcontroller.markers.add(
              Marker(
                markerId: const MarkerId('source'),
                position: source,
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Starting Point: $place',
                ),
              ),
            );
            drawPolyline(place, destination);

            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14),
              ),
            );
            setState(() {});
          },
        ),
      ),
    );
  }

  void drawPolyline(String placeId, LatLng destination) async {
    getxcontroller.polyline.clear();
    getxcontroller.polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: Colors.green,
      width: 5,
    ));
    // Add destination marker
    getxcontroller.markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        infoWindow: const InfoWindow(
          title: 'Destination',
        ),
      ),
    );
    // Get directions
    await _getDirection();
  }

  // Update _getDirection method signature to accept source and destination parameters
  _getDirection() async {
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      getxcontroller.polyline.clear();
      getxcontroller.polyline.add(Polyline(
        polylineId: const PolylineId("polyline_id"),
        visible: true,
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));

      double distanceInMeters = Geolocator.distanceBetween(source.latitude,
          source.longitude, destination.latitude, destination.longitude);

      debugPrint('Distance: ${distanceInMeters / 1000} km'); // Convert to km
    }
  }

  Future<String> showGoogleAutoComplete() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: 'en',
      onError: onError,
      strictbounds: false,
      types: [""],
      components: [
        Component(Component.country, "pk"),
        Component(Component.country, "usa")
      ],
    );

    return p?.description ?? '';
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId ?? '');

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    getxcontroller.markers.clear();
    getxcontroller.markers.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  /* void findNearestUsers() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng userLocation1 =
        LatLng(position.latitude + 0.0045, position.longitude + 0.0045);
    User bus1 = User(
        id: '',
        Distance: '',
        Arrival: '',
        Route: "Railway - Bhatti",
        imagePath: 'images/man.png',
        latitude: userLocation1.latitude,
        longitude: userLocation1.longitude);

    LatLng userLocation2 =
        LatLng(position.latitude + 0.0055, position.longitude + 0.0055);
    User bus2 = User(
        id: '',
        Distance: '',
        Arrival: '',
        Route: "Railway - Bhatti",
        imagePath: 'images/man.png',
        latitude: userLocation2.latitude,
        longitude: userLocation2.longitude);

    LatLng userLocation3 =
        LatLng(position.latitude + 0.0025, position.longitude + 0.0025);
    User bus3 = User(
        id: '',
        Distance: '',
        Arrival: '',
        Route: "Railway - Bhatti",
        imagePath: 'images/man.png',
        latitude: userLocation3.latitude,
        longitude: userLocation3.longitude);

    final marker = [bus1, bus2, bus3]
        .map((user) async => Marker(
              markerId: MarkerId(user.id.toString()),
              position: LatLng(user.latitude, user.longitude),
              icon: BitmapDescriptor.fromBytes(markIcons),
              infoWindow: InfoWindow(
                title: user.Route,
                snippet: '${user.id}, ${user.Arrival},${user.Distance}',
              ),
            ))
        .toList();

    final markersToAdd = await Future.wait(marker);

    getxcontroller.markers.clear();
    busList.addAll([bus1, bus2, bus3]);
    getxcontroller.markers.addAll(markersToAdd);
  } */

  //Custom marker
  loadCustomMarker() async {
    markIcons = await loadAsset('images/placeholder.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
