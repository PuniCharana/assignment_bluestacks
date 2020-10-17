import 'package:assignment_bluestacks/core/utils/app_localization.dart';
import 'package:assignment_bluestacks/modules/home/home.dart';
import 'package:assignment_bluestacks/modules/login/cubit/login_cubit.dart';
import 'package:assignment_bluestacks/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Container(
        padding: EdgeInsets.only(left: 32, right: 32),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              final snackBar = SnackBar(content: Text(AppLocalizations.of(context).translate('login_error')));
              Scaffold.of(context).showSnackBar(snackBar);
            } else if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          },
          builder: (context, state) => Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    // Logo
                    tag: "logo",
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 32),
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  ...loginForm(context),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity, // match_parent
                    child: toggleButton(context, state),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginForm(BuildContext context) {
    return [
      Container(
        margin: EdgeInsets.only(left: 16.0),
        child: TextFormField(
          controller: _userNameController,
          cursorColor: Colors.white,
          autofocus: false,
          style: TextStyle(color: Color(0Xfff6f6f6)),
          validator: (value) {
            return value.length < 3 || value.length > 10
                ? AppLocalizations.of(context).translate('invalid_username')
                : null;
          },
          onChanged: (val) => context.bloc<LoginCubit>().setPristine(),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: AppLocalizations.of(context).translate('username'),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        margin: EdgeInsets.only(left: 16.0),
        child: TextFormField(
          controller: _passwordController,
          cursorColor: Colors.white,
          autofocus: false,
          obscureText: true,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            return value.length < 3 || value.length > 11
                ? AppLocalizations.of(context).translate('invalid_password')
                : null;
          },
          onChanged: (val) => context.bloc<LoginCubit>().setPristine(),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: AppLocalizations.of(context).translate('password'),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    ];
  }

  Widget toggleButton(BuildContext context, LoginState state) {
    if (state is LoginLoading) {
      return Center(
        child: LoadingView(),
      );
    } else {
      return RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              AppLocalizations.of(context).translate('submit'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          color: Colors.amber,
          disabledColor: Colors.white30,
          disabledTextColor: Colors.white12,
          elevation: 4,
          onPressed: (state is LoginLoading) || (state is LoginError)
              ? null
              : () => {
                    if (_formKey.currentState.validate())
                      {
                        context.bloc<LoginCubit>().login(
                              _userNameController.text,
                              _passwordController.text,
                            )
                      }
                  });
    }
  }
}
