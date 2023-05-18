import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aggregator/features/fileaccess/presentation/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import '../cubit/select_files_cubit.dart';

class UploadLinks extends StatefulWidget {
  const UploadLinks({super.key});

  @override
  State<UploadLinks> createState() => _UploadLinksState();
}

class _UploadLinksState extends State<UploadLinks> {
  late TextEditingController controller;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    print("result is $result");
    if (result != null && result.files.isNotEmpty) {
      // Handle the picked files here
      for (var file in result.files) {
        List<int> fileBytes = file.bytes!;

        // Encode the file contents to Base64
        String encodedFile = base64.encode(fileBytes);

        // Convert Base64 to a string
        String encodedFileString = encodedFile.substring(0,encodedFile.length-2).toString();
        print("encoded file is $encodedFileString");
        var url = Uri.parse('http://127.0.0.1:5000/logAggregator');

        var res = await http.post(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },body: jsonEncode({
          "AgentId": "2",
          "filterList": '["1", "2"]',
          "startDatetime": "2023-01-27 14:30:21.220",
          "endDatetime": "2023-01-27 15:30:21.220",
          // "threadIds": threadIds,
          "files": {
            'ascwsfiles': [encodedFileString],
            'acdavayafiles':[],
            'swxevdfiles':[]
          }
        }));
        print(res.body);
      }
    }
  }

  List<String> logLevels = [
    "Select Log Level",
    "Trace",
    "Debug",
    "Error",
    "Warning"
  ];
  String dropdownValue = "Select Log Level";
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var selectFileCubit = BlocProvider.of<SelectFilesCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nice Systems"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/mainBackground.jpg"))),
            child: Column(children: [
              selectFileCubit.isACD
                  ? CustomTextField("Upload ACD Files", Icons.abc,
                      controller: controller, obscureText: false)
                  : SizedBox(),
              selectFileCubit.isAwaya
                  ? CustomTextField("Upload Awaya Files", Icons.abc,
                      controller: controller, obscureText: false)
                  : SizedBox(),
              selectFileCubit.isAcxwx
                  ? CustomTextField("Upload Acxwx Files", Icons.abc,
                      controller: controller, obscureText: false)
                  : SizedBox(),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField("Agent ID", Icons.abc,
                          controller: controller, obscureText: false)),
                  selectFileCubit.threadId
                      ? Expanded(
                          child: CustomTextField("Thread ID", Icons.abc,
                              controller: controller, obscureText: false))
                      : SizedBox(),
                  selectFileCubit.logLevel
                      ? Expanded(
                          child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: logLevels
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ))
                      : SizedBox()
                ],
              ),
              selectFileCubit.dateTime
                  ? DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      onChanged: (val) => print(val),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) => print(val),
                    )
                  : SizedBox(),
              ElevatedButton(
                onPressed: _pickFiles,
                child: Text('Pick Files'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
