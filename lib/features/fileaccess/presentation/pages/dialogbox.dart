import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aggregator/features/fileaccess/presentation/cubit/select_files_cubit.dart';
import 'package:log_aggregator/features/fileaccess/presentation/pages/linkupload.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool isAwaya = false;

  bool isAcxwx = false;

  bool isACD = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectFilesCubit()..init(),
      child: BlocBuilder<SelectFilesCubit, SelectFilesState>(
        builder: (context, state) {
          var selectFileCubit = BlocProvider.of<SelectFilesCubit>(context);
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              color: Colors.white,
              child: Column(
                children: [
                  const Text("Select log files you are uploading"),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.isAsc,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.isAsc = value!;
                          });
                        },
                      ),
                      const Text("Awaya log file")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.isACD,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.isACD = value!;
                          });
                        },
                      ),
                      const Text("ACD log file")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.isSwx,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.isSwx = value!;
                          });
                        },
                      ),
                      const Text("Acxwx log file")
                    ],
                  ),
                  const Text("Choose Filtering criteria"),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.dateTime,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.dateTime = value!;
                          });
                        },
                      ),
                      const Text("Date Time")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.threadId,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.threadId = value!;
                          });
                        },
                      ),
                      const Text("Thread Id")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: selectFileCubit.logLevel,
                        onChanged: (bool? value) {
                          setState(() {
                            selectFileCubit.logLevel = value!;
                          });
                        },
                      ),
                      const Text("Log Level")
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        selectFileCubit.generateFilterList();
                        print(selectFileCubit.filterList);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider.value(
                            value: selectFileCubit,
                            child: const UploadLinks(),
                          );
                        }));
                      },
                      child: const Text("Upload links >>"))
                ],
              ));
        },
      ),
    );
  }
}
