import 'package:flutter/material.dart';

import 'page/object_gestures_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _title = 'AR Plugin Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ExampleList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  const ExampleList({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = [
      ObjectModel(
        'Object Transformation Gestures',
        'Rotate, Pan and Scale objects.',
        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ObjectGesturesWidget())),
      ),
    ];
    return ListView(
      children: examples.map((example) => Model3DItem(example: example)).toList(),
    );
  }
}

class Model3DItem extends StatelessWidget {
  const Model3DItem({super.key, required this.example});
  final ObjectModel example;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          example.onTap();
        },
        child: ListTile(
          title: Text(example.name),
          subtitle: Text(example.description),
        ),
      ),
    );
  }
}

class ObjectModel {
  const ObjectModel(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

// import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Model Viewer')),
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height - kToolbarHeight,
//           child: const ModelViewer(
//             src: 'assets/Astronaut.glb',
//             ar: true,
//             // backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//             // alt: 'A 3D model of an astronaut',
//             // arModes: ['scene-viewer', 'webxr', 'quick-look'],
//             // autoRotate: false,
//             // // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
//             // disableZoom: false,
//             // cameraControls: true,
//             // disablePan: false,
//           ),
//         ),
//       ),
//     );
//   }
// }
