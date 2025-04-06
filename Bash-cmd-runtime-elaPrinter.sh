# Vainstein K 2025apr06
#
#
# Do not try to execute this file; source it.


unset -f save_tBefore save_tAfter since_tThen

save_tBefore() { echo -n "${EPOCHREALTIME}" > /tmp/.cmd-tstampThen-$$ ;}
#
export PS0='$(save_tBefore)'

save_tAfter() { echo -n "${EPOCHREALTIME}" > /tmp/.cmd-tstampNow-$$ ;}
#
export PROMPT_COMMAND='save_tAfter'

since_tThen() {
	local tstampThen=''
	{	read tstampThen < /tmp/.cmd-tstampThen-$$	;} 2>/dev/null
	rm -f /tmp/.cmd-tstampThen-$$
	if [ -z "$tstampThen" ]; then
		printf '?'
		return
	fi
	local -ra tokensThen=( ${tstampThen/./ } )
	# If tokens[1] starts with 0, then Bash treats it as a base-8 number; if tokens[1] is say
	# 000093, then an illegal base-8 number!  So we tell Bash to treat it as a base-10.
	local -ri secThen=${tokensThen[0]} microsThen=10#${tokensThen[1]}
	#
	local tstampNow=''
	{	read tstampNow < /tmp/.cmd-tstampNow-$$	;} 2>/dev/null
	rm -f /tmp/.cmd-tstampNow-$$
	if [ -z "tstampNow" ]; then
		printf '??'
		return
	fi
	local -ra tokensNow=( ${tstampNow/./ } )
	local -ri secNow=${tokensNow[0]} microsNow=10#${tokensNow[1]}
	#
	local -i secDelta=0 microsDelta=0
	if [ $secNow -eq $secThen ]; then
		microsDelta=$[microsNow-microsThen]
	else
		microsDelta=$[(1000000-microsThen) + microsNow]
		secDelta=$[(secNow-secThen)-1]
		if [ $microsDelta -ge 1000000 ]; then
			microsDelta+=-1000000
			secDelta+=1
		fi
	fi
	if [ $[secDelta+microsDelta] -gt 0 ]; then
		printf "%$[COLUMNS-15]s %u.%06u" 'Ela' ${secDelta} ${microsDelta}
	else
		printf '???'
	fi
}
#
elaPrinter='\[\e[35;3;2m\]$(since_tThen)\[\e[0m\]\n'
#
export PS1="${elaPrinter}${PS1}"
unset elaPrinter
