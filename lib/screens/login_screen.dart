import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subhayatra/global/global.dart';
import 'package:subhayatra/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool isObscurePassword = false;
  final _formKey = GlobalKey<FormState>();

    // vaildate all the form of the below
   void _submit() async {
  if (_formKey.currentState!.validate()) {
      await  firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim()     , 
      password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser =auth.user;
        
        await Fluttertoast.showToast(msg: "Logged in");
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

      }).catchError((errorMessage){
        Fluttertoast.showToast(msg: "Something went wrong! Try Again");
      }
      
      );
    }
     else{
        Fluttertoast.showToast(msg: "Enter your email and password");
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
                  'Login',
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
                                  
                                },
                                onChanged: (text) => setState(() {
                                      emailTextEditingController.text = text;
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
                                    return "Please enter a password";
                                  }

                                  

                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                      passwordTextEditingController.text = text;
                                    })),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: darkTheme
                                    ? Colors.amber.shade800
                                    : Colors.blue,
                                onPrimary:
                                    darkTheme ? Colors.black : Colors.white,
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
                                'Login',
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
                                  'Dont have an account?',
                                  style: TextStyle(
                                    color: darkTheme
                                        ? Colors.amber.shade900
                                        : const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Add your sign-in logic here
                                    Navigator.pushReplacementNamed(context, '/register');
                                  },
                                  child: Text(
                                    ' Sign Up',
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
