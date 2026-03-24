# Package-wide options for lbstproj

`lbstproj` exposes one global option that controls whether informational
messages are printed by package functions.

## Options

- **`lbstproj.quiet`** (`logical`, default `FALSE`) - When `TRUE`,
  suppresses all informational messages (e.g. "Saved to ...", "Importing
  TOT ...") across every function in the package.

  Individual functions also accept a `quiet` argument that overrides
  this option for a single call.

## Usage

Silence messages for an entire session:

    options(lbstproj.quiet = TRUE)

Restore the default (verbose) behaviour:

    options(lbstproj.quiet = FALSE)

Override the option for a single call:

    save_figure(fig, name = "my-fig", quiet = TRUE)   # silent
    save_figure(fig, name = "my-fig", quiet = FALSE)  # verbose
