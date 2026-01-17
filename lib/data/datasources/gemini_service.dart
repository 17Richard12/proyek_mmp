import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // NOTE: In a real app, do not store API keys directly in the code. Use environment variables.
  static const String _apiKey = "AIzaSyC32mw2Oo8KqcYNFVwnmgGZc1F46cYfEXk";
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<String> getSuggestion(String description) async {
    final content = [
      Content.text(
          "Based on this problem description in a city context: '$description', provide a short category (e.g., Infrastructure, Environment, Waste) and a 1-sentence suggested action.")
    ];
    try {
      final response = await _model.generateContent(content);
      return response.text ?? "No suggestion available.";
    } catch (e) {
      return "Error fetching suggestion.";
    }
  }
}
