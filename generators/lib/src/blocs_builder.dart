// ignore_for_file: lines_longer_than_80_chars

import 'package:build/build.dart';
import 'package:path/path.dart';

import 'utils.dart';

class BlocsBuilder implements Builder {
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
    final fileNameWithoutEx = fileName.replaceAll('.model.dart', 's');
    final dirPath =  buildStep.inputId.path.replaceAll('$dir/', '$dir/blocs/').replaceAll(fileName, '');
    
    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'$fileNameWithoutEx.e.dart')),
    '''
export '${fileNameWithoutEx}_bloc.dart';
export '${fileNameWithoutEx}_event.dart';
export '${fileNameWithoutEx}_state.dart';
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_bloc.dart')),
    '''
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../${fileName.replaceAll('.model.dart', '.firebase.dart')}';
import '../$fileName';

import '$fileNameWithoutEx.e.dart';

class ${classNameWithoutModel}sBloc extends Bloc<${classNameWithoutModel}sEvent, ${classNameWithoutModel}sState> {

  ${classNameWithoutModel}sBloc() : super(${classNameWithoutModel}sInit()){
    on<LoadAll${classNameWithoutModel}>(
      _onLoadAll${classNameWithoutModel});
    on<LoadAll${classNameWithoutModel}Stream>(
      _onLoadAll${classNameWithoutModel}Stream);
    on<LoadAll${classNameWithoutModel}StreamInTimePeriod>(
      _onLoadAll${classNameWithoutModel}StreamInTimePeriod);
    on<Load${classNameWithoutModel}InList>(
      _onLoad${classNameWithoutModel}InList);
    on<AddNew${classNameWithoutModel}InList>(
      _onAddNew${classNameWithoutModel}InList);
    on<Update${classNameWithoutModel}InList>(
      _onUpdate${classNameWithoutModel}InList);
    on<Remove${classNameWithoutModel}InList>(
      _onRemove${classNameWithoutModel}InList);
  }

  final ${classNameWithoutModel}FirebaseDatabase fDatabase = 
    ${classNameWithoutModel}FirebaseDatabase();

  StreamSubscription? _streamSubscription;

  void _onLoadAll${classNameWithoutModel}(
    LoadAll${classNameWithoutModel} event, Emitter<${classNameWithoutModel}sState> emit) async{

    if (kDebugMode) {
      print('_onLoadAll${classNameWithoutModel} - fileName: "${classNameWithoutModel}sBloc');
    }

    try {

      final item = await fDatabase.getAll${classNameWithoutModel}(
        timePeriod: event.timePeriod);

      if(item != null){
        emit(${classNameWithoutModel}sLoaded(items: item));
      }
      else{
        emit(${classNameWithoutModel}sLoaded(error: Exception('Items null')));
      }

    } catch (e) {
      if (kDebugMode) {
        print('_onLoadAll${classNameWithoutModel} \$e - fileName: ${classNameWithoutModel}sBloc');
      }
      emit(${classNameWithoutModel}sLoaded(error: e));
    }
  }

  void _onLoadAll${classNameWithoutModel}Stream(
    LoadAll${classNameWithoutModel}Stream event, Emitter<${classNameWithoutModel}sState> emit) async{

    if (kDebugMode) {
      print('_onLoadAll${classNameWithoutModel}Stream - fileName: "${classNameWithoutModel}sBloc');
    }

    try {
      _streamSubscription?.cancel();
      _streamSubscription = fDatabase.getAll${classNameWithoutModel}Stream().listen((items) {
        if (kDebugMode) {
          print(items);
        }
        add(Load${classNameWithoutModel}InList(items));
      });

    } catch (e) {
      if (kDebugMode) {
        print('_onLoadAll${classNameWithoutModel}Stream \$e - fileName: ${classNameWithoutModel}sBloc');
      }
      emit(${classNameWithoutModel}sLoaded(error: e));
    }
  }

  void _onLoadAll${classNameWithoutModel}StreamInTimePeriod(
    LoadAll${classNameWithoutModel}StreamInTimePeriod event, Emitter<${classNameWithoutModel}sState> emit) async{

    if (kDebugMode) {
      print('_onLoadAll${classNameWithoutModel}StreamInTimePeriod - fileName: ${classNameWithoutModel}sBloc');
    }

    try {

      _streamSubscription?.cancel();
      _streamSubscription = fDatabase.getAll${classNameWithoutModel}Stream(
        timePeriod: event.timePeriod).listen((items) {
        if (kDebugMode) {
          print(items);
        }
        add(Load${classNameWithoutModel}InList(items));
      });

    } catch (e) {
      if (kDebugMode) {
        print('_onLoadAll${classNameWithoutModel}StreamInTimePeriod \$e - fileName: ${classNameWithoutModel}sBloc');
      }
      emit(${classNameWithoutModel}sLoaded(error: e));
    }
  }
  
  void _onLoad${classNameWithoutModel}InList(
    Load${classNameWithoutModel}InList event, Emitter<${classNameWithoutModel}sState> emit){

    emit(${classNameWithoutModel}sLoaded(items: event.items));

  }

