module soltools_d.cli.index;

import soltools_d;
import std.getopt;
import std.process;
import std.stdio;

int indexRepo(string[] args)
{
  string localRepoDir;

  auto opts = getopt(
    args,
    "repo-location", "Repository Location", &localRepoDir,
  );

  if (opts.helpWanted)
  {
    defaultGetoptPrinter("soltools-d index --repo-location <path>", opts.options);
    return 1;
  }

  if (localRepoDir is null)
  {
    localRepoDir = defaultRepoLoc;
  }

  // Index the repo
  auto status = index(localRepoDir);
  if (status != 0)
  {
    writeln("error indexing local repository");
  }

  return status;
}
