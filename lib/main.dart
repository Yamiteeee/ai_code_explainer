import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For loading .env file
import 'package:ai_code_explainer/screens/code_explainer_screen.dart'; // Import your screen
import 'package:ai_code_explainer/services/ai_service.dart'; // Import your service

/// The main entry point of the Flutter application.
/// This function initializes Flutter widgets, loads environment variables,
/// initializes the AI service, and then runs the app.
Future<void> main() async {
  // Ensures that Flutter widgets are initialized before any Flutter-specific
  // operations (like runApp) are called. This is crucial for plugins like flutter_dotenv.
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file from the assets.
  // The 'fileName' parameter should match the name of your environment file.
  await dotenv.load(fileName: ".env");

  // Retrieve the API key from environment variables loaded by dotenv.
  // We use a fallback empty string if the key is not found to prevent null errors,
  // but the AiService will throw a more specific error if it's not set.
  final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  // Initialize the AI service instance.
  // This service will be passed down to the UI.
  final aiService = AiService(geminiApiKey: geminiApiKey);

  runApp(CodeExplainerApp(aiService: aiService));
}

/// The root widget of the application.
/// It sets up the overall theme and provides the AiService to the main screen.
class CodeExplainerApp extends StatelessWidget {
  /// The AI service instance to be provided to the rest of the app.
  final AiService aiService;

  /// Constructor for CodeExplainerApp.
  const CodeExplainerApp({super.key, required this.aiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Explainer',
      debugShowCheckedModeBanner: false, // to remove the debug banner
      // Define the application's overall visual theme.
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Main color palette
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts UI to platform
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey, // App bar color
          foregroundColor: Colors.white, // App bar text/icon color
          elevation: 6, // Shadow beneath the app bar
          centerTitle: true, // Center the title on the app bar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey, // Button background color
            foregroundColor: Colors.white, // Button text/icon color
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // Corrected CardThemeData definition
        cardTheme: CardThemeData( // Changed from CardTheme to CardThemeData
          elevation: 4, // Shadow for cards
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners for cards
          margin: EdgeInsets.zero, // Default margin to zero, handled by parent widgets
        ), // Closing parenthesis for CardThemeData constructor

        // TextTheme definition
        textTheme: const TextTheme( // Opening brace for TextTheme
          // Define custom text styles for different parts of the app.
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          bodyMedium: TextStyle(fontSize: 16),
        ), // Closing parenthesis for TextTheme constructor
      ), // Closing parenthesis for ThemeData constructor
      // Set the home screen of the application, passing the initialized AI service.
      home: CodeExplainerScreen(aiService: aiService),
    );
  }
}