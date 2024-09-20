import 'package:equatable/equatable.dart';

abstract class GenericState extends Equatable {
  @override
  List<Object> get props => [];
}

class GenericInitializeState extends GenericState {}

class GenericLoadingState extends GenericState {}

class GenericErrorState extends GenericState {
  final String errorMessage;
  GenericErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GenericActionLoadedState extends GenericState {
  final String message;
  GenericActionLoadedState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class GenericLoadedState<T> extends GenericState {
  final T data;
  GenericLoadedState({
    required this.data,
  });

  @override
  List<Object> get props => [data as Object];
}
