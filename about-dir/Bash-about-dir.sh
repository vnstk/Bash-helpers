# vim:ts=4:ft=sh
# Vainstein K 2025may10

# Typical `find ...... -printf '%Y %T@ %f\n'` output is
#                                                           f 1746842745.8921564720 queryTransforms.h
#
# Output of `printf "%(%b%d|%T.%02S)T\n" 1746842745` is
#                                                           May09|22:05:45.45
about-dir () {
	local -ri secPerDay=$[24*60*60]
	local prettyAgo
	compose_prettyAgo () {
		local -ri n=$1
		local -ri days=$[n / secPerDay]
		local -ri hrs=$[(n % secPerDay) / 3600]
		local -ri mins=$[(n % 3600) / 60]
		if [ $n -ge $[7*secPerDay] ]; then
			printf -v prettyAgo "%d days" $days
		elif [ $n -ge $[2*secPerDay] ]; then
			printf -v prettyAgo "%d days, %d hrs" $days $hrs
		else
			printf -v prettyAgo "%02d:%02d:%02d" $hrs $mins $[n%60]
		fi
		prettyAgo+=' ago'
	}
	if [ $# -le 3 ] && [ $# -ge 2 ] && [[ $1 =~ [1-9][0-9]* ]]; then
		local -ri maxDepth=$1
		shift
	else
		local -ri maxDepth=1
	fi
	if [ $# -eq 2 ] && [ "$1" == '-' ]; then
		local -r bare=false
		shift
	else
		local -r bare=true
	fi
	if [ $# -ne 1 ]; then
		echo "USAGE:  [<maxDepth>,=1]  [-]  <focusDir>" >&2 && return
	fi
	local -r focusDir=$1
	local typeCode maybeQuotedBasename unquotedBasename ext oldCt outpFragm_earliest outpFragm_latest
	local -i mtime extLenMax=0 currCt
	local -A ext_to_count ext_to_earliestMtime ext_to_earliestName ext_to_latestMtime ext_to_latestName
	shopt -p extglob >/dev/null && extglob_savedPosition='-s' || extglob_savedPosition='-u'
	shopt -s extglob
	while read -d $'\0' ; do
		typeCode=${REPLY:0:1} ; mtime=${REPLY:2:10} ; maybeQuotedBasename=${REPLY:24}
		unquotedBasename=$maybeQuotedBasename
		[ "${maybeQuotedBasename:0:1}" == '"' ] && [ "${maybeQuotedBasename:-1}" == '"' ] && {
			unquotedBasename=${maybeQuotedBasename:1:-1}
		}
		ext=${unquotedBasename/?(*\/|*.)/}
		if [ "$typeCode" == 'd' ]; then
			ext='<subdir>'
		elif [ "$ext" == "$unquotedBasename" ]; then
			ext='<none>'
		else
			ext=".${ext}"
		fi
		oldCt="${ext_to_count[$ext]}"
		if [ -z "$oldCt" ]; then
			ext_to_count[$ext]='1'
			$bare || {
				ext_to_earliestMtime[$ext]=$mtime
				ext_to_earliestName[$ext]=$unquotedBasename
				ext_to_latestMtime[$ext]=$mtime
				ext_to_latestName[$ext]=$unquotedBasename
				if [ ${#ext} -gt $extLenMax ]; then extLenMax=${#ext}; fi
			}
		else
			ext_to_count[$ext]=$[oldCt+1]
			$bare || {
				if [ $mtime -lt ${ext_to_earliestMtime[$ext]} ]; then
					ext_to_earliestMtime[$ext]=$mtime
					ext_to_earliestName[$ext]=$unquotedBasename
				fi
				if [ $mtime -gt ${ext_to_latestMtime[$ext]} ]; then
					ext_to_latestMtime[$ext]=$mtime
					ext_to_latestName[$ext]=$unquotedBasename
				fi
			}
		fi
	done < <(find $focusDir -mindepth 1 -maxdepth $maxDepth -printf '%Y %T@ %P\0')
	shopt $extglob_savedPosition extglob
	[ ${#ext_to_count[@]} -gt 0 ] && {
		for ext in ${!ext_to_count[@]}; do
			currCt=${ext_to_count[$ext]}
			if $bare; then
				printf "%5d of %s\n" $currCt $ext
			else
				mtime=${ext_to_earliestMtime[$ext]}
				compose_prettyAgo $[EPOCHSECONDS-mtime]
				printf -v outpFragm_earliest "\e[32m%q\e[0m \e[33;3m%s\e[0m" "${ext_to_earliestName[$ext]}" "$prettyAgo"
				if [ 1 -eq $currCt ]; then
					outpFragm_latest=''
				else
					mtime=${ext_to_latestMtime[$ext]}
					compose_prettyAgo $[EPOCHSECONDS-mtime]
					printf -v outpFragm_latest "\e[33;3m%s\e[0m \e[32m%q\e[0m" "$prettyAgo" "${ext_to_latestName[$ext]}"
				fi
				printf "%5d \e[2mof\e[0m \e[1m%-"${extLenMax}"s\e[0m %s <==> %s\n" $currCt $ext "$outpFragm_earliest" "$outpFragm_latest"
			fi
		done | sort -k1,1nr
	}
}
