import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  const FormState();
  @override
  List<Object?> get props => [];
}

class FormInitial extends FormState {}
class FormLoading extends FormState {}
class FormSuccess extends FormState {}
class FormFailure extends FormState {
  final String message;
  const FormFailure(this.message);
  @override
  List<Object> get props => [message];
}
class SuggestionLoaded extends FormState {
  final String suggestion;
  const SuggestionLoaded(this.suggestion);
  @override
  List<Object> get props => [suggestion];
}
class LocationLoaded extends FormState {
  final double latitude;
  final double longitude;
  const LocationLoaded(this.latitude, this.longitude);
  @override
  List<Object> get props => [latitude, longitude];
}
