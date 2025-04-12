# Vainstein K 2025apr10
#
#
# Do not try to execute this file; source it.


# Trims leading spaces as result from e.g. "uniq -c".  Use as
	#
	#	find * -xdev \( \( -type d \( $findDirPruneNamesCond -o -name libs -o -name _deps \) -prune \) -o -type f \) -regex '.*\.hpp' -printf '%h\n' | sort | uniq -c | cram-columns 3
	#
cram-columns () {
	local -ri want_nColumns=$1 consoleWidth=$COLUMNS minSeparatorWidth=2
	local -a inputLines
	readarray -t inputLines
	local -r regexLeadingSpaces='^[ ]*'
	local -i i nLeadingSpaces least_nLeadingSpaces=999
	for (( i=0 ; i<${#inputLines[@]} ; ++i )) ; do
		[[ "${inputLines[i]}" =~ $regexLeadingSpaces ]]
		nLeadingSpaces=${#BASH_REMATCH[0]}
		[ $nLeadingSpaces -lt $least_nLeadingSpaces ] && least_nLeadingSpaces=$nLeadingSpaces
	done
	local -ri columnWidth=$[(consoleWidth - minSeparatorWidth * want_nColumns) / want_nColumns]
	local line
	{	for (( i=0 ; i<${#inputLines[@]} ; ++i )) ; do
			line="${inputLines[i]}"
			echo "${line:least_nLeadingSpaces}"
		done
	} | cut -c -${columnWidth} | pr -${want_nColumns} -t -w $consoleWidth | expand
	# Must pass -w explicitly to pr(1), since it thinks its output is not going to the terminal.
}
