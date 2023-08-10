part of 'survey_bloc.dart';

@immutable
abstract class SurveyEvent {}

class SurveyEventRequested extends SurveyEvent {
  final dynamic scrg;
  SurveyEventRequested({this.scrg});
}
