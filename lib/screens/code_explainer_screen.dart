import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_code_explainer/models/explanation_result.dart'; // Import our data models
import 'package:ai_code_explainer/services/ai_service.dart'; // Import our AI service
import 'dart:developer' as developer; // For logging

/// The main UI screen for the Code Explainer application.
/// It displays buttons to pick images, shows extracted text,
/// and presents AI-generated code explanations.
class CodeExplainerScreen extends StatefulWidget {
  /// The AI service instance to use for text recognition and code explanation.
  /// This is passed from the main application entry point.
  final AiService aiService;

  /// Constructor for CodeExplainerScreen.
  const CodeExplainerScreen({super.key, required this.aiService});

  @override
  State<CodeExplainerScreen> createState() => _CodeExplainerScreenState();
}

class _CodeExplainerScreenState extends State<CodeExplainerScreen> {
  // State variables to manage the UI content and loading status.
  ExplanationResult _result = ExplanationResult.empty();
  bool _isLoading = false;
  String? _errorMessage; // To store and display any errors to the user.

  /// Handles the process of picking an image and getting an explanation.
  ///
  /// This method orchestrates the call to the AiService and manages the UI state
  /// (loading, displaying results, showing errors).
  /// [source] specifies whether the image comes from the camera or gallery.
  Future<void> _processImage(ImageSource source) async {
    // 1. Set initial loading state and clear previous results/errors.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      // Provide immediate feedback to the user that processing has started.
      _result = ExplanationResult(
        extractedCode: 'Processing image...',
        explanation: 'Generating explanation...',
      );
    });

    try {
      // 2. Call the AI service to perform the core logic.
      final newResult = await widget.aiService.processCodeImage(source);

      // 3. Update the UI with the results from the AI service.
      setState(() {
        _result = newResult;
      });
    } catch (e) {
      // 4. Handle errors: Log the error, update error message for display.
      developer.log('Error in _processImage: $e'); // Log detailed error for developer.
      setState(() {
        _errorMessage = 'Failed to process image or explain code: ${e.toString()}';
        _result = ExplanationResult.empty(); // Reset to empty/initial state on error.
      });
    } finally {
      // 5. Always set loading to false when the process completes (success or failure).
      setState(() {
        _isLoading = false;
      });
      // 6. Show a SnackBar if an error occurred.
      if (_errorMessage != null && mounted) { // Check mounted to prevent calling setState on disposed widget
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    }
  }

  @override
  void dispose() {
    // Important: Dispose the AI service resources when the screen (and its state)
    // is no longer part of the widget tree to prevent memory leaks.
    widget.aiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Explainer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section for Image Selection Buttons
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20), // Add some bottom margin
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Scan or Select Code Image',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            // Disable button if loading to prevent multiple presses
                            onPressed: _isLoading ? null : () => _processImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), // Spacing between buttons
                        Expanded(
                          child: ElevatedButton.icon(
                            // Disable button if loading
                            onPressed: _isLoading ? null : () => _processImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            // Extracted Code Display Section
            // Only show if there's actual extracted code or a processing message.
            if (_result.extractedCode != ExplanationResult.empty().extractedCode || _isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Extracted Code:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity, // Take full width
                      constraints: const BoxConstraints(minHeight: 100), // Ensure minimum height
                      child: SelectableText( // Allows text selection/copying
                        _result.extractedCode,
                        style: TextStyle(
                          fontFamily: 'monospace', // Monospace font for code
                          color: _result.extractedCode.contains('No readable text') ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Code Explanation Display Section
            // Only show if there's actual explanation or a processing message.
            if (_result.explanation != ExplanationResult.empty().explanation || _isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code Explanation:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: Colors.blueGrey[50], // Light background for explanation
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity, // Take full width
                      constraints: const BoxConstraints(minHeight: 150), // Ensure minimum height
                      child: SelectableText( // Allows text selection/copying
                        _result.explanation,
                        style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
