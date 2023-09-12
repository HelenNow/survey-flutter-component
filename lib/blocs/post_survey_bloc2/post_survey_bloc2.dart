import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'post_survey_event2.dart';
part 'post_survey_state2.dart';

class PostSurvey2Bloc extends Bloc<PostSurvey2Event, PostSurvey2State> {
  PostSurvey2Bloc(Function postFunction) : super(PostSurvey2Initial()) {
    on<PostSurvey2EventRequested>((event, emit) async {
      emit(PostSurvey2InProgress());
      try {
        var response = await postFunction(event.body);
        emit(PostSurvey2Success(data: response));
      } catch (e) {
        emit(PostSurvey2Failed());
      }
    });
  }
}
