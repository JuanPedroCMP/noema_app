import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/auth/services/sign_up_service.dart';

class SignUpController extends AsyncNotifier<void>{
  @override
  Future<void> build() async {}

  Future<void> createUser({
    required String userName,
    required String email,
    required String password,
    required String displayName,
  })

  async {
    final service = ref.read(signUpServiceProvider);

    state = await AsyncValue.guard(() => service.createUser(
          userName: userName,
          email: email,
          password: password,
          displayName: displayName,
        ));
  }
}

final signUpControllerProvider = AsyncNotifierProvider<SignUpController, void>(SignUpController.new);

// TODO analizar e aprender com todo esse código

