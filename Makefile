render: sdf.md
	kdrfc sdf.md

sourcecode: sdf.xml
	rm -rf sourcecode.ba?
	kramdown-rfc-extract-sourcecode -tfiles sdf.xml
	rm -rf sourcecode/ascii_art sourcecode/cddl sourcecode/jso_json sourcecode/svg sourcecode/json/unnamed_*

.PHONY: all
all: render sourcecode
