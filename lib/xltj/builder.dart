import 'dart:convert';
import 'dart:io' show Platform, Directory, File;

import "package:path/path.dart" show dirname;
import 'package:xl_to_json/xltj/xl_reader.dart';

Future<void> build() async {
  try {
    var uri = Platform.script;
    var packageRoot = '${dirname(uri.toFilePath())}/..';
    startExport(packageRoot);
  } catch (e, stack) {
    print('build -> {error: $e, stack: $stack}');
  }
}

Future<void> startExport(String path) async {
  var targets = loadSpec(path);
  for (var target in targets) {
    var source = <String, List<String?>>{};
    // 索引项数组
    var idxList = <String?>[];
    if (target.collects?.isNotEmpty ?? false) {
      // 若有组合columns的需要，取配置首个列项为输出名称
      source[target.collects!.first] = [];
    }
    var row2cols = loadXl(target);
    row2cols.forEach((key, value) {
      if (key == target.index) {
        idxList.addAll(value);
      } else if (target.collects?.contains(key) ?? false) {
        source[target.collects!.first]?.addAll(value);
      } else {
        source[key] = value;
      }
    });
    var dir = Directory('$path/${target.output}');
    dir.createSync(recursive: true);

    // 遍历输出文件
    source.forEach((filename, list) async {
      var json = <String, String?>{};
      for (var i = 0; i < idxList.length; i++) {
        json[idxList[i] ?? ""] = list[i];
      }
      var file = File('$path/${target.output}/$filename.json');
      await file.writeAsString(jsonEncode(json));
      file.create();
    });
  }
}
