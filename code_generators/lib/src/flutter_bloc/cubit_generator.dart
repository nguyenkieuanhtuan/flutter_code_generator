// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations/annotations.dart';

import '../utils.dart';
import 'cubit_visitor.dart';

class CubitGenerator extends GeneratorForAnnotation<BaseCubit> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement || !element.isAbstract) {
      throw Exception('@BaseCubit required on abstract class');
    }

    final visitor =
        CubitVisitor(annotation: annotation, className: element.name);
    element.visitChildren(visitor);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // Định nghĩa class
    buffer.writeln(
        'class ${visitor.cubitClassName} extends ${visitor.className} {');

    final generateCRUD = generateCRUDMethods(visitor);
    buffer.writeln(generateCRUD);

    // Kết thúc lớp
    buffer.writeln('}');

    return buffer.toString();
  }

  String generateCRUDMethods(CubitVisitor visitor) {
    final objectName = visitor.cubitNameWithoutSuffix;
    final modelClassName = visitor.modelClassName;

    final parentsParameters = visitor.repositoryVisitor?.parentCollectionNames
            .map((p) => 'String ${Utilities.toSingular(p)}Id')
            .join(', ') ??
        '';
    final parentsVariable = visitor.repositoryVisitor?.parentCollectionNames
            .map((p) => '${Utilities.toSingular(p)}Id')
            .join(', ') ??
        '';

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // buffer.writeln('// ${visitor.log}');
    // buffer.writeln();

    // Khai báo và khởi tạo repository
    buffer.writeln('  final ${visitor.repositoryClassName} _repository;');

    buffer.writeln(
        '  ${visitor.cubitClassName}(this._repository) : super(_repository);');

    buffer.writeln();
    buffer.writeln('// CRUD Methods');

    // --------------------Start CRUD Generation Code--------------------//
    buffer.writeln('''
      Future<void> create$objectName(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}$modelClassName model) async {
        emit(${objectName}Loading());
        try {
          final result = await _repository.create${objectName}(${parentsVariable.isEmpty ? '' : '$parentsVariable, '}model);
          emit(${objectName}Loaded(result));
        } catch (e) {
          emit(${objectName}Error('Create $modelClassName error: \$e'));
        }
      }
  ''');

    buffer.writeln('''
      Future<void> update$objectName(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}$modelClassName model) async {
        emit(${objectName}Loading());
        try {
          final result = await _repository.update${objectName}(${parentsVariable.isEmpty ? '' : '$parentsVariable, '}model);
          emit(${objectName}Loaded(result));
        } catch (e) {
          emit(${objectName}Error('Update $modelClassName error: \$e'));
        }
      }
  ''');

    buffer.writeln('''
      Future<void> delete$objectName(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}String id) async {
        emit(${objectName}Loading());
        try {
          await _repository.delete${objectName}(${parentsVariable.isEmpty ? '' : '$parentsVariable, '}id);
          emit(${objectName}Initial());
        } catch (e) {
          emit(${objectName}Error('Delete $modelClassName error: \$e'));
        }
      }
  ''');

    buffer.writeln('''
      Future<void> read${objectName}ById(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}String id) async {
        emit(${objectName}Loading());
        try {
          final model = await _repository.read${objectName}ById(${parentsVariable.isEmpty ? '' : '$parentsVariable, '}id);
          if (model != null) {
            emit(${objectName}Loaded(model));
          } else {
            emit(${objectName}Error('Read $modelClassName by id error model not found.'));
          }
        } catch (e) {
          emit(${objectName}Error('Read $modelClassName by id error: \$e'));
        }
      }
  ''');

    return buffer.toString();
    // --------------------End copyWith Generation Code--------------------//
  }
}
