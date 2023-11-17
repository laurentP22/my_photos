import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_photos/utils/camera_utils.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraUtils cameraUtils;
  final ResolutionPreset resolutionPreset;
  final CameraLensDirection cameraLensDirection;

  CameraController? _controller;

  CameraBloc({
    required this.cameraUtils,
    this.resolutionPreset = ResolutionPreset.high,
    this.cameraLensDirection = CameraLensDirection.back,
  }) : super(CameraInitial()) {
    on<CameraInitialized>((event, emit) async {
      try {
        _controller = await cameraUtils.getCameraController(resolutionPreset, cameraLensDirection);
        await _controller?.initialize();
        emit(CameraReady());
      } on CameraException catch (error) {
        _controller?.dispose();
        emit(CameraFailure(error: error.description ?? ''));
      } catch (error) {
        emit(CameraFailure(error: error.toString()));
      }
    });

    on<CameraCaptured>((event, emit) async {
      if (state is CameraReady) {
        emit(CameraCaptureInProgress());
        try {
          XFile? photo = await _controller?.takePicture();
          if (photo != null) {
            emit(CameraCaptureSuccess(photo.path));
          }
        } on CameraException catch (error) {
          emit(CameraCaptureFailure(error: error.description ?? ''));
        }
      }
    });

    on<CameraStopped>((event, emit) async {
      _controller?.dispose();
      emit(CameraInitial());
    });
  }

  CameraController getController() => _controller!;

  bool isInitialized() => _controller?.value.isInitialized ?? false;

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
