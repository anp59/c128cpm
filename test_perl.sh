#!/bin/sh
#perl -e 'print join("\n", reverse @ARGV)' "$@" | perl -ne 's/[\r\n]//g; printf "%-128s", chr(length($_)).$_.chr(0)' > 'A/0/$$$.SUB'
perl -e 'print join("\n", reverse @ARGV)' "$@" | perl -ne 's/[\r\n]//g; printf "%-128s", chr(length($_)).uc($_).chr(0)' > 'A/0/$$$.SUB'