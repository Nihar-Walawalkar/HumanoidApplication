import 'package:ai_humanoid_application/firebase_options.dart';
import 'package:ai_humanoid_application/login/login.dart';
import 'package:ai_humanoid_application/math_solver/math_solver.dart';
import 'package:ai_humanoid_application/services/auth_service.dart';
import 'package:ai_humanoid_application/text-to-image/text-to-image.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ai_humanoid_application/textandimagemodel/ImageChatHomepage.dart';
import 'package:ai_humanoid_application/textonlymodel/TextChatHomepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instant Generative AI',
      home: Login(), // Removed 'const' here
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ThemeMode _themeMode = ThemeMode.light; // Initialize theme mode to light
  bool _isvisionmodel = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instant Generative AI',
      theme: ThemeData.light(), // Set default theme to light mode
      darkTheme: ThemeData.dark(), // Set dark theme
      themeMode: _themeMode, // Use the selected theme mode

      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                ),
                child: _isvisionmodel
                    ? const Center(
                  child: Text(
                    "Image and Text Model",
                    style: TextStyle(color: Colors.black),
                  ),
                )
                    : const Center(
                  child: Text(
                    "Text only Model",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                title: _isvisionmodel
                    ? const Text("Switch to Text Only Model")
                    : const Text("Switch to Image and Text Model"),
                onTap: () {
                  setState(() {
                    _isvisionmodel = !_isvisionmodel;
                  });
                },
              ),
              ListTile(
                title: const Text("Text to Image"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiTextToImageGenerator()),
                  );
                },
              ),
              ListTile(
                title: const Text("Math Solver"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Math Solver')),
                  );
                },
              ),

              const Spacer(), // Push the logout button to the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Implement logout logic here
                    await AuthService().signout(context: context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Button color
                    foregroundColor: Colors.white, // Text/icon color
                    minimumSize:
                    const Size(double.infinity, 50), // Full-width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),

        appBar: AppBar(
          title: const Text('Instant Generative AI'),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb),
              onPressed: () {
                // Toggle between light and dark mode
                setState(() {
                  _themeMode = _themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                });
              },
            ),
          ],
        ),
        body: _isvisionmodel ? const Imagechatwidget() : const Textchatwidget(),
      ),
    );
  }
}
