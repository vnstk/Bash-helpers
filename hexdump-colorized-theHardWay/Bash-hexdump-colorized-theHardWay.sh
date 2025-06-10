# vim:ts=4:ft=sh
# Vainstein K 2009apr03


# Highlights bytes, _except for_ isprint(3)able ASCII bytes, as follows:
#
#	 purple foreground (ANSI escape sequence 35): newline.
#	lt blue foreground (ANSI escape sequence 36): tab.
#	    red foreground (ANSI escape sequence 31): other ASCII control codes.
#	 yellow foreground (ANSI escape sequence 33): non-ASCII.

pretty-hexdump () {
	[ $# -lt 1 -o $# -gt 5 ] && {
		cat >&2 <<LIMITstr
USAGE: $FUNCNAME [--w <width=16>] <binaryFile> [<sizeLimit> [<startOffset=0>]]

  Highlights bytes, [4mexcept for[0m isprint(3)able ASCII bytes, as follows:
	[35m newline [0m
	[36m tab [0m
	[31m other ASCII control codes [0m
	[33m non-ASCII [0m

LIMITstr
		return
	}
	if [[ $1 == '--w' && $# -ge 3 && $2 =~ ^[1-9][0-9]*$ ]]; then
		local -ri width=$2
		shift 2
	else
		local -ri width=16
	fi
	local -r binaryFile=$1
	[ ! -r $binaryFile ] && echo "File '$binaryFile' not found or not accessible." >&2 && return
	#  Adding 'z' suffix displays printable characters at the end of each output line.
	local od_options="--address-radix=x --output-duplicates --width=$width --format x1z"
	[ -n "$2" ] && od_options+=" --read-bytes=$2"
	[ -n "$3" ] && od_options+=" --skip-bytes=$3"
	[ -n "$LCEbashDEBUG" ] && echo -e "od_options[\n\t$od_options\n]" >&2
	local odd=false
	local line
	while IFS='' read line; do
		if $odd; then
			echo -E "${line#Z}" # Don't interpret any \-escapes; strip leading 'Z'; append EOL.
			odd=false
		else
			echo -e -n "${line}" # Interpret ANSI escapes; do not append EOL.
			odd=true
		fi
	done < <(od $od_options $binaryFile \
\
| sed -r 's/^(.*)(  '$'\x3E''.*)$/\1\nZ\2/' \
\
| sed \
'/^Z/! {'\
's/\<[89a-f][0-9a-f]\>/\\\\e[33m&\\\\e[0m/g'\
';'\
's/\<0a\>/\\\\e[35m&\\\\e[0m/g'\
';'\
's/\<09\>/\\\\e[36m&\\\\e[0m/g'\
';'\
's/\<[01][0-9a-f]\>/\\\\e[31m&\\\\e[0m/g'\
'}' \
\
| sed '/^Z/ { s/\\/\\\\/g }'
)
	$odd && echo
}
