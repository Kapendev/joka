/// This example shows how to use Joka's string utilities.

import joka;

void main() {
    // A CSV with 3 lines of comma-separated numbers.
    auto csv = "1,2,3\n4,5,6\n7,8,9\n";
    auto records = csv.split('\n');
    auto fields1 = records[0].split(',');
    auto fields2 = records[1].split(',');
    auto fields3 = records[2].split(',');
    foreach (field; fields1) print("|", field);
    println("|");
    foreach (field; fields2) print("|", field);
    println("|");
    foreach (field; fields3) print("|", field);
    println("|");

    // Concatenate and split strings.
    auto info = concat(
        "------\n",
        "Split and concat create slices.\n",
        "By default, they use internal buffers, so we don't need to free them.\n",
        "Just remember to copy the data after you are done with it.\n",
        "------",
    );
    println(info);
    auto path = pathConcat(
        "there",
        "/is",
        "/also/",
        "a/",
        "path\\concat\\",
    );
    path = path.pathFmt();
    println("Path: ", path);
    println("Parts: ", path.pathSplit().length);
}
