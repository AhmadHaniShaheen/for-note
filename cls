[1mdiff --git a/lib/main.dart b/lib/main.dart[m
[1mindex e978748..4b110de 100644[m
[1m--- a/lib/main.dart[m
[1m+++ b/lib/main.dart[m
[36m@@ -20,6 +20,7 @@[m [mvoid main() {[m
         '/login_screen': (context) => const LoginScreen(),[m
         '/register_screen': (context) => const RegisterScreen(),[m
         '/verify_email_screen': (context) => const VerifyEmailScreen(),[m
[32m+[m[32m        '/note_screen': (context) => const NoteScreen(),[m
       },[m
     ),[m
   );[m
[36m@@ -101,8 +102,8 @@[m [mclass _NoteScreenState extends State<NoteScreen> {[m
             itemBuilder: (context) {[m
               return [[m
                 const PopupMenuItem<MenuAction>([m
[31m-                  child: const Text('Log out'),[m
                   value: MenuAction.logOut,[m
[32m+[m[32m                  child: Text('Log out'),[m
                 ),[m
               ];[m
             },[m
[1mdiff --git a/lib/screens/login_screen.dart b/lib/screens/login_screen.dart[m
[1mindex 38e8e4f..e1d9b2b 100644[m
[1m--- a/lib/screens/login_screen.dart[m
[1m+++ b/lib/screens/login_screen.dart[m
[36m@@ -4,6 +4,7 @@[m [mimport 'package:flutter/material.dart';[m
 import 'package:fornote/firebase_options.dart';[m
 import 'package:fornote/main.dart';[m
 import 'package:fornote/widgets/text_field_widget.dart';[m
[32m+[m[32mimport 'dart:developer' as devtool show log;[m
 [m
 class LoginScreen extends StatefulWidget {[m
   const LoginScreen({super.key});[m
[36m@@ -152,18 +153,18 @@[m [mclass _LoginScreenState extends State<LoginScreen> {[m
                               );[m
                             });[m
 [m
[31m-                            print('user Credential is: $userCredential');[m
[32m+[m[32m                            devtool.log('user Credential is: $userCredential');[m
                           } on FirebaseException catch (e) {[m
                             if (e.code == 'unknown') {[m
[31m-                              print('The Email & Password is requred');[m
[32m+[m[32m                              devtool.log('The Email & Password is requred');[m
                             } else if (e.code == 'invalid-email') {[m
[31m-                              print('invalid email');[m
[32m+[m[32m                              devtool.log('invalid email');[m
                             } else if (e.code == 'wrong-password') {[m
[31m-                              print('Wrong password');[m
[32m+[m[32m                              devtool.log('Wrong password');[m
                             } else if (e.code == 'user-not-found') {[m
[31m-                              print('user not found');[m
[32m+[m[32m                              devtool.log('user not found');[m
                             } else {[m
[31m-                              print(e.code);[m
[32m+[m[32m                              devtool.log(e.code);[m
                             }[m
                           }[m
                         },[m
[1mdiff --git a/lib/screens/register_screen.dart b/lib/screens/register_screen.dart[m
[1mindex 4ae36a1..85b3dc7 100644[m
[1m--- a/lib/screens/register_screen.dart[m
[1m+++ b/lib/screens/register_screen.dart[m
[36m@@ -3,6 +3,7 @@[m [mimport 'package:firebase_core/firebase_core.dart';[m
 import 'package:flutter/material.dart';[m
 import 'package:fornote/firebase_options.dart';[m
 import 'package:fornote/widgets/text_field_widget.dart';[m
[32m+[m[32mimport 'dart:developer' as devtool show log;[m
 [m
 class RegisterScreen extends StatefulWidget {[m
   const RegisterScreen({super.key});[m
[36m@@ -141,18 +142,18 @@[m [mclass _RegisterScreenState extends State<RegisterScreen> {[m
                               email: email,[m
                               password: password,[m
                             );[m
[31m-                            print(userCredential);[m
[32m+[m[32m                            devtool.log(userCredential.toString());[m
                           } on FirebaseException catch (e) {[m
                             if (e.code == 'unknown') {[m
[31m-                              print('The Email & Password is requred');[m
[32m+[m[32m                              devtool.log('The Email & Password is requred');[m
                             } else if (e.code == 'weak-password') {[m
[31m-                              print('this is a weak-password');[m
[32m+[m[32m                              devtool.log('this is a weak-password');[m
                             } else if (e.code == 'email-already-in-use') {[m
[31m-                              print('email already in use');[m
[32m+[m[32m                              devtool.log('email already in use');[m
                             } else if (e.code == 'invalid-email') {[m
[31m-                              print('invalid email');[m
[32m+[m[32m                              devtool.log('invalid email');[m
                             } else {[m
[31m-                              print('Error is ${e.code}');[m
[32m+[m[32m                              devtool.log('Error is ${e.code}');[m
                             }[m
                           }[m
                         },[m
