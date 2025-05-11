kind: a function
<hr/>
Reports file count, by extension.&nbsp;&nbsp;Subdirectories are counted under pseudo-extension <tt>&lt;subdir&gt;</tt>; regfiles without extension are counted under pseudo-extension <tt>&lt;none&gt;</tt>.&nbsp;&nbsp;Report lines are sorted by count descending.<br/><br/>
If invoked with extra <i>maxDepth</i> argument, descends into subdirectories to the given tree depth.<br/><br/>
If invoked with the extra <b><tt>-</tt></b> argument, for each extension also reports the name and relative age of the oldest representative; and same for newest representative.&nbsp;&nbsp;(If there was only 1 such file, then obviously it is both oldest <i>and</i> newest, so we just omit the duplicate info on the right.)

<hr/>
Example:<br/>

![screensh--about-dir](https://github.com/user-attachments/assets/7c28715f-1e58-49d8-b7e7-0611fec23248)

(Note that <tt>cmd-runtime-elaPrinter</tt> had been sourced into this shell earlier.)
