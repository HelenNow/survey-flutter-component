part of 'survey_bloc.dart';

@immutable
abstract class SurveyState {}

class SurveyInitial extends SurveyState {}

class SurveyInProgress extends SurveyState {}

class SurveySuccess extends SurveyState {
  var data;
  SurveySuccess({this.data});
}

class SurveyFailed extends SurveyState {}
