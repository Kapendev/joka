/// This example shows how to use Joka's command-line parsing utilities.

import joka;

void main(string[] args) {
    if (args.length == 1) {
        println("Usage: cli [args...]");
        return;
    }
    foreach (token; args[1 .. $].argTokens) {
        with (ArgType) final switch (token.type) {
            case singleItem:
                printfln("Single Item: {}", token); break;
            case shortOption:
                printfln("Short Option: {}", token); break;
            case longOption:
                printfln("Long Option: {}", token); break;
        }
    }
}
