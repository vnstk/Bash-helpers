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


<hr/>
<hr/>

<table>
    <thead>
        <th>alias</th><th>sort by?</th><th>recurse?</th><th>show owner info?</th><th>show size?</th><th>mtime tstamp?</th><th>limits?</th>
   </thead>
  <tbody>
<tr><td><tt>l</tt></td><td>name</td><td>no</td><td>no</td><td>&mdash;</td><td>&mdash;</td><td>&mdash;</td></tr>
<tr><td><tt>ll</tt></td><td>name</td><td>no</td><td>no</td><td>&mdash;</td><td>coarse</td><td>&mdash;</td></tr>
    <!--            -->
<tr><td><tt>lr</tt></td><td>name</td><td>yes</td><td>no</td><td>&mdash;</td><td>&mdash;</td><td>&mdash;</td></tr>
<tr><td><tt>llr</tt></td><td>name</td><td>yes</td><td>no</td><td>&mdash;</td><td>coarse</td><td>&mdash;</td></tr>
<!--            -->
<tr><td><tt>llo</tt></td><td>name</td><td>no</td><td>yes</td><td>&mdash;</td><td>coarse</td><td>&mdash;</td></tr>
<tr><td><tt>llro</tt></td><td>name</td><td>yes</td><td>yes</td><td>&mdash;</td><td>coarse</td><td>&mdash;</td></tr>
    <!--            -->

<tr><td><tt>lz</tt></td><td>size, biggest-last</td><td>no</td><td>no</td><td>unit-abbr.</td><td>fine</td><td>&mdash;</td></tr>
<tr><td><tt>lzo</tt></td><td>size, biggest-last</td><td>no</td><td>yes</td><td>unit-abbr.</td><td>fine</td><td>&mdash;</td></tr>
    <!--            -->
<tr><td><tt>lzh</tt></td><td>size, biggest-last</td><td>no</td><td>no</td><td>byte count</td><td>coarse</td><td>&mdash;</td></tr>
<tr><td><tt>lzho</tt></td><td>size, biggest-last</td><td>no</td><td>yes</td><td>byte count</td><td>coarse</td><td>&mdash;</td></tr>
    <!--            -->
<tr><td><tt>lzr</tt></td><td>size, biggest-last</td><td>yes</td><td>no</td><td>unit-abbr.</td><td>coarse</td><td>&mdash;</td></tr>
<tr><td><tt>lzro</tt></td><td>size, biggest-last</td><td>yes</td><td>yes</td><td>unit-abbr.</td><td>coarse</td><td>&mdash;</td></tr>
    <!--            -->
<tr><td><tt>lt</tt></td><td>mtime, newest-last</td><td>no</td><td>no</td><td>unit-abbr.</td><td>fine</td><td>&mdash;</td></tr>
<tr><td><tt>lto</tt></td><td>mtime, newest-last</td><td>no</td><td>yes</td><td>unit-abbr.</td><td>fine</td><td>&mdash;</td></tr>
    <!--            -->
<tr><td><tt>ltr</tt></td><td>mtime, newest-last</td><td>yes</td><td>no</td><td>byte count</td><td>fine</td><td>&mdash;</td></tr>
<tr><td><tt>ltro</tt></td><td>mtime, newest-last</td><td>yes</td><td>yes</td><td>byte count</td><td>fine</td><td>&mdash;</td></tr>
<!--            -->
<tr><td><tt>lvz</tt></td><td>size, biggest-first</td><td>no</td><td>no</td><td>byte count</td><td>fine</td><td>first 5</td></tr>
<tr><td><tt>lvt</tt></td><td>mtime, newest-first</td><td>no</td><td>no</td><td>byte count</td><td>fine</td><td>first 5</td></tr>>
<tr><td><tt>lvzh</tt></td><td>size, biggest-first</td><td>no</td><td>no</td><td>unit-abbr.</td><td>coarse</td><td>first 5</td></tr>
<tr><td><tt>lvth</tt></td><td>mtime, newest-first</td><td>no</td><td>no</td><td>unit-abbr.</td><td>coarse</td><td>first 5</td></tr>>
<!--            -->
<tr><td><tt>lx</tt></td><td>name</td><td>no</td><td>no</td><td>&mdash;</td><td>&mdash;</td><td>fit on single line; no more than 10</td></tr>
<tr><td><tt>lxt</tt></td><td>mtime, newest-first</td><td>no</td><td>no</td><td>&mdash;</td><td>&mdash;</td><td>fit on single line; no more than 10</td></tr>
<tr><td><tt>lxz</tt></td><td>size, biggest-first</td><td>no</td><td>no</td><td>&mdash;</td><td>&mdash;</td><td>fit on single line; no more than 10</td></tr>
  </tbody>
</table>

Sort-by qualifiers like "biggest-last" and "newest-last" are meant <i>within each dir</i> <b>if</b> recurse=yes.
