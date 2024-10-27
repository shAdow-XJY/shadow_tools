class STConfigGlobal {
  static const String fileComponent = "File";
  static const String convertComponent = "Convert";
  static const String otherComponent = "Other";
  static List<String> fileList = [
    'Image Resize',
    'Image Format',
  ];
  static List<String> convertList = [
    'Encode/Decode',
  ];
  static List<String> otherList = [
    'Color Picker',
    'CSS Preview',
  ];

  static List<String> getListWithComponent(String component) {
    switch (component) {
      case "File":
        return fileList;
      case "Convert":
        return convertList;
      case "Other":
        return otherList;
      default:
        return [];
    }
  }

  static List<String> getAllItems() {
    return [
      ...fileList,
      ...convertList,
      ...otherList,
    ];
  }

  static const String fileImageResize = "Image Resize";
  static const String fileImageFormat = "Image Format";
  static const String convertEncodeDecode = "Encode/Decode";
  static const String otherColorPicker = "Color Picker";
  static const String otherCSSPreview = "CSS Preview";
}
