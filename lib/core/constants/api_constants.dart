class ApiConstants {
  const ApiConstants._internal();

  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const String breedsEndpoint = '/breeds';

  static const String apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  static const int pageSize = 10;
  static const int initialPage = 0;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
