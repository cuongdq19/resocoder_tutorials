import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:resocoder_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:resocoder_ddd/domain/notes/note.dart';
import 'package:resocoder_ddd/injection.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:resocoder_ddd/presentation/notes/note_form/widgets/todo_list_widget.dart';
import 'package:resocoder_ddd/presentation/routes/router.gr.dart';

class NoteFormPage extends StatelessWidget {
  final Note editedNote;

  const NoteFormPage({
    Key key,
    @required this.editedNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
          listenWhen: (p, c) =>
              p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
          listener: (ctx, state) {
            state.saveFailureOrSuccessOption.fold(() {}, (either) {
              either.fold((f) {
                FlushbarHelper.createError(
                    message: f.map(
                  unexpected: (_) =>
                      'Unexpected error occurred, please contact support.',
                  insufficientPermission: (_) => 'Insufficient permission ❌',
                  unableToUpdate: (_) => "Couldn't update the note.",
                )).show(context);
              }, (_) {
                ExtendedNavigator.of(context).popUntil(
                  (route) => route.settings.name == Routes.notesOverviewPage,
                );
              });
            });
          },
          buildWhen: (p, c) => p.isSaving != c.isSaving,
          builder: (ctx, state) {
            return Stack(
              children: <Widget>[
                const NoteFormPageScaffold(),
                SavingInProgressOverlay(
                  isSaving: state.isSaving,
                ),
              ],
            );
          }),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SavingInProgressOverlay({
    Key key,
    @required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (ctx, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.bloc<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          )
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidate: state.showErrorMessages,
              child: SingleChildScrollView(
                child: Column(
                  children: const <Widget>[
                    BodyField(),
                    ColorField(),
                    TodoList(),
                    AddTodoTile(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
