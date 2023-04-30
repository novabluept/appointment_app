
import '../../data_ref/users_ref.dart';
import 'forgot_password_view_model.dart';

class ForgotPasswordModelImp implements ForgotPasswordViewModel{

  @override
  Future sendPasswordResetEmail(String email) {
    return sendPasswordResetEmailRef(email);
  }

}