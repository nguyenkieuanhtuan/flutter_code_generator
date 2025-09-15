// ignore_for_file: lines_longer_than_80_chars

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'model_visitor.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/src/model_annotation.dart';

class JsonGenerator extends GeneratorForAnnotation<BaseModel> {
  @override
  String generateForAnnotatedElement(
    Element element, // Represent a class in this case.
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    // Visit class fields and constructor
    element.visitChildren(visitor);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // fromJson
    final generatedFromJSon = generateFromJsonMethod(visitor);
    buffer.writeln(generatedFromJSon);

    // toJson
    final generatedToJSon = generateToJsonMethod(visitor);
    buffer.writeln(generatedToJSon);

    return buffer.toString();
  }

  // Method to generate fromJSon method
  String generateFromJsonMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // --------------------Start fromJson Generation Code--------------------//
    buffer.writeln('// From Json Method');
    buffer.writeln(
        '$className _\$${className}FromJson(Map<String, dynamic> json) => ');
    buffer.write('$className(');

    for (var i = 0; i < visitor.dataFields.length; i++) {
      final fieldName = visitor.dataFields.keys.elementAt(i);
      final isModel = visitor.dataFields.values.elementAt(i).isModel;
      final dataType =
          visitor.dataFields.values.elementAt(i).type.replaceAll('?', '');

      final mapValue = "json['$fieldName']";

      if (isModel) {
        buffer.writeln(
          '${visitor.dataFields.keys.elementAt(i)}: ${dataType}.fromJson($mapValue),',
        );
      } else {
        buffer.writeln(
          '${visitor.dataFields.keys.elementAt(i)}: $mapValue,',
        );
      }
    }
    buffer.writeln(');');
    buffer.toString();
    return buffer.toString();
    // --------------------End fromJson Generation Code--------------------//
  }

  // Method to generate fromJSon method
  String generateToJsonMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // --------------------Start toJson Generation Code--------------------//
    buffer.writeln('// To Json Method');
    buffer.writeln(
        'Map<String, dynamic> _\$${className}ToJson($className instance) => ');
    buffer.write('<String, dynamic>{');
    for (var i = 0; i < visitor.dataFields.length; i++) {
      final fieldName = visitor.dataFields.keys.elementAt(i);
      final isModel = visitor.dataFields.values.elementAt(i).isModel;

      if (isModel) {
        buffer.writeln(
          "'$fieldName': instance.$fieldName.toJson,",
        );
      } else {
        buffer.writeln(
          "'$fieldName': instance.$fieldName,",
        );
      }
    }
    buffer.writeln('};');
    return buffer.toString();
    // --------------------End toJson Generation Code--------------------//
  }
}
