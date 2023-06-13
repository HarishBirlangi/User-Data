part of 'internet_access_bloc.dart';

abstract class InternetAccessState extends Equatable {
  const InternetAccessState();

  @override
  List<Object> get props => [];
}

class InternetAccessInitialState extends InternetAccessState {}

class InternetAccessSuccessState extends InternetAccessState {}

class InternetAccessFailureState extends InternetAccessState {}
