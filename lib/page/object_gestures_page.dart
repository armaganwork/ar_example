import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

const chickenPath = "Models/Chicken_01/Chicken_01.gltf";
const f22Raptor = "Models/f22_raptor/scene.gltf";
const box = "Models/Box.gltf";

class ObjectGesturesWidget extends StatefulWidget {
  const ObjectGesturesWidget({super.key});
  @override
  _ObjectGesturesWidgetState createState() => _ObjectGesturesWidgetState();
}

class _ObjectGesturesWidgetState extends State<ObjectGesturesWidget> {
  /// ARSessionManager provides interactions callbacks to interact with real world.
  /// For example, detection of planes, surfaces. Tapping on the detected surfaces,
  /// adding nodes to that surfaces and so on.
  ARSessionManager? arSessionManager;

  /// ARObjectManager to manipulate 3D model. Provides some callback functions, related to rotation, pan etc.
  ARObjectManager? arObjectManager;

  /// ARSessionManager provides interactions callbacks to interact with real world.
  /// For example, detection of planes, surfaces. Tapping on the detected surfaces,
  /// adding nodes to that surfaces and so on.
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  List<String> selectedNode = [];

  ////////////////////////////////////////////////////////////////////////
  /// Scaling variables to manipulate scale feature.
  double sX = 0.2;
  double sY = 0.2;
  double sZ = 0.2;

  String selectedModel = chickenPath;

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Object Transformation Gestures')),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text("Selected Node: $selectedNode"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: CupertinoColors.systemGrey.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text("Scale"),
                                  IconButton.filled(
                                    onPressed: () {
                                      for (var node in nodes) {
                                        if (selectedNode[0] == node.name) {
                                          setState(() {
                                            sX = sX + sX * 0.02;
                                            sY = sY + sY * 0.02;
                                            sZ = sZ + sZ * 0.02;

                                            node.scale = Vector3(sX, sY, sZ);
                                          });
                                        }
                                      }
                                    },
                                    icon: const Icon(CupertinoIcons.add),
                                  ),
                                  IconButton.filled(
                                    onPressed: () {
                                      for (var node in nodes) {
                                        if (selectedNode[0] == node.name) {
                                          setState(() {
                                            sX = sX - sX * 0.02;
                                            sY = sY - sY * 0.02;
                                            sZ = sZ - sZ * 0.02;

                                            node.scale = Vector3(sX, sY, sZ);
                                          });
                                        }
                                      }
                                    },
                                    icon: const Icon(CupertinoIcons.minus),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 40,
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                              color: CupertinoColors.systemBrown,
                              onPressed: () {
                                for (var node in nodes) {
                                  if (node.name == selectedNode[0]) {
                                    arObjectManager?.removeNode(node);
                                  }
                                }
                                setState(() {
                                  selectedNode.clear();
                                });
                              },
                              child: const Text("Remove Selected Node"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      color: selectedModel == chickenPath ? CupertinoColors.systemBrown : CupertinoColors.black.withOpacity(0),
                                      onPressed: () {
                                        setState(() {
                                          selectedModel = chickenPath;
                                        });
                                      },
                                      child: const Text("Chicken"),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CupertinoButton(
                                      color: selectedModel == f22Raptor ? CupertinoColors.systemBrown : CupertinoColors.black.withOpacity(0),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          selectedModel = f22Raptor;
                                        });
                                      },
                                      child: const Text("F22 Raptor"),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CupertinoButton(
                                      color: selectedModel == box ? CupertinoColors.systemBrown : CupertinoColors.black.withOpacity(0),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          selectedModel = box;
                                        });
                                      },
                                      child: const Text("Box"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arObjectManager = arObjectManager;
    this.arSessionManager = arSessionManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager?.onInitialize(
          showFeaturePoints: true,
          showPlanes: false,
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: true,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );

    this.arSessionManager?.onPlaneOrPointTap = onPlaneOrPointTapped;

    this.arObjectManager?.onInitialize;
    this.arObjectManager?.onPanStart = onPanStarted;
    this.arObjectManager?.onPanChange = onPanChanged;
    this.arObjectManager?.onPanEnd = onPanEnded;
    this.arObjectManager?.onRotationStart = onRotationStarted;
    this.arObjectManager?.onRotationChange = onRotationChanged;
    this.arObjectManager?.onRotationEnd = onRotationEnded;
    this.arObjectManager?.onNodeTap = onNodeTap;
    this.arObjectManager?.onNodeTap = onNodeTap;
  }

  Future<void> onRemoveEverything() async {
    for (final anchor in anchors) {
      arAnchorManager?.removeAnchor(anchor);
    }
    anchors = [];
  }

  void onNodeTap(List<String> tappedNode) {
    setState(() {
      selectedNode = tappedNode;
    });
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    final singleHitTestResult = hitTestResults.firstWhere((hitTestResult) => hitTestResult.type == ARHitTestResultType.point);
    final newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager?.addAnchor(newAnchor);
    if (didAddAnchor!) {
      anchors.add(newAnchor);

      // Create node with the selected 3D model.
      final newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: selectedModel,
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      bool? didAddNodeToAnchor = await arObjectManager?.addNode(newNode, planeAnchor: newAnchor);

      if (didAddNodeToAnchor != null) {
        if (didAddNodeToAnchor) {
          nodes.add(newNode);
        } else {
          arSessionManager?.onError = onError;
        }
      } else {
        arSessionManager?.onError = onError;
      }
    }
  }

  onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    print(message);
  }

  onPanStarted(String nodeName) {
    print("Started panning node $nodeName");
  }

  onPanChanged(String nodeName) {
    print("Continued panning node $nodeName");
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node $nodeName");
    final pannedNode = nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node $nodeName");
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node $nodeName");
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node $nodeName");
    final rotatedNode = nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    rotatedNode.transform = newTransform;
  }

  // Uncomment the following command if you want to place plain object on the surface.
  // void onPlaneDetected(int data) {
  //   print("Received total number of Planes $data");
  // }
}
