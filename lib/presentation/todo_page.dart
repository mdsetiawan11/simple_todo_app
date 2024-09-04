import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_todo_app/presentation/add_todo.dart';

import '../domain/models/todo.dart';
import 'todo_cubit.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shadTheme = ShadTheme.of(context);
    final shadTextTheme = ShadTextTheme();
    final todoCubit = context.read<TodoCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showShadSheet(
            side: ShadSheetSide.bottom,
            context: context,
            builder: (context) => const Add(side: ShadSheetSide.bottom),
          );
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: shadTheme.colorScheme.primary,
        title: Text(
          'Todo App',
          style: shadTextTheme.h3,
        ),
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          // List View
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              // get individual todo from todos list
              final todo = todos[index];

              // List Tile UI
              return ListTile(
                // text
                title: Text(
                  todo.text,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                // check box
                leading: ShadCheckbox(
                  value: todo.isCompleted,
                  onChanged: (value) => todoCubit.toggleCompletion(todo),
                ),

                // delete button
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    todoCubit.deleteTodo(todo);
                    ShadToaster.of(context).show(
                      const ShadToast(
                        description: Text('Deleted!'),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
