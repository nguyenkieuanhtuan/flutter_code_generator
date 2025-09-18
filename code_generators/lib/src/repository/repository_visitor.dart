// ignore_for_file: lines_longer_than_80_chars

/* Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify,
merge, publish, distribute, sublicense, create a derivative work,
and/or sell copies of the Software in any work that is designed,
intended, or marketed for pedagogical or instructional purposes
related to programming, coding, application development, or
information technology. Permission for such use, copying,
modification, merger, publication, distribution, sublicensing,
creation of derivative works, or sale is expressly withheld.

This project and source code may use libraries or frameworks
that are released under various Open-Source licenses. Use of
those libraries and frameworks are governed by their own
individual licenses.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE. */

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations/annotations.dart';
import '../model/model_visitor.dart';
import '../utils.dart';

/// RepositoryVisitor
class RepositoryVisitor extends SimpleElementVisitor<void> {
  final suffix = 'Repository';

  final ConstantReader annotation;

  RepositoryVisitor({required this.annotation, required this.className}) {
    // Ngay lập tức đọc thuộc tính và lưu trữ

    nameWithoutSuffix = Utilities.removeSuffix(className, suffix);

    _collectionName =
        annotation.read('collectionName').literalValue as String? ??
            nameWithoutSuffix.toLowerCase();
    _databaseTypes = Utilities.getDatabaseTypes(annotation);
    _parentCollectionNames = annotation
        .read('parentCollectionNames')
        .listValue
        .map((e) => e.toStringValue()!)
        .toList();

    final modelType = annotation.read('model').typeValue;
    if (!(modelType is! InterfaceType)) {
      _modelClassElement = modelType.element as ClassElement;

      if (_modelClassElement != null) {
        _modelClassName = _modelClassElement!.name;

        final modelAnnotation =
            Utilities.getAnnotationOfType(_modelClassElement!, BaseModel);
        if (modelAnnotation != null) {
          _modelVisitor = ModelVisitor(
              annotation: modelAnnotation, className: _modelClassElement!.name);
          _modelClassElement!.visitChildren(_modelVisitor!);
        }
      }
    }

    if (_modelClassName == null) {
      _modelClassName = '${nameWithoutSuffix}Model';
    }
  }

  String? _modelClassName;
  String get modelClassName => _modelClassName!;

  ClassElement? _modelClassElement;
  ClassElement? get modelClassElement => _modelClassElement;

  ModelVisitor? _modelVisitor;
  ModelVisitor? get modelVisitor => _modelVisitor;

  String get modelIdName => _modelVisitor?.idName ?? 'id';

  String? _collectionName;
  String get collectionName => _collectionName!;

  List<String> _parentCollectionNames = [];
  List<String> get parentCollectionNames => _parentCollectionNames;

  List<DatabaseType> _databaseTypes = [];
  List<DatabaseType> get databaseTypes => _databaseTypes;

  late String className;
  late String nameWithoutSuffix;

  Map<String, FieldElement> fields = <String, FieldElement>{};
  Map<String, MethodElement> methods = <String, MethodElement>{};

  String log = 'Log: ';

  // @override
  // void visitConstructorElement(ConstructorElement element) {
  //   log = '$log visitConstructorElement ${element.documentationComment}';

  //   final elementReturnType = element.type.returnType.toString();

  //   // DartType ends with '*', which needs to be eliminated
  //   // for the generated code to be accurate.
  //   className = elementReturnType.replaceFirst('*', '');
  //   nameWithoutSuffix = className.endsWith(suffix)
  //       ? className.substring(0, className.length - suffix.length)
  //       : className;
  // }

  @override
  void visitFieldElement(FieldElement element) {
    log = '$log visitFieldElement ${element.name} ${element.type.toString()}';

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    fields[element.name] = element;
  }

  @override
  void visitMethodElement(MethodElement element) {
    log = '$log visitMethodElement $element';

    methods[element.name] = element;
  }
}
