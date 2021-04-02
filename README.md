# NAME

File::Codeowners - Read and write CODEOWNERS files

# VERSION

version 0.51

# METHODS

## new

    $codeowners = File::Codeowners->new;

Construct a new [File::Codeowners](https://metacpan.org/pod/File%3A%3ACodeowners).

## parse

    $codeowners = File::Codeowners->parse('path/to/CODEOWNERS');
    $codeowners = File::Codeowners->parse($filehandle);
    $codeowners = File::Codeowners->parse(\@lines);
    $codeowners = File::Codeowners->parse(\$string);

Parse a `CODEOWNERS` file.

This is a shortcut for the `parse_from_*` methods.

## parse\_from\_filepath

    $codeowners = File::Codeowners->parse_from_filepath('path/to/CODEOWNERS');

Parse a `CODEOWNERS` file from the filesystem.

## parse\_from\_fh

    $codeowners = File::Codeowners->parse_from_fh($filehandle);

Parse a `CODEOWNERS` file from an open filehandle.

## parse\_from\_array

    $codeowners = File::Codeowners->parse_from_array(\@lines);

Parse a `CODEOWNERS` file stored as lines in an array.

## parse\_from\_string

    $codeowners = File::Codeowners->parse_from_string(\$string);
    $codeowners = File::Codeowners->parse_from_string($string);

Parse a `CODEOWNERS` file stored as a string. String should be UTF-8 encoded.

## write\_to\_filepath

    $codeowners->write_to_filepath($filepath);

Write the contents of the file to the filesystem atomically.

## write\_to\_fh

    $codeowners->write_to_fh($fh);

Format the file contents and write to a filehandle.

## write\_to\_string

    $scalarref = $codeowners->write_to_string;

Format the file contents and return a reference to a formatted string.

## write\_to\_array

    $lines = $codeowners->write_to_array;

Format the file contents as an arrayref of lines.

## match

    $owners = $codeowners->match($filepath);

Match the given filepath against the available patterns and return just the
owners for the matching pattern. Patterns are checked in the reverse order
they were defined in the file.

Returns `undef` if no patterns match.

## owners

    $owners = $codeowners->owners; # get all defined owners
    $owners = $codeowners->owners($pattern);

Get an arrayref of owners defined in the file. If a pattern argument is given,
only owners for the given pattern are returned (or empty arrayref if the
pattern does not exist). If no argument is given, simply returns all owners
defined in the file.

## patterns

    $patterns = $codeowners->patterns;
    $patterns = $codeowners->patterns($owner);

Get an arrayref of all patterns defined.

## projects

    $projects = $codeowners->projects;

Get an arrayref of all projects defined.

## update\_owners

    $codeowners->update_owners($pattern => \@new_owners);

Set a new set of owners for a given pattern. If for some reason the file has
multiple such patterns, they will all be updated.

Nothing happens if the file does not already have at least one such pattern.

## update\_owners\_by\_project

    $codeowners->update_owners_by_project($project => \@new_owners);

Set a new set of owners for all patterns under the given project.

Nothing happens if the file does not have a project with the given name.

## rename\_owner

    $codeowners->rename_owner($old_name => $new_name);

Rename an owner.

Nothing happens if the file does not have an owner with the old name.

## rename\_project

    $codeowners->rename_project($old_name => $new_name);

Rename a project.

Nothing happens if the file does not have a project with the old name.

## append

    $codeowners->append(comment => $str);
    $codeowners->append(pattern => $pattern, owners => \@owners);
    $codeowners->append();     # blank line

Append a new line.

## prepend

    $codeowners->prepend(comment => $str);
    $codeowners->prepend(pattern => $pattern, owners => \@owners);
    $codeowners->prepend();    # blank line

Prepend a new line.

## unowned

    $filepaths = $codeowners->unowned;

Get the list of filepaths in the "unowned" section.

This parser supports an "extension" to the `CODEOWNERS` file format which
lists unowned files at the end of the file. This list can be useful to have in
order to figure out what files we know are unowned versus what files we don't
know are unowned.

## add\_unowned

    $codeowners->add_unowned($filepath, ...);

Add one or more filepaths to the "unowned" list.

This method does not check to make sure the filepath(s) actually do not match
any patterns in the file, so you might want to call ["match"](#match) first.

See ["unowned"](#unowned) for an explanation.

## remove\_unowned

    $codeowners->remove_unowned($filepath, ...);

Remove one or more filepaths from the "unowned" list.

Silently ignores filepaths that are already not listed.

See ["unowned"](#unowned) for an explanation.

## is\_unowned

    $bool = $codeowners->is_unowned($filepath);

Test whether a filepath is in the "unowned" list.

See ["unowned"](#unowned) for an explanation.

## clear\_unowned

    $codeowners->clear_unowned;

Remove all filepaths from the "unowned" list.

See ["unowned"](#unowned) for an explanation.

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://github.com/chazmcgarvey/File-Codeowners/issues](https://github.com/chazmcgarvey/File-Codeowners/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Charles McGarvey <chazmcgarvey@brokenzipper.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Charles McGarvey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
