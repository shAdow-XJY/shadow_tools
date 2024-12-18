import 'package:flutter/cupertino.dart';
import 'package:shadow_tools/config/st_config_global.dart';
import 'package:shadow_tools/pages/file/file_image_format.dart';
import 'package:shadow_tools/pages/other/other_css_preview.dart';

import 'file/file_image_resize.dart';

class STPageEntry
{
  static Widget getWidgetWithType(String type)
  {
    switch (type) {
      case STConfigGlobal.fileImageResize: {
        return const STFileImageResize();
      }
      case STConfigGlobal.fileImageFormat: {
        return const STFileImageFormat();
      }
      case STConfigGlobal.otherCSSPreview: {
        return const STOtherCSSPreview();
      }
      default:
        return const SizedBox();
    }
  }
}