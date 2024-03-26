import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomvvm/model/todo.dart';
import 'package:todomvvm/viewModel/todo_bloc.dart';
import 'package:todomvvm/viewModel/todo_event.dart';
import 'package:todomvvm/viewModel/todo_state.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoBloc>().add(TodosLoaded());
    });

    return Scaffold(
      appBar: AppBar(title: const Text('할 일 목록')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoadSuccess) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (bool? newValue) {
                      context.read<TodoBloc>().add(
                          TodoUpdated(todo.copyWith(isCompleted: newValue!)));
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('할 일 목록을 불러오는 데 실패했습니다.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String uniqueId =
              '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999999)}';
          Todo newTodo = Todo(id: uniqueId, title: '새로운 할 일');
          context.read<TodoBloc>().add(TodoAdded(newTodo));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
