# Vainstein K 2025apr06
#
#
# Do not try to execute this file; source it.


unset -f save_tBefore save_tAfter since_tThen readSavedFractionalSeconds

save_tBefore() { echo -n "${EPOCHREALTIME}" > /tmp/.cmd-tstampThen-$$ ;}
#
export PS0='$(save_tBefore)'

save_tAfter() { echo -n "${EPOCHREALTIME}" > /tmp/.cmd-tstampNow-$$ ;}
#
export PROMPT_COMMAND='save_tAfter'

since_tThen() {
	readSavedFractionalSeconds() {
		local -r srcFile=$1
		declare -n refOut_sec=$2 refOut_micros=$3
		local tstamp=''
		{	read tstamp < $srcFile	;}  2>/dev/null
		rm -f $srcFile
		[ -z "$tstamp" ] && return
		local -ra tokens=( ${tstamp/./ } )
		# If tokens[1] starts with 0, Bash treats it as a base-8 number; if tokens[1] is say
		# 000093, then an illegal base-8 number!  So we tell Bash to treat it as a base-10.
		refOut_sec=${tokens[0]} refOut_micros=10#${tokens[1]}
	}
	local -i secThen=-2 microsThen=-2 secNow=-1 microsNow=-1
	readSavedFractionalSeconds /tmp/.cmd-tstampThen-$$ secThen microsThen
	readSavedFractionalSeconds /tmp/.cmd-tstampNow-$$ secNow microsNow
	if [ $secThen -ge $secNow ]; then
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
			printf '?' # A logic or arithmetic bug.
		fi
	fi # If prints nothing, most likely is because had failed to read both saved tstamps.
}
#
elaPrinter='\[\e[35;3;2m\]$(since_tThen)\[\e[0m\]\n'
#
export PS1="${elaPrinter}${PS1}"
unset elaPrinter
