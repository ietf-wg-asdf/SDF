kramdown-rfc-extract-sourcecode -dcheck-sourcecode "$@" # sdf.v2v3-25.xml
sed -n 's/^[+ ]//'p check-sourcecode/jso.json/json-schemaorg-rendition-of.jso.json | diff - sdf-framework.jso.json
sed -n 's/^[- ]//'p check-sourcecode/jso.json/json-schemaorg-rendition-of.jso.json | diff - sdf-validation.jso.json
