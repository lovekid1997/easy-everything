import 'package:easy_everything/rounded_loading_button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyExample(),
    );
  }
}

class MyExample extends StatelessWidget {
  final RoundedLoadingButtonGradientController controller =
      RoundedLoadingButtonGradientController();

  final duration = 800;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: RoundedLoadingButtonGradient(
                controller: controller,
                disableButton: false,
                durationAnimation: duration,
                widgetLoading: SpinKitSquareCircle(
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () async {
                  controller.start();
                  await fetchData();
                  controller.error(); // or success
                  await Future.delayed(Duration(milliseconds: duration));
                  controller.stop();
                },
                iconRight: Icons.ac_unit,
                iconLeft: Icons.add,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }
}
