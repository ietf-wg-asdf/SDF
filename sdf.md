---
coding: utf-8

title: >
  SDF: A Simple Definition Format for One Data Model definitions
abbrev: OneDM SDF
docname: draft-bormann-t2trg-sdf-latest
date: 2020-05-11
category: info

ipr: trust200902
area: Applications
workgroup: T2TRG
keyword: Internet-Draft

stand_alone: yes
pi: [toc, sortrefs, symrefs, comments]

author:
  - name: Michael Koster
    org: SmartThings
    street: 665 Clyde Avenue
    city: Mountain View
    code: '94043'
    country: USA
    phone: "+1-707-502-5136"
    email: Michael.Koster@smartthings.com
    role: editor
  - name: Carsten Bormann
    org: Universität Bremen TZI
    orgascii: Universitaet Bremen TZI
    street: Postfach 330440
    city: Bremen
    code: D-28359
    country: Germany
    phone: +49-421-218-63921
    email: cabo@tzi.org
    role: editor
contributor:
  - name: Ari Keränen
    org: Ericsson
    street: ''
    city: Jorvas
    code: '02420'
    country: Finland
    email: ari.keranen@ericsson.com
  - name: Wouter van der Beek

normative:
  IANA.senml: units
# [SenML unit]: https://www.iana.org/assignments/senml/senml.xhtml#senml-units
  I-D.handrews-json-schema-validation: jso
# -02#section-7.3
  RFC3986: uri
  RFC6901: pointer
  RFC8610: cddl
  W3C.NOTE-curie-20101216: curie
  RFC0020: ascii
informative:

entity:
        SELF: "[RFC-XXXX]"

--- abstract


The Simple Definition Format is a format for domain experts to use in the creation and maintenance of OneDM definitions.

OneDM tools convert this format to database formats and other serializations as needed.

This document describes definitions of OneDM Objects and their associated Events, Actions, Properties, and Data types.

The JSON format of an SDF definition is described in this document.

--- middle


# Introduction

The Simple Definition Format is a format for domain experts to use in the creation and maintenance of OneDM definitions.

OneDM tools convert this format to database formats and other serializations as needed.

This document describes definitions of OneDM Objects and their associated Events, Actions, Properties, and Data types.

The JSON format of an SDF definition is described in this document.

# Terminology and Conventions

<!-- Note: Should we use RFC 2119? -->

Quality:
: a metadata item in a definition or declaration which says something about that definition or declaration. A quality is represented in SDF as a member in a JSON object that serves as a definition or declaration

Definition:
: Creates a new semantic term for use in SDF models and associates it with a set of qualities

Declaration:
: A reference to and a use of a definition within an enclosing definition, intended to create component instances within that enclosing definition.


Conventions:

- The singular form is preferred for keywords.


{::boilerplate bcp14}

# Example Definition:

