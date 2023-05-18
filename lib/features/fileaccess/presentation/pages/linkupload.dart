import 'dart:convert';
import 'dart:developer';
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
  late TextEditingController agentIdController;
  late TextEditingController threadIdController;
  late TextEditingController startDateTimeController;
  late TextEditingController endDateTimeController;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    log("result is $result");
    if (result != null && result.files.isNotEmpty) {
      // Handle the picked files here
      for (var file in result.files) {
        List<int> fileBytes = file.bytes!;

        // Encode the file contents to Base64
        String encodedFile = base64.encode(fileBytes);

        // Convert Base64 to a string
        String encodedFileString = encodedFile.toString();
        log("encoded file is $encodedFileString");
        var url = Uri.parse('http://127.0.0.1:8111/logAggregator');

        var res = await http.post(url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "AgentId": "2",
              "filterList": ["1", "2"],
              "startDatetime": "2023-01-27 14:30:21.220",
              "endDatetime": "2023-01-27 15:30:21.220",
              // "threadIds": threadIds,
              "files": {
                'ascwsfiles': [],
                'acdavayafiles': [encodedFile],
                'swxevdfiles': []
              }
            }));
        log(res.body);
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
    agentIdController = TextEditingController();
  }

  bool acdSwiVal = false;
  bool swxSwiVal = false;
  bool ascSwiVal = false;

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
                  ? SelectFile(
                      title: "Upload ACD Files",
                      swival: acdSwiVal,
                      selectFilefuc: () {
                        selectFileCubit.getFiles(LogFileType.acd, acdSwiVal);
                      },
                      onPressed: (value) {
                        setState(() {
                          acdSwiVal = value;
                        });
                      })
                  : const SizedBox(),
              selectFileCubit.isAsc
                  ? SelectFile(
                      title: "Upload Ascws Files",
                      swival: ascSwiVal,
                      selectFilefuc: () {
                        selectFileCubit.getFiles(LogFileType.awa, ascSwiVal);
                      },
                      onPressed: (value) {
                        setState(() {
                          ascSwiVal = value;
                        });
                      })
                  : const SizedBox(),
              selectFileCubit.isSwx
                  ? SelectFile(
                      title: "Upload swxevd Files",
                      swival: swxSwiVal,
                      selectFilefuc: () {
                        selectFileCubit.getFiles(LogFileType.swx, swxSwiVal);
                      },
                      onPressed: (value) {
                        setState(() {
                          swxSwiVal = value;
                        });
                      })
                  : const SizedBox(),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField("Agent ID", Icons.abc,
                          controller: agentIdController, obscureText: false)),
                  selectFileCubit.threadId
                      ? Expanded(
                          child: CustomTextField("Thread ID", Icons.abc,
                              controller: threadIdController =
                                  TextEditingController(),
                              obscureText: false))
                      : const SizedBox(),
                  selectFileCubit.logLevel
                      ? Expanded(
                          child: DropdownButton<String>(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25.0)),
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
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
                      : const SizedBox()
                ],
              ),
              selectFileCubit.dateTime
                  ? Row(
                      children: [
                        Expanded(
                            child: CustomTextField("Start DateTime", Icons.abc,
                                controller: startDateTimeController =
                                    TextEditingController(),
                                obscureText: false)),
                        Expanded(
                            child: CustomTextField("End DateTime", Icons.abc,
                                controller: endDateTimeController =
                                    TextEditingController(),
                                obscureText: false)),
                      ],
                    )
                  : const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  selectFileCubit.agentId = agentIdController.text;
                  selectFileCubit.threadId
                      ? selectFileCubit.threadids = threadIdController.text
                      : "";
                  if (selectFileCubit.dateTime) {
                    selectFileCubit.startDatetime =
                        startDateTimeController.text;
                    selectFileCubit.endDatetime = endDateTimeController.text;
                  }
                  selectFileCubit.makeJson();
                },
                child: const Text('Upload Files'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class SelectFile extends StatelessWidget {
  SelectFile({
    super.key,
    required this.title,
    required this.swival,
    required this.selectFilefuc,
    required this.onPressed,
  });
  final String title;
  final bool swival;
  VoidCallback selectFilefuc;
  void Function(bool) onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: selectFilefuc,
          child: Text(title),
        ),
        Switch(
          value: swival, // Set the initial value of the switch
          onChanged: onPressed,
        ),
        Text("Is multiple files",style: TextStyle(color: Colors.white),)
      ],
    );
  }
}
