class Utilities {
  static String classNameToVariable(String className){
    return className.replaceRange(0, 0, className.substring(0,1).toLowerCase());
  }

  static String removeModelInName(String name){
    return name.replaceAll('Model', '');
  }

  static bool isClassModel(String className){
     final baseClass = ['int', 'double', 'num', 'String', 'DateTime', 'bool'];
     
     return baseClass.contains(className);
  }


}