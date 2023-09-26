render: sdf-framework.cddl sdf.jso.json-unidiff sdf.md
	kdrfc sdf.md

sourcecode: sdf.xml
	rm -rf sourcecode.ba?
	kramdown-rfc-extract-sourcecode -tfiles sdf.xml

.PHONY: all
all: render sourcecode
