
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trevo/main.dart';
import 'package:trevo/ui/Home/pages/createNewStory.dart';
import 'package:trevo/ui/Tiles/restaurantTile.dart';

void main() {
  testWidgets('Create New Story Widget Test', (WidgetTester tester) async {

    Widget makeTestableWidget(Widget child)
    {
      return MaterialApp(        home: child,

      );
    }
    await tester.pumpWidget(makeTestableWidget(CreateNewStory()));
    expect(find.byKey(Key("title")), findsOneWidget);
    var title= find.byKey(Key("title"));
    await tester.enterText(title, "hi");
    expect(find.text("hi"), findsOneWidget);



  });
}
