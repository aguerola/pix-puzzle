import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/levels_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PixPuzzleApp(repository: LevelsRepository()));
}
