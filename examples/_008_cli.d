/// This example shows how to use Joka's command-line parsing utilities.

import joka;
import joka.ranges;

void main(string[] args) {
    println("Arguments:");
    if (args.length == 1) println(" None");
    foreach (token; args[1 .. $].argTokens) {
        with (ArgType) final switch (token.type) {
            case singleItem:  println(" Single Item: ", token.name); break;
            case shortOption: println(" Short Option: ", token.name); break;
            case longOption:  println(" Long Option: ", token.name); break;
        }
    }
    println();
}
