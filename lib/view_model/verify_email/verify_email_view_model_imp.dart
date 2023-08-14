
import 'package:firebase_auth/firebase_auth.dart';
import '../../data_ref/users_ref.dart';
import 'verify_email_view_model.dart';

class VerifyEmailModelImp implements VerifyEmailViewModel{

  @override
  Future sendEmailVerification() async{
    return await sendEmailVerificationRef();
  }

  @override
  Future signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}