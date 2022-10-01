module soltools_d.cli.copy;

import soltools_d;
import std.algorithm;
import std.file;
import std.getopt;
import std.path;
import std.process;
import std.stdio;

int copyFiles(string[] args)
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
    defaultGetoptPrinter("soltools-d copy --repo-location <path> --skip-indexing", opts.options);
    return 1;
  }

  if (localRepoDir is null)
  {
    localRepoDir = defaultRepoLoc;
  }

  writeln("Found the following packages to copy:");

  // Get any eopkg files
  auto cwd = getcwd();
  auto entries = dirEntries(cwd, SpanMode.shallow).filter!(f => f.name.endsWith(".eopkg"));

  // Copy the packages to the local repo
  foreach (entry; entries)
  {
    auto name = baseName(entry.name);

    try
    {
      entry.copy(localRepoDir ~ name);
    }
    catch (FileException e)
    {
      writeln("error copying '" ~ name ~ "' to local repo: ", e.msg);
      continue;
    }

    writeln("  - " ~ name);
  }

  if (skipIndexing)
  {
    return 0;
  }

  // Index the repo
  try
  {
    index(localRepoDir);
  }
  catch (Exception e)
  {
    writeln("error indexing repo:", e.msg);
    return 1;
  }

  return 0;
}
