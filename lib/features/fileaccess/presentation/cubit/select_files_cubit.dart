import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'select_files_state.dart';

class SelectFilesCubit extends Cubit<SelectFilesState> {
  SelectFilesCubit() : super(SelectFilesInitial());
  late bool isAwaya;

  late bool isAcxwx;

  late bool isACD;

  late bool dateTime;
  late bool logLevel;
  late bool threadId;

  void init() {
    isAwaya = false;
    isAcxwx = false;
    isACD = false;
    dateTime = false;
    logLevel = false;
    threadId = false;
  }

  Future<void> sendFiles() async {
    var url = Uri.parse('http://127.0.0.1:5000/logAggregator');
    // var request = MultipartRequest('POST', url);
    // request.files.add(await MultipartFile.fromPath('file', 'path/to/file'));
    // request.send().then((response) {
    //   if (response.statusCode == 200) print('Uploaded!');
    // });
    var res = http.post(url, body: {
      "AgentId": 2,
      "filterList": [1, 2],
      "startDatetime": "2023-01-27 14:30:21.220",
      "endDatetime": "2023-01-27 15:30:21.220",
      // "threadIds": threadIds,
      "files": {
        // 'ascwsfiles':ascwsList,
      }
    });
  }
}
