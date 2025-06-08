/// This example shows how to use Joka's command-line parsing utilities.

import joka;

void main(string[] args) {
    // The "normal" way of checking arguments.
    println("Args:");
    if (args.length == 1) println(" None");
    foreach (token; args[1 .. $].toArgTokens()) {
        with (ArgType) final switch (token.type) {
            case singleItem:
                printfln(" Single Item: {}", token);
                break;
            case shortOption:
                printfln(" Short Option: {}", token);
                break;
            case longOption:
                printfln(" Long Option: {}", token);
                break;
        }
    }
    println();
    // The "I don't care" way of checking arguments.
    if (args.hasCommand("hello")) {
        println("Hello from Greece!");
    } else if (args.hasCommand("build")) {
        if (args.hasSubcommand("release")) {
            println("Building release...");
        } else {
            println("Building debug...");
        }
    } else {
        println("Usage: cli [args...]");
    }
}
