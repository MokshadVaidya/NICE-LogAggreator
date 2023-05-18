import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:excel/excel.dart';
part 'select_files_state.dart';

enum LogFileType { acd, swx, awa }

class SelectFilesCubit extends Cubit<SelectFilesState> {
  SelectFilesCubit() : super(SelectFilesInitial());
  late bool isAsc;

  late bool isSwx;

  late bool isACD;

  late bool dateTime;
  late bool logLevel;
  late bool threadId;
  List<String> ascwsfiles = [];
  List<String> acdavayafiles = [];
  List<String> swxevdfiles = [];
  List<String> filterList = [];
  String threadids = "";
  List<String> logLevels = [];
  String startDatetime = "";
  String endDatetime = "";
  String agentId = "-1";

  void init() {
    isAsc = false;
    isSwx = false;
    isACD = false;
    dateTime = false;
    logLevel = false;
    threadId = false;
  }

  Future<void> sendFiles(Map<String, dynamic> json) async {
    try {
      var url = Uri.parse('http://127.0.0.1:8111/logAggregator');
      var res = await http.post(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(json));
      print(jsonDecode(jsonDecode(res.body)['agentStory']));
      generateExcel(jsonDecode(jsonDecode(res.body)['agentStory']));
      print("done");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> generateExcel(jsonData) async {
    Excel excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow(
        ["index", "DateTime", "LogLevel", "Thread", "content", "Type"]);
    print("started saving");
    for (var data in jsonData) {
      sheet.appendRow([
        data["index"],
        data["DateTime"],
        data["LogLevel"],
        data["Thread"],
        data["content"],
        data["Type"]
      ]);
      //print(data["index"]);
    }
    var file = File('/Users/mokshadvaidya/Documents/Internship/log.xlsx');
    file.writeAsBytesSync(excel.save()!);
    print("file saved");
  }

  Future<void> generateFilterList() async {
    filterList.clear();
    if (dateTime) {
      filterList.add("1");
    }
    if (threadId) {
      filterList.add("2");
    }
    if (logLevel) {
      filterList.add("3");
    }
    print(filterList);
  }

  Future<void> getFiles(LogFileType type, bool isMultiple) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: isMultiple);
    log("result is $result");
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        List<int> fileBytes = file.bytes!;
        String encodedFile = base64.encode(fileBytes);
        log("encoded file is $encodedFile");
        if (type == LogFileType.acd) {
          acdavayafiles.add(encodedFile);
        } else if (type == LogFileType.awa) {
          ascwsfiles.add(encodedFile);
        } else {
          swxevdfiles.add(encodedFile);
        }
      }
    }
  }

  void makeJson() {
    Map<String, dynamic> json = {};
    if (agentId == "-1") {
      emit(SelectFilesError("Please Enter Valid AgentId"));
    } else {
      json["AgentId"] = agentId;
    }
    if (filterList.isEmpty) {
      emit(SelectFilesError("Please Select Atleast One Filter"));
    } else {
      if (filterList.contains("1")) {
        if (startDatetime == "" || endDatetime == "") {
          emit(SelectFilesError("Please Select Start and End Date"));
        } else {
          json["startDatetime"] = startDatetime;
          json["endDatetime"] = endDatetime;
        }
      }
      if (filterList.contains("2")) {
        List<String> threadIds =
            threadids.split(',').map((part) => part.trim()).toList();
        if (threadIds.isEmpty) {
          emit(SelectFilesError("Please Enter threadIds"));
        } else {
          json["threadIds"] = threadIds;
        }
      }
      if (filterList.contains("3")) {
        if (logLevels.isEmpty) {
          emit(SelectFilesError("Please Select Log Levels"));
        } else {
          json["logLevels"] = logLevels;
        }
      }
      json["filterList"] = filterList;
    }
    if (!isAsc && !isACD && !isSwx) {
      emit(SelectFilesError("Please Select Atleast One File"));
    } else {
      json["files"] = {
        'ascwsfiles': ascwsfiles,
        'acdavayafiles': acdavayafiles,
        'swxevdfiles': swxevdfiles
      };
    }
    sendFiles(json);
  }
}
