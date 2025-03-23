part of 'menu_bloc.dart';

class MenuState extends Equatable {
  final String selectedPage;
  final String? selectedCategoryId;
  final String? selectedCategoryname;
  final Map<String, bool> hoveredItems;

  const MenuState({
    this.selectedPage = 'Dashboard',
    this.selectedCategoryId,
    this.selectedCategoryname,
    this.hoveredItems = const {},
  });

  MenuState copyWith({
    String? selectedPage,
    String? selectedCategoryId,
    String? selectedCategoryName,
    Map<String, bool>? hoveredItems,
  }) {
    return MenuState(
      selectedPage: selectedPage ?? this.selectedPage,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryname: selectedCategoryName ?? selectedCategoryname,
      hoveredItems: hoveredItems ?? this.hoveredItems,
    );
  }

  @override
  List<Object?> get props => [
        selectedPage,
        selectedCategoryId,
        selectedCategoryname,
        hoveredItems,
      ];
}