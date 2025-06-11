# Vainstein K 2016may02
# vim:ts=4:ft=sh


findDirPruneNamesCond='-name __pycache__ -o -name .github -o -name .git'

# where (look for a regfile) and whered (look for a dir).

# NB: we here prefer
	# .............. | tee >(tr -d '\n' | rd_pastebuf)   ;}
# to
	# .............. | rd_pastebuf | pastebuf_wr   ;}
# , because latter variant keeps a trailing LF in clipboard.

if [[ $MACHTYPE =~ apple ]]; then
	where  () { find . -xdev -type d \( $findDirPruneNamesCond \) -prune -o -type f -iname "$1" -print | tee >(tr -d '\n' | rd_pastebuf) ;}
	whered () { find . -xdev -type d \( $findDirPruneNamesCond \) -prune -o -type d -iname "$1" -print | tee >(tr -d '\n' | rd_pastebuf) ;}
	# TODO: check --- does the other find syntax (see below) really not work in Brew??
else
	if $havePastebufManip; then
		where () { find . -xdev \( \( -type d \( $findDirPruneNamesCond \) -prune \) -o -type f \) -iname "$1" -print | tee >(rd_pastebuf) ;}
		whered() { find . -xdev \( \( -type d \( $findDirPruneNamesCond \) -prune \) -o -type d \) -iname "$1" -print | tee >(rd_pastebuf) ;}
	else
		where  () { find . -xdev \( \( -type d \( $findDirPruneNamesCond \) -prune \) -o -type f \) -iname "$1" ;}
		whered () { find . -xdev \( \( -type d \( $findDirPruneNamesCond \) -prune \) -o -type d \) -iname "$1" ;}
	fi
fi


# # # Look for a file; if there is exactly 1 result, cd to the result's parent dir.
thither () {
	local pathsWhere=( `where "$1"` )
	if [ -z "$pathsWhere" ]; then
		echo -e "\e[31mNot found.\e[0m" >&2                  && return 1
	elif [ -n "${pathsWhere[1]}" ]; then
		echo -e "\e[31mAmbiguous:\e[0m${pathsWhere[@]/#/\\n\\t}" >&2 && return 2
	else
		local -r dirWhere=`dirname "${pathsWhere[0]}"`
		cd "$dirWhere"               && return 0
	fi
}

# # # Look for a file, open it in its parent dir, and once done return to the dir where you started.
vere () {
	thither "$1" || return
	vir "$@"
	cd $OLDPWD
}
gvere () {
	thither "$1" || return
	gvir "$@"
	cd $OLDPWD
}
