module soltools_d.cli.clean;

import soltools_d;
import std.algorithm;
import std.file;
import std.getopt;
import std.path;
import std.stdio;

int cleanFiles(string[] args)
{
  string localRepoDir;
  bool skipIndexing = false;

  auto opts = getopt(
    args,
    "repo-location", "Repository Location", &localRepoDir,
    "skip-indexing", "Skip Indexing", &skipIndexing
  );

  if (opts.helpWanted)
  {
    defaultGetoptPrinter("soltools-d clean [OPTIONS]", opts.options);
    return 1;
  }

  if (localRepoDir is null)
  {
    localRepoDir = defaultRepoLoc;
  }

  writeln("Removing packages from the local repo");

  auto entries = dirEntries(localRepoDir, SpanMode.shallow).filter!(f => f.name.endsWith(".eopkg"));

  foreach (entry; entries)
  {
    try
    {
      entry.remove();
    }
    catch (FileException e)
    {
      writeln("error removing '" ~ baseName(entry.name) ~ "' from local repo: ", e.msg);
      return 1;
    }
  }

  if (skipIndexing)
  {
    return 0;
  }

  auto status = index(localRepoDir);
  if (status != 0)
  {
    writeln("error indexing local repository");
  }

  return status;
}
