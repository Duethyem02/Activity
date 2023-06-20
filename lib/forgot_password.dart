import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:activity_point_monitoring_project/utils/utils.dart';
import 'package:activity_point_monitoring_project/widgets/round_button.dart';
import 'package:email_validator/email_validator.dart';


class ForgotPasswordScreen extends StatefulWidget {
   ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController =TextEditingController();
  final auth = FirebaseAuth.instance ;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  hintText: 'Email'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            SizedBox(height: 40,),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),),
                icon: Icon(Icons.email_outlined),
                label: Text('Reset Password', style: TextStyle(fontSize: 24),),
                onPressed: resetPassword, )
            // RoundButton(title: 'Reset Password', onTap: (){
            //   final emailAddress = 'aabdi79011@gmail.com';
            //   auth
            //       .sendPasswordResetEmail(email: emailAddress)
            //       .then((value) {
            //   // auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
            //     Utils().toastMessage('We have sent you email to recover password, please check email');
            //   }).onError((error, stackTrace){
            //     Utils().toastMessage(error.toString());
            //   });
            // })
          ],
        ),
      ),
    );
  }
  Future resetPassword() async{
    showDialog(context: context,barrierDismissible: false, builder: (context) => Center(child: CircularProgressIndicator(),));

    try{
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    Utils().toastMessage('We have sent you email to recover password, please check email');
    Navigator.of(context).popUntil((route) => route.isFirst);
  } on FirebaseAuthException catch (e) {
      print(e);
      Utils().toastMessage('User not found');
      Navigator.of(context).pop();
    }
}
}
