kind: a function
<hr/>
Reports file count, by extension.&nbsp;&nbsp;Subdirectories are counted under pseudo-extension <tt><subdir></tt>; regfiles without extension are counted under pseudo-extension <tt><none></tt>.&nbsp;&nbsp;Report lines are sorted by count descending.

If invoked with extra maxdepth argument, will descend into subdirectories to the given tree depth.

If invoked with the extra argument <b><tt>-</tt></b> <b>&emdash;</b>, for each extension also reports the name and relative age of the oldest representative; and same for newest representative.&nbsp;&nbsp;(If there was only 1 such file, then obviously it is both oldest <i>and</i> newest, so we just omit the duplicate info on the right.)

<hr/>
Demo:
![screensh--about-dir](https://github.com/user-attachments/assets/7c28715f-1e58-49d8-b7e7-0611fec23248)
