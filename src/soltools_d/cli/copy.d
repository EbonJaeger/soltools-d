module soltools_d.cli.copy;

import soltools_d;
import std.algorithm;
import std.file;
import std.path;
import std.process;
import std.stdio;

import dopt;

@Command("copy") @Help("copy all packages in the current directory to the local repository")
package struct Copy {
    @Option() @Long("repo-location") @Short() @Help("location of the local repository") 
    string location = defaultRepoLoc;
    @Option() @Long("skip-indexing") @Help("skip indexing the local repository")
    bool skipIndexing;

    /**
     * Main entry point for the Copy subcommand.
     *
     * This will copy all packages in the current directory
     * to the local eopkg repository, and optionally re-indexes
     * the repo.
     */
    void run()
    {
        writeln("Found the following packages to copy:");

        // Get any eopkg files
        auto cwd = getcwd();
        auto entries = dirEntries(cwd, SpanMode.shallow).filter!(f => f.name.endsWith(".eopkg"));

        // Copy the packages to the local repo
        foreach (entry; entries)
        {
            auto name = baseName(entry.name);
            auto outPath = buildPath(location, name);

            try
            {
                entry.copy(outPath);
            }
            catch (FileException e)
            {
                writeln("error copying '" ~ name ~ "' to local repo: ", e.msg);
                continue;
            }

            // Print the name of the copied package
            writeln("  - " ~ name);
        }

        // Bail early if we should skip indexing
        if (skipIndexing)
        {
            return;
        }

        // Index the local repo
        auto status = index(location);
        if (status != 0)
        {
            writeln("error indexing local repository");
        }
    }
}
