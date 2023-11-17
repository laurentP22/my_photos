part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];
}

class PhotosLoaded extends PhotosEvent {}

class PhotosAdded extends PhotosEvent {
  const PhotosAdded({required this.photo});
  final Photo photo;
}

class PhotosDeleted extends PhotosEvent {
  const PhotosDeleted({required this.photo});
  final Photo photo;
}
