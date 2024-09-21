import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/widgets/store_logo.dart';
import 'package:store/core/widgets/store_text_button.dart';
import 'package:store/core/widgets/store_text_form_field.dart';
import '../../../core/generic_state.dart';
import '../auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<AuthCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericErrorState) {
          final snackBar = SnackBar(
            content: Text(state.errorMessage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is GenericLoadedState) {
          Navigator.pushReplacementNamed(context, "/product");
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const StoreLogo(),
                SizedBox(
                  height: size.height * 0.2,
                ),
                BlocBuilder<AuthCubit, GenericState>(
                  builder: (context, state) {
                    if (state is GenericLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }
                    return Form(
                      key: _key,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            StoreTextFormField(
                              prefixIcon: const Icon(Icons.email),
                              label: "Email",
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            StoreTextFormField(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscureText = !_isObscureText;
                                  });
                                },
                                icon: Icon(
                                  _isObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              label: "Password",
                              obscureText: _isObscureText,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Password';
                                } else if (value.length < 6) {
                                  return "Password minimum 6 characters";
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  StoreTextButton(
                                    text: "Forgot Password ?",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                        password: _passwordController.text,
                                        email: _emailController.text);
                                  }
                                },
                                child: const Text("Login"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't have any account ",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  StoreTextButton(
                                    text: "Sign Up Here ?",
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, "/register");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
