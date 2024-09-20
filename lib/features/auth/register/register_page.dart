import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/auth_cubit.dart';
import '../../../core/generic_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericErrorState) {
          final snackBar = SnackBar(
            content: Text(state.errorMessage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            BlocBuilder<AuthCubit, GenericState>(
              builder: (context, state) {
                if (state is GenericLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Form(
                  key: _key,
                  child: Column(
                    children: [
                      StoreTextFormField(
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
                        label: "Password",
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              context.read<AuthCubit>().register(
                                  password: _passwordController.text,
                                  email: _emailController.text);
                            }
                          },
                          child: const Text("Register")),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
