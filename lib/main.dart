import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomvvm/repository/todo_repository.dart';
import 'package:todomvvm/view/todos_page.dart';
import 'package:todomvvm/viewModel/todo_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository = TodoRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoBloc(todoRepository),
        child: const TodosPage(),
      ),
    );
  }
}
