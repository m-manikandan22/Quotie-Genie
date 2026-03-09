import 'dart:developer' as dev;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Singleton service that loads and runs the two TFLite models:
///   - price_model.tflite  (6 inputs → predicted cost)
///   - win_model.tflite    (5 inputs → win probability)
///
/// If the model files are not present in assets/models/, [loadModels] sets
/// [modelsLoaded] to false and all predict methods return null. The
/// PricingEngine will gracefully fall back to its formula engine in that case.
class MLInferenceService {
  static final MLInferenceService _instance = MLInferenceService._internal();
  factory MLInferenceService() => _instance;
  MLInferenceService._internal();

  Interpreter? _priceInterpreter;
  Interpreter? _winInterpreter;
  bool _modelsLoaded = false;

  bool get modelsLoaded => _modelsLoaded;

  /// Call once at app startup (in main.dart). Safe to call even when model
  /// files are absent — will catch the error and leave [_modelsLoaded] false.
  Future<void> loadModels() async {
    try {
      _priceInterpreter = await Interpreter.fromAsset(
        'assets/models/price_model.tflite',
      );
      _winInterpreter = await Interpreter.fromAsset(
        'assets/models/win_model.tflite',
      );
      _modelsLoaded = true;
      dev.log('[MLInferenceService] Models loaded successfully.');
    } catch (e) {
      _modelsLoaded = false;
      dev.log('[MLInferenceService] Model load failed (fallback active): $e');
    }
  }

  /// Price model: inputs [distance, vehicle, weather, category, weight, delivery_time]
  /// Returns predicted base cost or null if models not loaded.
  double? predictPrice(List<double> input) {
    if (!_modelsLoaded || _priceInterpreter == null) return null;
    try {
      // Shape: [1, 6] → [1, 1]
      final inputTensor = [input];
      final outputTensor = List.generate(1, (_) => List.filled(1, 0.0));
      _priceInterpreter!.run(inputTensor, outputTensor);
      return outputTensor[0][0];
    } catch (e) {
      dev.log('[MLInferenceService] predictPrice error: $e');
      return null;
    }
  }

  /// Win model: inputs [distance, category, weight, delivery_time, price]
  /// Returns win probability 0.0–1.0 or null if models not loaded.
  double? predictWin(List<double> input) {
    if (!_modelsLoaded || _winInterpreter == null) return null;
    try {
      // Shape: [1, 5] → [1, 1]
      final inputTensor = [input];
      final outputTensor = List.generate(1, (_) => List.filled(1, 0.0));
      _winInterpreter!.run(inputTensor, outputTensor);
      return outputTensor[0][0];
    } catch (e) {
      dev.log('[MLInferenceService] predictWin error: $e');
      return null;
    }
  }

  void dispose() {
    _priceInterpreter?.close();
    _winInterpreter?.close();
  }
}
