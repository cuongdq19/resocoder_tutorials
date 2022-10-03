import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_ddd/application/auth/auth_bloc.dart';
import 'package:resocoder_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:resocoder_ddd/presentation/routes/router.gr.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (ctx, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) {
            either.fold(
              (failure) => FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Cancelled',
                  serverError: (_) => 'Server Error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) =>
                      'Invalid email and password combination',
                ),
              ).show(context),
              (_) {
                ExtendedNavigator.of(context).replace(Routes.notesOverviewPage);
                context
                    .bloc<AuthBloc>()
                    .add(const AuthEvent.authCheckRequested());
              },
            );
          },
        );
      },
      builder: (ctx, state) {
        return Form(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              const Text(
                '📝',
                style: TextStyle(fontSize: 130),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                autovalidate: state.showErrorMessages,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) => ctx
                    .bloc<SignInFormBloc>()
                    .add(SignInFormEvent.emailChanged(value)),
                validator: (_) =>
                    ctx.bloc<SignInFormBloc>().state.emailAddress.value.fold(
                          (f) => f.maybeMap(
                            invalidEmail: (_) => 'Invalid Email',
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                autovalidate: state.showErrorMessages,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => ctx
                    .bloc<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) =>
                    ctx.bloc<SignInFormBloc>().state.password.value.fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) => 'Short Password',
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        ctx.bloc<SignInFormBloc>().add(const SignInFormEvent
                            .signInWithEmailAndPasswordPressed());
                      },
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        ctx.bloc<SignInFormBloc>().add(const SignInFormEvent
                            .registerWithEmailAndPasswordPressed());
                      },
                      child: const Text('REGISTER'),
                    ),
                  )
                ],
              ),
              RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  ctx
                      .bloc<SignInFormBloc>()
                      .add(const SignInFormEvent.signInWithGooglePressed());
                },
                child: const Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        );
      },
    );
  }
}
