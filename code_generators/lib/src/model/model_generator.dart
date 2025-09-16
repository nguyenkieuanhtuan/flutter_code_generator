// ignore_for_file: lines_longer_than_80_chars

import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../annotations.dart';
import 'model_visitor.dart';

class ModelGenerator extends GeneratorForAnnotation<BaseModel> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final options = getOptions(annotation);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();
    buffer.writeln('// Options: ${options}');
    buffer.writeln('// ${visitor.log}');
    buffer.writeln('// ${visitor.fields}');
    buffer.writeln();

    final generatedExtension = generateExtensionMethod(visitor);
    buffer.writeln(generatedExtension);

    buffer.writeln('// Map');
    final toMethod = generateToMapMethod(visitor);
    buffer.writeln(toMethod);

    final fromMethod = generateFromMapMethod(visitor);
    buffer.writeln(fromMethod);

    if (options.contains(BaseModelOptions.firestore)) {
      buffer.writeln('// Firestore');
      final toMethod = generateToFirestoreMethod(visitor);
      buffer.writeln(toMethod);

      final fromMethod = generateFromFirestoreMethod(visitor);
      buffer.writeln(fromMethod);
    }

    if (options.contains(BaseModelOptions.drift)) {
      final generateDriftTable = generateDriftTableMethod(visitor);
      buffer.writeln(generateDriftTable);

      final generateDriftCompanion = generateDriftCompanionMethod(visitor);
      buffer.writeln(generateDriftCompanion);
    }

    return buffer.toString();
  }

  List<BaseModelOptions> getOptions(ConstantReader annotation) {
    final optionsReader = annotation.read('options');
    final optionsList = optionsReader.listValue;

    final selectedOptions = <BaseModelOptions>[];
    for (final option in optionsList) {
      // Lấy tên của enum dưới dạng chuỗi
      final enumName = option.getField('index')!.toIntValue()!;
      final enumValue = BaseModelOptions.values[enumName];
      selectedOptions.add(enumValue);
    }

    return selectedOptions;
  }

  //MARK:- Extension
  String generateExtensionMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    buffer.writeln(
        "// Extension for a $className class to provide 'copyWith' method");
    buffer.writeln('extension \$${className}Extension on $className {');

    final idField = visitor.fields[visitor.idField];
    if (idField != null) {
      buffer.writeln(
          'bool get hasID => ${idField.typeName.contains('?') ? '${idField.name} != null &&' : ''} ${idField.name}.isNotEmpty;');
      buffer.writeln();
    }

    // --------------------Start copyWith Generation Code--------------------//
    buffer.writeln('$className copyWith({');
    for (var i = 0; i < visitor.fields.length; i++) {
      final dataType =
          visitor.fields.values.elementAt(i).typeName.replaceAll('?', '');
      final fieldName = visitor.fields.keys.elementAt(i);
      buffer.writeln(
        '$dataType? $fieldName,',
      );
    }
    buffer.writeln('}) {');
    buffer.writeln('return $className(');
    for (var i = 0; i < visitor.fields.length; i++) {
      final fieldName = visitor.fields.keys.elementAt(i);
      buffer.writeln(
        '${fieldName}: ${fieldName} ?? this.${fieldName},',
      );
    }
    buffer.writeln(');');
    buffer.writeln('}');
    // --------------------End copyWith Generation Code--------------------//

    buffer.writeln('}');
    buffer.toString();
    return buffer.toString();
  }

  //MARK: - Map
  String toFieldMap(FieldElement field) {
    final fieldName = field.name;

    if (field.isModel) {
      return 'instance.$fieldName.toMap()';
    } else if (field.isListModel) {
      return 'instance.$fieldName.map((e) => e.toMap()).toList()';
    } else if (field.isList) {
      return 'instance.$fieldName';
    } else if (field.isEnum) {
      return 'instance.$fieldName.index';
    }

    return 'instance.$fieldName';
  }

  String generateToMapMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // toMap
    buffer.writeln(
        'Map<String, dynamic> _\$${className}ToMap($className instance) {');

    buffer.writeln('return {');
    for (final field in visitor.fields.values) {
      final fieldName = field.fieldName;
      buffer.writeln("'${fieldName}': ${toFieldMap(field)},");
    }
    buffer.writeln('};');
    buffer.writeln('}');

    return buffer.toString();
  }

  String fromFieldMap(FieldElement field) {
    final fieldName = field.name;
    final typeName = field.typeName;

    if (field.isModel) {
      return '$typeName.fromMap(map[\'$fieldName\'])';
    } else if (field.isListModel) {
      final innerType =
          (field.type as InterfaceType).typeArguments.first.toString();
      return '(map[\'$fieldName\'] as List<dynamic>).map((e) => $innerType.fromMap(e)).toList()';
    } else if (field.isList) {
      final innerType =
          (field.type as InterfaceType).typeArguments.first.toString();
      return '(map[\'$fieldName\'] as List<dynamic>).map((e) => e as $innerType).toList()';
    } else if (field.isEnum) {
      return '$typeName.values[map[\'$fieldName\'] as int]';
    }
    // Trường hợp DocumentReference hoặc các loại dữ liệu khác
    return 'map[\'$fieldName\'] as $typeName';
  }

  String generateFromMapMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // fromMap
    buffer.writeln(
        '$className _\$${className}FromMap(Map<String,dynamic> map) {');

    buffer.writeln('try {');

    buffer.writeln('return ${className}(');
    for (final field in visitor.fields.values) {
      final fieldName = field.fieldName;
      buffer.writeln('$fieldName: ${fromFieldMap(field)},');
    }
    buffer.writeln(');');

    buffer.writeln('} catch (e) {');
    buffer.writeln('rethrow;');
    buffer.writeln('}');

    buffer.writeln('}');

    return buffer.toString();
  }

  //MARK: - Firestore
  String toFieldFirestore(FieldElement field) {
    final fieldName = field.name;

    if (field.isModel) {
      return 'instance.$fieldName.toFirestore()';
    } else if (field.isListModel) {
      return 'instance.$fieldName.map((e) => e.toFirestore()).toList()';
    } else if (field.isList) {
      return 'instance.$fieldName';
    } else if (field.isEnum) {
      return 'instance.$fieldName.index';
    }

    return 'instance.$fieldName';
  }

  String generateToFirestoreMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // toFirestore
    buffer.writeln(
        'Map<String, dynamic> _\$${className}ToFirestore($className instance) {');

    buffer.writeln('return {');
    for (final field in visitor.fields.values) {
      final fieldName = field.fieldName;
      buffer.writeln("'${fieldName}': ${toFieldFirestore(field)},");
    }
    buffer.writeln('};');
    buffer.writeln('}');

    return buffer.toString();
  }

  String fromFieldFirestore(FieldElement field) {
    final fieldName = field.name;
    final typeName = field.typeName;

    if (field.isModel) {
      return '$typeName.fromFirestore(map[\'$fieldName\'])';
    } else if (field.isListModel) {
      final innerType =
          (field.type as InterfaceType).typeArguments.first.toString();
      return '(map[\'$fieldName\'] as List<dynamic>).map((e) => $innerType.fromFirestore(e)).toList()';
    } else if (field.isList) {
      final innerType =
          (field.type as InterfaceType).typeArguments.first.toString();
      return '(map[\'$fieldName\'] as List<dynamic>).map((e) => e as $innerType).toList()';
    } else if (field.isEnum) {
      return '$typeName.values[map[\'$fieldName\'] as int]';
    }
    // Trường hợp DocumentReference hoặc các loại dữ liệu khác
    return 'map[\'$fieldName\'] as $typeName';
  }

  String generateFromFirestoreMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // fromFirestore
    buffer.writeln(
        '$className _\$${className}FromFirestore(DocumentSnapshot doc) {');

    buffer.writeln('try {');
    buffer.writeln('Map map = doc.data() as Map<String, dynamic>;');

    buffer.writeln('return ${className}(');
    for (final field in visitor.fields.values) {
      final fieldName = field.fieldName;
      buffer.writeln('$fieldName: ${fromFieldFirestore(field)},');
    }
    buffer.writeln(');');

    buffer.writeln('} catch (e) {');
    buffer.writeln('rethrow;');
    buffer.writeln('}');

    buffer.writeln('}');

    return buffer.toString();
  }

  //MARK: - Drift
  String generateDriftTableMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.baseClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // toMap
    buffer.writeln('/// Table for Drift database');
    buffer.writeln('class ${className}Table extends Table {');

    for (final dataField in visitor.fields.values) {
      final fieldColumn = _createTableColumn(dataField);

      if (fieldColumn.isNotEmpty) {
        buffer.writeln(fieldColumn);
      }
    }

    if (visitor.idField.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('@override');
      buffer.writeln(
          'Set<Column<Object>>? get primaryKey => {${visitor.idField}};');
    }

    buffer.writeln('}');

    //Converter
    for (final dataField in visitor.fields.values) {
      if (dataField.isListModel) {
        final converter = _createConverter(dataField);

        if (converter.isNotEmpty) {
          buffer.writeln(converter);
        }
      }
    }

    return buffer.toString();
  }

  String _createTableColumn(FieldElement dataField) {
    final dataType = dataField.typeName.replaceAll('?', '');
    final isNullable = dataField.typeName.endsWith('?');
    final fieldName = dataField.name.startsWith('_')
        ? dataField.name.replaceFirst('_', '')
        : dataField.name;

    if (dataField.isListModel) {
      return 'TextColumn get ${fieldName} => text().map(${_getDataTypeInListRegex(dataType)}Items.converter)();';
    }

    if (dataField.isEnum) {
      return 'TextColumn get ${fieldName} => textEnum<$dataType>()();';
    }

    var options = '';
    if (isNullable) {
      options = '$options.nullable()';
    }

    if (dataField.isUnique) {
      options = '$options.unique()';
    }

    if (dataField.tableRef.isNotEmpty) {
      options = '$options.references(${dataField.tableRef}, #$fieldName)';
    }

    switch (dataType) {
      case 'String':
        return 'TextColumn get $fieldName => text()${options}();';
      case 'DateTime':
        return 'DateTimeColumn get $fieldName => dateTime()${options}();';
      case 'int':
        return 'IntColumn get $fieldName => integer()${options}();';
      case 'double':
        return 'RealColumn get $fieldName => real()${options}();';
      case 'bool':
        return 'BoolColum get $fieldName => boolean()${options}();';
      default:
        return '';
    }
  }

  static String _getDataTypeInListRegex(String input) {
    final regex = RegExp(r'List<(.*?)>'); // Biểu thức chính quy
    final Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1) ?? ''; // Trả về group 1 (nội dung trong ngoặc)
    } else {
      return '';
    }
  }

  String _createConverter(FieldElement dataField) {
    final dataType = dataField.typeName.replaceAll('?', '');
    final isNullable = dataField.typeName.endsWith('?');
    final fieldName = dataField.name.startsWith('_')
        ? dataField.name.replaceFirst('_', '')
        : dataField.name;

    final modelClassName = _getDataTypeInListRegex(dataType);
    final className = '${modelClassName}Items';

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    buffer.writeln('class $className {');
    buffer.writeln('final $dataType items;');
    buffer.writeln('$className({required this.items});');
    buffer.writeln('''
factory $className.fromJson(Map<String, Object?> json) {
    final listMap = json['items'] as List;
    final List<$modelClassName> modelList = [];
    for (var map in listMap) {
      final model = $modelClassName.fromMap(map as Map);
      if(model != null){
        modelList.add(model);
      }      
    }

    return $className(items: modelList);
  }
''');

    buffer.writeln('''Map<String, Object?> toJson() {
    final Map<String, Object?> json = {
      'items': items.map((e) => e.toMap()).toList()
    };
    return json;
  }''');

    buffer.writeln('''
static JsonTypeConverter<$className, String> converter =
      TypeConverter.json(
    fromJson: (json) =>
        $className.fromJson(json as Map<String, Object?>),
    toJson: (entries) => entries.toJson(),
  );
''');
    buffer.writeln('}');

    return buffer.toString();
  }

  String generateDriftCompanionMethod(ModelVisitor visitor) {
    // Class name from model visitor
    final className = visitor.baseClassName;
    final modelClassName = visitor.modelClassName;

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // toCompanation
    buffer.writeln(
        '${className}TableCompanion _\$${modelClassName}ToCompanion($modelClassName instance, {String? id}) {');

    buffer.writeln('var companion = ${className}TableCompanion.insert(');

    for (final dataField in visitor.fields.values) {
      // final dataType = dataField.type.replaceAll('?', '');
      final isNullable = dataField.typeName.endsWith('?');
      final fieldName = dataField.name.startsWith('_')
          ? dataField.name.replaceFirst('_', '')
          : dataField.name;
      // final isModel = dataField.isModel;
      if (dataField.isListModel) {
        final model = _getDataTypeInListRegex(dataField.typeName);
        buffer.writeln(
            '$fieldName: ${isNullable ? 'Value(${model}Items(items: instance.$fieldName))' : '${model}Items(items: instance.$fieldName)'},');
      } else if (fieldName == visitor.idField) {
        buffer.writeln(
            '$fieldName:  ${isNullable ? 'Value(id ?? instance.$fieldName)' : 'id ?? instance.$fieldName'},');
      } else {
        buffer.writeln(
            '$fieldName: ${isNullable ? 'Value(instance.$fieldName)' : 'instance.$fieldName'},');
      }
    }
    buffer.writeln(');');

    buffer.writeln('return companion;');

    buffer.writeln('}');

    // fromCompanion
    buffer.writeln(
        '$modelClassName _\$${modelClassName}FromDriftData(${className}TableData data) {');

    buffer.writeln('try {');
    buffer.writeln('return $modelClassName(');
    for (final dataField in visitor.fields.values) {
      // final dataType = dataField.type.replaceAll('?', '');
      // final isNullable = dataField.type.endsWith('?');
      final fieldName = dataField.name.startsWith('_')
          ? dataField.name.replaceFirst('_', '')
          : dataField.name;
      // final isModel = dataField.isModel;

      if (dataField.isListModel) {
        buffer.writeln('$fieldName: data.$fieldName.items,');
      } else {
        buffer.writeln('$fieldName: data.$fieldName,');
      }
    }
    buffer.writeln(');');
    buffer.writeln('} catch (e) {');
    buffer.writeln(
        'LogUtils.log(e, isError:true,fileName: \'$className model\', functionName: \'fromDriftData\');');
    buffer.writeln('rethrow;');
    buffer.writeln('}');

    buffer.writeln('}');

    return buffer.toString();
  }
}
