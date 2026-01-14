import 'package:equatable/equatable.dart';
import 'package:city_care/domain/entities/report.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
  @override
  List<Object> get props => [];
}

class SuggestionRequested extends FormEvent {
  final String description;
  const SuggestionRequested(this.description);
}

class LocationRequested extends FormEvent {}

class SubmitReport extends FormEvent {
  final Report report;
  const SubmitReport(this.report);
}
