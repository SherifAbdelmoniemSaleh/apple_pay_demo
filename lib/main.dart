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
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  late final Pay _payClient;
  bool canPay = false;
  bool payDone = false;

  @override
  void initState() {
    _payClient = Pay({
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
          payment_configurations.defaultApplePay),
    });

    _payClient.userCanPay(PayProvider.apple_pay).then((value) => {
          setState(() {
            canPay = value;
          })
        });

    super.initState();
  }

  void onApplePayResult(paymentResult) {
    if (paymentResult != null) {
      setState(() {
        payDone = true;
      });
    }
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Apple payment demo'),
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: canPay
                    ? payDone
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  " Payment completed successfully",
                                  style: TextStyle(fontSize: 18),
                                ),
                                MaterialButton(
                                  child: Container(
                                      color: Colors.black,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Reload payment",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      payDone = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : ApplePayButton(
                            paymentConfiguration:
                                PaymentConfiguration.fromJsonString(
                                    payment_configurations.defaultApplePay),
                            paymentItems: _paymentItems,
                            style: ApplePayButtonStyle.black,
                            type: ApplePayButtonType.buy,
                            margin: const EdgeInsets.all(15.0),
                            height: 60,
                            width: 300,
                            onPaymentResult: onApplePayResult,
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                    : const Text(
                        "User can not pay on this device due to \n * Unsupported region \n * No wallet \n * Other unknown reason from apple",
                        style: TextStyle(fontSize: 18),
                      ))));
  }
}
