---
coding: utf-8

title: >
  Semantic Definition Format (SDF) for Data and Interactions of Things
abbrev: OneDM SDF
docname: draft-ietf-asdf-sdf-latest
category: std
consensus: true

ipr: trust200902
area: Applications
workgroup: ASDF
keyword: Internet-Draft

stand_alone: yes
pi: [toc, sortrefs, symrefs, comments]

author:
  - name: Michael Koster
    org: Dogtiger Labs
    street: 524 H Street
    city: Antioch, CA
    code: '94509'
    country: USA
    phone: "+1-707-502-5136"
    email: michaeljohnkoster@gmail.com
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
    org: Cascoda Ltd.
    street:
    - Threefield House
    - Threefield Lane
    city: Southampton
    country: United Kingdom
    email: w.vanderbeek@cascoda.com
 
normative:
  IANA.senml: units
# [SenML unit]: https://www.iana.org/assignments/senml/senml.xhtml#senml-units
  I-D.handrews-json-schema-validation: jso
# -02#section-7.3
  RFC3986: uri
  RFC6901: pointer
  RFC7396: merge-patch
  RFC8610: cddl
  RFC8949: cbor
  W3C.NOTE-curie-20101216: curie
  RFC0020: ascii
  SPDX:
    title: SPDX License List
    target: https://spdx.org/licenses/
    date: false
  I-D.ietf-cbor-cddl-control: control
informative:
  I-D.irtf-t2trg-rest-iot: rest-iot
  ZCL: DOI.10.1016/B978-0-7506-8597-9.00006-9
  OMA:
    title: OMA LightweightM2M (LwM2M) Object and Resource Registry
    date: false
    target: http://www.openmobilealliance.org/wp/omna/lwm2m/lwm2mregistry.html
  OCF:
    title: OCF Resource Type Specification
    date: false
# VERSION 2.1.2 | April 2020
    target: https://openconnectivity.org/specs/OCF_Resource_Type_Specification.pdf
  RFC8576: seccons

entity:
        SELF: "[RFC-XXXX]"

--- abstract


The Semantic Definition Format (SDF) is a format for domain experts to
use in the creation and maintenance of data and interaction models in
the Internet of Things.  It was created as a common language for use
in the development of the One Data Model liaison organization (OneDM)
definitions.  Tools convert this format to database formats and other
serializations as needed.

An SDF specification describes definitions of SDF Objects and their
associated interactions (Events, Actions, Properties), as well as the
Data types for the information exchanged in those interactions.

A JSON format representation of SDF 1.0 was defined in
version (-00) of this document; version (-05) was
designated as an *implementation draft*, labeled SDF 1.1, at the
IETF110 meeting of the ASDF WG (2021-03-11).
The present version (-06) is intended for discussion at the ASDF
interim meeting on 2021-06-02.

--- note_Contributing

Recent versions of this document are available at its GitHub
repository <https://github.com/ietf-wg-asdf/SDF> — this also provides
an issue tracker as well as a way to supply "pull requests".

