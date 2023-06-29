module soltools_d.cli.clean;

import soltools_d;
import std.algorithm;
import std.file;
import std.path;
import std.stdio;

import dopt;

@Command("clean") @Help("remove all packages from the local repository")
package struct Clean {
    @Option() @Long("repo-location") @Short() @Help("location of the local repository") 
    string location = defaultRepoLoc;
    @Option() @Long("skip-indexing") @Help("skip indexing the local repository")
    bool skipIndexing;

    /**
    * Main entry point for the Clean subcommand.
    *
    * This will remove all of the packages that are currently
    * in the local eopkg repository, and optionally re-indexes
    * the repo.
    */
    void run()
    {
        writeln("Removing packages from the local repo");

        // Get all of the eopkgs in the local repo
        auto entries = dirEntries(location, SpanMode.shallow).filter!(f => f.name.endsWith(".eopkg"));

        foreach (entry; entries)
        {
            // Try to remove each package
            try
            {
                entry.remove();
            }
            catch (FileException e)
            {
                writeln("error removing '" ~ baseName(entry.name) ~ "' from local repo: ", e.msg);
                return;
            }
        }

        // Bail early if we should skip indexing
        if (skipIndexing)
        {
            return;
        }

        // Index the (now empty) local repo
        auto status = index(location);
        if (status != 0)
        {
            writeln("error indexing local repository");
        }
    }
}
