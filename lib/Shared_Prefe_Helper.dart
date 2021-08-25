import 'package:flutter/material.dart';
import 'package:internetspeedapplication/InternetSpeedLists.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  setDoubleListPreferences(List<double> value) async {
    List<String> downloadSpeedList = [];
    value.forEach((element) {
      downloadSpeedList.add(element.toString());
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('doubleList', downloadSpeedList);
    List<String> temp = _prefs.getStringList('doubleList');
    print("THIS IS MY LIST FROM SHARED PREF $temp");
  }

//Upload List
  setDoubleUploadListPreferences(List<double> value) async {
    List<String> uploadSpeedList = [];
    value.forEach((element) {
      uploadSpeedList.add(element.toString());
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('doubleUploadList', uploadSpeedList);
    List<String> temp = _prefs.getStringList('doubleUploadList');
    print("THIS IS MY LIST FROM SHARED PREF $temp");
  }

  void removeUploadData(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('doubleUploadList');
  }

  // void removeDownloadData(String key) async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   _prefs.remove('doubleList');
  // }

  // void setListInPrefrences(List list) async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();

  //   //   List<double> list = [0.9, 8.6, 4.4, 4.5, 2.4, 5.6];

  //   List list2 = List.generate(
  //       list.length, (index) => double.parse(list[index].toString()));
  //   print("Download list is here ${list}");
  //   await _prefs.setStringList(
  //     "list",
  //     <String>[
  //       "$list2",
  //     ],
  //   ).then(
  //     (value) => print(value),
  //   );
  // }

}
