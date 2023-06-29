module soltools_d.cli.initialize;

import std.file;
import std.process;
import std.stdio;

import dopt;

@Command("init") @Help("initialize a new package git repository")
package struct Initialize {
    @Required() @Help("the name of the package")
    string packageName;
    @Required() @Help("the version of the package")
    string packageVersion;
    @Required() @Help("the URL of the source tarball to download")
    string url;

    /**
     * Main entry point for the Init subcommand.
     *
     * This will create a package skeleton for a new
     * Solus package.
     */
    void run()
    {
        auto currentDir = getcwd();
        auto yauto = currentDir ~ "/common/Scripts/yauto.py";
        auto packageDir = currentDir ~ "/" ~ packageName;

        // Find yauto.py
        if (!yauto.exists)
        {
            writeln("Unable to find yauto.py. Are you in the right directory?");
            return;
        }

        // Create a new directory for the package and populate it
        // with a Makefile
        try {
            mkdir(packageDir);
            std.file.write(packageDir ~ "/Makefile", "include ../Makefile.common\n");
        }
        catch (FileException e)
        {
            writeln("Error creating package directory: " ~ e.msg);
            if (exists(packageDir))
            {
                remove(packageDir);
            }
            return;
        }

        // Run yauto.py to generate a package.yml file
        auto pid = spawnProcess([yauto, url], null, Config.none, packageDir);
        scope(exit) wait(pid);
    }
}
