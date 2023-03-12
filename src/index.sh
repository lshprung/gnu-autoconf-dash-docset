#!/usr/bin/env sh

create_table() {
	sqlite3 "$DB_PATH" "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
	sqlite3 "$DB_PATH" "CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);"
}

get_title() {
	FILE="$1"

	pup -p -f "$FILE" 'title text{}' | \
		sed 's/(Autoconf)//g' | \
		sed 's/\"/\"\"/g'
}

get_type() {
	FILE="$1"
	PATTERN="The node you are looking for is at.*Limitations-of-.*\.html;Builtin
	The node you are looking for is at;Macro"

	echo "$PATTERN" | while read -r line; do
		#echo "$line"
		if grep -Eq "$(echo "$line" | cut -d ';' -f 1)" "$FILE"; then
			echo "$line" | cut -d ';' -f 2
			break
		fi
	done
}

insert() {
	NAME="$1"
	TYPE="$2"
	PAGE_PATH="$3"

	sqlite3 "$DB_PATH" "INSERT INTO searchIndex(name, type, path) VALUES (\"$NAME\",\"$TYPE\",\"$PAGE_PATH\");"
}

insert_index_terms() {
	# Get each term from an index page and insert
	while [ -n "$1" ]; do
		grep -Eo "<a href.*></a>" "$1" | while read -r line; do
			insert_term "$line"
		done

		shift
	done
}


insert_pages() {
	# Get title and insert into table for each html file
	while [ -n "$1" ]; do
		unset PAGE_NAME
		unset PAGE_TYPE
		PAGE_NAME="$(get_title "$1")"
		if [ -n "$PAGE_NAME" ]; then
			PAGE_TYPE="$(get_type "$1")"
			#get_type "$1"
			if [ -z "$PAGE_TYPE" ]; then
				PAGE_TYPE="Guide"
			fi
			#echo "$PAGE_TYPE"
			insert "$PAGE_NAME" "$PAGE_TYPE" "$(basename "$1")"
		fi
		shift
	done
}

insert_term() {
	LINK="$1"
	NAME="$(echo "$LINK" | pup -p 'a text{}' | sed 's/"/\"\"/g')"
	TYPE="$INDEX_TYPE"
	PAGE_PATH="$(echo "$LINK" | pup -p 'a attr{href}')"

	insert "$NAME" "$TYPE" "$PAGE_PATH"
}

TYPE="PAGES"

# Check flags
while true; do
	case "$1" in
		-i|--index)
			TYPE="INDEX"
			shift
			INDEX_TYPE="$1"
			shift
			;;
		*)
			break
	esac
done

DB_PATH="$1"
shift

create_table
case "$TYPE" in
	PAGES)
		insert_pages "$@"
		;;
	INDEX)
		insert_index_terms "$@"
		;;
esac
