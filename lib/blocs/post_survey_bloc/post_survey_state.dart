part of 'post_survey_bloc.dart';

@immutable
abstract class PostSurveyState {}

class PostSurveyInitial extends PostSurveyState {}

class PostSurveyInProgress extends PostSurveyState {}

class PostSurveySuccess extends PostSurveyState {
  final dynamic data;
  PostSurveySuccess({this.data});
}

class PostSurveyFailed extends PostSurveyState {}
