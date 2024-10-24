import 'dart:io';

import 'package:shadow_tools/config/st_config.dart';

void main() {
  // 文件路径
  const String filePath = 'lib/config/st_config_global.dart';

  // 打开文件写入
  File file = File(filePath);
  IOSink sink = file.openWrite();

  // 写入STConfigGlobal类
  sink.writeln('class STConfigGlobal {');

  // 遍历STConfig中的componentList
  STConfig.componentList.forEach((key, value) {
    // 将Key转为驼峰命名
    String keyCamelCase = _toCamelCase(key);
    String listName = '${keyCamelCase}Component';

    // 写入静态数组列表
    sink.writeln('  static const String $listName = "$key";');
  });

  // 遍历STConfig中的componentList
  STConfig.componentList.forEach((key, value) {
    // 将Key转为驼峰命名
    String keyCamelCase = _toCamelCase(key);
    String listName = '${keyCamelCase}List';

    // 写入静态数组列表
    sink.writeln('  static List<String> $listName = [');
    for (var item in value) {
      sink.writeln('    \'$item\',');
    }
    sink.writeln('  ];');
  });

  // 写入getListWithComponent方法
  sink.writeln('\n  static List<String> getListWithComponent(String component) {');
  sink.writeln('    switch (component) {');
  STConfig.componentList.forEach((key, value) {
    String keyCamelCase = _toCamelCase(key);
    sink.writeln('      case "$key":');
    sink.writeln('        return ${keyCamelCase}List;');
  });
  sink.writeln('      default:');
  sink.writeln('        return [];');
  sink.writeln('    }');
  sink.writeln('  }');

  // 写入getAllItems方法
  sink.writeln('\n  static List<String> getAllItems() {');
  sink.writeln('    return [');
  STConfig.componentList.forEach((key, value) {
    String keyCamelCase = _toCamelCase(key);
    sink.writeln('      ...${keyCamelCase}List,');
  });
  sink.writeln('    ];');
  sink.writeln('  }');

  // 生成所有的item项
  sink.writeln('');
  STConfig.componentList.forEach((key, value) {
    for (var item in value) {
      // 处理特殊字符并将item转为驼峰命名
      String enumName = '${_toCamelCase(key)}${_sanitizeEnumValue(item)}';
      sink.writeln('  static const String $enumName = "$item";');
    }
  });

  // 结束STConfigGlobal类
  sink.writeln('}');

  // 关闭文件写入
  sink.close();
  print('STConfigGlobal and Enum generated successfully!');
}

// 转换为驼峰命名
String _toCamelCase(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toLowerCase() + word.substring(1).toLowerCase();
  }).join('');
}

// 处理特殊字符
String _sanitizeEnumValue(String value) {
  return value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
}