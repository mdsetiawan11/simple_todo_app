import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_todo_app/presentation/todo_cubit.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.side});
  final ShadSheetSide side;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final formKey = GlobalKey<ShadFormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    return ShadForm(
      key: formKey,
      child: ShadSheet(
          constraints: widget.side == ShadSheetSide.left ||
                  widget.side == ShadSheetSide.right
              ? const BoxConstraints(maxWidth: 512)
              : null,
          title: const Text('Add Todo'),
          actions: [
            ShadButton(
              enabled: isLoading ? false : true,
              icon: isLoading == true
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()) {
                  setState(() {
                    isLoading = true;
                  });

                  Future.delayed(const Duration(seconds: 5), () {
                    todoCubit.addTodo(formKey.currentState!.value['todo']);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  });
                } else {}
              },
              child: Text(isLoading == true ? 'Please Wait' : 'Save'),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadInputFormField(
                id: 'todo',
                placeholder: const Text('Todo'),
                keyboardType: TextInputType.text,
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Todo cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          )),
    );
  }
}
