import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/category/category.dart';
import 'package:store/features/category/category_repository.dart';

class CategoryCubit extends Cubit<GenericState> {
  final CategoryRepository categoryRepository;
  final List<Category> _categories = [
    Category(
      id: 0,
      name: "All",
      image: "",
      creationAt: DateTime(0),
      updatedAt: DateTime(0),
    ),
  ];
  List<Category> get categorys => _categories;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  CategoryCubit({
    required this.categoryRepository,
  }) : super(GenericInitializeState());

  void fetch() async {
    emit(GenericLoadingState());
    final result = await categoryRepository.getCategory();
    result.fold((l) {
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) {
      _categories.addAll(r);
      emit(GenericLoadedState<List<Category>>(data: _categories));
    });
  }

  void change(int index) {
    _selectedIndex = index;
    emit(GenericActionLoadedState(message: "Change index $index"));
    emit(GenericLoadedState<List<Category>>(data: _categories));
  }
}
