import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey/data/survey_repo.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc(String getUrl, Map<String, String> headers) : super(SurveyInitial()) {
    on<SurveyEventRequested>((event, emit) async {
      emit(SurveyInProgress());
      try {
        var response =
            await APIRequestSurvey.getSurveyQuestions(event.scrg, getUrl, headers,);
        emit(SurveySuccess(data: response));
      } catch (e) {
        emit(SurveyFailed());
      }
    });
  }
}
