# Vainstein K 2025jun18
# vim:ts=4:ft=sh

ascii() {
	local wide=false
	if [ "$1" == 'w' ]; then
		wide=true
		shift
	fi
	local -r codes0through31='NULSOHSTXETCEOTENQACKBEL BSTAB LF VT FF CR SO SIDLEDC1DC2DC3DC4NAKSYNETBCAN EMEOFESC FS GS RS US'
	local -r isgraph_prettyStart="\e[35;1m" # magenta bold
	local -r   other_prettyStart="\e[36;3m" # cyan italics
	local -r           prettyEnd="\e[0m"
	local -r fmt="%3d \e[7m%02X\e[27m %b%b%b%b"
	local -r colSep='    '
	local -i code
	local codeAsHexEscapeSeq name prettyStart afterCol isLastCol
	print_code() {
		if [ $code -ge 33 -a $code -le 126 ]; then # isgraph?
			printf -v codeAsHexEscapeSeq '%x' $code
			printf -v name " \x${codeAsHexEscapeSeq} "
			prettyStart=$isgraph_prettyStart
		else
			prettyStart=$other_prettyStart
			if [ $code -le 31 ]; then     name=${codes0through31:$[code*3]:3}
			elif [ $code -eq 32 ]; then   name='SPC'
			else                          name='DEL'
			fi
		fi
		if $isLastCol; then afterCol="\n"; else afterCol="$colSep"; fi
		printf "$fmt" $code $code $prettyStart "$name" $prettyEnd "$afterCol"
	}
	if $wide; then
		for ((j=0;j<16;++j)); do   for ((i=0;i<8;++i)); do
			code=$[i*16 + j]
			if [ $i -eq 7 ]; then isLastCol=true; else isLastCol=false; fi
			print_code
		done   done
	else
		for ((j=0;j<32;++j)); do   for ((i=0;i<4;++i)); do
			code=$[i*32 + j]
			if [ $i -eq 3 ]; then isLastCol=true; else isLastCol=false; fi
			print_code
		done   done
	fi
	[ $# -eq 0 ] || cat <<FUNFACTS

	a.	Control codes start with 00b.
	b.	Digits start with 0x3; their lower nybble (hex digit) is the value.
	c.	Ucase letters have 6th (3rd-most-signif) bit = 1; obtain corresp lcase letter by flipping it.
	d.	UNIX console sequence to enter a char from 1st col, is Ctrl- <corresp char from 3rd col>.  Examples: BS is ^H, TAB is ^I, EOF is ^Z.  (Ctrl clears top nybble of whatever char you type, so ^: and ^z are also EOF.)
	e.	Win kbd seq to enter a char is Alt-<its code in decimal>.  Example: DEL is Alt-1-2-7.
	f.	Some alternative control code names: 10 is also EOL or NEL, 26 also SUB, 17 also XON, 19 also XOFF.
	g.	Less well known control code names:
		SOH        start of header; start of heading
		[SE]TX     {start,end} of text
		EOT        end of xmission; signal EOF to UNIX terminal driver
		S[OI]      shift {out,in}
		DLE        data link escape
		SYN        synchronous idle
		ETB        end xmission block
		CAN        cancel; disregard last character or block
		EM         end of medium; end of tape
		[FGRU]S    {file,group,record,unit} separator
FUNFACTS
	# Many thanks to https://ss64.com/ascii.html and https://www.ascii-code.com
}
