# ML Model Files

Place your trained TFLite model files here:

- `price_model.tflite` — Regression model
  - Input shape: `[1, 6]` — `[distance, vehicle, weather, category, weight, delivery_time]`
  - Output shape: `[1, 1]` — predicted cost (float)

- `win_model.tflite` — Classifier model
  - Input shape: `[1, 5]` — `[distance, category, weight, delivery_time, price]`
  - Output shape: `[1, 1]` — win probability 0.0–1.0 (float)

Until these files are present, the app uses the built-in formula engine as a fallback.
