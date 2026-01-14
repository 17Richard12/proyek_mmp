import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:city_care/presentation/bloc/form/form_bloc.dart';
import 'package:city_care/presentation/bloc/form/form_event.dart';
import 'package:city_care/presentation/bloc/form/form_state.dart';
import 'package:city_care/domain/repositories/report_repository.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  group('FormBloc', () {
    late ReportRepository reportRepository;
    late FormBloc formBloc;

    setUp(() {
      reportRepository = MockReportRepository();
      formBloc = FormBloc(reportRepository);
    });

    test('initial state is FormInitial', () {
      expect(formBloc.state, FormInitial());
    });

    blocTest<FormBloc, FormState>(
      'emits [FormLoading, SuggestionLoaded] when SuggestionRequested is added',
      build: () {
        when(() => reportRepository.getAiSuggestion(any()))
            .thenAnswer((_) async => 'Fix the pothole');
        return formBloc;
      },
      act: (bloc) => bloc.add(const SuggestionRequested('Big hole in road')),
      expect: () => [
        FormLoading(),
        const SuggestionLoaded('Fix the pothole'),
      ],
    );

    blocTest<FormBloc, FormState>(
      'emits [FormLoading, FormFailure] when SuggestionRequested fails',
      build: () {
        when(() => reportRepository.getAiSuggestion(any()))
            .thenThrow(Exception('API Error'));
        return formBloc;
      },
      act: (bloc) => bloc.add(const SuggestionRequested('Big hole in road')),
      expect: () => [
        FormLoading(),
        const FormFailure('Failed to get AI suggestion'),
      ],
    );
  });
}
