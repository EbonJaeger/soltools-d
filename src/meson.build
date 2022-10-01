soltools_d_sources = [
  'main.d',
  'soltools_d/index.d',
  'soltools_d/package.d',
  'soltools_d/cli/copy.d',
  'soltools_d/cli/index.d',
  'soltools_d/cli/package.d'
]

soltools_d_includes = [
  include_directories('.')
]

executable(
  'soltools-d',
  soltools_d_sources,
  install: true,
  include_directories: soltools_d_includes,
  link_args: ['--link-defaultlib-shared=false'],
)
