# Kiyu flutter code generator

- Install

flutter_code_generators:
    git: 
        url: https://github.com/nguyenkieuanhtuan/flutter_code_generator.git
        path: code_generators

dev_dependencies:
    flutter_code_generators:
        path: /Volumes/Data/Project/KiyuFlutterCodeGenerator/kiyu_flutter_code_generator/generators

- Run
    dart run build_runner build
    dart run build_runner build --build-filter="lib/database/category/*.dart"