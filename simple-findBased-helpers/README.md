kind: functions

<hr/>

Several simple functions building on top each other:
<lu>

<li><tt>where </tt> <i>regfileName</i>: prints the found paths of the specified file, and copies them to the paste 
buffer &mDash; see the <tt>copyPaste-buffer-manipulation</tt> script.</li>

<li><tt>whered </tt> <i>dirName</i>: like <tt>where</tt>, but looks for subdirectories instead.</li>

<li><tt>thither </tt> <i>regfileName</i>: passes its arg to <tt>where</tt>; then, ...
<br/>&nbsp;&nbsp;&nbsp;&nbsp;... if <tt>where</tt> found 0 paths, <tt>thither</tt> prints <b><tt>Not found</tt></b> in red.
<br/>&nbsp;&nbsp;&nbsp;&nbsp;... if <tt>where</tt> found exactly 1 path, <tt>thither</tt> takes you there (cd's you there).
<br/>&nbsp;&nbsp;&nbsp;&nbsp;... if <tt>where</tt> found exactly more than 1 path, <tt>thither</tt> prints <b><tt>Ambiguous</tt></b> in red.&nbsp;&nbsp;All the found paths are now in your copy-paste buffer, of course.
    </li>

<li><tt>thither </tt> <i>regfileName</i>: passes its arg to <tt>thither</tt>; if the sought file was found in exactly 1 path, our PWD has been changed to that path's dirname courtesy of <tt>thither</tt>, and now all <tt>vere</tt> has to do is invoke <tt>vir</tt> <i>regfileName</i>.
<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("VERE" is short for "Vi of whERE", a little pun.)
      </li>
</lu>
<hr/>
<hr/><br/>
Demo, in a C++ codebase where headers have been named <tt>*.hpp</tt>:

![demoAA--simple-findBased](https://github.com/user-attachments/assets/649c8bc7-6c15-4f85-9137-06fd0028ec8c)

Note that the 3 paths had been copied to the copy-paste buffer in step "D", so step "E" was obtained just by pressing Shift-Ins.

<hr/>

