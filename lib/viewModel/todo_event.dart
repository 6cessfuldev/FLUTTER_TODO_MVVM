import 'package:equatable/equatable.dart';
import 'package:todomvvm/model/todo.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoAdded extends TodoEvent {
  final Todo todo;

  TodoAdded(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoUpdated extends TodoEvent {
  final Todo todo;

  TodoUpdated(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoDeleted extends TodoEvent {
  final String id;

  TodoDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class TodosLoaded extends TodoEvent {}
