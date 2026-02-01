import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserDatasource datasource;

  UserBloc({required this.datasource}) : super(const UserInitial()) {
    on<FetchUser>(_onFetchUser);
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    try {
      final data = await datasource.getUsers();
      emit(UserLoaded(data));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
