part of 'photos_bloc.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object> get props => [];
}

class PhotosInitial extends PhotosState {}

class PhotosLoadInProgress extends PhotosState {}

class PhotosLoadSuccess extends PhotosState {
  const PhotosLoadSuccess({required this.photos});
  final List<Photo> photos;
}

class PhotosLoadFailure extends PhotosState {
  const PhotosLoadFailure({this.error = "PhotosFailure"});
  final String error;

  @override
  List<Object> get props => [error];
}
