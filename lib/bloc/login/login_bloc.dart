import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_strapi_ecomm/data/datasources/auth_remote_datasource.dart';

import '../../data/models/login_request_model.dart';
import '../../data/models/responses/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource datasource;
  LoginBloc(
    this.datasource,
  ) : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      emit(LoginLoading());
      final result = await datasource.login(event.model);
      result.fold(
        (l) => emit(LoginError()),
        (r) => emit(LoginLoaded(model: r)),
      );
    });
  }
}
