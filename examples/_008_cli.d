/// This example shows how to use Joka's command-line parsing utilities.

import joka;

void main(string[] args) {
    println("Arguments:");
    if (args.length == 1) println(" None");
    foreach (token; ArgTokenRange(args[1 .. $])) {
        with (ArgType) final switch (token.type) {
            case singleItem: printfln(" Single Item: {}", token); break;
            case shortOption: printfln(" Short Option: {}", token); break;
            case longOption: printfln(" Long Option: {}", token); break;
        }
    }
    println();
}
