import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hkun/services/auth_service.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  final _authService = AuthService();
  final _storage = GetStorage();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      yield AuthLoading();
      if (event is AuthInitialize) {
        final credentials = _storage.read('credentials');
        if (credentials != null) {
          final alreadyLoggedIn = await _authService.isLoggedIn();
          print(alreadyLoggedIn);
          if (!alreadyLoggedIn) {
            add(AuthLogin(credentials['email'], credentials['password']));
          } else {
            yield AuthLoginSuccess();
          }
        } else {
          yield AuthInitial();
        }
      }

      if (event is ShowNews) {
        yield ShowNewsScreen();
      }

      if (event is ShowHkun) {
        yield ShowHkunScreen();
      }

      if (event is AuthLogin) {
        final result = await _authService.signIn(event.email, event.password);
        if (result) {
          _storage.write('credentials', {
            'email': event.email,
            'password': event.password,
          });
          yield AuthLoginSuccess();
        } else {
          yield AuthError('Email or password is incorrect');
        }
      }

      if (event is AuthLogout) {
        await _authService.signOut();
        yield AuthLogoutSuccess();
      }
    } catch (e) {
      yield AuthError(e.toString());
    }
  }
}
