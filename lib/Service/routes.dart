import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../Service/search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  int? selectedRouteIndex;
  var routes = [
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Routes',
          style: GoogleFonts.getFont('Lato'),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/map.png"), fit: BoxFit.cover),
        ),
        child: ListWheelScrollView(
          itemExtent: 100,
          children: routes
              .asMap()
              .entries
              .map(
                (entry) => GestureDetector(
                  onTap: () {
                    splitSelectedRoute(entry.key);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: ScreenUtil().setWidth(5.0),
                        ),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.getFont('Cinzel',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void splitSelectedRoute(int index) {
    List<String> splitRoute = routes[index].split(":");
    destinationController.text = splitRoute[1].trim();
    sourceController.text = splitRoute[0].trim();
    selectedRouteIndex = index;
    Get.to(
      () => const SearchPlacesScreen(),
    );
  }
}
