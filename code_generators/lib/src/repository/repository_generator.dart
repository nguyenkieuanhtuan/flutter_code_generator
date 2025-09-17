// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations.dart';

import 'repository_visitor.dart';

class RepositoryGenerator extends GeneratorForAnnotation<BaseRepository> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = RepositoryVisitor(annotation);
    element.visitChildren(visitor);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    if (visitor.databaseTypes.contains(DatabaseType.firestore)) {
      final generateBase = generateCRUDFirestoreMethods(visitor);
      buffer.writeln(generateBase);
    }

    return buffer.toString();
  }

  String generateCRUDFirestoreMethods(RepositoryVisitor visitor) {
    final collectionName =
        visitor.collectionName ?? visitor.nameWithoutSuffix.toLowerCase();

    final modelClassName = visitor.modelClassElement?.name ?? '';

    final collectionVariable = '_\$${collectionName}Collection';

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // buffer.writeln('// ${visitor.log}');
    // buffer.writeln();

    buffer.writeln('// Firestore');
    // --------------------Start CRUD Generation Code--------------------//
    buffer.writeln('''
        final $collectionVariable = FirebaseFirestore.instance.collection('$collectionName');
    ''');

    buffer.writeln('''
      Future<void> _\$Create${modelClassName}($modelClassName model) {
      try{
        return $collectionVariable.add(model.toFirestore());
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<void> _\$Update${modelClassName}($modelClassName model) {
      try {
        return $collectionVariable.doc(model.${visitor.modelVisitor?.idField?.name ?? 'id'}).update(model.toFirestore());
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<void> _\$Delete${modelClassName}(String id) {
      try {
        return $collectionVariable.doc(id).delete();
        } catch (e) {
    rethrow;
  }
      }
  ''');

    buffer.writeln('''
      Future<${modelClassName}?> _\$Read${modelClassName}ById(String id) async {
      try {
        DocumentSnapshot doc = await $collectionVariable.doc(id).get();
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
      Future<List<${modelClassName}>> _\$ReadAll${modelClassName}() async {
        QuerySnapshot querySnapshot = await $collectionVariable.get();
        return querySnapshot.docs
        .map((doc) => ${modelClassName}.fromFirestore(doc))
        .toList();
      }
  ''');

    return buffer.toString();
    // --------------------End copyWith Generation Code--------------------//
  }
}
