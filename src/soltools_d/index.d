module soltools_d.index;

import std.process;
import std.stdio;

void index(in string localRepoDir)
{
  auto pid = spawnProcess(
    ["eopkg", "index", "--skip-signing", localRepoDir],
    null,
    Config.none,
    localRepoDir
  );
  auto status = wait(pid);

  if (status != 0)
  {
    writeln("error indexing the local repo");
    return;
  }

  return;
}
