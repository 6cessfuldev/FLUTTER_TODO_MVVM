import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomvvm/model/todo.dart';
import 'package:todomvvm/viewModel/todo_bloc.dart';
import 'package:todomvvm/viewModel/todo_event.dart';
import 'package:todomvvm/viewModel/todo_state.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  void _showAddTodoDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    void Function(TodoEvent event) addEvent = context.read<TodoBloc>().add;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 탭해도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todo 항목 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "제목"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(hintText: "내용"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                String uniqueId =
                    '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999999)}';
                Todo newTodo = Todo(
                    id: uniqueId,
                    title: titleController.text,
                    description: contentController.text);

                addEvent(TodoAdded(newTodo));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      var state = context.watch<TodoBloc>().state;
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
                  context
                      .read<TodoBloc>()
                      .add(TodoUpdated(todo.copyWith(isCompleted: newValue!)));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.read<TodoBloc>().add(TodoDeleted(todo.id));
                },
              ),
            );
          },
        );
      } else {
        return const Center(child: Text('할 일 목록을 불러오는 데 실패했습니다.'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('할 일 목록')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
