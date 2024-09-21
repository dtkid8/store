import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/auth/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().check();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericInitializeState) {
          Navigator.pushReplacementNamed(context, "/login");
        } else if (state is GenericLoadedState) {
          Navigator.pushReplacementNamed(context, "/product");
        }
      },
      child: Scaffold(
        body: Center(
          child: Text(
            "Splash",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
