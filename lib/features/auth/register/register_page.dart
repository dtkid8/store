import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/auth_cubit.dart';
import '../../../core/generic_state.dart';
import '../../../core/widgets/store_logo.dart';
import '../../../core/widgets/store_text_button.dart';
import '../../../core/widgets/store_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        } else if (state is GenericActionLoadedState) {
          final snackBar = SnackBar(
            content: Text(state.message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        child: CircularProgressIndicator(color: Colors.black,),
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
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    context.read<AuthCubit>().register(
                                        password: _passwordController.text,
                                        email: _emailController.text);
                                    _passwordController.clear();
                                    _emailController.clear();
                                  }
                                },
                                child: const Text("Register"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Have an a account ",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  StoreTextButton(
                                    text: "Login Here",
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, "/login");
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
