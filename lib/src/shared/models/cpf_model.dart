import '../entities/cpf.dart';

class CpfModel extends Cpf {
  CpfModel(super.cpf);

  factory CpfModel.fromMap(Map<String, dynamic> map) {
    return CpfModel(map['cpf'] as String);
  }
}
