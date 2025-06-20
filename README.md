AI Code Explainer
A Flutter project designed to capture or select images containing code, perform Optical Character Recognition (OCR) to extract the text, and then use Google's Gemini AI to provide clear, concise explanations. The app displays the extracted code with syntax highlighting and its explanation in a user-friendly, scrollable interface.

This is an app developed for fun, learning, and showcasing Flutter development skills, particularly with integrating Google's AI services.

✨ Features
Image Input: Capture code directly using your device's camera or select an image from the gallery.

Optical Character Recognition (OCR): Leverages Google ML Kit for accurate text extraction from images.

AI Code Explanation: Integrates with Google's Gemini AI to generate detailed and readable explanations for code snippets.

Syntax Highlighting: Displays extracted code with basic syntax coloring (keywords, types, strings, numbers, comments) for improved readability, mimicking an IDE.

Scrollable Output: Both the extracted code and its explanation are presented in individually scrollable sections, ensuring a comfortable viewing experience for longer texts.

Loading Indicators & Error Handling: Provides clear user feedback during processing and displays informative messages in case of API or processing errors.

🚀 Getting Started
To run this project locally and leverage Google's AI capabilities, follow these steps:

Prerequisites
Flutter SDK installed.

Firebase CLI installed (requires Node.js and npm).

FlutterFire CLI activated: dart pub global activate flutterfire_cli.

A Google account to create a Firebase project and access Google AI Studio.

Setup Steps
Clone the repository:

git clone https://github.com/YourUsername/ai_code_explainer.git
cd ai_code_explainer

(Replace YourUsername and ai_code_explainer with your actual GitHub username and repository name)

Install Flutter dependencies:

flutter pub get

Firebase Project Setup:
This app uses Firebase for integrating with Google's AI models.

a. Create a Firebase Project:

Go to the Firebase Console.

Click "Add project" and follow the prompts to create a new project. You can name it anything you like (e.g., ai-code-explainer-project).

b. Run FlutterFire Configure:

Open your terminal in the root of your Flutter project (ai_code_explainer) and run:

flutterfire configure

Follow the prompts. Select your newly created Firebase project.

Choose the platforms you want to configure (Android, iOS, web, etc.). This command will automatically generate the lib/firebase_options.dart file with your project's configuration.

c. Enable Required Firebase Services:

In the Firebase Console for your project, ensure the Generative Language API is enabled. You can usually find this under "Build" > "Extensions" or by going to Google Cloud Console -> APIs & Services -> Enabled APIs & Services, or directly through Google AI Studio. This API is essential for using Gemini models.

Set up Gemini API Key:
You need a Gemini API key from Google AI Studio.

Generate an API key in Google AI Studio.

At the root of your ai_code_explainer project, create a new file named .env.

Add your Gemini API key to this file in the following format:

GEMINI_API_KEY=YOUR_GENERATED_API_KEY_HERE

Replace YOUR_GENERATED_API_KEY_HERE with your actual key.

Important Security: Ensure .env is included in your .gitignore file to prevent it from being committed to version control:

# Environment variables
.env

Run the Application:
Connect a device or start an emulator/simulator, then run the app:

flutter run

How to Use
Launch the App: Once the app is running on your device/emulator, you will see the main screen with "Camera" and "Gallery" buttons.

Select or Capture Image:

Tap "Camera" to open your device's camera and take a photo of code.

Tap "Gallery" to select an image of code from your device's photo library.

Wait for Processing: A loading indicator and "Processing image..." / "Generating explanation..." text will appear while the app extracts text and queries the AI.

View Results:

The "Extracted Code" section will display the text recognized from your image, with basic syntax highlighting.

The "Code Explanation" section will show the AI-generated explanation of the code.

Both sections are individually scrollable if the content is long.

Future Improvements
Implement saving and loading of explanations.

Allow users to edit extracted code before sending to AI.

Improve syntax highlighting robustness and language support.

Add a history of previous explanations.

More sophisticated error handling and user feedback.

Support for multiple programming languages with specific highlighting.

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
