part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class SelectMenuEvent extends MenuEvent {
  final String page;
  final String? categoryId;
  final String? categoryName;

  const SelectMenuEvent({required this.page, this.categoryId, this.categoryName});

  @override
  List<Object> get props => [page, categoryId ?? '', categoryName ?? ''];
}

class HoverMenuEvent extends MenuEvent {
  final String page;
  final bool isHovering;

  const HoverMenuEvent({required this.page, required this.isHovering});

  @override
  List<Object> get props => [page, isHovering];
}