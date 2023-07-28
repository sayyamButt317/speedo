import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Controller/getxcontroller.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  String cardNumber = "";
  final Controller getxcontroller = Get.put<Controller>(Controller());
  bool showQrCode = false;

  String generateCardNumber() {
    for (int i = 0; i < 8; i++) {
      cardNumber += Random().nextInt(10).toString();
    }
    return cardNumber;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tracking',
            style: GoogleFonts.getFont("Lato"),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            "Current Balance: ${getxcontroller.balance.value}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 160,
                      right: 20,
                      left: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/metrobus.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    showQrCode = !showQrCode;
                  });
                },
                color: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("images/qrcode.png", width: 30),
                    const Spacer(),
                    const Text(
                      "Scan",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Visibility(
                visible: showQrCode,
                child: Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 200.0,
                      width: 200.0,
                      child: QrImageView(
                        data: cardNumber,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
