part of 'mesa_bloc.dart';

abstract class MesaEvent extends Equatable {
  const MesaEvent();

  @override
  List<Object> get props => [];
}

class MesaInit extends MesaEvent {}

class GetAllMesa extends MesaEvent {}

class SaveMesa extends MesaEvent {
  final MesaData mesaData;
  const SaveMesa({ required this.mesaData});
}

class RemoveMesa extends MesaEvent{
  final String mesaId;
  const RemoveMesa({required this.mesaId});
}

class UpdatedMesa extends MesaEvent{
  final String mesaId;
  final String nombre;
  final String url;
  final bool activo;
  const UpdatedMesa({
    required this.mesaId, 
    required this.nombre, 
    required this.url, 
    required this.activo,
  });
}