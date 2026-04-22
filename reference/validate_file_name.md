# Validate the name of a script

Ensures that a script name only contains valid characters and removes
any potential extension. In non-strict mode, letters, numbers,
underscores, and hyphens are allowed. In strict mode, underscores are
disallowed.

## Usage

``` r
validate_file_name(name, strict = FALSE)
```

## Arguments

- name:

  *Character*. The name of the script to validate.

- strict:

  *Logical*. Whether to disallow underscores in the validated name.

  *Default*: `FALSE`

## Value

*Character*. The validated name of the script without any extension.
