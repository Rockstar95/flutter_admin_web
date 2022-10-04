class MyUtils {
  static double roundTo(double value, double precision) => (value * precision).round() / precision;

  static String getSecureUrl(String url) {
    if(url.startsWith("http:")) {
      url = url.replaceFirst("http:", "https:");
    }
    return url;
  }
}