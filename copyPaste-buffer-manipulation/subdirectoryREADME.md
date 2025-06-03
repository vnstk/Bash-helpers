kind: startup script logic, aliases
<hr/>

The actual commands used for scriptamatic manipulation of the copy-paste buffer depend on host:
<ul>
  <li>Linux: <tt>xsel</tt>; not installed by default.</li>
  <li>MSYS2: <tt>putclip</tt> and <tt>putclip</tt>; not installed by default.</li>
  <li>MacOS: <tt>pbcopy</tt> and <tt>pbpaste</tt>; comes with MacOS (don't even need Brew).</li>
</ul>

All <tt>Bash-copyPaste-buffer-manipulation.sh</tt> does is define 2 aliases, <tt>rd_pastebuf</tt> and <tt>pastebuf_wr</tt>; and set 1 readonly global variable, <tt>havePastebufManip=</tt>.  Several of my helpers use these.
