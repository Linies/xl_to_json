class TargetModel {
  /// 文件地址路径
  final String input;

  /// 输出地址路径
  final String output;

  /// 索引项
  final String index;

  /// excel具体页
  String? sheet;

  /// 集成excel中横向key为一个文件
  List<String>? collects;

  /// 忽略项
  List<String>? ignores;

  TargetModel({
    required this.input,
    required this.output,
    required this.index,
    this.sheet,
    this.collects,
    this.ignores,
  });
}
