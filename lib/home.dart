import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbRef = FirebaseDatabase.instance.reference();
  String text = "Locker is securely Locked!";
  String val = "";
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  bool? _canCheckBiometrics;
  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    readData();
    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Smart Locker System"),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('OPEN'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey, primary: Colors.black),
                  onPressed: () {
                    dbRef.child("LOCKER_STATUS").set("ON");
                    setState(() {
                      text = "Locker is Open";
                    });
                  },
                ),
                TextButton(
                  child: const Text('CLOSE'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey, primary: Colors.black),
                  onPressed: () {
                    dbRef.child("LOCKER_STATUS").set("OFF");
                    setState(() {
                      text = "Locker is Securely Locked!";
                    });
                  },
                ),
              ],
            ),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ));
  }

  readData() async {
    dbRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
    String value = (await dbRef.child("LOCKER_STATUS").once()).value();
    setState(() {
      val = value;
    });
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
