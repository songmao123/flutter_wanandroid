import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/entity/hot_search.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WanAndroidSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    var themeData = Theme.of(context).copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          decorationColor: Colors.white,
          fontSize: 16.0,
          fontFamily: "Montserrat-Bold",
        ),
      ),
    );
    return themeData;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    print(
        "buildResults----------------------------------------------->: $query");
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(
        "buildSuggestions----------------------------------------------->: $query");
    return FutureBuilder<HotSearchBean>(
      future: getHotSearchData(),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          var data = snapShot.data;
          if (data.errorCode != 0 || data.data.isEmpty) {
            return Container();
          } else {
            return buildSuggestionsWidget(context, data.data);
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildSuggestionsWidget(
      BuildContext context, List<HotSearchData> dataList) {
    var suggestionWidgets = dataList
        .map((data) => Container(
              child: InputChip(
                label: Text(
                  data.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-Medium",
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.teal,
                disabledColor: Colors.teal,
                elevation: 2.0,
                onPressed: () {
                  query = data.name;
                  Fluttertoast.showToast(msg: data.name);
                },
              ),
              margin: EdgeInsets.only(right: 16.0),
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hot Search",
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xff666666),
              fontFamily: "Montserrat-Medium",
            ),
          ),
          Wrap(
            children: suggestionWidgets,
          ),
        ],
      ),
    );
  }
}
