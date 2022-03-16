import 'dart:io';

import 'package:excel/excel.dart';
import 'package:xl_to_json/xltj/model.dart';
import 'package:xl_to_json/utils/yaml_reader.dart';

List<TargetModel> loadSpec(String path) {
  var yamlMap = loadYaml('${path}/xlmap.yaml');
  return yamlMap['targets']
          .map<TargetModel>((element) => TargetModel(
                input:
                    '$path${Platform.pathSeparator}${Uri.file(element['input'], windows: Platform.isWindows).toFilePath()}',
                output: Uri.file(element['output'], windows: Platform.isWindows)
                    .toFilePath(),
                index: element['index'],
                collects: (element['collects'] ?? [])
                    .map<String>((value) => value.toString())
                    .toList(),
                ignores: (element['ignores'] ?? [])
                    .map<String>((value) => value.toString())
                    .toList(),
                sheet: element['sheet'],
              ))
          .toList() ??
      <TargetModel>[];
}

/// 读取excel文件，构建row-column数据集合
Map<String, List<String?>> loadXl(TargetModel model) {
  var file = File(model.input);
  var excel = Excel.decodeBytes(file.readAsBytesSync());
  var result = <String, List<String?>>{};

  if (model.sheet != null) {
    var rows = excel.sheets[model.sheet]?.rows ?? [];
    if (rows.isEmpty) return result;
    for (var columns in rows) {
      if (columns.isEmpty) continue;
      var first = columns.removeAt(0);
      if (model.ignores?.contains(first?.value) ??
          false || first?.value == null) {
        continue;
      }
      result[first!.value] =
          columns.map((col) => col?.value.toString()).toList();
    }
  } else {
    var rows = excel.sheets[excel.getDefaultSheet()]?.rows ?? [];
    if (rows.isEmpty) return result;
    for (var columns in rows) {
      if (columns.isEmpty) continue;
      var first = columns.removeAt(0);
      if (model.ignores?.contains(first?.value) ??
          false || first?.value == null) {
        continue;
      }
      result[first!.value] =
          columns.map((col) => col?.value.toString()).toList();
    }
  }
  return result;
}
