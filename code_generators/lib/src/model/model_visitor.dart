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

import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations/model_annotation.dart';

class DataField {
  final String name;
  final String type;
  final String comment;
  final bool isEnum;
  final bool isModel;
  final bool isListModel;
  final String tableRef;
  final bool isUnique;

  DataField(
      {required this.name,
      required this.type,
      this.comment = '',
      this.isEnum = false,
      this.isModel = false,
      this.tableRef = '',
      this.isListModel = false,
      this.isUnique = false});

  static String _getStoreTableRegex(String input) {
    final regex = RegExp(r'Ref\((.*?)\)'); // Biểu thức chính quy
    final Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1) ?? ''; // Trả về group 1 (nội dung trong ngoặc)
    } else {
      return '';
    }
  }

  static bool isFieldEnum(FieldElement field) {
    final fieldType = field.type;

    // 1. Check if the type is a class. Enums are represented as classes.
    if (fieldType is! InterfaceType) {
      return false;
    }

    final interfaceType = fieldType;
    final Element? element = interfaceType.element;

    // 2. Check if the class element is an enum.
    if (element is! EnumElement) {
      return false;
    }

    return true;
  }

  factory DataField.fromElement(FieldElement element) {
    final lowerCase = element.documentationComment?.toLowerCase() ?? '';

    final isModel =
        lowerCase.contains('ismodel') || lowerCase.contains('model');
    final isListModel =
        lowerCase.contains('islist') || lowerCase.contains('list');
    final isUnique =
        lowerCase.contains('isunique') || lowerCase.contains('unique');
    final ref = _getStoreTableRegex(element.documentationComment ?? '');
    final elementType = element.type.toString();

    return DataField(
        name: element.name,
        type: elementType.replaceFirst('*', ''),
        isModel: isModel,
        isEnum: isFieldEnum(element),
        tableRef: ref,
        isListModel: isListModel,
        isUnique: isUnique);
  }

  @override
  String toString() {
    return 'Name:$name type:$type isEnum:$isEnum isListModel:$isListModel tabbleRef:$tableRef';
  }
}

extension FieldElementExtension on FieldElement {
  String get typeName => type.toString().replaceFirst('*', '');

  String get fieldName => name.startsWith('_') ? name.substring(1) : name;

  bool get isEnum {
    final fieldType = type;

    // 1. Check if the type is a class. Enums are represented as classes.
    if (fieldType is! InterfaceType) {
      return false;
    }

    final interfaceType = fieldType;
    final Element? element = interfaceType.element;

    // 2. Check if the class element is an enum.
    if (element is! EnumElement) {
      return false;
    }

    return true;
  }

  bool get isUnique {
    const checker = TypeChecker.fromRuntime(UniqueField);

    return checker.hasAnnotationOf(this);
  }

  bool isBaseModel(Element element) {
    const checker = TypeChecker.fromRuntime(BaseModel);
    return checker.hasAnnotationOf(element);
  }

  bool get isModel {
    final fieldType = type;
    if (fieldType is! InterfaceType) {
      return false;
    }

    final fieldClass = fieldType.element;
    return isBaseModel(fieldClass);
  }

  bool get isList {
    final fieldType = type;
    if (fieldType is! InterfaceType) {
      return false;
    }

    return fieldType.element.name == 'List';
  }

  bool get isListModel {
    final fieldType = type;
    if (fieldType is! InterfaceType) {
      return false;
    }

    if (fieldType.element.name != 'List') {
      return false;
    }
    // Lấy kiểu dữ liệu bên trong của List
    final innerType = fieldType.typeArguments.first;
    if (innerType is! InterfaceType) {
      return false;
    }

    // Kiểm tra xem kiểu bên trong có phải là model không
    final innerClass = innerType.element;
    return isBaseModel(innerClass);
  }

  String get tableRef {
    // 1. Tạo một TypeChecker để tìm kiếm annotation @TableRef
    const checker = TypeChecker.fromRuntime(TableRef);

    // 2. Lấy đối tượng của annotation (nếu có)
    final annotation = checker.firstAnnotationOf(this);

    // 3. Nếu không có annotation, trả về chuỗi rỗng
    if (annotation == null) {
      return '';
    }

    // 4. Lấy giá trị của thuộc tính 'name' và trả về
    return annotation.getField('name')!.toStringValue()!;
  }
}

class ModelVisitor extends SimpleElementVisitor<void> {
  late String modelClassName;
  late String baseClassName;

  Map<String, FieldElement> fields = <String, FieldElement>{};
  Map<String, MethodElement> methods = <String, MethodElement>{};
  String idField = '';

  String log = 'Log: ';

  @override
  void visitConstructorElement(ConstructorElement element) {
    log = '$log visitConstructorElement ${element.documentationComment}';

    final elementReturnType = element.type.returnType.toString();

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    modelClassName = elementReturnType.replaceFirst('*', '');
    baseClassName = modelClassName.endsWith('Model')
        ? modelClassName.substring(0, modelClassName.length - 5)
        : modelClassName;
  }

  @override
  void visitFieldElement(FieldElement element) {
    log = '$log visitFieldElement ${element.name} ${element.type.toString()}';

    final documentationComment = element.documentationComment ?? '';

    if (documentationComment.toLowerCase().contains('id')) {
      idField = element.name;
    }

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
