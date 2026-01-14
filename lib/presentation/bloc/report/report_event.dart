import 'package:equatable/equatable.dart';
import 'package:city_care/domain/entities/report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object> get props => [];
}

class LoadReports extends ReportEvent {}
class LoadDrafts extends ReportEvent {}
