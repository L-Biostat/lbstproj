# Check if a file can be overwritten

Check if a file can be overwritten

## Usage

``` r
check_can_overwrite(path, overwrite, what = "File")
```

## Arguments

- path:

  *Character*. Path of the file to check

- overwrite:

  *Logical*. Whether the file can be overwritten or not.

- what:

  *Character*. The type of file being checked. This is only used to
  customize the error message if the file can't be overwritten.

  *Default*: `"File"`. A generic description

## Value

Invisibly return the path of the file
