import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_photos/data/providers/photo_provider.dart';
import 'package:my_photos/models/photo.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc({
    required this.photoProvider,
  }) : super(PhotosInitial()) {
    on<PhotosLoaded>((event, emit) async {
      emit(PhotosLoadInProgress());

      try {
        final photos = await photoProvider.loadPhotos();
        emit(PhotosLoadSuccess(photos: photos));
      } on Exception catch (error) {
        emit(PhotosLoadFailure(error: error.toString()));
      }
    });

    on<PhotosAdded>((event, emit) async {
      if (state is PhotosLoadSuccess) {
        final photos = List<Photo>.from((state as PhotosLoadSuccess).photos)..add(event.photo);
        emit(PhotosLoadInProgress());

        try {
          await photoProvider.addPhoto(event.photo);
          emit(PhotosLoadSuccess(photos: photos));
        } on Exception catch (error) {
          emit(PhotosLoadFailure(error: error.toString()));
        }
      }
    });

    on<PhotosDeleted>((event, emit) async {
      if (state is PhotosLoadSuccess) {
        final photos = List<Photo>.from((state as PhotosLoadSuccess).photos)..remove(event.photo);
        emit(PhotosLoadInProgress());

        try {
          await photoProvider.deletePhoto(event.photo);
          emit(PhotosLoadSuccess(photos: photos));
        } on Exception catch (error) {
          emit(PhotosLoadFailure(error: error.toString()));
        }
      }
    });
  }

  final PhotoProvider photoProvider;
}
