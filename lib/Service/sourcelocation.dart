import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Controller/getxcontroller.dart';

class Mapsourcelocation extends StatefulWidget {
  const Mapsourcelocation({
    Key? key,
  }) : super(key: key);

  @override
  State<Mapsourcelocation> createState() => _MapsourcelocationState();
}

class _MapsourcelocationState extends State<Mapsourcelocation> {
  final Controller getxcontroller = Get.put<Controller>(Controller());

  List<String> routes = [
    "Route 1:Railway station - Bhatti chowk",
    "Route 2:SamnabadMor - Bhatti chowk",
    "Route 3:Railwaystation - Shahdara Lari-Adda",
    "Route 4:R.A. Bazar - Chungi Amar Sidhu",
    "Route 5:Shad Bagh Underpass - Bhatti chowk",
    "Route 6:Babu Sabu - Raj Garh Chowk",
    "Route 7:Bagrian - Chungi Amar Sidhu",
    "Route 8:Doctor Hospital - Canal",
    "Route 9:Railway Station - Sham Nagar",
    "Route 10:Multan Chungi - Qartaba Chowk",
    "Route 11:Babu Sabu - Main Market Gulberg",
    "Route 12:R.A Bazar - Civil Secretariat",
    "Route 13:Bagrian - Kalma Chowk",
    "Route 14:R.A Bazar - Chungi Amar Sidhu",
    "Route 15:Qartba Chowk - Babu Sabu",
    "Route 16:Railway Station - Bhatti Chowk",
    "Route 17:Canal - Railway Station",
    "Route 18:Bhatti Chowk - Shimla Pahari",
    "Route 19:Main Market - Bhatti Chowk",
    "Route 20:Jain Mandar - Chowk Yateem Khana",
    "Route 21:Depot Chowk - Thokar Niaz Baig",
    "Route 22:Depot Chowk - Thokar Niaz  Baig",
    "Route 23:Valencia - Thokar Niaz Baig",
    "Route 24:Multan Chungi - Ghazi Chowk",
    "Route 25:R.A Bazar - Railway Station",
    "Route 26:R.A Bazar - Daroghawala",
    "Route 27:BataPur - Daroghawala",
    "Route 28:Quaid e Azam Interchange - Airport",
    "Route 29:Niazi Interchange - Salamat Pura",
    "Route 30:Daroghawala - Airport",
    "Route 31:Daroghawala - Lari Adda",
    "Route 32:Shimla Pahari - Ek Moriya",
    "Route 33:Cooper Store - Mughalpura",
    "Route 34:Singhpura - Mughalpura",
  ];

  @override
  Widget build(BuildContext context) {
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
        child: FormBuilderDropdown(
          name: 'Routes',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Choose Your Route',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xffA7A7A7),
            ),
            border: InputBorder.none,
          ),
          initialValue: null,
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Choose Your Route'),
            ),
            ...routes.map((language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
          ],
          onChanged: (value) {
            if (value != null) {
              getxcontroller.selectedRoute.value = value;
              displayMarkersForSelectedRoute(value);
            }
          },
        ),
      ),
    );
  }

  void displayMarkersForSelectedRoute(String? selectedRoute) async {
    getxcontroller.markers.clear();
    getxcontroller.polyline.clear();

    List<Marker> markers = [];
    List<LatLng> polylinePoints = [];

    if (selectedRoute != null) {
      if (selectedRoute.startsWith('Route ')) {
        int? routeNumber = int.tryParse(selectedRoute.substring(6));
        if (routeNumber != null && routeNumber >= 1 && routeNumber <= 34) {
          List<LatLng> markerLatLngs = getMarkerLatLngsForRoute(routeNumber);

          for (LatLng latLng in markerLatLngs) {
            markers.add(
              Marker(
                markerId: MarkerId(latLng.toString()),
                position: latLng,
                infoWindow: InfoWindow(title: latLng.toString()),
                onTap: () {},
              ),
            );
          }

          polylinePoints = markerLatLngs;
        }
      }
    }

    setState(() {
      getxcontroller.markers.addAll(markers);

      if (polylinePoints.isNotEmpty) {
        getxcontroller.polyline.add(
          Polyline(
            polylineId: const PolylineId("Route"),
            visible: true,
            points: polylinePoints,
            color: Colors.blue,
            width: 5,
          ),
        );
      }
    });

    if (polylinePoints.isNotEmpty) {
      List<LatLng> updatedPolylinePoints = await getDirections(polylinePoints);
      if (updatedPolylinePoints.isNotEmpty) {
        setState(() {
          polylinePoints = updatedPolylinePoints;
          getxcontroller.polyline.add(
            Polyline(
              polylineId: const PolylineId("Route"),
              visible: true,
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    }
  }

  List<LatLng> getMarkerLatLngsForRoute(int routeNumber) {
    switch (routeNumber) {
      case 1:
        return [
          const LatLng(31.577520864960405, 74.3366289138794),
          const LatLng(31.5819378, 74.3208949),
          const LatLng(31.335837826204635, 74.19852197170258),
          const LatLng(31.5865905, 74.3208949),
          const LatLng(31.593470183988373, 74.31752680822605),
          const LatLng(31.588734189484295, 74.30673369055481),
          const LatLng(31.475423367412965, 74.24245655536652),
        ];
      // Add cases for other route numbers if needed
      default:
        return [];
    }
  }

  Future<List<LatLng>> getDirections(List<LatLng> waypoints) async {
    List<LatLng> polylinePoints = [];
    // Implement logic to retrieve directions between waypoints if needed
    return polylinePoints;
  }
}
