import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/annotations.dart';

class Utilities {
  static String classNameToVariable(String className) {
    return className.replaceRange(
        0, 0, className.substring(0, 1).toLowerCase());
  }

  static String removeModelInName(String name) {
    return name.replaceAll('Model', '');
  }

  static bool isClassModel(String className) {
    final baseClass = ['int', 'double', 'num', 'String', 'DateTime', 'bool'];

    return baseClass.contains(className);
  }

  static List<DatabaseType> getDatabaseTypes(ConstantReader annotation) {
    final optionsReader = annotation.read('types');
    final optionsList = optionsReader.listValue;

    final selectedOptions = <DatabaseType>[];
    for (final option in optionsList) {
      // Lấy tên của enum dưới dạng chuỗi
      final enumName = option.getField('index')!.toIntValue()!;
      final enumValue = DatabaseType.values[enumName];
      selectedOptions.add(enumValue);
    }

    return selectedOptions;
  }

  static ConstantReader? getAnnotationOfType(Element element, Type type) {
    final typeChecker = TypeChecker.fromRuntime(type);

    // Tìm annotation [type] trên [element]
    final annotaton = typeChecker.firstAnnotationOf(element);

    if (annotaton == null) {
      return null;
    }

    // Bây giờ bạn có thể truy cập các thuộc tính của annotation [type]
    return ConstantReader(annotaton);
  }

  static String toSingular(String pluralWord) {
    final irregulars = {
      'children': 'child',
      'people': 'person',
      'men': 'man',
      'women': 'woman',
      'feet': 'foot',
      'teeth': 'tooth',
      'mice': 'mouse',
    };

    if (irregulars.containsKey(pluralWord)) {
      return irregulars[pluralWord]!;
    }

    if (pluralWord.endsWith('ies')) {
      return pluralWord.substring(0, pluralWord.length - 3) + 'y';
    }

    if (pluralWord.endsWith('es')) {
      return pluralWord.substring(0, pluralWord.length - 2);
    }

    if (pluralWord.endsWith('s')) {
      return pluralWord.substring(0, pluralWord.length - 1);
    }

    return pluralWord; // Trả về chính nó nếu không tìm thấy quy tắc nào
  }

  static String removePrefix(String value, String prefix) {
    if (value.startsWith(prefix)) {
      return value.substring(prefix.length);
    }
    return value;
  }

  static String removeSuffix(String value, String suffix) {
    if (value.endsWith(suffix)) {
      return value.substring(0, value.length - suffix.length);
    }

    return value;
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

  bool get isId {
    const checker = TypeChecker.fromRuntime(IdField);

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
