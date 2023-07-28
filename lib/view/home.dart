import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../Service/search.dart';
import 'setting.dart';
import '../Controller/getxcontroller.dart';
import '../Service/payment.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Controller getxcontroller = Get.put<Controller>(Controller());
  final Widget _mySetting = const Setting();
  final Widget _myRoutes = const SearchPlacesScreen();
  final Widget _myPayment = const Payment();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => getBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: getxcontroller.selectedIndex.value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.route_rounded),
            label: "Routes",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.credit_card),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user_circle),
            label: "Setting",
          ),
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (getxcontroller.selectedIndex.value == 0) {
      return _myRoutes;
    } else if (getxcontroller.selectedIndex.value == 1) {
      return _myPayment;
    } else if (getxcontroller.selectedIndex.value == 2) {
      return _mySetting;
    } else {
      return _myRoutes;
    }
  }

  void onTapHandler(int index) {
    getxcontroller.selectedIndex.value = index;
  }
}
