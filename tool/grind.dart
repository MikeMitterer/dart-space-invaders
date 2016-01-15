import 'package:grinder/grinder.dart';

import 'package:path/path.dart' as path;

main(args) => grind(args);

@Task()
@Depends(genCss, test)
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
genCss() {
    final String src = "lib/assets/styles/main.scss";
    final String target = "${path.withoutExtension(src)}.css";
    final String mini = "${path.withoutExtension(src)}.min.css";

    run("sassc", arguments: [ src, target ] );
    run("autoprefixer", arguments: [ target ] );
    run("minify", arguments: [ "--output", mini, target ]);
}

@Task()
clean() => defaultClean();
