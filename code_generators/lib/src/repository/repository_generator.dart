// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations/annotations.dart';

import '../utils.dart';
import 'repository_visitor.dart';

class RepositoryGenerator extends GeneratorForAnnotation<BaseRepository> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw Exception('@BaseRepository required on class');
    }

    final visitor =
        RepositoryVisitor(annotation: annotation, className: element.name);
    element.visitChildren(visitor);

    final className = element.name;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // Định nghĩa extentsion
    buffer.writeln('extension ${className}Extension on $className {');

    if (visitor.databaseTypes.contains(DatabaseType.firestore)) {
      final generateCRUD = generateCRUDFirestoreMethods(visitor);
      buffer.writeln(generateCRUD);
    }

    // Kết thúc lớp
    buffer.writeln('}');

    return buffer.toString();
  }

  String generateCRUDFirestoreMethods(RepositoryVisitor visitor) {
    final objectName = visitor.nameWithoutSuffix;

    final collectionName = visitor.collectionName;

    final modelClassName = visitor.modelClassElement?.name ?? '';

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // buffer.writeln('// ${visitor.log}');
    // buffer.writeln();

    buffer.writeln('// Firestore');

    final parentsParameters = visitor.parentCollectionNames
        .map((p) => 'String ${Utilities.toSingular(p)}Id')
        .join(', ');
    final parentsVariable = visitor.parentCollectionNames
        .map((p) => '${Utilities.toSingular(p)}Id')
        .join(', ');

    final pathSegments = <String>[];
    for (final parent in visitor.parentCollectionNames) {
      pathSegments.add(parent);
      pathSegments.add('\$${Utilities.toSingular(parent)}Id');
    }
    pathSegments.add(collectionName);

    final fullPath = pathSegments.join('/');

    buffer.writeln('''
      CollectionReference collectionRef(${parentsParameters}) => FirebaseFirestore.instance.collection(\'$fullPath\');
    ''');

    // --------------------Start CRUD Generation Code--------------------//
    buffer.writeln('''
      Future<$modelClassName> create${objectName}(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}$modelClassName model) async {
      try{
        DocumentReference docRef = await collectionRef(${parentsVariable}).add(model.toFirestore());

        return model.copyWith(${visitor.modelIdName}: docRef.id);
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<$modelClassName> update${objectName}(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}$modelClassName model) async {
      try {
        await collectionRef(${parentsVariable}).doc(model.${visitor.modelVisitor?.idField?.name ?? 'id'}).update(model.toFirestore());
        return model;
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<bool> delete${objectName}(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}String id) async {
      try {
        await collectionRef(${parentsVariable}).doc(id).delete();
        return true;
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<${modelClassName}?> read${objectName}ById(${parentsParameters.isEmpty ? '' : '$parentsParameters, '}String id) async {
      try {
        DocumentSnapshot doc = await collectionRef(${parentsVariable}).doc(id).get();
        if (doc.exists) {
          return ${modelClassName}.fromFirestore(doc);
        }
        return null;
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<List<${modelClassName}>> readAll${objectName}(${parentsParameters}) async {
      try {
        QuerySnapshot querySnapshot = await collectionRef(${parentsVariable}).get();
        return querySnapshot.docs
        .map((doc) => ${modelClassName}.fromFirestore(doc))
        .toList();
        } catch (e) {
    rethrow;
  }
      }
  ''');

    return buffer.toString();
    // --------------------End copyWith Generation Code--------------------//
  }
}