General discussion of this SDF Internet-Draft happens on the mailing
list of the IETF ASDF Working Group, asdf@ietf.org (subscribe at
<https://www.ietf.org/mailman/listinfo/asdf>).

The IETF Note Well applies (<https://www.ietf.org/about/note-well/>).

--- middle


# Introduction


The Semantic Definition Format (SDF) is a format for domain experts to
use in the creation and maintenance of data and interaction models in
the Internet of Things.  It was created as a common language for use
in the development of the One Data Model liaison organization (OneDM)
definitions.  Tools convert this format to database formats and other
serializations as needed.

An SDF specification describes definitions of SDF Objects and their
associated interactions (Events, Actions, Properties), as well as the
Data types for the information exchanged in those interactions.

A JSON format representation of SDF 1.0 was defined in a previous
(-00) version of this document.  The present document has been
designated as an *implementation draft*, labeled SDF 1.1, at the
IETF110 meeting of the ASDF WG (2021-03-11).


## Terminology and Conventions

<!-- Note: Should we use RFC 2119? -->

Thing:
: A physical item that is also made available in the Internet of
  Things.  The term is used here for Things that are notable for their
  interaction with the physical world beyond interaction with humans;
  a temperature sensor or a light might be a Thing, but a router that
  employs both temperature sensors and indicator lights might exhibit
  less Thingness, as the effects of its functioning are mostly on the
  digital side.

Affordance:
: An element of an interface offered for interaction, defining its
  possible uses or making clear how it can or should be used.  The
  term is used here for the digital interfaces of a Thing only; it
  might also have physical affordances such as buttons, dials, and
  displays.

Quality:
: A metadata item in a definition or declaration which says something
  about that definition or declaration.  A quality is represented in
  SDF as an entry in a JSON map (object) that serves as a definition
  or declaration.

Entry:
: A key-value pair in a map. (In JSON maps, sometimes also called "member".)

Block:
: One or more entries in a JSON map that is part of an SDF
  specification; these entries together serve a specific function.

Group:
: An entry in the main SDF map and in certain nested definitions that
  has a Class Name Keyword as its key and a map of definition
  entries (Definition Group) as a value.

Class Name Keyword:
: One of sdfThing, sdfProduct, sdfObject, sdfProperty, sdfAction,
  sdfEvent, or sdfData; the Classes for these type keywords are
  capitalized and prefixed with `sdf`.

Class:
: Abstract term for the information that is contained in groups
  identified by a Class Name Keyword.

Property:
: An affordance that can potentially be used to read, write, and/or
  observe state on an Object.  (Note that Entries are often called
  properties in other environments; in this document, the term
  Property is specifically reserved for affordances, even if the map
  key "properties" might be imported from a data definition language
  with the other semantics.)

Action:
: An affordance that can potentially be used to perform a named operation on an Object.

Event:
: An affordance that can potentially be used to obtain information about what happened to an Object.

Object:
: A grouping of Property, Action, and Event definitions; the main
  "atom" of reusable semantics for model construction.  (Note that
  JSON maps are often called JSON objects due to JSON's JavaScript
  heritage; in this document, the
  term Object is specifically reserved for the above grouping, even if
  the type name "object" might be imported from a data definition
  language with the other semantics.)

Element:
: A part or an aspect of something abstract; used here in its usual English definition.
  (Occasionally, also used specifically for the elements of JSON arrays.)

Definition:
: An entry in a Definition Group; the entry creates a new semantic
  term for use in SDF models and associates it with a set of
  qualities.

Declaration:
: A reference to and a use of a definition within an enclosing
  definition, intended to create component instances within that
  enclosing definition.  Every declaration can also be used as a
  definition for reference in a different place.

Protocol Binding:
: A companion document to an SDF specification that defines how to map
  the abstract concepts in the specification into the protocols in use
  in a specific ecosystem.  Might supply URL components, numeric IDs,
  and similar details.

<!-- XXX -->

Conventions:

- The singular form is chosen as the preferred one for the keywords defined here.

{::boilerplate bcp14}

# Overview

## Example Definition

We start with an example for the SDF definition of a simple Object called "Switch" ({{example1}}).

~~~ json
{
    "info": {
        "title": "Example file for OneDM Semantic Definition Format",
        "version": "2019-04-24",
        "copyright": "Copyright 2019 Example Corp. All rights reserved.",
        "license": "https://example.com/license"
    },
    "namespace": {
        "cap": "https://example.com/capability/cap"
    },
    "defaultNamespace": "cap",
    "sdfObject": {
        "Switch": {
            "sdfProperty": {
                "value": {
                    "description": "The state of the switch; false for off and true for on."
                    "type": "boolean"
                }
            },
            "sdfAction": {
                "on": {
                    "description": "Turn the switch on; equivalent to setting value to true."
                },
                "off": {
                    "description": "Turn the switch off; equivalent to setting value to false."
                },
                "toggle": {
                    "description": "Toggle the switch; equivalent to setting value to its complement."
                }
            }
        }
    }
}
~~~
{: #example1 title="A simple example of an SDF definition file"}

This is a model of a switch.
The state `value` declared in the `sdfProperty` group, represented by a Boolean, will be true for "on" and will be false for "off".
The actions `on` or `off` declared in the `sdfAction` group are redundant with setting the `value` and are in the example to illustrate that there are often different ways of achieving the same effect.
The action `toggle` will invert the value of the sdfProperty value, so that 2-way switches can be created; having such action will avoid the need for first retrieving the current value and then applying/setting the inverted value.

The `sdfObject` group lists the affordances of instances of this object.
The `sdfProperty` group lists the property affordances described by the model; these represent various perspectives on the state of the object.
Properties can have additional qualities to describe the state more precisely.
Properties can be annotated to be read, write or read/write; how this is actually done by the underlying transfer protocols is not described in the SDF model but left to companion protocol bindings.
Properties are often used with RESTful paradigms {{-rest-iot}}, describing state.
The `sdfAction` group is the mechanism to describe other interactions in terms of their names, input, and output data (no data are used in the example), as in a POST method in REST or in a remote procedure call.
The example `toggle` is an Action that
changes the state based on the current state of the Property named `value`.
(The third type of affordance is Events, which are not described in this example.)

## Elements of an SDF model

The SDF language uses seven predefined Class Name Keywords for modeling connected
Things, six of which are illustrated in {{fig-class-2}} (the seventh
class `sdfProduct` is similar enough to `sdfThing` that it would look
the same in the figure).

~~~ plantuml-utxt
sdfThing --> "0+" sdfObject : hasObject
sdfThing --> "0+" sdfThing : hasThing

sdfObject --> "0+" sdfProperty : hasProperty
sdfObject --> "0+" sdfAction : hasAction
sdfObject --> "0+" sdfEvent : hasEvent

sdfAction --> "1+" sdfData : hasInputData
sdfAction --> "0+" sdfData : hasOutputData

sdfEvent --> "1+" sdfData : hasOutputData

sdfProperty --> "1" sdfData : isInstanceOf

class sdfThing {
}

class sdfObject {
}

class sdfProperty {
}

class sdfAction {
}

class sdfEvent {
}

class sdfData {
}
~~~
{: #fig-class-2 title="Main classes used in SDF models"}

The seven main Class Name Keywords are discussed below.

### sdfObject

Objects, the items listed in an `sdfObject` group, are the main "atom" of reusable semantics for model construction.
It aligns in scope with common definition items from many IoT modeling
systems, for example ZigBee Clusters {{ZCL}}, OMA SpecWorks LwM2M
Objects {{OMA}}, and
OCF Resource Types {{OCF}}.

An `sdfObject` contains a set of `sdfProperty`, `sdfAction`, and
`sdfEvent` definitions that describe the interaction affordances
associated with some scope of functionality.

For the granularity of definition, `sdfObject` definitions are meant
to be kept narrow enough in scope to enable broad reuse and
interoperability.
For example, defining a light bulb using separate `sdfObject`
definitions for on/off control, dimming, and color control affordances
will enable interoperable functionality to be configured for diverse
product types.
An `sdfObject` definition for a common on/off control may be used to
control may different kinds of Things that require on/off control.

Optional qualities "minItems" and "maxItems" can be used to define
sdfObjects as arrays.

### sdfProperty

`sdfProperty` is used to model elements of state within `sdfObject` instances.

An instance of `sdfProperty` may be associated with some protocol
affordance to enable the application to obtain the state variable and,
optionally, modify the state variable.
Additionally, some protocols provide for in-time reporting of state
changes.
(These three aspects are described by the qualities `readable`,
`writable`, and `observable` defined for an `sdfProperty`.)

Definitions in `sdfProperty` groups look like definitions in `sdfData` groups, however, they actually also declare a Property with the given qualities to be potentially present in the containing Object.
(Qualities beyond those of `sdfData` definitions could be defined for `sdfProperty` declarations
but currently aren't; this means that even Property qualities
such as `readable` and `writable` can be associated with definitions in `sdfData` groups, as well.)

For definitions in `sdfProperty` and `sdfData`, SDF provides qualities that can
constrain the structure and values of data allowed in an instance of
these data, as well as qualities that associate semantics to these
data, for engineering units and unit scaling information.

For the data definition within `sdfProperty` or `sdfData`, SDF borrows
a number of elements proposed for the drafts 4 and 7 of the json-schema.org "JSON Schema"
format {{-jso}}, enhanced by qualities that are specific to SDF.
For the current version of SDF, data are constrained to be of
simple types (number, string, Boolean),
JSON maps composed of named data ("objects"), and arrays of these types.
Syntax extension points are provided that can be used to provide
richer types in future versions of this specification (possibly more
of which can be borrowed from json-schema.org).

Note that `sdfProperty` definitions (and `sdfData` definitions in
general) are not intended to constrain the formats of data used for
communication over network interfaces.
Where needed, data definitions for payloads of protocol messages are
expected to be part of the protocol binding.

### sdfAction {#sdfaction-overview}

The `sdfAction` group contains declarations of Actions, model affordances that, when triggered,
have more effect than just reading, updating, or observing Thing
state, often resulting in some outward physical effect (which, itself,
cannot be modeled in SDF).  From a programmer's perspective, they
might be considered to be roughly analogous to method calls.

Actions may have data parameters; these are modeled as a single item of input
data and output data, each.  (Where multiple parameters need to be
modeled, an "object" type can be used to combine these parameters into one.)
<!-- (using `sdfData` definitions, i.e., the same entries as for `sdfProperty` declarations). -->
Actions may be long-running, that is to say that the effects may not
take place immediately as would be expected for an update to an
`sdfPoperty`; the effects may play out over time and emit action
results.
Actions may also not always complete and may result in application
errors, such as an item blocking the closing of an automatic door.

Actions may have (or lack) qualities of idempotency and side-effect safety.

The current version of SDF only provides data constraint modeling and semantics for the input and output data of definitions in `sdfAction` groups.
Again, data definitions for payloads of protocol messages, and
detailed protocol settings for invoking the action, are expected to be
part of the protocol binding.

### sdfEvent {#sdfevent-overview}

The `sdfEvent` group contains declarations of Events, which can model
affordances that inform about "happenings" associated with an instance
of an Object; these may result in a signal being stored or emitted as
a result.

Note that there is a trivial overlap with sdfProperty state changes,
which may also be defined as events but are not generally required to
be defined as such.
However, Events may exhibit certain ordering, consistency, and
reliability requirements that are expected to be supported in various
implementations of `sdfEvent` that do distinguish sdfEvent from
sdfProperty.
For instance, while a state change may simply be superseded by another
state change, some events are "precious" and need to be preserved even
if further events follow.

The current version of SDF only provides data constraint modeling and
semantics for the output data of Event affordances.
Again, data definitions for payloads of protocol messages, and
detailed protocol settings for invoking the action, are expected to be
part of the protocol binding.


### sdfData

Definitions in `sdfData` groups are provided separately from those in
`sdfProperty` groups to enable common
modeling patterns, data constraints, and semantic anchor concepts to
be factored out for data items that make up `sdfProperty` items and
serve as input and output data for `sdfAction` and `sdfEvent` items.

It is a common use case for such a data definition to be shared
between an `sdfProperty` item and input or output parameters of an
`sdfAction` or output data provided by an `sdfEvent`.
`sdfData` definitions also enable factoring out extended application
data types such as mode and machine state enumerations to be reused
across multiple definitions that have similar basic characteristics
and requirements.

### sdfThing

Back at the top level, the `sdfThing` groups enables definition of models for
complex devices that will use one or more `sdfObject` definitions.

A definition in an `sdfThing` group can refine the metadata of the definitions it
is composed from: other definitions in `sdfThing` groups definitions in `sdfObject` groups.

### sdfProduct

`sdfThing` has a derived class `sdfProduct`, which can be used to
indicate a top level inventory item with a Stock-Keeping Unit (SKU)
identifier and other particular metadata.
Structurally, there is no difference between definitions in either
group; semantically, a definition in an `sdfProduct` group is intended
to describe a class of complete Things.


# SDF structure

SDF definitions are contained in SDF files.  One or more SDF files can
work together to provide the definitions and declarations that are the
payload of the SDF format.

A SDF definition file contains a single JSON map (JSON object).
This object has three sections: the information block, the namespaces section, and the definitions section.

## Information block

The information block contains generic meta data for the file itself and all included definitions.
To enable tool integration, the information block is optional in the grammar
of SDF; most processes for working with SDF files will have policies
that only SDF models with an info block can be processed.
It is therefore RECOMMENDED that SDF validator tools emit a warning
when no information block is found.

The keyword (map key) that defines an information block is "info". Its
value is a JSON map in turn, with a set of entries that represent qualities that apply to the included definition.

Qualities of the information block are shown in {{infoblockqual}}.

| Quality   | Type   | Required | Description                                                 |
|-----------|--------|----------|-------------------------------------------------------------|
| title     | string | yes      | A short summary to be displayed in search results, etc.     |
| version   | string | yes      | The incremental version of the definition, format TBD       |
| copyright | string | yes      | Link to text or embedded text containing a copyright notice |
| license   | string | yes      | Link to text or embedded text containing license terms      |
{: #infoblockqual title="Qualities of the Information Block"}

While the format of the version string is marked as TBD, it is intended to be lexicographically increasing over the life of a model: a newer model always has a version string that string-compares higher than all previous versions.
This is easily achieved by following the convention to start the version with an {{?RFC3339}} `date-time` or, if new versions are generated less frequently than once a day, just the `full-date` (i.e., YYYY-MM-DD); in many cases, that will be all that is needed (see {{example1}} for an example).

The license string is preferably either a URI that points to a web page with an unambiguous definition of the license, or an {{SPDX}} license identifier.
(For models to be handled by the One Data Model liaison group, this will typically be "BSD-3-Clause".)

## Namespaces section

The namespaces section contains the namespace map and the defaultNamespace setting.

The namespace map is a map from short names for URIs to the namespace URIs
themselves.

The defaultNamespace setting selects one of the entries in the
namespace map by giving its short name.  The associated URI (value of
this entry) becomes the default namespace for the SDF definition file.

| Quality          | Type   | Required | Description                                                                                          |
|------------------|--------|----------|------------------------------------------------------------------------------------------------------|
| namespace        | map    | no       | Defines short names mapped to namespace URIs, to be used as identifier prefixes                      |
| defaultNamespace | string | no       | Identifies one of the prefixes in the namespace map to be used as a default in resolving identifiers |
{: #nssec title="Namespaces Section"}

The following example declares a set of namespaces and defines `cap`
as the default namespace.
By convention, the values in the namespace map contain full URIs
without a fragment identifier, and the fragment identifier is then
added, if needed, where the namespace entry is used.

~~~ json
"namespace": {
  "cap": "https://example.com/capability/cap",
  "zcl": "https://zcl.example.com/sdf"
},
"defaultNamespace": "cap",
~~~

If no defaultNamespace setting is given, the SDF definition file does not
contribute to a global namespace.  As the defaultNamespace is set by giving a
namespace short name, its presence requires a namespace map that contains a
mapping for that namespace short name.

If no namespace map is given, no short names for namespace URIs are
set up, and no defaultNamespace can be given.


## Definitions section

The Definitions section contains one or more groups, each identified by a Class Name Keyword (there can only be one group per keyword; the actual grouping is just a shortcut and does not carry any specific semantics).
The value of each group is a JSON map (object), the keys of which serve for naming the individual definitions in this group, and the corresponding values provide a set of qualities (name-value pairs) for the individual definition.
(In short, we speak of the map entries as "named sets of qualities".)

Each group may contain zero or more definitions.
Each identifier defined creates a new type and term in the target namespace.
Declarations have a scope of the current definition block. <!-- what exactly does this mean? -->

A definition may in turn contain other definitions. Each definition is a named set of qualities, i.e., it consists of the newly defined identifier and a set of key-value pairs that represent the defined qualities and contained definitions.

An example for an Object definition is given in {{exobject}}:

~~~ json
"sdfObject": {
  "foo": {
    "sdfProperty": {
      "bar": {
        "type": "boolean"
      }
    }
  }
}
~~~
{: #exobject title="Example Object definition"}

This example defines an Object "foo" that is defined in the default namespace (full address: `#/sdfObject/foo`), containing a property that can be addressed as
`#/sdfObject/foo/sdfProperty/bar`, with data of type boolean.
<!-- we could define a URN-style namespace that looks exactly that way -->

Some of the definitions are also declarations: the definition of the entry "bar" in the property "foo" means that each instance of a "foo" can have zero or one instance of a "bar".  Entries within `sdfProperty`, `sdfAction`, and `sdfEvent`, within `sdfObject` entries, are declarations.  Similarly, entries within an `sdfThing` describe instances of `sdfObject` (or nested `sdfThing`) that form part of instances of the Thing.

# Names and namespaces

SDF definition files may contribute to a global namespace, and may
reference elements from that global namespace.
(An SDF definition file that does not set a defaultNamespace does not
contribute to a global namespace.)

## Structure

Global names look exactly like `https://` URIs with attached fragment identifiers.

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
we therefore also call it the "target namespace" of the SDF definition file.

E.g., in {{example1}}, definitions for the following global names are contributed:

* https://example.com/capability/cap#/sdfObject/Switch
* https://example.com/capability/cap#/sdfObject/Switch/sdfProperty/value
* https://example.com/capability/cap#/sdfObject/Switch/sdfAction/on
* https://example.com/capability/cap#/sdfObject/Switch/sdfAction/off

Note the `#`, which separates the absolute-URI part (Section 4.3 of
{{-uri}}) from the fragment identifier part.

## Referencing global names

A name reference takes the form of the production `curie` in
{{-curie}} (note that this excludes the production `safe-curie`),
but also limiting the IRIs involved in that production to URIs as per {{-uri}}
and the prefixes to ASCII characters {{-ascii}}.

A name that is contributed by the current SDF definition file can be
referenced by a Same-Document Reference as per section 4.4 of
{{-uri}}.
As there is little point in referencing the entire SDF definition
file, this will be a `#` followed by a JSON pointer.
This is the only kind of name reference to itself that is possible in an SDF
definition file that does not set a default namespace.

Name references that point outside the current SDF definition file
need to contain curie prefixes.  These then reference namespace
declarations in the namespaces section.

For example, if a namespace prefix is defined:

~~~ json
"namespace": {
  "foo": "https://example.com/"
}
~~~

Then this reference to that namespace:

~~~ json
{ "sdfRef": "foo:#/sdfData/temperatureData" }
~~~

references the global name:

~~~ json
"https://example.com/#/sdfData/temperatureData"
~~~

Note that there is no way to provide a URI scheme name in a curie, so
all references outside of the document need to go through the
namespace map.

Name references occur only in specific elements of the syntax of SDF:

* copying elements via sdfRef values
* pointing to elements via sdfRequired value elements


## sdfRef

In a JSON map establishing a definition, the keyword "sdfRef" is used
to copy all of the qualities of the referenced definition, indicated
by the included name reference, into the newly formed definition.
(This can be compared to the processing of the "$ref" keyword in {{-jso}}.)

For example, this reference:

~~~ json
"temperatureProperty": {
  "sdfRef": "#/sdfData/temperatureData"
}
~~~

creates a new definition "temperatureProperty" that contains all of the qualities defined in the definition at /sdfData/temperatureData.

The sdfRef member need not be the only member of a map.
Additional members may be present with the intention to override parts
of the referenced map.
More formally, for a JSON map that contains an
sdfRef member, the semantics is defined to be as if the following steps were performed:

1. The JSON map that contains the sdfRef member is copied into a
   variable named "patch".
2. The sdfRef member of the copy in "patch" is removed.
3. the JSON pointer that is the value of the sdfRef member is
   dereferenced and the result is copied into a variable named "original".
4. The JSON Merge Patch algorithm {{-merge-patch}} is applied to patch
   the contents of "original" with the contents of "patch".
5. The result of the Merge Patch is used in place of the value of the
   original JSON map.

TODO: Make sure that the grammar in {{syntax}} allows specifying the
null values that are necessary to remove members in a merge-patch.

## sdfRequired

The keyword "sdfRequired" is provided to apply a constraint that
defines for which declarations corresponding data are mandatory in an
instance conforming the current definition.

The value of "sdfRequired" is an array of name references (JSON pointers), each
indicating one declaration that is mandatory to be represented.

The example in {{example-req}} shows two required elements in the sdfObject definition for "temperatureWithAlarm", the sdfProperty "currentTemperature", and the sdfEvent "overTemperatureEvent". The example also shows the use of JSON pointer with "sdfRef" to use a pre-existing definition in this definition, for the "alarmType" data (sdfOutputData) produced by the sdfEvent "overTemperatureEvent".

~~~ json
{
  "sdfObject": {
    "temperatureWithAlarm": {
      "sdfRequired": [
        "#/sdfObject/temperatureWithAlarm/sdfProperty/currentTemperature",
        "#/sdfObject/temperatureWithAlarm/sdfEvent/overTemperatureEvent"
      ],
      "sdfData":{
        "temperatureData": {
          "type": "number"
        }
      },
      "sdfProperty": {
        "currentTemperature": {
          "sdfRef": "#/sdfObject/temperatureWithAlarm/sdfData/temperatureData"
        }
      },
      "sdfEvent": {
        "overTemperatureEvent": {
          "sdfOutputData": {
            "type": "object",
            "properties": {
              "alarmType": {
                "sdfRef": "cap:/sdfData/alarmTypes/quantityAlarms",
                "const": "OverTemperatureAlarm"
              },
              "temperature": {
                "sdfRef": "#/sdfObject/temperatureWithAlarm/sdfData/temperatureData"
              }
            }
          }
        }
      }
    }
  }
}
~~~
{: #example-req title="Using sdfRequired"}

## Common Qualities

Definitions in SDF share a number of qualities that provide metadata for
them.  These are listed in {{tbl-common-qualities}}.  None of these
qualities are required or have default values that are assumed if the
quality is absent.
If a label is required for an application and no label is given in the SDF model, the
last part (`reference-token`, Section 3 of {{-pointer}}) of the JSON
pointer to the definition can be used.

| Quality     | Type         | Description                                                        |
|-------------|--------------|--------------------------------------------------------------------|
| description | text         | long text (no constraints)                                         |
| label       | text         | short text (no constraints)                                        |
| $comment    | text         | source code comments only, no semantics                            |
| sdfRef      | sdf-pointer  | (see {{sdfref}})                                                   |
| sdfRequired | pointer-list | (see {{sdfrequired}}, applies to qualities of properties, of data) |
{: #tbl-common-qualities title="Common Qualities"}

## Data Qualities

Data qualities are used in `sdfData` and `sdfProperty` definitions,
which are named sets of data qualities (abbreviated as `named-sdq`).

{{sdfdataqual1}} lists data qualities borrowed from {{-jso}}; the
intention is that these qualities retain their semantics from the
versions of the json-schema.org proposal they were imported from.
A description that starts with a parenthesized term means the quality
is only applicable when `type` has the value of the term.

{{sdfdataqual2}} lists data qualities defined specifically for the
present specification.

The term "allowed types" stands for primitive JSON types, JSON maps ("objects")" as well as
homogeneous arrays of numbers, text, Booleans, or maps.  (This list might be
extended in a future version of SDF.)  An "allowed value" is a value
allowed for one of these types.

| Quality          | Type                                                             | Description                                                        |
|------------------+------------------------------------------------------------------+--------------------------------------------------------------------|
| type             | "number" / "string" / "boolean" / "integer" / "array" / "object" | JSON data type (note 1)                                             |
| const            | allowed value                                                    | specifies a constant value for a data item or property             |
| default          | allowed value                                                    | specifies the default value for initialization                     |
| minimum          | number                                                           | (number) lower limit of value                                      |
| maximum          | number                                                           | (number) upper limit of value                                      |
| exclusiveMinimum | number or boolean (jso draft 7/4)                                | (number) lower limit of value                                      |
| exclusiveMaximum | number or boolean (jso draft 7/4)                                | (number) lower limit of value                                      |
| multipleOf       | number                                                           | (number) resolution of the number \[NEEDED?]                       |
| minLength        | integer                                                          | (string) shortest length string in octets                          |
| maxLength        | integer                                                          | (string) longest length string in octets                           |
| pattern          | string                                                           | (string) regular expression to constrain a string pattern          |
| format           | "date-time" / "date" / "time" / "uri" / "uri-reference" / "uuid" | (string) JSON Schema formats as per {{-jso}}, Section 7.3          |
| minItems         | number                                                           | (array) Minimum number of items in array                            |
| maxItems         | number                                                           | (array) Maximum number of items in array                           |
| uniqueItems      | boolean                                                          | (array) if true, requires items to be all different                |
| items            | (subset of common/data qualities; see {{syntax}}                 | (array) constraints on array items                                  |
| required         | array of strings                                                 | (object) names of properties (note 2) that are required in the JSON map ("object") |
| properties       | named set of data qualities                                      | (object) entries allowed for the JSON map ("object")                  |
{: #sdfdataqual1 title="Qualities of sdfProperty and sdfData borrowed from json-schema.org"}

(1) A type value of `integer` means that only integral values of JSON
numbers can be used.

(2) Note that the term "properties" as used for map entries in {{-jso}} is unrelated to sdfProperty.

| Quality       | Type                        | Description                                                         | Default |
|---------------|-----------------------------|---------------------------------------------------------------------|---------|
| (common)      |                             | {{common-qualities}}                                                |         |
| unit          | string                      | SenML unit name as per {{-units}}, subregistry SenML Units (note 3) | N/A     |
| scaleMinimum  | number                      | lower limit of value in units given by unit (note 4)                 | N/A     |
| scaleMaximum  | number                      | upper limit of value in units given by unit (note 4)                | N/A     |
| readable      | boolean                     | Reads are allowed                                                   | true    |
| writable      | boolean                     | Writes are allowed                                                  | true    |
| observable    | boolean                     | flag to indicate asynchronous notification is available             | true    |
| nullable      | boolean                     | indicates a null value is available for this type                   | true    |
| contentFormat | string                      | content type (IANA media type string plus parameters), encoding     | N/A     |
| sdfType       | string ({{sdftype}})        | sdfType enumeration (extensible)                                    | N/A     |
| sdfChoice     | named set of data qualities | named alternatives                                                  | N/A     |
| enum          | array of strings            | abbreviation for string-valued named alternatives                   | N/A     |
{: #sdfdataqual2 title="SDF-defined Qualities of sdfProperty and sdfData"}

(3) note that the quality `unit` was called `units` in SDF 1.0.

(4) these qualities were included in SDF 1.0, but were not fully
    defined; they are not included in SDF 1.1.  In 1.next, they will
    be replaced by qualities to express scaling that are more aligned
    with the processes that combine ecosystem and instance specific
    information with an SDF model.

### sdfType

SDF defines a number of basic types beyond those provided by JSON or
{{-jso}}.  These types are identified by the `sdfType` quality, which
is a text string from a set of type names defined by SDF.

To aid interworking with {{-jso}} implementations, it is RECOMMENDED
that `sdfType` is always used in conjunction with the `type` quality
inherited from {{-jso}}, in such a way as to yield a common
representation of the type's values in JSON.

Values for `sdfType` that are defined in SDF 1.1 are shown in
{{sdftype1}}.
This table also gives a description of the semantics of the sdfType,
the conventional value for `type` to be used with the `sdfType` value,
and a conventional JSON representation for values of the type.

| sdfType     | Description                      | type   | JSON Representation                                        |
|-------------|----------------------------------|--------|------------------------------------------------------------|
| byte-string | A sequence of zero or more bytes | string | base64url without padding ({{Section 3.4.5.2 of RFC8949}}) |
| unix-time   | A point in civil time (note 1)   | number | POSIX time ({{Section 3.4.2 of RFC8949}})                  |
{: #sdftype1 title="Values defined in SDF 1.1 for sdfType quality"}

(1) Note that the definition of `unix-time` does not imply the
capability to represent points in time that fall on leap seconds.
More date/time-related sdfTypes are likely to be added in future versions
of this specification.

In SDF 1.0, a similar concept was called `subtype`.

### sdfChoice

Data can be a choice of named alternatives, called `sdfChoice`.
Each alternative is identified by a name (string, key in the JSON
object used to represent the choice) and a set of dataqualities
(object, the value in the JSON object used to represent the choice).

sdfChoice merges the functions of two constructs found in {{-jso}}:

* `enum`

  What would have been

  ~~~ json
  "enum": ["foo", "bar", "baz"]
  ~~~

  in SDF 1.0, is often best represented as:

  ~~~ json
  "sdfChoice": {
    "foo": { "description": "This is a foonly"},
    "bar": { "description": "As defined in the second world congress"},
    "baz": { "description": "From zigbee foobaz"}
  }
  ~~~

  This allows the placement of other dataqualities such as
  `description` in the example.

  If an enum needs to use a data type different from text string,
  e.g. what would have been

  ~~~ json
  "type": "number",
  "enum": [1, 2, 3]
  ~~~

  in SDF 1.0, is represented as:

  ~~~ json
  "type": "number",
  "sdfChoice": {
    "a-better-name-for-alternative-1": { "const": 1 },
    "alternative-2": { "const": 2 },
    "the-third-alternative": { "const": 3 }
  }
  ~~~

  where the string names obviously would be chosen in a way that is
  descriptive for what these numbers actually stand for; sdfChoice
  also makes it easy to add number ranges into the mix.

  (Note that `const` can also be used for strings as in the previous
  example, e.g., if the actual string value is indeed a crucial
  element for the data model.)

* anyOf

  {{-jso}} provides a type union called `anyOf`, which provides a
  choice between anonymous alternatives.

  What could have been

  ~~~ json
  "anyOf": [
    {"type": "array", "minItems": 3, "maxItems": "3", "items": {
       "sdfRef": "rgbVal"}}
    {"type": "array", "minItems": 4, "maxItems": "4", "items": {
       "sdfRef": "cmykVal"}}
  ]
  ~~~

  in {{-jso}} can be more descriptively notated in SDF as:

  ~~~ json
  "sdfChoice": {
    "rgb": {"type": "array", "minItems": 3, "maxItems": "3", "items": {
              "sdfRef": "rgbVal"}}
    "cmyk": {"type": "array", "minItems": 4, "maxItems": "4", "items": {
              "sdfRef": "cmykVal"}}
  ]
  ~~~

Note that there is no need in SDF for the type intersection construct
`allOf` or the peculiar type-xor construct `oneOf` found in {{-jso}}.

As a simplification for readers of SDF specifications accustomed to
the {{-jso}} enum keyword, this is retained, but limited to a choice
of text string values, such that

~~~ json
"enum": ["foo", "bar", "baz"]
~~~

is syntactic sugar for

~~~ json
"sdfChoice": {
  "foo": { "const": "foo"},
  "bar": { "const": "bar"},
  "baz": { "const": "baz"}
}
~~~

# Keywords for definition groups

The following SDF keywords are used to create definition groups in the target namespace.
All these definitions share some common qualities as discussed in {{common-qualities}}.

## sdfObject

The sdfObject keyword denotes a group of zero or more Object definitions.
Object definitions may contain or include definitions of Properties, Actions, Events declared for the object, as well as data types (sdfData group) to be used in this or other Objects.

The qualities of an sdfObject include the common qualities, additional qualities are shown in {{sdfobjqual}}.
None of these
qualities are required or have default values that are assumed if the
quality is absent.

| Quality     | Type      | Description                                                              |
|-------------+-----------+--------------------------------------------------------------------------|
| (common)    |           | {{common-qualities}}                                                     |
| sdfProperty | property  | zero or more named property definitions for this object                  |
| sdfAction   | action    | zero or more named action definitions for this object                    |
| sdfEvent    | event     | zero or more named event definitions for this object                     |
| sdfData     | named-sdq | zero or more named data type definitions that might be used in the above |
| minItems    | number    | (array) Minimum number of sdfObject instances in array                   |
| maxItems    | number    | (array) Maximum number of sdfObject instances in array                   |
{: #sdfobjqual title="Qualities of sdfObject"}


## sdfProperty

The sdfProperty keyword denotes a group of zero or more Property definitions.

Properties are used to model elements of state.

The qualities of a Property definition include the data qualities (and
thus the common qualities), see {{data-qualities}}.

## sdfAction

The sdfAction keyword denotes a group of zero or more Action definitions.

Actions are used to model commands and methods which are invoked. Actions have parameter data that are supplied upon invocation.

The qualities of an Action definition include the common qualities, additional qualities are shown in {{sdfactqual}}.

| Quality       | Type      | Description                                                              |
|---------------+-----------+--------------------------------------------------------------------------|
| (common)      |           | {{common-qualities}}                                                     |
| sdfInputData  | map       | data qualities of the input data for an Action                           |
| sdfOutputData | map       | data qualities of the output data for an Action                          |
| sdfData       | named-sdq | zero or more named data type definitions that might be used in the above |
{: #sdfactqual title="Qualities of sdfAction"}

`sdfInputData` defines the input data of the action.  `sdfOutputData`
defines the output data of the action.
As discussed in {{sdfaction-overview}}, a set of data qualities with
type "object" can be used to substructure either data item, with
optionality indicated by the data quality `required`.

## sdfEvent

The sdfEvent keyword denotes zero or more Event definitions.

Events are used to model asynchronous occurrences that may be communicated proactively. Events have data elements which are communicated upon the occurrence of the event.

The qualities of sdfEvent include the common qualities, additional qualities are shown in {{sdfevqual}}.

| Quality       | Type      | Description                                                              |
|---------------+-----------+--------------------------------------------------------------------------|
| (common)      |           | {{common-qualities}}                                                     |
| sdfOutputData | map       | data qualities of the output data for an Event                           |
| sdfData       | named-sdq | zero or more named data type definitions that might be used in the above |
{: #sdfevqual title="Qualities of sdfEvent"}

`sdfOutputData` defines the output data of the action.
As discussed in {{sdfevent-overview}}, a set of data qualities with
type "object" can be used to substructure the output data item, with
optionality indicated by the data quality `required`.

## sdfData

The sdfData keyword denotes a group of zero or more named data type
definitions (named-sdq).

An sdfData definition provides a reusable semantic identifier for a
type of data item and describes the constraints on the defined type.
It is not itself a declaration, i.e., it does not cause any of these
data items to be included in an affordance definition.

The qualities of sdfData include the data qualities (and thus the common qualities), see {{data-qualities}}.

# High Level Composition

The requirements for high level composition include the following:

- The ability to represent products, standardized product types, and modular products while maintaining the atomicity of Objects.

- The ability to compose a reusable definition block from Objects, for example a single plug unit of an outlet strip with on/off control, energy monitor, and optional dimmer objects, while retaining the atomicity of the individual objects.

- The ability to compose Objects and other definition blocks into a higher level thing that represents a product, while retaining the atomicity of objects.

- The ability to enrich and refine a base definition to have product-specific qualities and quality values, e.g. unit, range, and scale settings.

- The ability to reference items in one part of a complex definition from another part of the same definition, for example to summarize the energy readings from all plugs in an outlet strip.

## Paths in the model namespaces

The model namespace is organized according to terms that are defined in the definition files that are present in the namespace. For example, definitions that originate from an organization or vendor are expected to be in a namespace that is specific to that organization or vendor. There is expected to be an SDF namespace for common SDF definitions used in OneDM.

The structure of a path in a namespace is defined by the JSON Pointers to the definitions in the files in that namespace. For example, if there is a file defining an object "Switch" with an action "on", then the reference to the action would be "ns:/sdfObject/Switch/sdfAction/on" where `ns` is the namespace prefix (short name for the namespace).

## Modular Composition

Modular composition of definitions enables an existing definition (could be in the same file or another file) to become part of a new definition by including a reference to the existing definition within the model namespace.

### Use of the "sdfRef" keyword to re-use a definition

An existing definition may be used as a template for a new definition, that is, a new definition is created in the target namespace which uses the defined qualities of some existing definition. This pattern will use the keyword "sdfRef" as a quality of a new definition with a value consisting of a reference to the existing definition that is to be used as a template. 

In the definition that uses "sdfRef", new qualities may be added
and existing qualities from the referenced definition may be
overridden.  (Note that JSON maps (objects) do not have a defined
order, so the SDF processor may see these overrides before seeing the
`sdfRef`.)

As a convention, overrides are intended to be used only for further restricting
the set of data values, as shown in {{exa-sdfref}}:  any value for a
`cable-length` also is a valid value for a `length`, with the
additional restriction that the length cannot be smaller than 5 cm.
(This is labeled as a convention as it cannot be checked in the
general case; a quality of implementation consideration for a tool
might be to provide at least some form of checking.)
Note that a description is provided that overrides the description of
the referenced definition; as this quality is intended for human
consumption there is no conflict with the intended goal.

~~~
"sdfData":
  "length" : {
    "type": "number",
    "minimum": 0,
    "unit": "m"
    "description": "There can be no negative lengths."
  }
...
  "cable-length" : {
    "sdfRef": "#/sdfData/length"
    "minimum": 0.05,
    "description": "Cables must be at least 5 cm."
  }
~~~
{: #exa-sdfref}

## sdfThing

An sdfThing is a set of declarations and qualities that may be part of a more complex model. For example, the object declarations that make up the definition of a single socket of an outlet strip could be encapsulated in an sdfThing, and the socket-thing itself could be used in a declaration in the sdfThing definition for the outlet strip.

sdfThing definitions carry semantic meaning, such as a defined refrigerator compartment and a defined freezer compartment, making up a combination refrigerator-freezer product.

An sdfThing may be composed of sdfObjects and other sdfThings.

The qualities of sdfThing are shown in {{sdfthingqual}}.

| Quality   | Type   | Description          |
|-----------|--------|----------------------|
| (common)  |        | {{common-qualities}} |
| sdfThing  | thing  |                      |
| sdfObject | object |                      |
{: #sdfthingqual title="Qualities of sdfThing and sdfProduct"}


## sdfProduct

An sdfProduct provides the level of abstraction for representing a unique product or a profile for a standardized type of product, for example a "device type" definition with required minimum functionality.

Products may be composed of Objects and Things at the high level, and may include their own definitions of Properties, Actions, and Events that can be used to extend or complete the included Object definitions.

Product definitions may set optional defaults and constant values for specific use cases, for example units, range, and scale settings for properties, or available parameters for Actions.

The qualities of sdfProduct are the same as for sdfThing and are shown in {{sdfthingqual}}.


IANA Considerations {#iana}
===================

Media Type
-----------

IANA is requested to add the following Media-Type to the "Media Types" registry.

| Name     | Template             | Reference                 |
| sdf+json | application/sdf+json | RFC XXXX, {{media-type}}  |
{: align="left"}

// RFC Ed.: please replace RFC XXXX with this RFC number and remove this note.

{: spacing="compact"}
Type name:
: application

Subtype name:
: sdf+json

Required parameters:
: none

Optional parameters:
: none

Encoding considerations:
: binary (JSON is UTF-8-encoded text)

Security considerations:
: {{seccons}} of RFC XXXX

Interoperability considerations:
: none

Published specification:
: {{media-type}} of RFC XXXX

Applications that use this media type:
: Tools for data and interaction modeling in the Internet of Things

Fragment identifier considerations:
: A JSON Pointer fragment identifier may be used, as defined in
  {{Section 6 of RFC6901}}.

Person & email address to contact for further information:
: ASDF WG mailing list (asdf@ietf.org),
  or IETF Applications and Real-Time Area (art@ietf.org)

Intended usage:
: COMMON

Restrictions on usage:
: none

Author/Change controller:
: IETF

Provisional registration:
: no



Registries
----------

(TBD: After future additions, check if we need any.)


Security Considerations {#seccons}
=======================

Some wider issues are discussed in {{-seccons}}.

(Specifics: TBD.)


--- back

# Formal Syntax of SDF {#syntax}

This appendix describes the syntax of SDF using CDDL {{-cddl}}.  Note
that this appendix was derived from Ari Keranen's "alt-schema" and
Michael Koster's "schema", with a view of covering the syntax that is
currently in use at the One Data Model `playground` repository.

This appendix shows the framework syntax only, i.e., a syntax with liberal extension points.
Since this syntax is nearly useless in finding typos in an SDF
specification, a second syntax, the validation syntax, is defined that
does not include the extension points.
The validation syntax can be generated from the framework syntax by
leaving out all lines containing the string `EXTENSION-POINT`; as this
is trivial, the result is not shown here.

This appendix makes use of CDDL "features" as defined in Section 4 of {{-control}}.
A feature named "1.0" is used to indicate parts of the syntax being
deprecated towards SDF 1.1, and a feature named "1.1" is used to
indicate new syntax intended for SDF 1.1.
Features whose names end in "-ext" indicate extension points for
further evolution.

~~~ cddl
{::include sdf-framework.cddl}
~~~


# json-schema.org Rendition of SDF Syntax

This appendix describes the syntax of SDF defined in {{syntax}}, but
using a version of the description techniques advertised on
json-schema.org {{-jso}}.

The appendix shows both the validation and the framework syntax.
Since most of the lines are the same between these two files, those lines are shown only once, with a leading space, in the form of a unified diff.
Lines leading with a `-` are part of the validation syntax, and lines leading with a `+` are part of the framework syntax.

~~~ jso.json
{::include sdf.jso.json-unidiff}
~~~
 
# Acknowledgements
{: numbered="no"}

This draft is based on `sdf.md` and `sdf-schema.json` in the old
one-data-model `language` repository, as well as {{{Ari Keränen}}}'s
"alt-schema" from the Ericsson Research `ipso-odm` repository (which
is now under subdirectory `sdflint` in the one-data model `tools`
repository).

<!--  LocalWords:  SDF namespace defaultNamespace instantiation OMA
 -->
<!--  LocalWords:  affordances ZigBee LWM OCF sdfObject sdfThing
 -->
<!--  LocalWords:  idempotency Thingness sdfProperty sdfEvent sdfRef
 -->
<!--  LocalWords:  namespaces sdfRequired Optionality sdfAction
 -->
<!--  LocalWords:  sdfProduct dereferenced dereferencing atomicity
 -->
<!--  LocalWords:  interworking
 -->
