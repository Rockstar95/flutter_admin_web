class MydashboardTab {
  final String title;
  final String id;

  const MydashboardTab({this.title = "", this.id = ""});
}

const List<MydashboardTab> choices = <MydashboardTab>[
  MydashboardTab(title: 'Leaders', id: '1'),
  MydashboardTab(title: 'Points', id: '2'),
  MydashboardTab(title: 'Badges', id: '3'),
  MydashboardTab(title: 'Levels', id: '4'),
];
