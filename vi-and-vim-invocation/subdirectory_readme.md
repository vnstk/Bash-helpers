kind: functions, startup script logic
<hr/>
Given path of a file along with line numbe and maybe also column, all as a colon-separated string &#8212; such as compilers are wont to emit &#8212; these functions will open said file at the proper line and with cursor at the proper column.
<br/><br/>
All you need do is copy the whole thing, and paste it after typed <tt>vi</tt> (or <tt>vir</tt> or <tt>gvir</tt> or <tt>virreally</tt> or .....).

<hr/>
Example:<br/>

![vir-demo-A](https://github.com/user-attachments/assets/b080ad73-aac1-4d83-b28b-0477280b9aeb)


<hr/>
To summarize, all of the following will work:
<ul>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h</tt></li>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h:399</tt></li>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h:399:</tt></li>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h:399:79</tt></li>  
  <li><i>shortcutName</i> <tt>foo/bar/qux.h:399:79:</tt></li>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h +399</tt></li>
  <li><i>shortcutName</i> <tt>foo/bar/qux.h +/assert</tt></li>
</ul>
; where <i>shortcutName</i> := <tt>vi</tt> | <tt>vir</tt> | <tt>virreally</tt> | <tt>vish</tt> | <tt>virsh</tt> | <tt>viu8</tt> | <tt>viru8</tt> | <tt>gvi</tt> | <tt>gvir</tt> | .....
