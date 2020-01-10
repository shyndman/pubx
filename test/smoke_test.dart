import 'package:args/command_runner.dart';
import 'package:pubx/src/commands/view.dart';
import 'package:test/test.dart';

void main() {
  test('Does not throw while viewing a package', () {
    final runner = CommandRunner('pubx', 'Testing runner')
      ..addCommand(ViewCommand());
    expect(() => runner.run(['view', 'pubx']), returnsNormally);
  });
}
