import 'package:firebase_utilization/auth_service.dart';
import 'package:firebase_utilization/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    final AuthService auth = AuthService();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();
    bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Register'),
        ),
        body: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        TextField(
                            controller: emailCtrl,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                            controller: passwordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                            ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                            child: loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
                            onPressed: () async {
                                if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) return;
                                setState(() {
                                    loading = true;
                                });

                                final user = await auth.registerWithEmail(
                                    emailCtrl.text, 
                                    passwordCtrl.text
                                );
                                setState(() {
                                    loading = false;
                                });

                                if (user != null) {
                                    // Send Verification Email
                                    if (!user.emailVerified) {
                                        await user.sendEmailVerification();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: 
                                            Text('Verification email sent. Please check your inbox.'),
                                            ),
                                        );
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => LoginPage()),
                                    );
                                } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Registration failed')),
                                    );
                                }
                            },
                        ),
                        SizedBox(height: 12.0),
                        TextButton(
                            child: Text('Already have an account? Login'),
                            onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginPage()),
                                );
                            },
                        )
                    ]
                ),
            ),
        ),
    );
  }
}