~~~ json
{
  "info": {
    "title": "Example file for ODM Simple JSON Definition Format",
    "version": "20190424",
    "copyright": "Copyright 2019 Example Corp. All rights reserved.",
    "license": "https://example.com/license"
  },
  "namespace": {
    "st": "https://example.com/capability/odm"
  },
  "defaultNamespace": "st",
  "odmObject": {
    "Switch": {
      "odmProperty": {
        "value": {
          "type": "string",
          "enum": [
            "on",
            "off"
          ]
        }
      },
      "odmAction": {
        "on": {},
        "off": {}
      }
    }
  }
}
~~~
{: #example1 title="A simple example of an SDF definition file"}

# SDF structure

SDF definitions are contained in SDF files.  One or more SDF files can
work together to provide the definitions and declarations that are the
payload of the SDF format.

A SDF definition file contains a single JSON map (JSON object).
This object has three sections: the information block, the namespaces section and the definitions section.

## Information block

The information block contains generic meta data for the file itself and all included definitions.

The keyword (map key) that defines an information block is "info". Its
value is a JSON map in turn, with a set of key-value pairs that represent qualities that apply to the included definition.

Qualities of the information block are shown in {{infoblockqual}}.

| Quality   | Type   | Required | Description                                                 |
|-----------|--------|----------|-------------------------------------------------------------|
| title     | string | yes      | A short summary to be displayed in search results, etc.     |
| version   | string | yes      | The incremental version of the definition, format TBD       |
| copyright | string | yes      | Link to text or embedded text containing a copyright notice |
| license   | string | yes      | Link to text or embedded text containing license terms      |
{: #infoblockqual title="Qualities of the Information Block"}

## Namespaces section

The namespaces section contains the namespace map and the defaultnamespace setting.

The namespace map is a map from short names for URIs to the namespace URIs
themselves.

The defaultnamespace setting selects one of the short names in the
namespace map; the associated URI of which becomes the default
namespace for the SDF definition file.

| Quality          | Type   | Required | Description                                                                                          |
|------------------|--------|----------|------------------------------------------------------------------------------------------------------|
| namespace        | map    | no       | Defines short names mapped to namespace URIs, to be used as identifier prefixes                      |
| defaultnamespace | string | no       | Identifies one of the prefixes in the namespace map to be used as a default in resolving identifiers |
{: #nssec title="Namespaces Section"}

The following example declares a set of namespaces and defines `st` as the default namespace.

~~~ json
"namespace": {
  "st": "https://example.com/capability/odm",
  "zcl": "https://example.com/zcl/odm"
},
"defaultnamespace": "st",
~~~

If no defaultnamespace setting is given, the SDF definition file does not
contribute to a global namespace.  As the defaultnamespace gives a
namespace short name, its presence requires a namespace map that contains a
mapping for that namespace short name.

If no namespace map is given, no short names for namespace URIs are
set up, and no defaultnamespace can be given.


## Definitions section

The Definitions section contains one or more type definitions according to the class name keywords for type definitions (object, property, action, event, data).

Each class may have zero or more type definitions associated with it. Each defined identifier creates a new type and term in the target namespace, and has a scope of the current definition block.

A definition consists of a map entry using the newly defined term as a JSON key, with a value consisting of a map of Qualities and their values.

A definition may in turn contain other definitions. Each definition consists of the newly defined identifier and a set of key-value pairs that represent the defined qualities and contained type definitions.

An example for an Object definition is given in {{exobject}}:

~~~ json
"odmObject": {
  "foo": {
    "odmProperty": {
      "bar": {
        "type": "boolean"
      }
    }
  }
}
~~~
{: #exobject title="Example Object definition"}

This example defines an Object "foo" that is defined in the default namespace, containing a property
`odm:/odmObject/foo/odmProperty/bar`, with data of type boolean.
<!-- we could define a URN-style namespace that looks exactly that way -->

# Names and namespaces

SDF definition files may contribute to a global namespace, and may
reference elements from that global namespace.
(An SDF definition file that does not set a defaultnamespace does not
contribute to the global namespace.)

## Structure

Global names look exactly like https:// URIs with attached fragment identifiers.

There is no intention to require that these URIs can be dereferenced.
<!-- Looking things up there is a convenience -->
(However, as future versions of SDF might find a use for dereferencing
global names, the URI should be chosen in such a way that this may
become possible in the future.)

The absolute URI of a global name should be a URI as per Section 3 of
{{-uri}}, with a scheme of "https" and a path (`hier-part` in {{-uri}}).
For the present version of this specification, the query part should
not be used (it might be used in later versions).

The fragment identifier is constructed as per Section 6 of
{{-pointer}}.

## Contributing global names

The fragment identifier part of a global name defined in an SDF
definition file is constructed from a JSON pointer that selects the
element defined for this name in the SDF definition file.

The absolute URI part is a copy of the default namespace, i.e., the
default namespace is always the target namespace for a name for which
a definition is contributed.
When emphasizing that name definitions are contributed to the default namespace,
we therefore also call it the "target namespace".

E.g., in {{example1}}, definitions for the following global names are contributed:

* https://example.com/capability/odm#/odmObject/Switch
* https://example.com/capability/odm#/odmObject/Switch/odmProperty/value
* https://example.com/capability/odm#/odmObject/Switch/odmAction/on
* https://example.com/capability/odm#/odmObject/Switch/odmAction/off

Note the "#", which separates the base part from the fragment
identifier part.

## Referencing global names

A name reference takes the form of the production `curie` in
{{-curie}} (note that this excludes the production `safe-curie`),
limiting the IRIs involved in that production to URIs as per {{-uri}}
and the prefixes to ASCII characters {{-ascii}}.

A name that is contributed by the current SDF definition file can be
referenced by a Same-Document Reference as per section 4.4 of
{{-uri}}.
As there is little point in referencing the entire SDF definition
file, this will be a "#" followed by a JSON pointer.
This is the only kind of name reference that is possible in an SDF
definition file that does not set a default namespace.

Name references that point outside the current SDF definition file
need to contain curie prefixes.  These then reference namespace
declarations in the namespaces section.

For example, if a namespace prefix is defined:

~~~ json
"namespace": {
  "foo": "https://example.com/#"
}
~~~

Then this reference to that namespace:

~~~ json
{ "odmRef": "foo:odmData/temperatureData" }
~~~

references the global name:

~~~ json
"https://example.com/#odmData/temperatureData"
~~~

Note that there is no way to provide a URI scheme name in a curie, so
all references outside of the document need to go through the
namespace map.

Name references occur only in specific elements of the syntax of SDF:

* copying elements via odmRef values
* pointing to elements via odmRequired value elements or as
  odmOutputData and similar


## odmRef

The keyword "odmRef" is used in a JSON map establishing a definition
to copy all of the qualities of the referenced definition, indicated
by the included name reference, into the newly formed definition.
(This can be compared to the processing of the "$ref" keyword in JSON Schema.)

For example, this reference:

~~~ json
"temperatureProperty": {
  "odmRef": "#/odmData/temperatureData"
}
~~~

creates a new definition "temperatureProperty" that contains all of the qualities defined in the definition at /odmData/temperatureData.

## odmRequired

The value of "odmRequired" is an array of name references, each
pointing to one declaration instantiation of which is declared mandatory.

# Optionality using the keyword "odmRequired"

The keyword "odmRequired" is provided to apply a constraint for which definitions are mandatory in an instance conforming to a particular definition in which the constraint appears.

The value of "odmRequired" is an array JSON pointers, each indicating one mandatory definition.

The example in the figure below shows two required elements in the odmObject definition for "temperatureWithAlarm", the odmProperty "temperatureData", and the odmEvent "overTemperatureEvent". The example also shows the use of JSON pointer with "odmRef" to use a pre-existing definition in this definition, for the "alarmType" data (odmOutputData) produced by the odmEvent "overTemperatureEvent".

~~~ json
{
  "odmObject": {
    "temperatureWithAlarm": {
      "odmRequired": [
        "#/odmObject/temperatureWithAlarm/odmData/temperatureData",
        "#/odmObject/temperatureWithAlarm/odmEvent/overTemperatureEvent"
      ],
      "odmData":{
        "temperatureData": {
          "type": "number"
        }
      },
      "odmEvent": {
        "overTemperatureEvent": {
          "odmOutputData": {
            "alarmType": {
              "odmRef": "odm:/#odmData/alarmTypes/quantityAlarms",
              "const": "OverTemperatureAlarm"
            },
            "temperature": {
              "odmRef": "#/odmObject/temperatureWithAlarm/odmData/temperatureData"
            }
          }
        }
      }
    }
  }
}
~~~

# Keywords for type definitions

The following SDF keywords are used to create type definitions in the target namespace.

## odmObject

The odmObject keyword denotes zero or more Object definitions. An odmObject may contain or include definitions of events, actions, properties, and data types.

The qualities of odmObject are shown in {{odmobjqual}}.

| Quality | Type | Required | Description | Default |
|---|---|---|---|---|
|name|string|no|human readable name| N/A |
|description|string|no|human readable description| N/A |
|title|string|no|human readable title to display| N/A |
|$comment|string|no|explanatory comments | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid definition | N/A |
{: #odmobjqual title="Qualities of odmObject"}

odmObject may define or include the following ODM types:

- odmProperty
- odmAction
- odmEvent
- odmData


## odmProperty

The odmProperty keyword denotes zero or more property definitions.

Properties are used to model elements of state.

The qualities of odmProperty are shown in {{odmpropqual}}.

| Quality | Type | Required | Description | Default |
|---|---|---|---|---|
|name|string|no|human readable name| N/A |
|description|string|no|human readable description| N/A |
|title|string|no|human readable title to display| N/A |
|$comment|string|no|explanatory comments | N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid definition | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition| N/A |
|readable|boolean|no|Reads are allowed| true |
|writable|boolean|no|Writes are allowed| true |
|observable|boolean|no| flag to indicate asynchronous notification is available| true |
|contentFormat|string|no|IANA media type string| N/A |
|subtype|string|no|subtype enumeration|N/A|
|widthInBits|integer|no|hint for protocol binding| N/A|
|units|string|no|SenML unit name as per {{-units}}, subregistry SenML Units  | N/A |
|nullable|boolean|no|indicates a null value is available for this type| true |
|scaleMinimum|number|no|lower limit of value in units| N/A |
|scaleMaximum|number| no|upper limit of value in units| N/A |
|type|string, enum|no|JSON data type| N/A |
|minimum|number|no|lower limit of value in the representation format| N/A |
|maximum|number|no|upper limit of value in the representation format| N/A |
|multipleOf|number|no|indicates the resolution of the number in representation format| N/A |
|enum|array|no|enumeration constraint| N/A |
|pattern|string|no|regular expression to constrain a string pattern| N/A |
|format|string|no|JSON Schema formats as per {{-jso}}, Section 7.3     | N/A|
|minLength|integer|no|shortest length string in octets| N/A |
|maxLength|integer|no|longest length string in octets| N/A |
|default|number, boolean, string|no|specifies the default value for initialization| N/A |
|const|number, boolean, string|no|specifies a constant value for a data item or property| N/A |
{: #odmpropqual title="Qualities of odmProperty"}

odmProperty may define or include the following ODM types:

- odmData

## odmAction

The odmAction keyword denotes zero or more Action definitions.

Actions are used to model commands and methods which are invoked. Actions have parameter data that are supplied upon invocation.

The qualities of odmAction are shown in {{odmactqual}}.

| Quality | Type | Required | Description |
|---|---|---|---|
|name|string|no|human readable name|
|description|string|no|human readable description|
|title|string|no|human readable title to display|
|$comment|string|no|explanatory comments | N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid action definition | N/A |
|odmInputData|array|no|Array of JSON Pointers to mandatory items in a valid action definition | N/A |
|odmRequiredInputData|array|no|Array of JSON Pointers to mandatory items in a valid action definition | N/A |
|odmOutputData|array|no|Array of JSON Pointers to mandatory items in a valid action definition | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|
{: #odmactqual title="Qualities of odmAction"}

odmAction may define or include the following ODM types:

- odmData


## odmEvent

The odmEvent keyword denotes zero or more Event definitions.

Events are used to model asynchronous occurrences that may be communicated proactively. Events have data elements which are communicated upon the occurrence of the event.

The qualities of odmEvent are shown in {{odmevqual}}.

| Quality | Type | Required | Description |
|---|---|---|---|
|name|string|no|human readable name|
|description|string|no|human readable description|
|title|string|no|human readable title to display|
|$comment|string|no|explanatory comments | N/A |
|odmOutputData|array|no|Array of JSON Pointers to output items in a valid definition | N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid definition | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|
{: #odmevqual title="Qualities of odmEvent"}

odmEvent may define or include the following ODM types:

- odmData


## odmData

The odmData keyword denotes zero or more Data type definitions.

An odmData definition provides a semantic identifier for a data item and describes the constraints on the defined data item.

odmData is used for Action parameters, for Event data, and for reusable constraints in property definitions

{{odmdataqual}} lists the qualities of odmData.

| Quality | Type | Required | Description |
|---|---|---|---|
|name|string|no|human readable name|
|description|string|no|human readable description|
|title|string|no|human readable title to display|
|$comment|string|no|explanatory comments | N/A |
|required|array|no|list of references to mandatory items in a valid definition | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|
|type|object|no|reference to a definition to be used as a template for a new definition|
|subtype|string|no|subtype enumeration|N/A|
|widthInBits|integer|no|hint for protocol binding| N/A|
|units|string|no|SenML unit name as per {{-units}}, subregistry SenML Units  | N/A |
|nullable|boolean|no|indicates a null value is available for this type|
|scaleMinimum|number|no|lower limit of value in units|
|scaleMaximum|number|no|upper limit of value in units|
|type|string, enum|yes|JSON data type|
|minimum|number|no|lower limit of value in the representation format|
|maximum|number|no|upper limit of value in the representation format|
|multipleOf|number|no|indicates the resolution of the number in representation format|
|enum|array of any type|no|enumeration constraint|
|pattern|string|no|regular expression to constrain a string pattern|
|format|string|no|JSON Schema formats as per {{-jso}}, Section 7.3     | N/A|
|minLength|integer|no|shortest length string in octets|
|maxLength|integer|no|longest length string in octets|
|default|number, boolean, string|no|specifies the default value for initialization|
|const|number, boolean, string|no|specifies a constant value for a data item or property|
{: #odmdataqual title="Qualities of odmData"}

odmData may define or contain the following ODM types:

- JSON Schema Types with numeric constraint extensions


# Example Simple Object Definition:

~~~json
{
  "info": {
    "title": "Example file for ODM Simple JSON Definition Format",
    "version": "20190424",
    "copyright": "Copyright 2019 Example Corp. All rights reserved.",
    "license": "https://example.com/license"
  },
  "namespace": {
    "st": "https://example.com/capability/odm"
  },
  "defaultNamespace": "st",
  "odmObject": {
    "Switch": {
      "odmProperty": {
        "value": {
          "type": "string",
          "enum": [
            "on",
            "off"
          ]
        }
      },
      "odmAction": {
        "on": {},
        "off": {}
      }
    }
  }
}
~~~


# High Level Composition

The requirements for high level composition include the following:

- The ability to represent products, standardized product types, and modular products while maintaining the atomicity of Objects.

- The ability to compose a reusable definition block from objects, for example a single plug unit of an outlet strip with on/off control, energy monitor, and optional dimmer objects, while retaining the atomicity of the individual objects.

- The ability to compose objects and other definition blocks into a higher level thing that represents a product, while retaining the atomicity of objects.

- The ability to enrich and refine a base definition to have product-specific qualities and quality values, e.g. unit, range, and scale settings.

- The ability to reference items in one part of a complex definition from another part of the same definition, for example to summarize the energy readings from all plugs in an outlet strip.

## Paths in the model namespaces

The model namespace is organized according to terms that are defined in the definition files that are present in the namespace. For example, definitions that originate from an organization or vendor are expected to be in a namespace that is specific to that organization or vendor. There is expecred to be an ODM namespace for common ODM definitions.

The structure of a path in a namespace is defined by the JSON Pointers to the definitions in the files in that namespace. For example, if there is a file defining an object "Switch" with an action "on", then the reference to the action would be "ns:/odmObject/Switch/odmAction/on" where ns is the short name for the namespace prefix.

## Modular Composition
Modular composition of definitions enables an existing definition (could be in the same file or another file) to become part of a new definition by including a reference to the existing definition within the model namespace. 

### Use of the "odmRef" keyword to re-use a definition
An existing definition may be used as a template for a new definition, that is, a new definition is created in the target namespace which uses the defined qualities of some existing definition. This pattern will use the keyword "odmRef" as a quality of a new definition with a value consisting of a reference to the existing definition that is to be used as a template. Optionally, new qualities may be added and values of optional qualities and quality values may be defined.

ISSUE: Can qualities from the source definition be overridden?
The above only says "added".
Yes, we do want to enable overriding, but need to warn specifiers not
to use this in a way that changes the semantics.

~~~
 
"odmData": 
  "length" : {
    "type": "number",
    "minimum": 0,
    "units": "m"
    "description": "There can be no negative lenghts"
  }
...
  "cable-length" : {
    "odmRef": "#/odmData/length"
    "minimum": 0,05
    "description": "cables must be at least 5 cm"
  }
~~~

## odmThing

An odmThing is a set of declarations and qualities that may be part of a more complex model. For example, the object declarations that make up the definition of a single socket of an outlet strip could be encapsulated in an odmThing, and the socket-thing itself could be used in a declaration in the odmThing definition for the outlet strip.

odmThing definitions carry semantic meaning, such as a defined refrigerator compartment and a defined freezer compartment, making up a combination referigerator-freezer product.

An odmThing may be composed of odmObjects and other odmThings. 

The qualities of odmThing are shown in {{odmthingqual}}.

| Quality | Type | Required | Description |
|---|---|---|---|
|name|string|no|human readable name|
|description|string|no|human readable description|
|title|string|no|human readable title to display|
|$comment|string|no|explanatory comments | N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid definition | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|
{: #odmthingqual title="Qualities of odmThing"}

odmThing may define or include the following ODM types:

- odmThing
- odmObject

## odmProduct

An odmProduct provides the level of abstraction for representing a unique product or a profile for a standardized type of product, for example a "device type" definition with required minimum functionality.

Products may be composed of Objects and Things at the high level, and may include their own definitions of Properties, Actions, and Events that can be used to extend or complete the included Object definitions.

Product definitions may set optional defaults and constant values for specific use cases, for example units, range, and scale settings for properties, or available parameters for Actions.

The qualities of odmProduct are shown in {{odmprodqual}}.

| Quality | Type | Required | Description |
|---|---|---|---|
|name|string|no|human readable name|
|description|string|no|human readable description|
|title|string|no|human readable title to display|
|$comment|string|no|explanatory comments | N/A |
|odmRequired|array|no|Array of JSON Pointers to mandatory items in a valid definition  | N/A |
|odmRef|object|no|reference to a definition to be used as a template for a new definition|
{: #odmprodqual title="Qualities of odmProduct"}

odmProduct may define or include the following ODM types:

- odmThing
- odmObject

--- back

# Formal Syntax of SDF

This appendix describes the syntax of SDF using CDDL {{-cddl}}.
Note that this appendix was derived from Ari Keranen's "alt-schema",
so it only contains the syntax that is currently in use at the One
Data Model `playground` repository.

TODO: Align with full framework syntax, as required.

~~~ cddl
{::include sdfalt.cddl}
~~~

# Acknowledgements
{: numbered="no"}

This strawman draft is based on `sdf.md` in the one-data-model
`language` repository, as well as Ari Keranen's "alt-schema" from the
Ericsson Research `ipso-odm` repository.

<!--  LocalWords:  SDF
 -->
