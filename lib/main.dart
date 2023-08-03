import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _deviceModel = "permission";
  String _alarmModel = "ask alarm";
  int _argsModel = 123;

  static const platformChannel = MethodChannel('com.gama.applePay/native');
  @override
  void initState() {
    super.initState();
  }

  Future getNativeCodeMethod() async {
    String model;
    try {
      // 1
      final String result = await platformChannel.invokeMethod('getNativeCode');

      // 2
      model = result;
    } catch (e) {
      // 3
      model = "Can't fetch the method: '$e'.";
    }

    // 4
    setState(() {
      _deviceModel = model;
    });
  }

  Future getAlarmNativeCodeMethod() async {
    String model;
    try {
      // 1
      final String result =
          await platformChannel.invokeMethod('getNativeAlarmCode');

      // 2
      model = result;
    } catch (e) {
      // 3
      model = "Can't fetch the method: '$e'.";
    }

    // 4
    setState(() {
      _alarmModel = model;
    });
  }

  Future getArgsNativeCodeMethod() async {
    int model;
    try {
      // 1

      final arguments = {"number": _argsModel};
      final int result =
          await platformChannel.invokeMethod('getNativeArgsCode', arguments);

      // 2
      model = result;
    } catch (e) {
      // 3
      model = -1;
    }

    // 4
    setState(() {
      _argsModel = model;
    });
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
                child: Column(
              children: [
                MaterialButton(
                    child: Container(
                        color: Colors.amber, child: Text(_deviceModel)),
                    onPressed: getNativeCodeMethod),
                SizedBox(
                  height: 80,
                ),
                MaterialButton(
                    child: Container(
                        color: Colors.amber, child: Text(_alarmModel)),
                    onPressed: getAlarmNativeCodeMethod),
                SizedBox(
                  height: 80,
                ),
                MaterialButton(
                    child: Container(
                        color: Colors.amber, child: Text("$_argsModel")),
                    onPressed: getArgsNativeCodeMethod),
              ],
            ))));
  }
}
