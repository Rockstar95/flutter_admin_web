class GlossaryExpandable {
  final String charName;
  List<GlossaryItem> glossaryitem = [];

  GlossaryExpandable({this.charName = "", required this.glossaryitem});
}

class GlossaryItem {
  final String title;
  final String description;

  GlossaryItem({this.title = "", this.description = ""});
}
