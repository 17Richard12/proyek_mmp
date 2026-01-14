import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_care/domain/repositories/report_repository.dart';
import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ReportRepository repository;

  FormBloc(this.repository) : super(FormInitial()) {
    on<SuggestionRequested>(_onSuggestionRequested);
    on<LocationRequested>(_onLocationRequested);
    on<SubmitReport>(_onSubmitReport);
  }

  Future<void> _onSuggestionRequested(SuggestionRequested event, Emitter<FormState> emit) async {
    emit(FormLoading());
    try {
      final suggestion = await repository.getAiSuggestion(event.description);
      emit(SuggestionLoaded(suggestion));
    } catch (e) {
      emit(FormFailure("Failed to get AI suggestion"));
    }
  }

  Future<void> _onLocationRequested(LocationRequested event, Emitter<FormState> emit) async {
    emit(FormLoading());
    try {
      final location = await repository.getCurrentLocation();
      emit(LocationLoaded(location['latitude']!, location['longitude']!));
    } catch (e) {
      emit(FormFailure("Failed to get location"));
    }
  }

  Future<void> _onSubmitReport(SubmitReport event, Emitter<FormState> emit) async {
    emit(FormLoading());
    try {
      await repository.saveReport(event.report);
      emit(FormSuccess());
    } catch (e) {
      emit(FormFailure("Failed to save report"));
    }
  }
}
