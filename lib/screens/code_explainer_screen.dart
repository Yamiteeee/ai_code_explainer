import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_code_explainer/models/explanation_result.dart'; // Import our data model
import 'package:ai_code_explainer/services/ai_service.dart'; // Import our AI service
import 'dart:developer' as developer; // For logging

/// The main UI screen for the Code Explainer application.
/// It displays buttons to pick images, shows extracted text,
/// and presents AI-generated code explanations directly on the screen.
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
      // 5. Show a SnackBar if an error occurred.
      if (_errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    } finally {
      // 6. Always set loading to false when the process completes (success or failure).
      setState(() {
        _isLoading = false;
      });
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
      body: SingleChildScrollView( // This makes the whole body scrollable
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

            // Loading Indicator (only visible while loading or generating explanation)
            if (_isLoading) // Simplified condition to always show loading if _isLoading is true
              Padding( // Using Padding directly, `const` removed for dynamic content
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Column( // Use a column to stack indicator and text
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_result.extractedCode == 'Processing image...' || _result.explanation == 'Generating explanation...')
                        const CircularProgressIndicator(), // Show spinner initially
                      if (_result.extractedCode == 'Processing image...' || _result.explanation == 'Generating explanation...')
                        const SizedBox(height: 10), // Spacing
                      Text(
                        _result.extractedCode == 'Processing image...'
                            ? 'Processing image...'
                            : 'Generating explanation...',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ),
            // No else if needed here, as the loading state is covered by the `if (_isLoading)` block

            // Extracted Code Display Section
            // Only show if there's actual extracted code (not the initial placeholder)
            if (_result.extractedCode != ExplanationResult.empty().extractedCode && !_isLoading)
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
                    color: Colors.grey[900], // Dark background for code
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 250, // Fixed height for the code box
                      child: SingleChildScrollView( // Make content inside this box scrollable
                        child: SelectableText.rich(
                          _buildSyntaxHighlightedText(_result.extractedCode),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Code Explanation Display Section
            // Only show if there's actual explanation (not the initial placeholder)
            if (_result.explanation != ExplanationResult.empty().explanation && !_isLoading)
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
                    color: Colors.blueGrey[900], // Dark background for explanation
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 250, // Fixed height for the explanation box
                      child: SingleChildScrollView( // Make content inside this box scrollable
                        child: SelectableText(
                          _result.explanation,
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
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

// Helper class to store segments of text with their color
class MatchSegment {
  final String text;
  final Color color;
  MatchSegment({required this.text, required this.color});
}

// Function to build RichText Span with basic syntax highlighting
TextSpan _buildSyntaxHighlightedText(String text) {
  if (text.contains('No readable text') || text.trim().isEmpty) {
    return TextSpan(
      text: text.isEmpty ? 'No text recognized.' : text,
      style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace'),
    );
  }

  final List<InlineSpan> spans = [];

  // Define simple regex patterns and their corresponding colors
  // Ordered from most specific/prioritized (comments, strings) to least specific (keywords, types)
  final Map<RegExp, Color> patterns = {
    // Comments (multi-line) - Most prioritized
    RegExp(r'/\*[\s\S]*?\*/'): Colors.grey[600]!,
    // Comments (single line)
    RegExp(r'//[^\n]*'): Colors.grey[600]!,
    // Strings (single or double quotes)
    RegExp(r'''("|')([^"'\\]*(\\.[^"'\\]*)*)("|')'''): Colors.lightGreenAccent[400]!,
    // Numbers
    RegExp(r'\b\d+\.?\d*\b'): Colors.orangeAccent[100]!,
    // Keywords (e.g., import, class, void, if, return)
    RegExp(r'\b(import|class|extends|with|void|Future|async|await|late|final|const|var|if|else|for|while|return|new|super|this|true|false|null|override|setState|build|widget|context|debugPrint|try|catch|finally|throw|rethrow)\b'): Colors.pinkAccent[100]!,
    // Types (e.g., String, int, double, Widget, MaterialApp)
    RegExp(r'\b(String|int|double|bool|List|Map|Set|dynamic|Object|State|Widget|MaterialApp|Scaffold|AppBar|Text|Column|Row|Container|Card|Padding|ElevatedButton|CircularProgressIndicator|SingleChildScrollView|SelectableText|Expanded|SizedBox|ImageSource|TextRecognizer|GenerativeModel|ExplanationResult|AiService|BuildContext|Key)\b'): Colors.lightBlueAccent[100]!,
  };

  final List<String> lines = text.split('\n');

  for (String line in lines) {
    List<InlineSpan> lineSpans = [];
    int currentLineIndex = 0; // Tracks position within the current line

    // Keep track of matches already processed for the current line to avoid re-matching
    List<({RegExpMatch match, Color color})> lineMatches = [];

    // Collect all matches for the current line
    for (var entry in patterns.entries) {
      for (RegExpMatch match in entry.key.allMatches(line)) {
        lineMatches.add((match: match, color: entry.value));
      }
    }

    // Sort matches: first by start index, then by length (longer matches first for priority, e.g., multiline comments)
    lineMatches.sort((a, b) {
      if (a.match.start != b.match.start) {
        return a.match.start.compareTo(b.match.start);
      }
      return b.match.group(0)!.length.compareTo(a.match.group(0)!.length);
    });

    for (var coloredMatch in lineMatches) {
      final match = coloredMatch.match;
      final color = coloredMatch.color;

      // Ensure the match starts at or after our current position in the line
      if (match.start >= currentLineIndex) {
        // Add plain text before this match
        if (match.start > currentLineIndex) {
          lineSpans.add(TextSpan(
            text: line.substring(currentLineIndex, match.start),
            style: const TextStyle(color: Colors.white),
          ));
        }

        // Add the highlighted text
        lineSpans.add(TextSpan(
          text: line.substring(match.start, match.end),
          style: TextStyle(color: color, fontFamily: 'monospace'),
        ));

        // Move the current index past the end of the matched text
        currentLineIndex = match.end;
      }
    }

    // Add any remaining plain text at the end of the line
    if (currentLineIndex < line.length) {
      lineSpans.add(TextSpan(
        text: line.substring(currentLineIndex),
        style: const TextStyle(color: Colors.white),
      ));
    }

    // Add the collected spans for this line to the main list
    spans.add(TextSpan(children: lineSpans));
    // Add a newline for the next line, unless it's the very last line
    if (line != lines.last) {
      spans.add(const TextSpan(text: '\n'));
    }
  }

  return TextSpan(children: spans, style: const TextStyle(fontFamily: 'monospace', fontSize: 14));
}
