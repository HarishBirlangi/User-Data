part of 'internet_access_bloc.dart';

abstract class InternetAccessEvent extends Equatable {
  const InternetAccessEvent();

  @override
  List<Object> get props => [];
}

class InternetAccessObserveEvent extends InternetAccessEvent {}

class InternetAccessNotifyEvent extends InternetAccessEvent {
  final bool isConnected;

  const InternetAccessNotifyEvent({this.isConnected = false});
}
