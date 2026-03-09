/// Offline currency converter using fixed exchange rates relative to INR (₹).
///
/// Rates are approximate market values — for a production app, these would be
/// fetched from an exchange rate API, but since Quotie-Genie is fully offline,
/// fixed rates give a realistic demo experience.
class CurrencyConverter {
  static const Map<String, double> _ratesFromINR = {
    '₹': 1.0,
    '\$': 0.012, // USD
    '€': 0.011, // EUR
    '£': 0.0095, // GBP
    '¥': 1.80, // JPY
    'A\$': 0.019, // AUD
    'C\$': 0.016, // CAD
  };

  /// Convert an amount from INR to the target currency.
  /// Returns the same amount if the target symbol is unknown.
  static double fromINR(double amountINR, String targetSymbol) {
    final rate = _ratesFromINR[targetSymbol] ?? 1.0;
    return amountINR * rate;
  }

  /// Return the exchange rate for a given currency symbol relative to INR.
  static double rateFromINR(String symbol) {
    return _ratesFromINR[symbol] ?? 1.0;
  }
}
