import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:subhayatra/global/global.dart';
// import 'package:subhayatra/screens/home_page.dart';
import 'package:subhayatra/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final adressTextEditingCOntoller = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmpasswordTextEditingController = TextEditingController();
  bool isObscurePassword = false;
  bool isObscureConfirmPassword = false; // for hiding the password text in UI

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    // vaildate all the form of the below
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;
        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": adressTextEditingCOntoller.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };
          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "RegistrationSuccess");
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Something went wrong! Try Again");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all field are vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme
                    ? 'images/darktheme.png'
                    : 'images/lighttheme.png'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Full name",
                                    hintStyle: TextStyle(
                                      color: darkTheme
                                          ? Color.fromARGB(255, 105, 3, 3)
                                          : Color.fromARGB(249, 63, 63, 63),
                                    ),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Color.fromARGB(221, 223, 219, 219)
                                        : Color.fromARGB(255, 234, 209, 209),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkTheme
                                          ? Colors.amber.shade900
                                          : Colors.black,
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Enter Name";
                                  }
                                  if (text.length < 2) {
                                    return "Please enter  a valid name";
                                  }
                                  if (text.length > 50) {
                                    return "Name is too long ";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      nameTextEditingController.text = text;
                                    })),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color: darkTheme
                                            ? Color.fromARGB(255, 105, 3, 3)
                                            : Color.fromARGB(249, 63, 63, 63)),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Color.fromARGB(221, 223, 219, 219)
                                        : Color.fromARGB(255, 234, 209, 209),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: darkTheme
                                          ? Colors.amber.shade900
                                          : const Color.fromARGB(255, 0, 0, 0),
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter your email";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length < 2) {
                                    return "Please enter a valid email";
                                  }
                                  if (text.length > 49) {
                                    return "email is too long ";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      emailTextEditingController.text = text;
                                    })),
                            SizedBox(
                              height: 10,
                            ),
                            IntlPhoneField(
                              showCountryFlag: true,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: darkTheme
                                    ? Colors.amber.shade900
                                    : const Color.fromARGB(255, 0, 0, 0),
                              ),
                              decoration: InputDecoration(
                                  hintText: "Mobile number",
                                  hintStyle: TextStyle(
                                      color: darkTheme
                                          ? Color.fromARGB(255, 105, 3, 3)
                                          : Color.fromARGB(249, 63, 63, 63)),
                                  filled: true,
                                  fillColor: darkTheme
                                      ? Color.fromARGB(221, 223, 219, 219)
                                      : Color.fromARGB(255, 234, 209, 209),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: darkTheme
                                        ? Colors.amber.shade900
                                        : const Color.fromARGB(255, 0, 0, 0),
                                  )),
                              initialCountryCode: 'NP',
                              onChanged: (text) => setState(() {
                                phoneTextEditingController.text =
                                    text.completeNumber;
                              }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Address",
                                    hintStyle: TextStyle(
                                        color: darkTheme
                                            ? Color.fromARGB(255, 105, 3, 3)
                                            : Color.fromARGB(249, 63, 63, 63)),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Color.fromARGB(221, 223, 219, 219)
                                        : Color.fromARGB(255, 234, 209, 209),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: darkTheme
                                          ? Colors.amber.shade900
                                          : const Color.fromARGB(255, 0, 0, 0),
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter your address";
                                  }

                                  if (text.length < 2) {
                                    return "Please enter a valid address";
                                  }
                                  if (text.length > 49) {
                                    return "adress is too long ";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      adressTextEditingCOntoller.text = text;
                                    })),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                obscureText: !isObscurePassword,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: darkTheme
                                            ? Color.fromARGB(255, 105, 3, 3)
                                            : Color.fromARGB(249, 63, 63, 63)),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Color.fromARGB(221, 223, 219, 219)
                                        : Color.fromARGB(255, 234, 209, 209),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: darkTheme
                                          ? Colors.amber.shade900
                                          : const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isObscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: darkTheme
                                            ? Colors.amber.shade900
                                            : const Color.fromARGB(
                                                255, 0, 0, 0),
                                      ),
                                      onPressed: () {
                                        //update the status i.e ., show or hide the password.
                                        setState(() {
                                          isObscurePassword =
                                              !isObscurePassword;
                                        });
                                      },
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter a strong password";
                                  }

                                  if (text.length < 6) {
                                    return "Password must be at least 6 characters long";
                                  }

                                  if (text.length > 12) {
                                    return "Password length is up to 12 characters";
                                  }

                                  // Check for at least one special character, one uppercase letter, one lowercase letter, and one number
                                  RegExp specialChar =
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                                  RegExp upperCase = RegExp(r'[A-Z]');
                                  RegExp lowerCase = RegExp(r'[a-z]');
                                  RegExp digit = RegExp(r'\d');

                                  if (!specialChar.hasMatch(text) ||
                                      !upperCase.hasMatch(text) ||
                                      !lowerCase.hasMatch(text) ||
                                      !digit.hasMatch(text)) {
                                    return "Password must contain at least one special character,\n one uppercase letter, one lowercase letter,\n and one number";
                                  }

                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      passwordTextEditingController.text = text;
                                    })),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                obscureText: !isObscurePassword,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                        color: darkTheme
                                            ? Color.fromARGB(255, 105, 3, 3)
                                            : Color.fromARGB(249, 63, 63, 63)),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Color.fromARGB(221, 223, 219, 219)
                                        : Color.fromARGB(255, 234, 209, 209),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: darkTheme
                                          ? Colors.amber.shade900
                                          : const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isObscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: darkTheme
                                            ? Colors.amber.shade900
                                            : const Color.fromARGB(
                                                255, 0, 0, 0),
                                      ),
                                      onPressed: () {
                                        //update the status i.e ., show or hide the password.
                                        setState(() {
                                          isObscureConfirmPassword =
                                              !isObscureConfirmPassword;
                                        });
                                      },
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter a strong password";
                                  }

                                  if (text.length < 6) {
                                    return "Password must be at least 6 characters long";
                                  }

                                  if (text.length > 12) {
                                    return "Password length is up to 12 characters";
                                  }

                                  // Check for at least one special character, one uppercase letter, one lowercase letter, and one number
                                  RegExp specialChar =
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                                  RegExp upperCase = RegExp(r'[A-Z]');
                                  RegExp lowerCase = RegExp(r'[a-z]');
                                  RegExp digit = RegExp(r'\d');

                                  if (!specialChar.hasMatch(text) ||
                                      !upperCase.hasMatch(text) ||
                                      !lowerCase.hasMatch(text) ||
                                      !digit.hasMatch(text)) {
                                    return "Password must contain at least one special character,\n one uppercase letter, one lowercase letter,\n and one number";
                                  }

                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      confirmpasswordTextEditingController
                                          .text = text;
                                    })),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    darkTheme ? Colors.black : Colors.white,
                                backgroundColor: darkTheme
                                    ? Colors.amber.shade800
                                    : Colors.blue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                _submit();
                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: darkTheme
                                        ? Colors.amber.shade900
                                        : const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Add your sign-in logic here
                                  },
                                  child: Text(
                                    ' Sign in',
                                    style: TextStyle(
                                      color: darkTheme
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
