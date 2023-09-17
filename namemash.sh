#!/bin/bash
SCRIPT="$(basename $0)"

warn() {
	echo "[!] $@" >&2
	return 0
}

die() {
	warn "$@. Aborted"
	exit 1
}

produce_names() {
	if [ "$#" -lt 3 ]; then
		die "Missing parameter"
	fi
	f="$1"
	s="$2"
	w="$3"
	l="$(echo $w | sed 's/ //g')"
	lu="$(echo $w | sed 's/ /_/g')"
	l1="$(echo $w | sed 's/^\(.\).*$/\1/')"
	l2="$(echo $w | sed 's/^\(..\).*$/\1/')"
	f1="$(echo $f | sed 's/^\(.\).*$/\1/')"
	f2="$(echo $f | sed 's/^\(..\).*$/\1/')"
	# - Difficult cases
	ld=$(echo "$w " | sed 's/\(.\)[^ ]* /\1/g')	# first characters of every last name
	le=$(echo "$w" | awk '{print $NF}')		# final part of last name
	lf=$(echo $ld | sed 's/.$//')			# first chars of last names up to final part
	lg="$lf$s$le"					# first chars of last names and final part in full
	le1=$(echo $le | sed 's/^\(.\).*$/\1/')		# first chars of final part
	le2=$(echo $le | sed 's/^\(..\).*$/\1/')	# first chars of final part
	# -
	echo "$f$s$l"	# John.DoeSmith
	echo "$f$s$lu"	# John.Doe_Smith
	echo "$f$s$le"	# John.Smith
	echo "$f$s$l1"	# John.D
	echo "$f$s$l2"	# John.Do
	echo "$f$s$ld"	# John.DS
	echo "$f$s$lg"	# John.D.Smith
	echo "$f$s$le1"	# John.S
	echo "$f$s$le2"	# John.Sm
	# -
	echo "$f1$s$l"	# J.DoeSmith
	echo "$f1$s$lu"	# J.Doe_Smith
	echo "$f1$s$le"	# J.Smith
	echo "$f1$s$l1"	# J.D
	echo "$f1$s$l2"	# J.Do
	echo "$f1$s$ld"	# J.DS
	echo "$f1$s$lg"	# J.D.Smith
	echo "$f1$s$le1"	# J.S
	echo "$f1$s$le2"	# J.Sm
	# -
	echo "$f2$s$l"	# Jo.DoeSmith
	echo "$f2$s$lu"	# Jo.Doe_Smith
	echo "$f2$s$le"	# Jo.Smith
	echo "$f2$s$l1"	# Jo.D
	echo "$f2$s$l2"	# Jo.Do
	echo "$f2$s$ld"	# Jo.DS
	echo "$f2$s$lg"	# Jo.D.Smith
	echo "$f2$s$le1"	# Jo.S
	echo "$f2$s$le2"	# Jo.Sm
	# -
	echo "$l$s$f"	# DoeSmith.John
	echo "$lu$s$f"	# Doe_Smith.John
	echo "$le$s$f"	# Smith.John
	echo "$l1$s$f"	# D.John
	echo "$l2$s$f"	# Do.John
	echo "$ld$s$f"	# DS.John
	echo "$lg$s$f"	# D.Smith.John
	echo "$le1$s$f"	# S.John
	echo "$le2$s$f"	# Sm.John
	# -
	echo "$l$s$f1"	# DoeSmith.J
	echo "$lu$s$f1"	# Doe_Smith.J
	echo "$le$s$f1"	# Smith.J
	echo "$l1$s$f1"	# D.J
	echo "$l2$s$f1"	# Do.J
	echo "$ld$s$f1"	# DS.J
	echo "$lg$s$f1"	# D.Smith.J
	echo "$le1$s$f1"	# S.J
	echo "$le2$s$f1"	# Sm.J
	# -
	echo "$l$s$f2"	# DoeSmith.Jo
	echo "$lu$s$f2"	# Doe_Smith.Jo
	echo "$le$s$f2"	# Smith.Jo
	echo "$l1$s$f2"	# D.Jo
	echo "$l2$s$f2"	# Do.Jo
	echo "$ld$s$f2"	# DS.Jo
	echo "$lg$s$f2"	# D.Smith.Jo
	echo "$le1$s$f2"	# S.Jo
	echo "$le2$s$f2"	# Sm.Jo
	# -
	echo "$f"	# John
	echo "$l"	# Doe_Smith
	echo "$lg"	# D.Smith
	# -
	return 0
}

transform_name() {
	if [ "$#" -lt 3 ]; then
		die "Missing parameter"
	fi
	for transform in "cat" "tr '[a-z]' '[A-Z]'" "tr '[A-Z]' '[a-z]'"
	do
		#echo "--> transform $transform"
		produce_names "$1" "$2" "$3" | eval $transform
	done
	return 0
}

process_name() {
	if [ "$#" -lt 2 ]; then
		die "Missing parameter"
	fi
	for sep in "" "." "_"
	do
		transform_name "$1" "$sep" "$2"
	done
	return 0
}

parse_names() {
	if [ "x${1}x" != "x-x" -a ! -r "$1" ]; then
		die "$1 is not readable"
	fi
	cat "$1" | sed 's/#.*$//' | grep " " | while read first whatever
	do
		process_name "$first" "$whatever"
	done
	return 0
}

main() {
	if [ "x${@}x" = "xx" ]; then
		die "Nothing to do. Need at least one file. Use '-' for stdin processing"
	fi
	for i in $@
	do
		parse_names "$i"
	done
	return 0
}

main $@ | sort -u

