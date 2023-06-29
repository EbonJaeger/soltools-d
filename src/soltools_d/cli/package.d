module soltools_d.cli;

import std.stdio;
import std.sumtype;

import soltools_d.cli.clean;
import soltools_d.cli.copy;
import soltools_d.cli.index;
import soltools_d.cli.initialize;

import dopt;

private alias Subcommand = SumType!(Clean, Copy, Index, Initialize);

@Command("soltools-d") @Help("helper utility for Solus packaging") @Version("0.1.0")
private struct Soltools {
    @Subcommand()
    Subcommand subcommand;
}

public int run(string[] args)
{
    Soltools cli;

    try {
        cli = parse!Soltools(args);
    }
    catch (DoptException e)
    {
        return e.isUsage;
    }

    try {
        cli.subcommand.match!(
            (Clean c) => c.run(),
            (Copy c) => c.run(),
            (Index c) => c.run(),
            (Initialize c) => c.run(),
        );
    }
    catch (Exception e)
    {
        writeln("error running command: " ~ e.message);
        return -1;
    }

    return 0;
}
