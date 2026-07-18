// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/red_header_layout.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RedHeaderLayout(
      title: 'Change Password',
      showSearchBar: false,
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            padding: EdgeInsets.all(16),
            child: Card(
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // title
                      Text(
                        'Old password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),

                      const SizedBox(height: 8),

                      //old password
                      TextFormField(
                        controller: _oldPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          hintText: '********',
                          visualDensity: VisualDensity.compact,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscureOld = !_isObscureOld;
                              });
                            },
                            icon: Icon(
                              _isObscureOld
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined,
                            ),
                          ),
                        ),
                        obscureText: _isObscureOld,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your password';
                          } else if (val.length < 8) {
                            return 'Password at least 8 character';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: Spacing.lg),

                      // title
                      Text(
                        'New password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),

                      //new password
                      TextFormField(
                        controller: _newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          hintText: '********',
                          visualDensity: VisualDensity.compact,

                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscureNew = !_isObscureNew;
                              });
                            },
                            icon: Icon(
                              _isObscureNew
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined,
                            ),
                          ),
                        ),
                        obscureText: _isObscureNew,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your password';
                          } else if (val.length < 8) {
                            return 'Password at least 8 character';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // signup
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                //
                                if (_globalKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  //
                                  await changePassword(
                                    oldPassword: _oldPasswordController.text,
                                    newPassword: _newPasswordController.text,
                                  );
                                }
                              },
                        child: _isLoading
                            ? const CupertinoActivityIndicator()
                            : Text('Change Password'.toUpperCase()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // change pass
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    /*
    var currentUser = FirebaseAuth.instance.currentUser;

    if (oldPassword == newPassword) {
      Fluttertoast.showToast(
        msg: 'Old and New Password are same. Please change it',
      );
      setState(() => _isLoading = false);
    } else {
      try {
        var credential = EmailAuthProvider.credential(
          email: currentUser!.email.toString(),
          password: oldPassword,
        );

        await currentUser.reauthenticateWithCredential(credential).then((
          value,
        ) {
          currentUser.updatePassword(newPassword);
          Fluttertoast.showToast(msg: 'Password change successfully');

          FirebaseAuth.instance.signOut().then((value) {
            context.goNamed('/');
          });
        });
      } on FirebaseAuthException catch (e) {
        log(e.code);
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: 'Old password is invalid, Enter valid one!',
          toastLength: Toast.LENGTH_LONG,
        );
      } catch (e) {
        log(e.toString());
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
    */
    Fluttertoast.showToast(msg: 'Password change is temporarily unavailable.');
    setState(() => _isLoading = false);
  }
}
