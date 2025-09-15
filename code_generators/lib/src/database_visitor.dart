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

class DatabaseVisitor extends SimpleElementVisitor<void> {
  
  late String modelClassName;
  late String repositoryClassName;
  late String databaseClassName;
  
  Map<String, dynamic> fields = <String, dynamic>{};
  Map<String, dynamic> dataFields = <String, dynamic>{};
  Map<String, MethodElement> methods = <String, MethodElement>{};

  String log = 'Log: ';

  @override
  void visitConstructorElement(ConstructorElement element) {
    log = '$log visitConstructorElement ${element.documentationComment}';

    final elementReturnType = element.type.returnType.toString();

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    databaseClassName = elementReturnType.replaceFirst('*', '');    
    repositoryClassName = databaseClassName.replaceAll('Database','Repository');
    modelClassName = databaseClassName.replaceAll('Database', 'Model');    
  }

  @override
  void visitFieldElement(FieldElement element) {
    log = '$log visitFieldElement $element ${element.documentationComment}';

    final elementType = element.type.toString();

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.

    if(element.documentationComment == '/// DataField'){      
      dataFields[element.name] = elementType.replaceFirst('*', '');
    }
    
    fields[element.name] = elementType.replaceFirst('*', '');
  }

  @override
  void visitMethodElement(MethodElement element) {
    log = '$log visitMethodElement $element';
    
    methods[element.name] = element;
  }
}
