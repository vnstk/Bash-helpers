# vim:ts=4:ft=sh
# Vainstein K 2025may10

# Typical `find ...... -printf '%Y %T@ %f\n'` output is
#                                                           f 1746842745.8921564720 queryTransforms.h
# ; the tenths-of-nanosecond precision is spurious.
#
# Output of `printf "%(%b%d|%T.%02S)T\n" 1746842745` is
#                                                           May09|22:05:45.45
summarize-dir () {
	local -ri secPerDay=$[24*60*60]
	prettyAgo () {
		local outp=''
		local -i n=$1
		local -ri days=$[n / secPerDay]
		local -ri hrs=$[(n % secPerDay) / 3600]
		local -ri mins=$[(n % 3600) / 60]
		if [ $n -ge $[7*secPerDay] ]; then
			printf -v outp "%d days" $days
		elif [ $n -ge $[2*secPerDay] ]; then
			printf -v outp "%d days, %d hrs" $days $hrs
		else
			printf -v outp "%02d:%02d:%02d" $hrs $mins $[n%60]
		fi
		echo "$outp ago"
	}
	if [ "$1" == '-' ]; then
		shift
		local -r bare=false
	else
		local -r bare=true
	fi
	local -r focusDir=$1
	local typeCode maybeQuotedBasename unquotedBasename ext oldCt outpFragm_earliest outpFragm_latest
	local -i mtime extLenMax=0 currCt
	local -A ext_to_count ext_to_earliestMtime ext_to_earliestName ext_to_latestMtime ext_to_latestName
	while read -d $'\0' ; do
		typeCode=${REPLY:0:1} ; mtime=${REPLY:2:10} ; maybeQuotedBasename=${REPLY:24}
		unquotedBasename=$maybeQuotedBasename
		[ "${maybeQuotedBasename:0:1}" == '"' ] && [ "${maybeQuotedBasename:-1}" == '"' ] && {
			unquotedBasename=${maybeQuotedBasename:1:-1}
		}
		ext=${unquotedBasename##*.}
		if [ "$typeCode" == 'd' ]; then
			ext='<subdir>'
		elif [ "$ext" == "$unquotedBasename" ]; then
			ext='<none>'
		else
			ext=".${ext}"
		fi
		oldCt="${ext_to_count[$ext]}"
		[ -n "$vdbg" ] &&  echo -e "\e[33m REPLY[$REPLY] typeCode[$typeCode] mtime[$mtime] maybeQuotedBasename[$maybeQuotedBasename] ext[$ext] oldCt[$oldCt] extLenMax[$extLenMax]\e[0m" >&2
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
				[ -n "$vdbg" ] &&  echo -e "\e[36m mtime[$mtime]  ext_to_earliestMtime[ext]=<${ext_to_earliestMtime[$ext]}>  ext_to_latestMtime[ext]=<${ext_to_latestMtime[$ext]}>   extLenMax[$extLenMax]\e[0m" >&2
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
	done < <(find $focusDir -mindepth 1 -maxdepth 1 -printf '%Y %T@ %f\0')
	[ ${#ext_to_count[@]} -gt 0 ] && {
		for ext in ${!ext_to_count[@]}; do
			currCt=${ext_to_count[$ext]}
			if $bare; then
				printf "%5d of %s\n" $currCt $ext
			else
				mtime=${ext_to_earliestMtime[$ext]}
				printf -v outpFragm_earliest "\e[32m%s\e[0m \e[33;3m%s\e[0m" "${ext_to_earliestName[$ext]}" "`prettyAgo $[EPOCHSECONDS-mtime]`"
				if [ 1 -eq $currCt ]; then
					printf -v outpFragm_latest "\e[32;3mN/A\e[0m"
				else
					mtime=${ext_to_latestMtime[$ext]}
					printf -v outpFragm_latest "\e[33;3m%s\e[0m \e[32m%s\e[0m " "`prettyAgo $[EPOCHSECONDS-mtime]`" "${ext_to_latestName[$ext]}"
				fi
				printf "%5d \e[2mof\e[0m \e[1m%-"${extLenMax}"s\e[0m %s <--> %s\n" $currCt $ext "$outpFragm_earliest" "$outpFragm_latest"
			fi
		done | sort -k1,1nr
	}
}
