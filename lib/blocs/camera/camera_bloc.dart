import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_photos/utils/camera_utils.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraUtils cameraUtils;
  final ResolutionPreset resolutionPreset;
  final CameraLensDirection cameraLensDirection;

  CameraController _controller;

  CameraBloc({
    @required this.cameraUtils,
    this.resolutionPreset = ResolutionPreset.high,
    this.cameraLensDirection = CameraLensDirection.back,
  }) : super(CameraInitial());

  CameraController getController() => _controller;

  bool isInitialized() => _controller?.value?.isInitialized ?? false;

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is CameraInitialized)
      yield* _mapCameraInitializedToState(event);
    else if (event is CameraCaptured)
      yield* _mapCameraCapturedToState(event);
    else if (event is CameraStopped) yield* _mapCameraStoppedToState(event);
  }

  Stream<CameraState> _mapCameraInitializedToState(CameraInitialized event) async* {
    try {
      _controller = await cameraUtils
          .getCameraController(resolutionPreset, cameraLensDirection);
      await _controller.initialize();
      yield CameraReady();
    } on CameraException catch (error) {
      _controller?.dispose();
      yield CameraFailure(error: error.description);
    } catch (error) {
      yield CameraFailure(error: error.toString());
    }
  }

  Stream<CameraState> _mapCameraCapturedToState(CameraCaptured event) async* {
    if(state is CameraReady){
      yield CameraCaptureInProgress();
      try {
        final path = await cameraUtils.getPath();
        await _controller.takePicture(path);
        yield CameraCaptureSuccess(path);
      } on CameraException catch (error) {
        yield CameraCaptureFailure(error: error.description);
      }
    }
  }

  Stream<CameraState> _mapCameraStoppedToState(CameraStopped event) async* {
    _controller?.dispose();
    yield CameraInitial();
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
