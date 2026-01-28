import 'package:flutter_bloc/flutter_bloc.dart';{{#use_equatable}}
import 'package:equatable/equatable.dart';{{/use_equatable}}

part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  final {{{datasource_name}}} datasource;

  {{name.pascalCase()}}Bloc({
    required this.datasource,
  }) : super(const {{name.pascalCase()}}Initial()) {
    on<Fetch{{name.pascalCase()}}>(_onFetch{{name.pascalCase()}});
  }

  Future<void> _onFetch{{name.pascalCase()}}(
    Fetch{{name.pascalCase()}} event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit(const {{name.pascalCase()}}Loading());
    
    try {
      final data = await datasource.{{{datasource_method}}}();
      emit({{name.pascalCase()}}Loaded(data));
    } catch (e) {
      emit({{name.pascalCase()}}Error(e.toString()));
    }
  }
}