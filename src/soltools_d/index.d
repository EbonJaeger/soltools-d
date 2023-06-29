module soltools_d.index;

import std.process;
import std.stdio;

auto index(scope string localRepoDir)
{
    auto pid = spawnProcess(
        ["eopkg", "index", "--skip-signing", localRepoDir],
        null,
        Config.none,
        localRepoDir
    );

    return wait(pid);
}
