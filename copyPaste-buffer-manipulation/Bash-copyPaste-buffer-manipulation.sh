# Vainstein K 2025may29
# vim:ts=4:ft=sh


if [ -n "$MSYSTEM" ]; then            declare -r amInMSYS2=true
elif [[ $MACHTYPE =~ apple ]]; then   declare -r amOnApple=true
else                                  declare -r amOnLinux=true
fi


if ${amInMSYS2:-false}; then
	#	-u 		Outp UNIX-style EOLs.
	alias rd_pastebuf='putclip -u'
	alias pastebuf_wr='getclip -u'
	command -v 'getclip' >/dev/null && declare -r havePastebufManip=true || declare -r havePastebufManip=false
elif ${amOnApple:-false}; then
	alias rd_pastebuf='pbcopy'
	alias pastebuf_wr='pbpaste'
	declare -r havePastebufManip=true
elif ${amOnLinux:-false}; then
	# "-l /dev/null" is so avoid seeing its complaints about how input doesn't end with an EOL.
	alias rd_pastebuf='xsel -p -i -l /dev/null'
	alias pastebuf_wr='xsel -p -o'
	command -v 'xsel' >/dev/null && declare -r havePastebufManip=true || declare -r havePastebufManip=false
fi
