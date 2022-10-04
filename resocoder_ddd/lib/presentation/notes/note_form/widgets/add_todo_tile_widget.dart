import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/misc/build_context_x.dart';
import 'package:resocoder_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (ctx, state) {
        ctx.formTodos = state.note.todos.value.fold(
          (f) => listOf<TodoItemPrimitive>(),
          (todoItemList) =>
              todoItemList.map((_) => TodoItemPrimitive.fromDomain(_)),
        );
      },
      buildWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      builder: (ctx, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a todo'),
          leading: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.add),
          ),
          onTap: () {
            ctx.formTodos = Provider.of<FormTodos>(ctx, listen: false)
                .value
                .plusElement(TodoItemPrimitive.empty());
            ctx.bloc<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(ctx.formTodos),
                );
          },
        );
      },
    );
  }
}
