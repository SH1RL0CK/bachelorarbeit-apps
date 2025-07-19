import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:flutter_app/cine_lines_app.dart';

void main() {
  runApp(const CineLinesApp());
  if (kIsWeb) {
    SemanticsBinding.instance.ensureSemantics();
  }
}
