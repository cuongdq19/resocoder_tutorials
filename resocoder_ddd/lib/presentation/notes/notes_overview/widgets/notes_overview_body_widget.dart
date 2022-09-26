import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:resocoder_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:resocoder_ddd/presentation/notes/notes_overview/widgets/critical_error_display_widget.dart';
import 'package:resocoder_ddd/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:resocoder_ddd/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (ctx, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loadSuccess: (state) {
            return ListView.builder(
              itemCount: state.notes.size,
              itemBuilder: (c, i) {
                final note = state.notes[i];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note: note);
                }
                return NoteCard(
                  note: note,
                );
              },
            );
          },
          loadFailure: (state) {
            return CriticalErrorDisplay(failure: state.noteFailure);
          },
        );
      },
    );
  }
}
