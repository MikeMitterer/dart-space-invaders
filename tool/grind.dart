import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
@Depends(test)
build() {
  Pub.build();
}

@Task()
@Depends(analyze,testUnit)
test() { }

@Task()
testUnit() {
    new TestRunner().testAsync(files: "test/unit");

    // Alle test mit @TestOn("content-shell") im header
    new TestRunner().testAsync(files: "test/unit",platformSelector: "content-shell");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/spaceinvaders.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));

    Analyzer.analyze("web/main.dart");

    Analyzer.analyze("test");
}

@Task()
clean() => defaultClean();
