import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/education_titles_response.dart';

/// This helper widget manages the scrollable content inside a picker widget.
class ScrollPicker extends StatefulWidget {
  ScrollPicker(
      {Key? key,
      required this.items,
      required this.initialValue,
      this.onChanged,
      this.onSelectedPos})
      : assert(items != null),
        super(key: key);

  // Events
  final ValueChanged<String>? onChanged;
  final ValueChanged<int>? onSelectedPos;

  // Variables
  final List<EducationTitleList> items;
  final int initialValue;

  @override
  _ScrollPickerState createState() => _ScrollPickerState();
}

class _ScrollPickerState extends State<ScrollPicker> {
  // Constants
  static const double itemHeight = 50.0;

  // Variables
  double widgetHeight = 0;
  int numberOfVisibleItems = 0;
  int numberOfPaddingRows = 0;
  double visibleItemsHeight = 0;
  double offset = 0;

  String selectedValue = "";

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    print('initialvall ${widget.initialValue}');
    int initial;
    if (widget.initialValue == null) {
      selectedValue = widget.items[0].name;
      initial = 0;
    } else {
      selectedValue = widget.items[widget.initialValue].name;
      initial = (widget.initialValue);
    }
    scrollController = FixedExtentScrollController(initialItem: initial);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle defaultStyle = themeData.textTheme.bodyText2 ?? TextStyle();
    TextStyle selectedStyle = themeData.textTheme.headline5?.copyWith(
            color: themeData.accentColor, fontWeight: FontWeight.bold) ??
        TextStyle(color: themeData.accentColor, fontWeight: FontWeight.bold);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            GestureDetector(
              onTapUp: _itemTapped,
              child: ListWheelScrollView.useDelegate(
                useMagnifier: true,
                magnification: 1.5,
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (BuildContext context, int index) {
                  if (index < 0 || index > widget.items.length - 1) {
                    return null;
                  }

                  var value = widget.items[index].name;

                  final TextStyle itemStyle =
                      (value == selectedValue) ? selectedStyle : defaultStyle;

                  return Center(
                    child: Text(value, style: itemStyle),
                  );
                }),
                controller: scrollController,
                itemExtent: itemHeight,
                onSelectedItemChanged: _onSelectedItemChanged,
                physics: FixedExtentScrollPhysics(),
              ),
            ),
//            Center(child: Divider()),
            Center(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: themeData.accentColor, width: 1.0),
                    bottom:
                        BorderSide(color: themeData.accentColor, width: 1.0),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController.offset + changeBy;

    // animate to and center on the selected item
    scrollController.animateTo(newPosition,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onSelectedItemChanged(int index) {
    String newValue = widget.items[index].name;
    if (newValue != selectedValue) {
      selectedValue = newValue;
      if (widget.onChanged != null) widget.onChanged!(newValue);
      if (widget.onSelectedPos != null)
        widget.onSelectedPos!(widget.items[index].id);
    }
  }
}
