# Vainstein K 2018jan03
# vim:ts=4:ft=sh

pretty-ls () {
	local readonly timeStyle=$1
	local flags=$2
	shift 2
	local flagJ=false flagV=false
	if [[ $flags =~ J ]]; then flagJ=true; flags="${flags//J/}"; fi
	if [[ $flags =~ V ]]; then flagV=true; flags="${flags//V/}"; fi
	local -a optsArr=( "$flags" )
	$flagJ && optsArr+=( '--group-directories-first' )
	local timeStyleArg
	local readonly copy_IFS="$IFS"
	if [ $timeStyle == '--curt' ]; then
		IFS= timeStyleArg='--time-style=+ [%y-%b%d] %H:%M '
		optsArr+=( "$timeStyleArg" )
	elif [ $timeStyle == '--long' ]; then
		IFS= timeStyleArg='--time-style=+ [%y-%b%d] %H:%M:%S.%6N '
		optsArr+=( "$timeStyleArg" )
	fi
	local sedCommand=''
	# Strip link count total?
	[[ $flags =~ A.*[glR] ]] && sedCommand+='/^total [0-9]+[KMGT]?$/ d; '
	# Strip per-file link count?
	[[ $flags =~ A.*l ]] && {
		[[ $flags =~ A.*R ]] && sedCommand+='/^[-d]/ '
		sedCommand+='s/^(.{10})\.?[ ]+[0-9]+(.*)$/\1 \2/'
	} || {
		optsArr+=( '-C' "--width=$COLUMNS" )
	}
    # Cut the clutter: don't tell me that "size" of a directory is 4096, or 4.0K either.
    [[ $flags =~ l ]] && {
        if [[ $flags =~ h ]]; then
            sedCommand+='; /^d/ s/4.0K/----/'
        else
            sedCommand+='; /^d/ s/4096/----/'
        fi
    }
	# If recursing, make names of intermediate directories extra obtrusive.
	[[ $flags =~ R ]] && sedCommand+='; /^\.\/.*:$/ { s/^/\o33[35;1;4m/ ; s/$/\o33[0m/ ;}'
	# If asked to only show first 5, quit after 5th.
	$flagV && sedCommand+='; 6q'
	if [ -z "$sedCommand" ]; then
		optsArr+=( '--color=auto' )
		ls ${optsArr[@]} $@
	else
		optsArr+=( '--color=always' )
		ls ${optsArr[@]} $@ | sed -r "$sedCommand"
	fi
	IFS="$copy_IFS"
}
# -A: include dotfiles but exclude '.' and '..' entries.
# -b: escape shell-interacting isprint() chars; print iscntrl() chars as \0ooo.
# -F: print '/' after dir names, etc.; good if printing to file, otherwise color is nicer.
# -G: don't print group owner.
# -g: don't print user owner.
# -R: descend into subdirs.
# -r: reverse the sort.
# -S: sort by size.
# -t: sort by mtime.
# -J: not an actual ls(1) flag!  Used here to request "--group-directories-first".
# -V: also not an actual ls(1) flag!  Used here to discard output after 5th line.

# no tstamp; sort names alpha; in columns; do not colorize.  Almost identical to the bone-stock ls(1).
alias lbb='ls --color=never -Ab'   #(bb="bare-bones")
#
# no tstamp; sort names alpha; in rows; do not colorize.
alias lbbx='ls --color=never -Abx' #(bb="bare-bones")

# no tstamp; sort names alpha; in columns.
alias lpp='ls --color=auto -Ab'    #(pp="pretty plain")
#
# no tstamp; sort names alpha; in rows.
alias lppx='ls --color=auto -Abx'  #(pp="pretty plain")

# no tstamp; sort names alpha, grouping dirs first.
alias l='ls --color=auto --group-directories-first -Ab'

# no tstamp; sort names alpha, grouping dirs first; recurse.
alias lr='ls --color=auto --group-directories-first -AbR'

# coarse tstamp; sort names alpha, grouping dirs first.
alias ll='pretty-ls --curt -AblGgJ'

# coarse tstamp; sort names alpha, grouping dirs first; recurse.
alias llr='pretty-ls --curt -AblGgJR'

# coarse tstamp; sort names alpha, grouping dirs first; also show owner info.
alias llo='pretty-ls --curt -AblJ'

# coarse tstamp; sort names alpha, grouping dirs first; recurse; also show owner info.
alias llro='pretty-ls --curt -AblJR'

# coarse tstamp; sort by size, biggest-last; unit-abbreviated size.
alias lzh='pretty-ls --curt -AblhGgSrJ'

# coarse tstamp; sort by size, biggest-last; unit-abbreviated size; also show owner info.
alias lzho='pretty-ls --curt -AblhSrJ'

# fine tstamp; sort by size, biggest-last
alias lz='pretty-ls --curt -AblGgSrJ'

# fine tstamp; sort by size, biggest-last; also show owner info.
alias lzo='pretty-ls --long -AblSrJ'

# fine tstamp; sort by size, biggest-last; recurse.
alias lzr='pretty-ls --long -AblSGgrJR'

# fine tstamp; sort by size, biggest-last; recurse; also show owner info.
alias lzro='pretty-ls --long -AblSrJR'

# fine tstamp; sort by mtime, newest-last
alias lt='pretty-ls --long -AblGgtr'

# fine tstamp; sort by mtime, newest-last; also show owner info.
alias lto='pretty-ls --long -Abltr'

# fine tstamp; sort by mtime, newest-last; recurse
alias ltr='pretty-ls --long -AblGgtrR'

# fine tstamp; sort by mtime, newest-last; recurse; also show owner info.
alias ltro='pretty-ls --long -AbltrR'

# fine tstamp; list the 5 biggest, biggest-first; also show owner info.
alias lvz='pretty-ls --long -AblSV'
#
# fine tstamp; list the 5 newest, newest-first; also show owner info.
alias lvt='pretty-ls --long -AbltV'

# coarse tstamp; list the 5 biggest, biggest-first; also show owner info; unit-abbreviated size.
alias lvzh='pretty-ls --curt -AblhSV'
#
# coarse tstamp; list the 5 newest, newest-first; also show owner info; unit-abbreviated size.
alias lvth='pretty-ls --curt -AblhtV'


[ -z "$lxAwkScript" ] && readonly lxAwkScript='11==NR {exit} {sep="   "} 1==NR {sep=""} {sepn=length(sep); n=length(gensub("\033\\[[0-9][0-9;]*m" ,"","g")); if (totn + sepn + n > w) exit; s = s sep $1; totn+=sepn; totn+=n} END {print s}'
#
# no tstamp; list the first 10 (fewer if won't fit), by alpha, all on 1 line.
lx () {   ls --color=always -Ab1 --group-directories-first $@ | awk -v w=$COLUMNS "${lxAwkScript}"   ;}
#
# no tstamp; list the first 10 (fewer if won't fit), biggest-first, all on 1 line.
lxz () {   ls --color=always -AbS1 $@ | awk -v w=$COLUMNS "${lxAwkScript}"   ;}
#
# no tstamp; list the first 10 (fewer if won't fit), newest-first, all on 1 line.
lxt () {   ls --color=always -Abt1 $@ | awk -v w=$COLUMNS "${lxAwkScript}"   ;}

