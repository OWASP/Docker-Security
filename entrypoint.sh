#!/bin/bash
VAR=""

for f in *.md; do
  [[ -f $f ]] || continue
    VAR+="'${f}' "
    cat "$f" >> './dist/combined-guide.md'
done

IFS=$'\n'
echo "Combining Files" $VAR
pandoc ./dist/combined-guide.md -o ./dist/owasp-docker-security.pdf
# cat './dist/combined-guide.md' | md-to-pdf > ./dist/owasp-docker-security.pdf 