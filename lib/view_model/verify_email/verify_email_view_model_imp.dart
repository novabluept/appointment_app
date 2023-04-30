
import '../../data_ref/users_ref.dart';
import 'verify_email_view_model.dart';

class VerifyEmailModelImp implements VerifyEmailViewModel{
  @override
  Future sendEmailVerification() {
    return sendEmailVerificationRef();
  }


}