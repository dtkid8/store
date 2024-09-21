import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/auth/user.dart';

class AuthCubit extends Cubit<GenericState> {
  final AuthRepository repository;
  User _user = User(email: "");
  User get user => _user;
  AuthCubit({
    required this.repository,
  }) : super(GenericInitializeState());

  void register({required String password, required String email}) async {
    emit(GenericLoadingState());
    final result = await repository.register(email: email, password: password);
    result.fold((l) {
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) {
      emit(GenericActionLoadedState(
          message: r ? "Succes Register $email" : "Fail Register $email"));
    });
  }

  void login({required String password, required String email}) async {
    emit(GenericLoadingState());
    final result = await repository.login(email: email, password: password);
    final user = User(email: email);
    result.fold((l) {
      print("data ${l.errorMessage}");
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) async {
      print("data ${r}");
      final addUser = await repository.addUser(user: user);
      addUser.fold((l) {
        emit(GenericErrorState(errorMessage: l.errorMessage));
      }, (r) {
        _user = user;
        emit(GenericLoadedState(data: _user));
      });
    });
  }

  void check() async {
    final result = await repository.getUser();
    result.fold((l) {
      emit(GenericErrorState(errorMessage: l.errorMessage));
      emit(GenericInitializeState());
    }, (r) {
      _user = r;
      emit(GenericLoadedState(data: _user));
    });
  }

  void logout() async {
    final result = await repository.logout();
    result.fold((l) {
      print("data ${l.errorMessage}");
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) {
      print("data $r");
      emit(GenericInitializeState());
    });
  }
}
