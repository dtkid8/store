import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/auth_cubit.dart';

import '../../core/generic_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductView();
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
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
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
        ),
      ),
    );
  }
}