  void _onAddNew${classNameWithoutModel}InList(
    AddNew${classNameWithoutModel}InList event, Emitter<${classNameWithoutModel}sState> emit){

    if (kDebugMode) {
      print('_mapAddNew${classNameWithoutModel}InListToState - fileName: ${classNameWithoutModel}sBloc');
    }

    var updatedItems = <${className}>[];
    if(state is ${classNameWithoutModel}sLoaded){
      updatedItems = List.from((state as ${classNameWithoutModel}sLoaded).items ?? []);
    }

    updatedItems.add(event.item);

    emit(${classNameWithoutModel}sLoaded(items: updatedItems));

  }

  void _onUpdate${classNameWithoutModel}InList(
    Update${classNameWithoutModel}InList event, Emitter<${classNameWithoutModel}sState> emit){

    print('_mapUpdate${classNameWithoutModel}InListToState - fileName: ${classNameWithoutModel}sBloc');

    var updatedItems = <${className}>[];
    if(state is ${classNameWithoutModel}sLoaded){
      updatedItems = List.from((state as ${classNameWithoutModel}sLoaded).items!);
    }

    final updatedItem = event.item;

    updatedItems = updatedItems.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    emit(${classNameWithoutModel}sLoaded(items: updatedItems));
  }

  void _onRemove${classNameWithoutModel}InList(
    Remove${classNameWithoutModel}InList event, Emitter<${classNameWithoutModel}sState> emit) {

    print('_mapRemove${classNameWithoutModel}InListToState - fileName: ${classNameWithoutModel}sBloc');

    var updatedItems = <${className}>[];
    if(state is ${classNameWithoutModel}sLoaded){
      updatedItems = List.from((state as ${classNameWithoutModel}sLoaded).items!);
    }

    updatedItems = updatedItems.where((item) => item.id != event.item.id).toList();

    emit(${classNameWithoutModel}sLoaded(items: updatedItems));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();

    return super.close();
  }
}
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_state.dart')),
    '''
import 'package:equatable/equatable.dart';

import '../$fileName';

abstract class ${classNameWithoutModel}sState extends Equatable {
  const ${classNameWithoutModel}sState();

  @override
  List<Object?> get props => [];
}

class ${classNameWithoutModel}sInit extends ${classNameWithoutModel}sState {}

class ${classNameWithoutModel}sEmpty extends ${classNameWithoutModel}sState {}

class ${classNameWithoutModel}sLoading extends ${classNameWithoutModel}sState {}

class ${classNameWithoutModel}sLoaded extends ${classNameWithoutModel}sState {

  final List<${className}>? items;
  final dynamic error;

  const ${classNameWithoutModel}sLoaded({this.items, this.error});

  @override
  List<Object?> get props => [items,  error];

  // @override
  // bool get stringify => true;
}
''');

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, join(dirPath,'${fileNameWithoutEx}_event.dart')),
    '''
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../$fileName';

abstract class ${classNameWithoutModel}sEvent extends Equatable {
  const ${classNameWithoutModel}sEvent();
}

class LoadAll${classNameWithoutModel} extends ${classNameWithoutModel}sEvent {

  const LoadAll${classNameWithoutModel}({this.timePeriod});

  final DateTimeRange? timePeriod;

  @override
  List<Object?> get props => [timePeriod];
}

class LoadAll${classNameWithoutModel}Stream extends ${classNameWithoutModel}sEvent {  

  const LoadAll${classNameWithoutModel}Stream();

  @override
  List<Object> get props => [];
}

class LoadAll${classNameWithoutModel}StreamInTimePeriod extends ${classNameWithoutModel}sEvent {
  const LoadAll${classNameWithoutModel}StreamInTimePeriod({required this.timePeriod});

  final DateTimeRange timePeriod;

  @override
  List<Object> get props => [timePeriod];
}

class Load${classNameWithoutModel}InList extends ${classNameWithoutModel}sEvent {
  final List<${className}> items;

  const Load${classNameWithoutModel}InList(this.items);

  @override
  List<Object> get props => [items];
}

class AddNew${classNameWithoutModel}InList extends ${classNameWithoutModel}sEvent {
  final ${className} item;

  const AddNew${classNameWithoutModel}InList(this.item);

  @override
  List<Object> get props => [item];
}

class Update${classNameWithoutModel}InList extends ${classNameWithoutModel}sEvent {

  final ${className} item;

  const Update${classNameWithoutModel}InList(this.item);

  @override
  List<Object> get props => [item];
}

class Remove${classNameWithoutModel}InList extends ${classNameWithoutModel}sEvent {
  final ${className} item;

  const Remove${classNameWithoutModel}InList(this.item) ;

  @override
  List<Object> get props => [item];
}
''');  
  }

  @override
  final buildExtensions = const {
    '{{dir}}/{{file}}.model.dart': [
      '{{dir}}/blocs/{{file}}s.e.dart',
      '{{dir}}/blocs/{{file}}s_bloc.dart',
      '{{dir}}/blocs/{{file}}s_event.dart',
      '{{dir}}/blocs/{{file}}s_state.dart']    
  };
}
