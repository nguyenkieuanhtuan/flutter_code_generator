// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

import 'database_visitor.dart';

const _databaseMethodChecker =
    TypeChecker.fromRuntime(DatabaseMethodAnnotation);

class DatabaseGenerator extends GeneratorForAnnotation<DatabaseAnnotation> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = DatabaseVisitor();
    element.visitChildren(visitor);

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    final modelClassName = annotation.read('forClassName').stringValue;
    buffer.writeln('// forClassName: $modelClassName');
    buffer.writeln();

    final generatedFirebaseDatabaseClass = generatedFirebaseDatabaseClassMethod(
        visitor: visitor, forClassName: modelClassName);
    buffer.writeln(generatedFirebaseDatabaseClass);

    // final generateToMap = generateToMapMethod(visitor);
    // buffer.writeln(generateToMap);

    // final generateFromMap = generateFromMapMethod(visitor);
    // buffer.writeln(generateFromMap);

    return buffer.toString();
  }

  // Method to generate fromJSon method
  String generatedFirebaseDatabaseClassMethod(
      {required DatabaseVisitor visitor, String? forClassName}) {
    // Class name from model visitor
    final databaseClassName = visitor.databaseClassName;
    final modelClassName = forClassName ?? visitor.databaseClassName;
    final baseClassName = modelClassName.replaceAll('Model', '');

    final refName = 'k${baseClassName}sRefName';

    // Buffer to write each part of generated class
    final buffer = StringBuffer();

    // --------------------Start Firebase Database Generation Code--------------------//
    buffer.writeln('// Firebase Database');
    buffer.writeln(
        'class _\$${baseClassName}FirebaseDatabase implements $databaseClassName{');
    buffer.writeln();

    buffer.writeln(
        'static String ${refName} = \'${baseClassName.toLowerCase()}s\';');
    buffer.writeln();

    buffer.writeln(
        'final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();');
    buffer.writeln();

    for (var i = 0; i < visitor.methods.length; i++) {
      final methodElement = visitor.methods.values.elementAt(i);

      if (_databaseMethodChecker.hasAnnotationOfExact(methodElement)) {
        final annotation =
            _databaseMethodChecker.firstAnnotationOfExact(methodElement);
        final type = annotation?.getField('type')?.toStringValue() ?? '';
        if (type == 'new') {
          buffer.writeln(newModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        } else if (type == 'update') {
          buffer.writeln(updateModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        } else if (type == 'delete') {
          buffer.writeln(deleteModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        } else if (type == 'get') {
          buffer.writeln(getModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        } else if (type == 'getList') {
          buffer.writeln(getListModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        } else if (type == 'streamList') {
          buffer.writeln(streamListModelMethod(
              methodElement: methodElement,
              modelClassName: modelClassName,
              refName: refName));
          buffer.writeln();
        }
      }
    }

    buffer.writeln('}');

    buffer.toString();
    return buffer.toString();
    // --------------------End Firebase Database Generation Code--------------------//
  }

  String newModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final modelParameterElement = methodElement.parameters
        .where((param) => param.type.toString() == modelClassName)
        .firstOrNull;

    if (modelParameterElement != null) {
      return '''@override            
            $methodElement async {
            final reference = _databaseRef.child(${refName}).push();
            final map = ${modelParameterElement.name}.toFirebaseDatabaseMap();
            map['id'] = reference.key;
            map['createdAt'] = DateTime.now().millisecondsSinceEpoch;

            return reference.set(map).then((_) {
              return ${modelParameterElement.name}.copyWith(id: reference.key, createdAt: map['createdAt']);
            }).catchError((e) {
              if (kDebugMode) {
                print('new ${modelClassName} error \$e');
              }
              throw e;
            });
          }
          ''';
    } else {
      return '// $methodElement not create';
    }
  }

  String updateModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final modelParameterElement = methodElement.parameters
        .where((param) => param.type.toString() == modelClassName)
        .firstOrNull;

    if (modelParameterElement != null) {
      return '''@override
      $methodElement async {
      if(${modelParameterElement.name}.hasID){
        final reference = _databaseRef.child(${refName}).child(${modelParameterElement.name}.id);
        final map = ${modelParameterElement.name}.toFirebaseDatabaseMap();
        map['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      return reference.update(map).then((_) {
        return ${modelParameterElement.name};
      }).catchError((e) {
        if (kDebugMode) {
          print('update ${modelClassName} error \$e');
        }
        throw e;
      });
    }
    else {
        throw Exception('id_not_exist');
    }
  }''';
    } else {
      return '// $methodElement not create';
    }
  }

  String deleteModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final modelParameterElement = methodElement.parameters
        .where((param) => param.type.toString() == modelClassName)
        .firstOrNull;

    if (modelParameterElement != null) {
      return '''@override
      $methodElement async {

    if (${modelParameterElement.name}.hasID) {
        final reference = _databaseRef.child(${refName}).child(
            ${modelParameterElement.name}.id);

        return reference.remove().then((_) {
          return true;
        }).catchError((e) {
          if (kDebugMode) {
            print('delete ${modelClassName} error \$e');
          }
          throw e;
        });
      }
      else {
        throw Exception('id_not_exist');
      }
  }''';
    } else {
      return '// $methodElement not create';
    }
  }

  String getModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final idParameterElement = methodElement.parameters
        .where((param) => param.name == 'id')
        .firstOrNull;

    if (idParameterElement != null) {
      return '''@override
      $methodElement async {

    try{
      final dataEvent= await _databaseRef.child(${refName}).child(${idParameterElement.name})
            .once();

      final map = dataEvent.snapshot.value as Map<String,dynamic>;

        final model = ${modelClassName}.fromMap(map);

        return model;
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }''';
    } else {
      return '// $methodElement not create';
    }
  }

  String getListModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final queryCondition = StringBuffer();

    final timePeriodParameterElement = methodElement.parameters
        .where((param) => (param.type.toString() == 'DateTimeRange' &&
            param.name == 'timePeriod'))
        .firstOrNull;

    if (timePeriodParameterElement != null) {
      queryCondition.writeln(
          'if(timePeriod != null){ query = query.startAt(timePeriod.start.millisecondsSinceEpoch).endAt(timePeriod.end.millisecondsSinceEpoch);}');
    }

    return '''@override
    $methodElement async {

    try{
      var query = _databaseRef.child(${refName}).orderByChild('createdAt');

        ${queryCondition.toString()}

        final dataEvent= await query.once();

        final dataValues = dataEvent.snapshot.value as Map?;

        final models = <${modelClassName}>[];
        dataValues?.forEach((key, value) {          
          final map = value as Map<String,dynamic>?;
          if(map != null){
            final model = ${modelClassName}.fromMap(map);
            if(model != null){ models.add(model);}
          }  
        });

        return models;
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }''';
  }

  String streamListModelMethod(
      {required MethodElement methodElement,
      required String modelClassName,
      required String refName}) {
    final queryCondition = StringBuffer();

    final timePeriodParameterElement = methodElement.parameters
        .where((param) => (param.type.toString() == 'DateTimeRange' &&
            param.name == 'timePeriod'))
        .firstOrNull;

    if (timePeriodParameterElement != null) {
      queryCondition.writeln(
          'if(timePeriod != null){ query = query.startAt(timePeriod.start.millisecondsSinceEpoch).endAt(timePeriod.end.millisecondsSinceEpoch);}');
    }

    return '''@override
    $methodElement {

    var query = _databaseRef.child(${refName}).orderByChild('createdAt');
    
     ${queryCondition.toString()}

    return query.onValue.map((event) {
      final models = <${modelClassName}>[];
      if(event.snapshot.value is Map){
        final dataMap = event.snapshot.value as Map?;

        dataMap?.forEach((key, value) {          
          final map = value as Map<String,dynamic>?;
          if(map != null){
            final model = ${modelClassName}.fromMap(map);
            if(model != null){ models.add(model);}
          }          
        });
      }
      return models;
    });
  }''';
  }
}
