import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey/data/survey_repo.dart';
part 'post_survey_event2.dart';
part 'post_survey_state2.dart';

class PostSurvey2Bloc extends Bloc<PostSurvey2Event, PostSurvey2State> {
  PostSurvey2Bloc(Function postFunction, Map<String, String> headers)
      : super(PostSurvey2Initial()) {
    on<PostSurvey2EventRequested>((event, emit) async {
      emit(PostSurvey2InProgress());
      try {
        var response = await postFunction();
        emit(PostSurvey2Success(data: response));
      } catch (e) {
        emit(PostSurvey2Failed());
      }
    });
  }
}