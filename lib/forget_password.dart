
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momentum/auth/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// Send Password Reset Email
  void sendPasswordResetEmail() async {
    // Show progress indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (emailController.text.isEmpty) {
      displayMessageToUser("Email field cannot be empty", context);
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      displayMessageToUser("Invalid email format", context);
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Reset Email Sent"),
          content: Text(
            "A password reset link has been sent to ${emailController.text}. Please check your email.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the login page
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      displayMessageToUser(
          e.message ?? "An error occurred. Please try again.", context);
    } finally {
      // Dismiss progress indicator
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 96, 139, 118),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),

                Text(
                  "Reset Your Password",
                  style: GoogleFonts.nanumMyeongjo(
                    color:  const Color.fromARGB(255, 204, 203, 203),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Email TextField
                MyTextfield(
                  hintText: "Enter your email",
                  obscuretext: false,
                  controller: emailController,
                ),
                const SizedBox(height: 25),

                // Send Button
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        buttonText: "Send Reset Link",
                        onTap: sendPasswordResetEmail,
                      ),
                const SizedBox(height: 10),

                // Back to Login Link
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),)); // Go back to the login page
                  },
                  child:  Text(
                    "Back to Login",
                    style: TextStyle(fontSize: 14 ,color:  const Color.fromARGB(255, 204, 203, 203)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MyButton extends StatelessWidget {
  const MyButton({super.key,required this.buttonText , required this.onTap });
  
  final Function()? onTap ;
  final String buttonText ;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
     onTap: onTap ,
     child: Container(
      
      decoration:  BoxDecoration(
        color: const Color.fromARGB(255, 202, 202, 202),
        borderRadius: const BorderRadius.all(Radius.circular(12)) ,
      ),

      padding: const EdgeInsets.all(25),
      child: Center(child: Text( buttonText , style: const TextStyle(fontSize: 16, color:   Color.fromARGB(255, 96, 139, 118)),)),
      
     ),
    );
  }
}


class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.hintText, required this.obscuretext, required this.controller});
  
  final String hintText ;
  final bool obscuretext ;
  final TextEditingController controller ;
  @override
  Widget build(BuildContext context) {
    return  TextField(
      enableInteractiveSelection: true,
      style: GoogleFonts.roboto(fontWeight: FontWeight.w300 , color:  Colors.white),
      controller: controller,
      decoration:  InputDecoration(
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))) ,
        hintText: hintText  ,
      ),
     obscureText: obscuretext,

    );
  }
}


displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}
