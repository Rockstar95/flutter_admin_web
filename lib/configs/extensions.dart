extension StringExtension on String {
  String capitalize() {
    String  text = "";
    if(isNotEmpty) {
      text += this[0].toUpperCase();
      if(length > 1) {
        text += substring(1).toLowerCase();
      }
    }
    return text;
  }
}