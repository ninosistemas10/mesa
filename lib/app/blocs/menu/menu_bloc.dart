import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState()) {
    on<SelectMenuEvent>(_onSelectMenu);
    on<HoverMenuEvent>(_onHoverMenu);
    _initializeHoverStates();
  }

  void _initializeHoverStates() {
    final initialHovers = {
      'Dashboard': false,
      'Categoria': false,
      'Mesa': false,
      'Producto': false,
    };
    emit(state.copyWith(hoveredItems: initialHovers));
  }

  void _onSelectMenu(SelectMenuEvent event, Emitter<MenuState> emit) {
  emit(state.copyWith(
    selectedPage: event.page,
    selectedCategoryId: event.categoryId,
    selectedCategoryName: event.categoryName
  ));
}

  void _onHoverMenu(HoverMenuEvent event, Emitter<MenuState> emit) {
    final updatedHovers = Map<String, bool>.from(state.hoveredItems)
      ..[event.page] = event.isHovering;
    
    emit(state.copyWith(hoveredItems: updatedHovers));
  }
}