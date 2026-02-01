{{#use_equatable}}
import 'package:equatable/equatable.dart';
{{/use_equatable}}

part of '{{name.snakeCase()}}_bloc.dart';

{{#use_equatable}}
abstract class {{name.pascalCase()}}Event extends Equatable {
  const {{name.pascalCase()}}Event();
  
  @override
  List<Object?> get props => [];
}

class Fetch{{name.pascalCase()}} extends {{name.pascalCase()}}Event {
  const Fetch{{name.pascalCase()}}();
}
{{/use_equatable}}
{{^use_equatable}}
abstract class {{name.pascalCase()}}Event {
  const {{name.pascalCase()}}Event();
}

class Fetch{{name.pascalCase()}} extends {{name.pascalCase()}}Event {
  const Fetch{{name.pascalCase()}}();
}
{{/use_equatable}}