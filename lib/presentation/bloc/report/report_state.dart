import 'package:equatable/equatable.dart';
import 'package:city_care/domain/entities/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}
class ReportLoading extends ReportState {}
class ReportLoaded extends ReportState {
  final List<Report> reports;
  final List<Report> drafts;
  const ReportLoaded(this.reports, this.drafts);
  @override
  List<Object> get props => [reports, drafts];
}
class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);
  @override
  List<Object> get props => [message];
}
