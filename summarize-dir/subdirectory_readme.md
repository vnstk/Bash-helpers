kind: a function
<hr/>
Reports file count, by extension.  Subdirectories are counted under pseudo-extension <tt><subdir></tt>; regfiles without extension are counted under pseudo-extension <tt><none></tt>.

Report lines are sorted by count descending.

If invoked with the extra argument <b>&ndash;</b>, for each extension also reports the name and relative age of the oldest representative; and same for newest representative.

Handle file names with internal spaces, internal newlines, internal DEL bytes, etc.

If you commonly name your directories <b>&ndash;</b>, this will not work out too well.
