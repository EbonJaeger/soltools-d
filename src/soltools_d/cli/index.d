module soltools_d.cli.index;

import soltools_d;
import std.process;
import std.stdio;

import dopt;

@Command("index") @Help("index packages in the local repository")
package struct Index {
    @Option() @Long("repo-location") @Short() @Help("location of the local repository") 
    string location = defaultRepoLoc;

    /**
    * Main entry point for the Index subcommand.
    *
    * This will index all packages in the local eopkg
    * repository.
    */
    void run()
    {
        // Index the repo
        auto status = index(location);
        if (status != 0)
        {
            writeln("error indexing local repository");
        }
    }
}
