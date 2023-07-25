import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import 'payment_configurations.dart' as payment_configurations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  late final Pay _payClient;

  @override
  void initState() {
// When you are ready to load your configuration
    _payClient = Pay({
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
          payment_configurations.defaultApplePay),
    });

    var res = _payClient
        .userCanPay(PayProvider.apple_pay)
        .then((value) => print(value));
    print("----------------------------------------------------");
    print(res.toString());
    print("----------------------------------------------------");

    super.initState();
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Yalla tour Shop'),
        ),

        // backgroundColor: Colors.blue,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: Column(
            children: [
              Container(
                height: 200,
                color: Colors.green,
              ),
              Container(
                color: Colors.red,
                child: // Example pay button configured using a string
                    ApplePayButton(
                  paymentConfiguration: PaymentConfiguration.fromJsonString(
                      payment_configurations.defaultApplePay),
                  paymentItems: _paymentItems,
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onApplePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Container(
                color: Colors.amber,
                height: 200,
              ),
            ],
          ),
        ));
  }
}
