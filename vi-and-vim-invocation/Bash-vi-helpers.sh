# Vainstein K 2025may29
# vim:ts=4:ft=sh


# Must handle any of
					#	src/FooBar.cpp:130:24:
					#	src/FooBar.cpp:130:24
					#	src/FooBar.cpp:130:
					#	src/FooBar.cpp:130
					#	src/FooBar.cpp:
					#	src/FooBar.cpp
vi_of_adjustedArgs () {
	local -r editorExe=$1
	shift
	local -r firstArg=$1
	shift
	# vi doesn't know about "call cursor(N,M)", but it does know about "+N".
    if [[ $editorExe != 'vi' && $firstArg =~ ^([^:]+):([0-9]+):([0-9]+) ]]; then
        command $editorExe  ${BASH_REMATCH[1]}  -c  "call cursor(${BASH_REMATCH[2]},${BASH_REMATCH[3]})"  $@
    elif [[ $firstArg =~ ^([^:]+):([0-9]+) ]]; then
        command $editorExe  ${BASH_REMATCH[1]}  +${BASH_REMATCH[2]}  $@
    else
        command $editorExe  ${firstArg%:}  $@
    fi
}

command -v 'vim' >/dev/null && {               #### If have vim, use it.
	[[ $MACHTYPE =~ apple ]] || {
		# With MacOS, if VIMINIT is defined, MacVim will not read ~/.vimrc; strange but true.
		export VIMINIT=':map qpq <Esc>:q!<CR> | set ts=4 | syntax on | set wrap | set restorescreen | map <F5> :set hls!<bar>set hls?<CR> | map <F4> :set hls!<bar>set hls?<CR> | imap <S-Tab> <Space><Space><Space><Space> | set ic | set smartcase | highlight comment ctermfg=lightblue'
	}
		# -m: disables writes back to file (but can edit buffer).  Can override with "set write".
		# -M: disables writes back to file, and even mods of buffer. Can override with "set modifiable" + "set write"
		# -n: no swapfile
		# -R: read-only unless you add "!" after save command.  Implies -n.
	# Open to edit.
	vi () {   vi_of_adjustedArgs vim $@   ;}
	# Open to read, but can later override the read-only choice with ":w!" for example.
	vir() {   vi_of_adjustedArgs vim $@ -Rn   ;}
	# Open to read, but overriding the read-only choice later is much harder.
	virreally () {   vi_of_adjustedArgs vim $@ -MRn   ;}
	# Open to edit what I promise is a shell script & hence ought be syntax-colorized as such.
	vish () {   vi_of_adjustedArgs vim $@ -c 'set ft=sh'   ;}
	# Open to read what I promise is a shell script & hence ought be syntax-colorized as such.
	virsh() {   vi_of_adjustedArgs vim $@ -c 'set ft=sh' -Rn   ;}
	# Open to edit what might contain UTF-8 and not just ASCII.
		# NB: enc a.k.a. 'encoding' also acts as default for 'fileencodings'.
	viu8 () {   vi_of_adjustedArgs vim $@ -c 'set enc=utf-8'   ;}
	# Open to edit what might contain UTF-8 and not just ASCII.
	viru8() {   vi_of_adjustedArgs vim $@ -c 'set enc=utf-8' -Rn   ;}
	# Open to to read some really big file: so big that must disable syntax colorizing and
	# plugins.  But still want some essentials from my .vimrc file.
	virfast() {   vi_of_adjustedArgs vim $@ -Rn -u NONE -c 'set ts=4' -c 'syntax on' -c 'set wrap' -c 'set smartcase' -c 'set hls' -c $'map qpq \x1B:q!\x0D'   ;}
} || {                                         #### If lack vim, POSIX guarantees vi so let's use that.
	#NB: noai=noautoindent noeb=noerrorbells ic=ignorecase sm=showmatch sw=shiftwidth ts=tabstop ws=wrapscan
	export EXINIT='set noai noeb ic magic redraw sm terse sw=4 ts=4 ws'
	vi () {   vi_of_adjustedArgs vi $@ -c "$EXINIT"   ;}
	vir() {   vi_of_adjustedArgs vi $@ -c "$EXINIT" -R   ;}
}


# MacOS, with MacVim installed?
[[ $MACHTYPE =~ apple ]] && [ -d /Applications/MacVim.app/Contents/bin ] && {
	# Shortcuts to launch the pretty standalone application, from cmdline; gvim must be in PATH.
	gvi () {        vi_of_adjustedArgs /Applications/MacVim.app/Contents/bin/gvim  $@ &        ;}
	gvir () {       vi_of_adjustedArgs /Applications/MacVim.app/Contents/bin/gvim  $@ -Rn &    ;}
	gvirreally () { vi_of_adjustedArgs /Applications/MacVim.app/Contents/bin/gvim  $@ -RnM &   ;}
	gview () {      vi_of_adjustedArgs /Applications/MacVim.app/Contents/bin/gview $@ &        ;}
	gvimdiff () {   /Applications/MacVim.app/Contents/bin/gvimdiff $@ &                        ;}
}

# MSYS2, with vim-for-Windows installed and in PATH?   (Would be "/c/progra~1/vim/vim82" or such.)
[ -n "$MSYSTEM" ] && command -v 'gvim' >&/dev/null && {
	# Shortcuts to launch the pretty standalone application, from cmdline; gvim must be in PATH.
	gvi () {        gvim      $@ &   ;}
	gvir () {       gvim -Rn  $@ &   ;}
	gvirreally () { gvim -RnM $@ &   ;}
}


# A special Bash func to enable visually pleasing recall of the definition of a Bash func.
# Example usage:
	#					view-bash-func vi_of_adjustedArgs
view-bash-func () {
	declare -f $1 | vim -Rn -c 'syntax on' -c 'set ft=bash' -
}
