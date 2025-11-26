import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

// matrix widget
class MatrixWidget extends StatelessWidget {
  final List<List<TextEditingController>> controllers;
  final List<List<FocusNode>> focusNodes;

  MatrixWidget({required this.controllers, super.key})
    : focusNodes = controllers
          .map((row) => row.map((_) => FocusNode()).toList())
          .toList() {
    // add listeners for lose focus to each focus node
    for (int i = 0; i < focusNodes.length; i++) {
      for (int j = 0; j < focusNodes[i].length; j++) {
        focusNodes[i][j].addListener(() {
          if (!focusNodes[i][j].hasFocus) {
            // on lose focus, make sure it's not empty
            if (controllers[i][j].text.isEmpty) {
              controllers[i][j].text = '0';
            }
          }
        });
      }
    }

    // add listeners to each controller to multiply matrices on change
    for (int i = 0; i < controllers.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j].addListener(() {
          if (controllers[i][j].text.isNotEmpty) {
            multiplyMatrices();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: controllers.map((rowControllers) {
        return Row(
          children: rowControllers.map((controller) {
            return SizedBox(
              width: 50,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                focusNode:
                    focusNodes[controllers.indexOf(
                      rowControllers,
                    )][rowControllers.indexOf(controller)],
                textAlign: .center,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

// two instances of MatrixWidget side by side
MatrixWidget matrix1 = MatrixWidget(
  controllers: [
    [
      TextEditingController(text: '1'),
      TextEditingController(text: '2'),
      TextEditingController(text: '3'),
    ],
    [
      TextEditingController(text: '4'),
      TextEditingController(text: '5'),
      TextEditingController(text: '6'),
    ],
    [
      TextEditingController(text: '7'),
      TextEditingController(text: '8'),
      TextEditingController(text: '9'),
    ],
  ],
);

var matrix2 = MatrixWidget(
  controllers: [
    [
      TextEditingController(text: '9'),
      TextEditingController(text: '8'),
      TextEditingController(text: '7'),
    ],
    [
      TextEditingController(text: '6'),
      TextEditingController(text: '5'),
      TextEditingController(text: '4'),
    ],
    [
      TextEditingController(text: '3'),
      TextEditingController(text: '2'),
      TextEditingController(text: '1'),
    ],
  ],
);

// the result matrix widget
var resultMatrix = MatrixWidget(
  controllers: [
    [
      TextEditingController(text: '30'),
      TextEditingController(text: '24'),
      TextEditingController(text: '18'),
    ],
    [
      TextEditingController(text: '84'),
      TextEditingController(text: '69'),
      TextEditingController(text: '54'),
    ],
    [
      TextEditingController(text: '138'),
      TextEditingController(text: '114'),
      TextEditingController(text: '90'),
    ],
  ],
);

void multiplyMatrices() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int sum = 0;
      for (int k = 0; k < 3; k++) {
        if (matrix1.controllers[i][k].text.isEmpty || matrix2.controllers[k][j].text.isEmpty) {
          return;
        }
        int a = int.parse(matrix1.controllers[i][k].text);
        int b = int.parse(matrix2.controllers[k][j].text);
        sum += a * b;
      }
      resultMatrix.controllers[i][j].text = sum.toString();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart + Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Dart + Flutter Demo: Matrix Multiplication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            // row containing two matrices to be multiplied
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First matrix
                matrix1,
                const SizedBox(width: 20),
                const Text('x'),
                const SizedBox(width: 20),
                // Second matrix
                matrix2,
              ],
            ),
            const SizedBox(height: 20),
            const Text('Result:'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [resultMatrix],
            ),
          ],
        ),
      ),
    );
  }
}
