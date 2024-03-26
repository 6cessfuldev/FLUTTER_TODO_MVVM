import 'package:todomvvm/dataSource/todo_local_data_source.dart';
import 'package:todomvvm/model/todo.dart';

class TodoRepository {
  final TodoLocalDataSource _dataSource = TodoLocalDataSource();

  Future<List<Todo>> getTodoList() {
    return _dataSource.getTodoList();
  }

  Future<bool> saveTodoList(List<Todo> todoList) {
    return _dataSource.saveTodoList(todoList);
  }

  Future<bool> addTodo(Todo item) {
    return _dataSource.addTodo(item);
  }

  Future<bool> removeTodo(String id) {
    return _dataSource.removeTodo(id);
  }

  Future<bool> updateTodo(Todo updatedTodo) {
    return _dataSource.updateTodo(updatedTodo);
  }
}
