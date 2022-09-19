extension c on String {
  String capitalize() {
    String  text = "";
    if(this.isNotEmpty) {
      text += this[0].toUpperCase();
      if(this.length > 1) {
        text += this.substring(1).toLowerCase();
      }
    }
    return text;
  }
}