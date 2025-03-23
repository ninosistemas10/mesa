import 'package:equatable/equatable.dart';

import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';



class MesaState extends Equatable {
  final bool loading;
  final String error;
  final bool add;
  final bool removed;
  final bool updated;
  final List<MesaData> listMesa;

  const MesaState({
    this.loading = false,
    this.error = '',
    this.add = false,
    this.removed = false,
    this.updated = false,
    this.listMesa = const [],
  });

  MesaState copyWith({
    bool? loading,
    String? error,
    bool? add,
    bool? removed,
    bool? updated,
    List<MesaData>? listMesa,
  }) {
    return MesaState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      add: add ?? this.add,
      removed: removed ?? this.removed,
      updated: updated ?? this.updated,
      listMesa: listMesa ?? this.listMesa,
    );
  }

  @override
  List<Object> get props => [loading, error, add, removed, updated, listMesa];
}