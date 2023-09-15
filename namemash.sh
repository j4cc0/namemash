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
	echo "$f$s$l"	# John.DoeSmith
	echo "$f$s$lu"	# John.Doe_Smith
	echo "$f1$s$l"	# J.Doe_Smith
	echo "$f$s$l1"	# John.D
	echo "$f$s$l2"	# John.Do
	echo "$f1$s$l2"	# J.Do
	echo "$f2$s$l2"	# Jo.Do
	echo "$l$s$f"	# DoeSmith.John
	echo "$lu$s$f"	# Doe_Smith.John
	echo "$l$s$f1"	# DoeSmith.J
	echo "$l1$s$f"	# D.John
	echo "$l2$s$f"	# Do.John
	echo "$l2$s$f1"	# Do.J
	echo "$l2$s$f2"	# Do.Jo
	echo "$f"	# John
	echo "$l"	# Doe_Smith
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

