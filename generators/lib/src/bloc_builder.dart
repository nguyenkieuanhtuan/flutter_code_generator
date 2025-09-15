// ignore_for_file: lines_longer_than_80_chars

import 'package:build/build.dart';
import 'package:path/path.dart';

import 'utils.dart';

class BlocBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {

    print('start bloc builder');

    // Get the `LibraryElement` for the primary input.
    final entryLib = await buildStep.inputLibrary;
    final className = entryLib.topLevelElements.first.displayName;
    final classNameWithoutModel = Utilities.removeModelInName(className);

    // Resolves all libraries reachable from the primary input.
    final resolver = buildStep.resolver;
    final visibleLibraries = await resolver.libraries.length;
        
    final dir = buildStep.inputId.pathSegments[
      buildStep.inputId.pathSegments.length -2];
    final fileName = buildStep.inputId.pathSegments.last; //.model.dart
    final fileNameWithoutEx = fileName.replaceAll('.model.dart', '');
    final dirPath =  buildStep.inputId.path.replaceAll('$dir/', '$dir/bloc/').replaceAll(fileName, '');
    
    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'$fileNameWithoutEx.e.dart')),
    '''
export '${fileNameWithoutEx}_bloc.dart';
export '${fileNameWithoutEx}_event.dart';
export '${fileNameWithoutEx}_state.dart';
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_bloc.dart')),
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../$fileNameWithoutEx.firebase.dart';
// import '../$fileName';

import '$fileNameWithoutEx.e.dart';


class ${classNameWithoutModel}Bloc extends Bloc<${classNameWithoutModel}Event, ${classNameWithoutModel}State> {

  final ${classNameWithoutModel}FirebaseDatabase fDatabase 
    = ${classNameWithoutModel}FirebaseDatabase();

  ${classNameWithoutModel}Bloc() : super(${classNameWithoutModel}Init()){
    on<New${classNameWithoutModel}Event>(_mapNew${classNameWithoutModel}ToState);
    on<Update${classNameWithoutModel}Event>(_mapUpdate${classNameWithoutModel}ToState);
    on<Delete${classNameWithoutModel}>(_mapDelete${classNameWithoutModel}ToState);
    on<Load${classNameWithoutModel}Event>(_mapLoad${classNameWithoutModel}ToState);
  }

//  @override
//  PlantsState get initialState => PlantsInit();

  void _mapNew${classNameWithoutModel}ToState(
    New${classNameWithoutModel}Event event,Emitter<${classNameWithoutModel}State> emit) async {

    emit(${classNameWithoutModel}Loading());

    final model = await fDatabase.new${classNameWithoutModel}(
      model: event.model);

    if(model != null){
      emit(${classNameWithoutModel}Completed(added${classNameWithoutModel}: model));
    }
    else{
      emit(${classNameWithoutModel}Completed(
        added${classNameWithoutModel}: null,
        error: Exception('Add order error')));
    }
  }

  void _mapUpdate${classNameWithoutModel}ToState(
    Update${classNameWithoutModel}Event event,Emitter<${classNameWithoutModel}State> emit) async {

    final model = await fDatabase.update${classNameWithoutModel}(
      model: event.model);

    if(model != null){
      emit(${classNameWithoutModel}Completed(updated${classNameWithoutModel}: model));
    }
    else{
      emit(${classNameWithoutModel}Completed(
        updated${classNameWithoutModel}: null, error: Exception('Update order error')));
    }
  }

  void _mapDelete${classNameWithoutModel}ToState(
    Delete${classNameWithoutModel} event,Emitter<${classNameWithoutModel}State> emit) async {

    bool result = await fDatabase.delete${classNameWithoutModel}(
      model: event.model);

    if(result){

      emit(${classNameWithoutModel}Completed(
        deleted${classNameWithoutModel}: event.model));

    }
    else{
      emit(${classNameWithoutModel}Completed(
        deleted${classNameWithoutModel}: null, error: Exception('Delete order error')));
    }
  }

  void _mapLoad${classNameWithoutModel}ToState(
    Load${classNameWithoutModel}Event event,Emitter<${classNameWithoutModel}State> emit) async {

    if(kDebugMode){
      print('_mapLoad${classNameWithoutModel}ToState - fileName: ${classNameWithoutModel}Bloc');
    }

    try {

      final model = await fDatabase.get${classNameWithoutModel}(modelID: event.iD);

      if(model != null){
        emit(${classNameWithoutModel}Completed(loaded${classNameWithoutModel}: model));
      }
      else{
        emit(${classNameWithoutModel}Completed(error: Exception('${classNameWithoutModel} null')));
      }

    } catch (e) {
      if(kDebugMode){
        print('_mapLoad${classNameWithoutModel}ToState error \${e.toString()}');
      }      
      emit(${classNameWithoutModel}Completed(error: e));
    }
  }
}
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_state.dart')),
    '''
import 'package:equatable/equatable.dart';

import '../$fileName';

abstract class ${classNameWithoutModel}State extends Equatable {
  const ${classNameWithoutModel}State();

  @override
  List<Object?> get props => [];
}

class ${classNameWithoutModel}Init extends ${classNameWithoutModel}State {}

class ${classNameWithoutModel}Loading extends ${classNameWithoutModel}State {}

class ${classNameWithoutModel}Completed extends ${classNameWithoutModel}State {

  final ${className}? loaded${classNameWithoutModel};
  final ${className}? added${classNameWithoutModel};
  final ${className}? updated${classNameWithoutModel};
  final ${className}? deleted${classNameWithoutModel};
  final Object? error;

  const ${classNameWithoutModel}Completed({
    this.added${classNameWithoutModel}, 
    this.updated${classNameWithoutModel}, 
    this.deleted${classNameWithoutModel},
    this.loaded${classNameWithoutModel},
    this.error});

  @override
  List<Object?> get props => [
    added${classNameWithoutModel},
    updated${classNameWithoutModel},
    deleted${classNameWithoutModel},
    loaded${classNameWithoutModel},
    error];
}
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_event.dart')),
    '''
import 'package:equatable/equatable.dart';
import '../$fileName';

abstract class ${classNameWithoutModel}Event extends Equatable {
  const ${classNameWithoutModel}Event();
}

class Load${classNameWithoutModel}Event extends ${classNameWithoutModel}Event {
  final String iD;

  const Load${classNameWithoutModel}Event({required this.iD}) ;

  @override
  List<Object> get props => [iD];
}

class New${classNameWithoutModel}Event extends ${classNameWithoutModel}Event {
  final ${className} model;  

  const New${classNameWithoutModel}Event({required this.model});

  @override
  List<Object> get props => [model];
}

class Update${classNameWithoutModel}Event extends ${classNameWithoutModel}Event {

  final ${className} model;  

  const Update${classNameWithoutModel}Event({required this.model});

  @override
  List<Object> get props => [model];
}

class Delete${classNameWithoutModel} extends ${classNameWithoutModel}Event {
  final ${className} model;  

  const Delete${classNameWithoutModel}({required this.model});

  @override
  List<Object> get props => [model];
}
''');
  
  }

  @override
  final buildExtensions = const {
    '{{dir}}/{{file}}.model.dart': [
      '{{dir}}/bloc/{{file}}.e.dart',
      '{{dir}}/bloc/{{file}}_bloc.dart',
      '{{dir}}/bloc/{{file}}_event.dart',
      '{{dir}}/bloc/{{file}}_state.dart']    
  };
}
