import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_photos/blocs/camera/camera_bloc.dart';
import 'package:my_photos/keys.dart';
import 'package:my_photos/widgets/error.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<CameraBloc>(context);

    // App state changed before we got the chance to initialize.
    if (!bloc.isInitialized()) return;

    if (state == AppLifecycleState.inactive)
      bloc.add(CameraStopped());
    else if (state == AppLifecycleState.resumed) bloc.add(CameraInitialized());
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CameraBloc, CameraState>(
      builder: (_, state) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(title: Text("Camera")),
            body: BlocListener<CameraBloc, CameraState>(
                listener: (_, state) {
                  if (state is CameraCaptureSuccess)
                    Navigator.of(context).pop(state.path);
                  else if (state is CameraCaptureFailure)
                    Scaffold.of(context).showSnackBar(SnackBar(
                      key: MyPhotosKeys.errorSnackBar,
                      content: Text(state.error),
                    ));
                },
                child: state is CameraReady
                    ? Container(
                        key: MyPhotosKeys.cameraPreviewScreen,
                        child: CameraPreview(
                            BlocProvider.of<CameraBloc>(context)
                                .getController()))
                    : state is CameraFailure
                        ? Error(
                            key: MyPhotosKeys.errorScreen, message: state.error)
                        : Container(
                            key: MyPhotosKeys.emptyContainerScreen,
                          )),
            floatingActionButton: state is CameraReady
                ? FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: () => BlocProvider.of<CameraBloc>(context)
                        .add(CameraCaptured()),
                  )
                : Container(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ));
}
