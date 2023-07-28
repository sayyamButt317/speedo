import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Controller extends GetxController {
  var isprofileloading = false.obs;
  RxInt activeIndex = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedRoute = ''.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polyline = <Polyline>{}.obs;
  RxInt balance = 100.obs;
  RxString? cardholdername;
  RxString? cardnumber;
}
