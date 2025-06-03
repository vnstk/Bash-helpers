kind: functions, aliases
<hr/>
<h2>All:</h2>
<ul>
  <li>Ensure <tt>ls</tt> colorizes it output; if output isn't going to a terminal, then have <tt>ls</tt> at least append a distinguishing character to names (e.g. <tt>/</tt> after dir names)</li>
  <li>Ensure files whose name starts with <tt>.</tt> are shown (but exclude the <tt>.</tt> and <tt>..</tt> pseudo-directories) </li>
  <li>Ensure that shell-interacting characters are escaped, and control characters printed as <tt>\0</tt><i>ooo</i> . </li>
  <li>Tstamps are printed either coarse-grain style (e.g. <tt>[25-Jun03] 11:49</tt>) or fine-grain style (e.g. <tt>[25-Jun03] 11:49:23.578603</tt>)</li>
  <li>When sorting by name, group directory entries first.  (So, subdirs by name and then regfiles by name.)</li>
</ul>
<hr/>

Demo, just-the-names, no recurse:
![demo__L](https://github.com/user-attachments/assets/9dfe133b-3861-4e5f-9d7e-1f65fc1a52f6)

<hr/>

Demo, names and details, no recurse:
![demo__LT](https://github.com/user-attachments/assets/dbaba505-604b-4f75-a8ea-4f28929a7d21)

 <div class="sidebar">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note that uninteresting info (<b>A</b>,<b>B</b>,<b>C</b>,<b>D</b>) is removed.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note that dates are printed unambiguously: "May 18" could be 18th of May or May of 2018, but "25-May18" could only be 18th of May in 2025).
</div>
  
<hr/>

Demo, names and details, recurse:
![demo_LLR](https://github.com/user-attachments/assets/3a214e57-4250-4095-993f-49c8075b7984)


<hr/><hr/>
<h2>The <tt>lv</tt><i>*</i> series: <tt>lvt</tt>, <tt>lvz</tt>, <tt>lvth</tt>, <tt>lvzh</tt> </h2>
Print only the first (after sorting applied) 5 entries, to not clutter up your console overmuch.
<ul>
  <li><tt>lvt</tt>&nbsp;&mdash;&nbsp;fine tstamp; list the 5 newest, newest-first; also show owner info.</li>  
  <li><tt>lvz</tt>&nbsp;&mdash;&nbsp;fine tstamp; list the 5 biggest, biggest-first; also show owner info.</li>
  <li><tt>lvth</tt>&nbsp;&mdash;&nbsp;coarse tstamp; list the 5 newest, newest-first; also show owner info; unit-abbreviated size.</li>
  <li><tt>lvzh</tt>&nbsp;&mdash;&nbsp;coarse tstamp; list the 5 biggest, biggest-first; also show owner info; unit-abbreviated size.</li>
</ul>
Demo:

![demo_LVseries](https://github.com/user-attachments/assets/5fc4db11-e768-4381-ac6d-1f869c8f82e6)


<hr/><hr/>
<h2>The <tt>lx</tt><i>*</i> series: <tt>lx</tt>, <tt>lxt</tt>, <tt>lxz</tt></h2>
Print <i>just the names of</i> up to 10 first (after sorting applied) entries; make sure output fits onto a <i>single screen line</i>, to not clutter up your console at all.
<ul>
  <li><tt>lx</tt>&nbsp;&mdash;&nbsp;sort by name alpha (ASCIIbetically).</li>  
  <li><tt>lxt</tt>&nbsp;&mdash;&nbsp;sort by mtime (newest first)</li>
  <li><tt>lxz</tt>&nbsp;&mdash;&nbsp;sort by size (biggest first).</li>
</ul>
Demo:

![demo_LX_LXZ_LXT](https://github.com/user-attachments/assets/45e9038a-64ba-45b3-96cb-186b9bcd2fff)


&nbsp;
