import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_ddd/application/auth/auth_bloc.dart';
import 'package:resocoder_ddd/application/notes/note_actor/note_actor_bloc.dart';
import 'package:resocoder_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:resocoder_ddd/injection.dart';
import 'package:resocoder_ddd/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:resocoder_ddd/presentation/routes/router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (ctx) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (ctx) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (ctx, state) {
              state.maybeMap(
                unauthenticated: (_) => ExtendedNavigator.of(context)
                    .pushReplacementNamed(Routes.signInPage),
                orElse: () {},
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (ctx, state) {
              state.maybeMap(
                orElse: () {},
                deleteFailure: (state) => FlushbarHelper.createError(
                  duration: const Duration(seconds: 5),
                  message: state.noteFailure.map(
                      unableToUpdate: (_) => 'Impossible error.',
                      insufficientPermission: (_) =>
                          'Insufficient permissions.',
                      unexpected: (_) =>
                          'Unexpected error occurred while deleting, please contact support.'),
                ).show(context),
              );
            },
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.bloc<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.indeterminate_check_box),
                onPressed: () {},
              )
            ],
          ),
          body: NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Navigate to NoteFormPage
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
