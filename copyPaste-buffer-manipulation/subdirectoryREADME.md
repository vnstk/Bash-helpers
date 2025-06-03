TODO, revise 

kind: a function
<hr/>
Trims leading spaces as result from e.g. <tt>uniq -c</tt>.&nbsp;&nbsp;Use as
<tt>
find * -xdev \( \( -type d \( -name libs -o -name _deps \) -prune \) -o -type f \) -regex '.*\.hpp' -printf '%h\n' | sort | uniq -c | cram-columns 3
</tt>
<br/>
The numeric argument is # of columns desired; this, and separatorWidth (hardcoded as 2) are scrupulously respected.&nbsp;&nbsp;Best possible use is made of available space.
