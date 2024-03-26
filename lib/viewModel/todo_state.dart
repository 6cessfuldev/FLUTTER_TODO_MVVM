import 'package:equatable/equatable.dart';
import 'package:todomvvm/model/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodosLoadInProgress extends TodoState {}

class TodosLoadSuccess extends TodoState {
  final List<Todo> todos;

  TodosLoadSuccess([this.todos = const []]);

  @override
  List<Object?> get props => [todos];
}

class TodosLoadFailure extends TodoState {}
