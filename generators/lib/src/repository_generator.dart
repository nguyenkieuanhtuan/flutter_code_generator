// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/annotations.dart';

import 'database_visitor.dart';

class RepositoryGenerator extends GeneratorForAnnotation<DatabaseAnnotation> {
  
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    
    final visitor = DatabaseVisitor();
    element.visitChildren(visitor);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    final modelClassName = annotation.read('forClassName').toString();
    buffer.writeln('// forClassName: $modelClassName');

    // copyWith
    final generateBase = generateBaseMethods(visitor);
    buffer.writeln(generateBase);

    return buffer.toString();
  }

  String generateBaseMethods(DatabaseVisitor visitor) {
    // Class name from model visitor
    // final databaseClassName = visitor.databaseClassName;
    // final modelClassName = visitor.modelClassName;        
    final repositoryClassName = visitor.repositoryClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // buffer.writeln('// ${visitor.log}');    
    // buffer.writeln();

    // --------------------Start copyWith Generation Code--------------------//
    buffer.writeln(
        '// Extension for a ${repositoryClassName}Repository class to provide base method');
    buffer.writeln('extension \$${repositoryClassName}Extension on ${repositoryClassName} {');

    for (var i = 0; i < visitor.methods.length; i++) {
      final methodElement = visitor.methods.values.elementAt(i);
      final methodName = visitor.methods.keys.elementAt(i);
      
      buffer.writeln('$methodElement {');
      buffer.writeln('return database.$methodName(');
      for (final variable in methodElement.parameters) {  
        if(variable.isNamed){
          buffer.write('${variable.name} : ${variable.name},');
        }
        else {
          buffer.write('${variable.name},');
        }
      }
      buffer.write(');');
      buffer.writeln('}');
    }
    
    buffer.writeln('}');
    
    return buffer.toString();
    // --------------------End copyWith Generation Code--------------------//
  }
  
}
