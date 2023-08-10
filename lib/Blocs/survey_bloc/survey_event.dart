part of 'survey_bloc.dart';

@immutable
abstract class SurveyEvent {}

class SurveyEventRequested extends SurveyEvent {
  var scrg;
  SurveyEventRequested({this.scrg});
}
