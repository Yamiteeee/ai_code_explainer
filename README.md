AI Code Explainer
An intelligent Flutter application that allows users to capture or select images containing code snippets, performs Optical Character Recognition (OCR) to extract the text, and then leverages Google's Gemini AI to provide clear, concise explanations of the code. The application displays the extracted code with syntax highlighting and its explanation in a user-friendly, scrollable interface.

Features
Image Input: Capture code directly using your device's camera or select an image from the gallery.

Optical Character Recognition (OCR): Utilizes Google ML Kit to accurately extract text from images.

AI Code Explanation: Integrates with Google's Gemini AI to generate detailed and readable explanations for the extracted code.

Syntax Highlighting: Displays the extracted code with basic syntax coloring (keywords, types, strings, numbers, comments) for improved readability, mimicking an an IDE.

Scrollable Output: Both the extracted code and its explanation are presented in individually scrollable sections, ensuring a comfortable viewing experience for longer texts.

Loading Indicators & Error Handling: Provides user feedback during processing and displays informative messages in case of errors.

Technologies Used
Flutter: Cross-platform UI toolkit.

Google ML Kit (Text Recognition): For on-device OCR capabilities.

Google Generative AI SDK: For interacting with Gemini AI models.

flutter_dotenv: For secure management of API keys and environment variables.

Setup and Installation
Follow these steps to get the AI Code Explainer up and running on your local machine.

Prerequisites
Flutter SDK: Install Flutter (ensure it's on your PATH).

Firebase CLI: Install Node.js and npm (if not already installed), then npm install -g firebase-tools.

FlutterFire CLI: dart pub global activate flutterfire_cli.

1. Clone the Repository
If you haven't already, clone your new GitHub repository:

git clone https://github.com/Yamiteeee/ai_code_explainer.git
cd ai_code_explainer

(Replace YourUsername and ai_code_explainer with your actual GitHub username and repository name)

2. Install Dependencies
Navigate to the project root and fetch the Flutter and Dart packages:

flutter pub get

3. Firebase Project Setup
This app integrates with Google Firebase for AI capabilities.

a. Create a Firebase Project
Go to the Firebase Console.

Click "Add project" and follow the steps to create a new Firebase project.

b. Run FlutterFire Configure
In your project's root directory, run the FlutterFire CLI command to configure Firebase for your Flutter app:

flutterfire configure

Follow the prompts to select your Firebase project and choose the platforms you want to enable (Android, iOS, etc.).

c. Enable Required Firebase Services
In the Firebase Console for your project:

Generative Language API: Ensure the Generative Language API is enabled. You can check this in Google Cloud Console -> APIs & Services -> Enabled APIs & Services, or directly through Google AI Studio where you generate your Gemini API key.

4. Set up Gemini API Key
You need a Gemini API key from Google AI Studio.

Generate an API key in Google AI Studio.

At the root of your ai_code_explainer project, create a new file named .env.

Add your Gemini API key to this file in the following format:

GEMINI_API_KEY=YOUR_GENERATED_API_KEY_HERE

Replace YOUR_GENERATED_API_KEY_HERE with your actual key.

Important Security: Ensure .env is included in your .gitignore file to prevent it from being committed to version control:

# Environment variables
.env

5. Run the Application
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

Add history of previous explanations.

More sophisticated error handling and user feedback.

Support for multiple programming languages with specific highlighting.
