# Vainstein K 2025apr06
#
#
# Do not try to execute this file; source it.


unset -f save_tBefore save_tAfter since_tThen readSavedFractionalSeconds

# EPOCHREALTIME is fractional Epoch seconds, "1744043648.988914" for example.  The first
# 10 chars (index 0 through 9) give the seconds, and micros is chars at index 11 and onward.
save_tBefore() { rm -f /tmp/.cmd-tstamp*-$$ ; builtin echo -n ${EPOCHREALTIME} > /tmp/.cmd-tstampThen-$$ ;}
#
export PS0='$(save_tBefore)'

save_tAfter() { builtin echo -n ${EPOCHREALTIME} > /tmp/.cmd-tstampNow-$$ ;}
#
export PROMPT_COMMAND='save_tAfter'

since_tThen() {
	local -r savedExitStatuses=${PIPESTATUS[*]}
	readSavedFractionalSeconds() {
		local -r srcFile=$1
		declare -n refOut_sec=$2 refOut_micros=$3
		local tstamp=''
		{	read tstamp < $srcFile   ;} 2>/dev/null
		rm -f $srcFile
		[ -z "$tstamp" ] && return
		# If micros starts with 0, Bash treats it as a base-8 number; if micros is say
		# 000093, then an illegal base-8 number!  So we tell Bash to treat it as a base-10.
		refOut_sec=${tstamp:0:10} refOut_micros=10#${tstamp:11}
echo "    srcFile[$srcFile] refOut_sec[$refOut_sec] refOut_micros[$refOut_micros]" >&2
	}
	local -i secThen=-3 microsThen secNow=-3 microsNow
	readSavedFractionalSeconds /tmp/.cmd-tstampThen-$$ secThen microsThen
echo "secThen[$secThen] microsThen[$microsThen]" >&2
	readSavedFractionalSeconds /tmp/.cmd-tstampNow-$$ secNow microsNow
	if [[ $secThen -gt 0 && $secNow -gt 0 ]]; then
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
		local remark
		printf -v remark "|%s|   Ela %u.%06u" "${savedExitStatuses}" ${secDelta} ${microsDelta}
echo "secDelta[$secDelta] microsDelta[$microsDelta] remark[$remark]" >&2
		printf "%${COLUMNS}s" "${remark}"
	fi # If prints nothing, most likely is because had failed to read both saved tstamps.
}
#
elaPrinter='\[\e[35;3;2m\]$(since_tThen)\[\e[0m\]\n'
#
#export PS1="${elaPrinter}${PS1}"
#unset elaPrinter


# Ideas to maybe cut overhead further:
	#	Put the echo commands directly into PS0 and PROMPT_COMMAND, to lose overhead of func lookup and call.
	#	Re-impl as dynamic lib, have Bash load that as a plugin on startup.  (A rather heavyweight approach.)
	#	Def readSavedFractionalSeconds() separately, instead of nesting it within since_tThen().
	#	Foreach func, export -fn funcName --- forego exporting to subshells.
	#	Foreach func, declare -t funcName --- do not inherit DEBUG or TRACE traps if any set.
	#	Unroll readSavedFractionalSeconds().
	#	Disable various fancypants Bash features (HISTTIMEFORMAT, PROMPT_DIRTRIM, globstar, extglob, blink-matching-paren, show-all-if-ambiguous, etc etc etc); what, did you think those were free??
