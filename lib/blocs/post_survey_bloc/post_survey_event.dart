part of 'post_survey_bloc.dart';

@immutable
abstract class PostSurveyEvent {}

class PostSurveyEventRequested extends PostSurveyEvent {
  final dynamic body;
  PostSurveyEventRequested({this.body});
}
