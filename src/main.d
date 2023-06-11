module main;

import soltools_d.cli;
import std.getopt;

int main(string[] args)
{
  auto subcommands = [
    "clean": &cleanFiles,
    "copy": &copyFiles,
    "index": &indexRepo,
    "init": &initializeRepo,
  ];

  if (args.length < 2)
  {
    return 1;
  }

  auto func = (args[1] in subcommands);

  if (func is null)
  {
    return 2;
  }

  return (*func)(args);
}
