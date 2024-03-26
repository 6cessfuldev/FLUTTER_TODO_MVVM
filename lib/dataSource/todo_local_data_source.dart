import 'package:shared_preferences/shared_preferences.dart';
import 'package:todomvvm/model/todo.dart';
import 'dart:convert';

class TodoLocalDataSource {
  static const String _todoListKey = 'todoList';

  Future<List<Todo>> getTodoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? todoListJson = prefs.getString(_todoListKey);
    if (todoListJson != null) {
      final List<dynamic> jsonList = json.decode(todoListJson) as List<dynamic>;
      final List<Todo> todoList = jsonList
          .map((jsonItem) => Todo.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
      return todoList;
    } else {
      return [];
    }
  }

  Future<bool> saveTodoList(List<Todo> todoList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String todoListJson =
        json.encode(todoList.map((item) => item.toJson()).toList());
    return prefs.setString(_todoListKey, todoListJson);
  }

  Future<bool> addTodo(Todo item) async {
    final List<Todo> todoList = await getTodoList();
    todoList.add(item);
    return saveTodoList(todoList);
  }

  Future<bool> removeTodo(String id) async {
    final List<Todo> todoList = await getTodoList();
    todoList.removeWhere((item) => item.id == id);
    return saveTodoList(todoList);
  }

  Future<bool> updateTodo(Todo updatedTodo) async {
    final List<Todo> todoList = await getTodoList();
    final int index = todoList.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todoList[index] = updatedTodo;
      return await saveTodoList(todoList);
    }
    return false;
  }
}
