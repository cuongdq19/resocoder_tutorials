import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:resocoder_ddd/domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (p, c) => p.note.color != c.note.color,
      builder: (ctx, state) {
        return SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              final itemColor = NoteColor.predefinedColors[i];

              return GestureDetector(
                onTap: () {
                  ctx
                      .bloc<NoteFormBloc>()
                      .add(NoteFormEvent.colorChanged(itemColor));
                },
                child: Material(
                  color: itemColor,
                  elevation: 4,
                  shape: CircleBorder(
                    side: state.note.color.value.fold(
                        (_) => BorderSide.none,
                        (color) => color == itemColor
                            ? const BorderSide(width: 1.5)
                            : BorderSide.none),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, i) {
              return const SizedBox(width: 12);
            },
            itemCount: NoteColor.predefinedColors.length,
          ),
        );
      },
    );
  }
}
