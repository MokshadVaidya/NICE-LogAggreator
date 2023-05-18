part of 'select_files_cubit.dart';

@immutable
abstract class SelectFilesState {}

class SelectFilesInitial extends SelectFilesState {}

class SelectFilesError extends SelectFilesState {
  final String message;
  SelectFilesError(this.message);
}
