import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomvvm/repository/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../model/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(TodoRepository todoRepository)
      : _todoRepository = todoRepository,
        super(TodosLoadInProgress()) {
    on<TodoAdded>(_onTodoAdded);
    on<TodoUpdated>(_onTodoUpdated);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodosLoaded>(_onTodosLoaded);
  }

  Future<void> _onTodoAdded(TodoAdded event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      await _todoRepository.addTodo(event.todo);
      final List<Todo> updatedTodos = await _todoRepository.getTodoList();
      emit(TodosLoadSuccess(updatedTodos));
    }
  }

  Future<void> _onTodoUpdated(
      TodoUpdated event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      await _todoRepository.updateTodo(event.todo);
      final List<Todo> updatedTodos = await _todoRepository.getTodoList();
      emit(TodosLoadSuccess(updatedTodos));
    }
  }

  Future<void> _onTodoDeleted(
      TodoDeleted event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      await _todoRepository.removeTodo(event.id);
      final updatedTodos = await _todoRepository.getTodoList();
      emit(TodosLoadSuccess(updatedTodos));
    }
  }

  Future<void> _onTodosLoaded(
      TodosLoaded event, Emitter<TodoState> emit) async {
    try {
      final todos = await _todoRepository.getTodoList();
      emit(TodosLoadSuccess(todos));
    } catch (_) {
      emit(TodosLoadFailure());
    }
  }
}
