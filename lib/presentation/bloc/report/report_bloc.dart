import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_care/domain/repositories/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    on<LoadReports>(_onLoadReports);
  }

  Future<void> _onLoadReports(
      LoadReports event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final reports = await repository.getReports();
      final drafts = await repository.getDrafts();
      emit(ReportLoaded(reports, drafts));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
