Nowadays <tt>hexdump(1)</tt> takes format strings with color codes, so you can colorize its output with ease; but that had not been so until just a few years ago.&nbsp;&nbsp;If all you have is an older <tt>hexdump(1)</tt>, or if you have no <tt>hexdump(1)</tt> at all, the <tt>pretty-hexdump</tt> function can help.&nbsp;&nbsp;Implemented with <tt>od(1)</tt>.
<br/><br/>
Implementation explained:
<ul>
  <li>We start with output of <tt>od(1)</tt>, say
<tt>
0054a0 0a 00 00 00 48 89 ef e8 d4 fb 00 00 48 8b 75 08  >....H.......H.u.<
0054b0 48 8b 7d 10 48 85 db 48 0f 44 1d 09 74 01 00 31  >H.}.H..H.D..t..1<
</tt>
</li>
  
  <li>The first transform, <tt>sed -r 's/^(.*)(  '$'\x3E''.*)$/\1\nZ\2/'</tt>, splits each line so that the "best-effort-printable" substrings are on their own lines, prefixed with <tt>Z</tt>.&nbsp;&nbsp;(There is no chance of confusion, since all the other lines start with a lowercase hex digit.)
<tt>
0054a0 0a 00 00 00 48 89 ef e8 d4 fb 00 00 48 8b 75 08
Z  >....H.......H.u.<
0054b0 48 8b 7d 10 48 85 db 48 0f 44 1d 09 74 01 00 31
Z  >H.}.H..H.D..t..1<
</tt>
</li>
    <li>The second transform, <tt>sed '/^Z/! {s/\<[89a-f][0-9a-f]\>/\\\\e[33m&\\\\e[0m/g'; </tt><i>...3 more similar "s" commands...</i><tt>}</tt>, wraps selected byte codes in ANSI color escape sequences; we obtain
<tt>
0054a0 \\e[35m0a\\e[0m \\e[31m00\\e[0m \\e[31m00\\e[0m \\e[31m00\\e[0m 48 \\e[33m89\\e[0m \\e[33mef\\e[0m \\e[33me8\\e[0m \\e[33md4\\e[0m \\e[33mfb\\e[0m \\e[31m00\\e[0m \\e[31m00\\e[0m 48 \\e[33m8b\\e[0m 75 \\e[31m08\\e[0m
Z  >....H.......H.u.<
0054b0 48 \\e[33m8b\\e[0m 7d \\e[31m10\\e[0m 48 \\e[33m85\\e[0m \\e[33mdb\\e[0m 48 \\e[31m0f\\e[0m 44 \\e[31m1d\\e[0m \\e[36m09\\e[0m 74 \\e[31m01\\e[0m \\e[31m00\\e[0m 31
Z  >H.}.H..H.D..t..1<
</tt>
</li>
    <li>The third transform, <tt>sed '/^Z/ { s/\\/\\\\/g }'</tt>, <t>\</t>-escapes any <tt>\</tt> characters in the "best-effort-printable" substrings.&nbsp;&nbsp;(There are none in our example.)
</li>
    <li>Finally, we print odd-numbered lines (the byte codes) and even-numbered lines (the "best-effort-printable" strings) differently:
    <ul>
      <li>Odd: don't interpret any <tt>\</tt>-escapes; strip leading 'Z'; append EOL.</li>
      <li>Even: do interpret ANSI escapes; do not append EOL.</li>
    </ul>
</li>
    <li>And here's how it all looks to the user:</li>
</ul>

![pretty-hexdump-demo](https://github.com/user-attachments/assets/0eb8e95a-3d32-4dfd-a847-d74dcc290617)

<hr/>
Color choices are explained in the usage banner,

![pretty-hexdump-usage-banner](https://github.com/user-attachments/assets/4ecaec84-75f3-43df-9c96-df0c02370a7f)

<hr/>
