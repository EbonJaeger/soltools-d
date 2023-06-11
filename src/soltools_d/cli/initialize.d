module soltools_d.cli.initialize;

import std.file;
import std.getopt;
import std.process;
import std.stdio;

int initializeRepo(string[] args)
{
  if (args.length != 4)
  {
    writeln("Incorrect number of args. Usage:");
    writeln("\tsoltools-d init <package name> <tarball URL>");
    return 1;
  }

  auto name = args[2];
  auto tarball = args[3];
  auto currentDir = getcwd();
  auto yauto = currentDir ~ "/common/Scripts/yauto.py";
  auto packageDir = currentDir ~ "/" ~ name;

  // Find yauto.py
  if (!yauto.exists)
  {
    writeln("Unable to find yauto.py. Are you in the right directory?");
    return 1;
  }

  // Create a new directory for the package and populate it
  // with a Makefile
  try {
    mkdir(packageDir);
    std.file.write(packageDir ~ "/Makefile", "include ../Makefile.common\n");
  } catch (FileException e)
  {
    writeln("Error creating package directory: " ~ e.msg);
    if (exists(packageDir))
    {
      remove(packageDir);
    }
    return 1;
  }

  // Run yauto.py to generate a package.yml file
  auto pid = spawnProcess([yauto, tarball], null, Config.none, packageDir);

  return wait(pid);
}
