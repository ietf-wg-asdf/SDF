---
v: 3
coding: utf-8

title: >
  Semantic Definition Format (SDF) for Data and Interactions of Things
abbrev: SDF (Semantic Definition Format)
docname: draft-ietf-asdf-sdf-latest
category: std
consensus: true
submissiontype: IETF

area: Applications
workgroup: ASDF
keyword: Internet-Draft

venue:
    group: A Semantic Definition Format for Data and Interactions of Things (ASDF)
    mail: asdf@ietf.org
    github: ietf-wg-asdf/SDF

author:
  - name: Michael Koster
    org: KTC Control AB
    street: 29415 Alderpoint Road
    city: Blocksburg, CA
    code: '95514'
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
  - name: Ari Keränen
    org: Ericsson
    city: Jorvas
    code: '02420'
    country: Finland
    email: ari.keranen@ericsson.com
contributor:
  - name: Jan Romann
    org: Universität Bremen
    email: jan.romann@uni-bremen.de
  - name: Wouter | van der Beek
    org: Cascoda Ltd.
    street:
    - Threefield House
    - Threefield Lane
    city: Southampton
    country: United Kingdom
    email: w.vanderbeek@cascoda.com

normative:
  IANA.senml: units
  IANA.params: params
  RFC3339: dt
  RFC8428: senml
  RFC8798: senml-units-2
  RFC3986: uri
  RFC4122: uuid
  RFC6901: pointer
  RFC7396: merge-patch
  RFC3629: utf8
  RFC8259: json
  RFC8610: cddl
  RFC8949: cbor
  RFC9193: data-ct
  RFC8126:
    -: reg
    display: BCP26
  W3C.NOTE-curie-20101216: curie
  RFC0020: ascii
  SPDX:
    title: SPDX License List
    target: https://spdx.org/licenses/
    date: false
  RFC9165: control
informative:
  JSO7:
    =: I-D.handrews-json-schema-01
    -: jso
    ann: This is the base specification for json-schema.org "draft 7".
  JSO7V:
    =: I-D.handrews-json-schema-validation-01
    -: jso7v
    ann: This is the validation specification for json-schema.org "draft 7".
  JSO4:
    =: I-D.draft-zyp-json-schema-04
#   =: I-D.wright-json-schema
    -: jso4
    ann: This is the base specification for json-schema.org "draft 4".
  JSO4V:
    =: I-D.fge-json-schema-validation-00
    -: jso4v
    ann: This is the validation specification for json-schema.org "draft 4".
# -02#section-7.3 -- formats
  I-D.irtf-t2trg-rest-iot: rest-iot
  ZCL: DOI.10.1016/B978-0-7506-8597-9.00006-9
  OMA:
    title: OMA LightweightM2M (LwM2M) Object and Resource Registry
    date: false
    target: http://www.openmobilealliance.org/wp/omna/lwm2m/lwm2mregistry.html
  OCF:
    title: OCF Resource Type Specification
    date: false
# v2.1.4 August 2021
    target: https://openconnectivity.org/specs/OCF_Resource_Type_Specification.pdf
  RFC8576: seccons
  ECMA-262:
    target: https://www.ecma-international.org/wp-content/uploads/ECMA-262.pdf
    title: ECMAScript 2020 Language Specification
    author:
    - org: Ecma International
    date: 2020-06
    seriesinfo:
      ECMA: Standard ECMA-262, 11th Edition
  CamelCase:
    target: http://wiki.c2.com/?CamelCase
    title: Camel Case
    date: '2014-12-18'
  KebabCase:
    target: http://wiki.c2.com/?KebabCase
    title: Kebab Case
    date: '2014-08-29'
  I-D.bormann-asdf-sdftype-link: sdflink
  I-D.bormann-asdf-sdf-mapping: mapping
  I-D.bormann-t2trg-deref-id: deref
  RFC9485: iregexp
  I-D.ietf-jsonpath-base: jsonpath

entity:
        SELF: "[RFC-XXXX]"

--- abstract

[^intro-]

[^intro-]:
    The Semantic Definition Format (SDF) is a format for domain experts to
    use in the creation and maintenance of data and interaction models
    that describe Things, i.e., physical objects that are available for interaction
    over a network. An SDF specification describes definitions of
    SDF Objects/SDF Things and their associated interactions (Events, Actions,
    Properties), as well as the Data types for the information exchanged
    in those interactions. Tools convert this format to database formats
    and other serializations as needed.

[^status]

[^status]: The present revision (-18) adds security considerations, a
    few editorial cleanups, discusses JSON pointer encodings, and adds
    sockets to the CDDL for easier future extension.

--- middle


# Introduction

[^intro-]

[^status]

SDF is designed to be an extensible format.
The present document constitutes the base specification for SDF; we
speak of "base SDF" for short.
In addition, SDF extensions can be defined, some of which may make use
of extension points specifically defined for this in base SDF.
One area for such extensions would be refinements of SDF's abstract
interaction models into protocol bindings for specific ecosystems
(e.g., {{-mapping}}).
For other extensions, it may be necessary to indicate in the SDF
document that a specific extension is in effect; see
{{information-block}} for details of the `features` quality that can be
used for such indications.
With extension points and feature indications available,
base SDF does not define a "version" concept for the SDF format itself
(as opposed to version indications within SDF documents indicating
their own evolution, see {{information-block}}).

## Structure of This Document

After introductory material and an overview ({{overview}}) over the
elements of the model and over the different kinds of names used,
{{sdf-structure}} introduces the main components of an SDF model.
{{names-and-namespaces}} revisits names and structures them into
namespaces.
{{kw-defgroups}} discusses the inner structure of the Objects defined by
SDF, the sdfObjects, in further detail.
{{high-level-composition}} discusses how SDF supports composition.
Conventional Sections ({{<<iana}}, {{<<seccons}},
{{<<sec-normative-references}}, and {{<<sec-informative-references}})
follow.
The normative {{syntax}} defines the syntax of SDF in
terms of its JSON structures, employing the Concise Data Definition
Language (CDDL) {{-cddl}}.
This is followed by the informative {{jso}}, a rendition of the SDF
syntax in a "JSON Schema" format as they are defined by
`json-schema.org` (collectively called JSO).
The normative {{jso-inspired}} defines certain terms ("data qualities")
used at the SDF data model level that were inspired by JSO.
Finally, the informative {{composition-examples}} provides a few
examples for the use of composition in SDF.

## Terminology and Conventions

Thing:
: A physical item that is also available for interaction over a network.

Grouping:
: An sdfThing or sdfObject, i.e., (directly or indirectly) a combination of Affordances.

sdfThing:
: A grouping of Groupings as well as potentially Affordance
  declarations (Property, Action, and Event declarations).

Affordance:
: An element of an interface offered for interaction, for which
  information is available (directly or indirectly) that indicates how
  it can or should be used.
  The term is used here for the digital (network-directed) interfaces
  of a Thing only; it
  might also have physical affordances such as buttons, dials, and
  displays.

Quality:
: A metadata item in a definition or declaration which says something
  about that definition or declaration.  A quality is represented in
  SDF as an entry in a JSON map (JSON object) that serves as a definition
  or declaration.

Entry:
: A key-value pair in a map. (In JSON maps, sometimes also called "member".)

Block:
: One or more entries in a JSON map that is part of an SDF
  specification; these entries together serve a specific function.

Group:
: An entry in the main JSON map representing the SDF document, and in
  certain nested definitions, that
  has a Class Name Keyword as its key and a map of named definition
  entries (Definition Group) as a value.

Class Name Keyword:
: One of `sdfThing`, `sdfObject`, `sdfProperty`, `sdfAction`,
  `sdfEvent`, or `sdfData`; the Classes for these type keywords are
  capitalized and prefixed with `sdf`.

Class:
: Abstract term for the information that is contained in groups
  identified by a Class Name Keyword.

Property:
: An affordance that can potentially be used to read, write, and/or
  observe state (current/stored information) on an sdfObject.
  (Note that Entries are often called
  properties in other environments; in this document, the term
  Property is specifically reserved for affordances, even if the map
  key "properties" might be imported from a data definition language
  with the other semantics.)

Action:
: An affordance that can potentially be used to perform a named operation on an sdfObject.

Event:
: An affordance that can potentially be used to obtain information about what happened to an sdfObject.

Object, sdfObject:
: A grouping containing only Affordance declarations (Property, Action, and Event declarations); the main
  "atom" of reusable semantics for model construction. sdfObjects are
  similar to sdfThings but do not allow nesting, i.e., they cannot contain
  other Groupings (sdfObjects or sdfThings). (Note that
  JSON maps are often called JSON objects due to JSON's JavaScript
  heritage; in the context of SDF, the term Object as the colloquial shorthand for sdfObject, is specifically reserved for the
  above grouping, even if
  the type name `"object"` is imported from a data definition
  language with the other semantics.)

Element:
: A part or an aspect of something abstract; used here in its usual English definition.
  (Occasionally, also used specifically for the elements of JSON arrays.)

Definition:
: An entry in a Definition Group; the entry creates a new semantic
  term for use in SDF models and associates it with a set of
  qualities.
  Unless it is also a Declaration, a definition just defines a term,
  it does not create a component item within the enclosing definition.

Declaration:
: A definition within an enclosing
  definition, intended to create a component item within that
  enclosing definition.  Every declaration can also be used as a
  definition for reference in a different place.

SDF Document:
: Container for SDF Definitions, together with data
  about the SDF Document itself (information block).
  Represented as a JSON text representing a single JSON map, which is
  built from nested maps.

SDF Model:
: Definitions and declarations that model the digital interaction
  opportunities offered by one or more kinds of Things, represented
  by sdfObjects and sdfThings.
  An SDF Model can be fully contained in a single SDF Document, or it
  can be built from an SDF Document that references definitions and
  declarations from additional SDF documents.

Protocol Binding:
: A companion document to an SDF Model that defines how to map
  the abstract concepts in the model into the protocols in use
  in a specific ecosystem.  Might supply URL components, numeric IDs,
  and similar details.  Protocol Bindings are one case of an
  Augmentation Mechanism.

Augmentation Mechanism:
: A companion document to a base SDF Model that provides additional
  information ("augments" the base specification), possibly for use in
  a specific ecosystem or with a specific protocol ("Protocol Binding").
  No specific Augmentation Mechanisms are defined in base SDF.
  A simple mechanism for such augmentations has been discussed as a
  "mapping file" {{-mapping}}.

The term "byte" is used in its now-customary sense as a synonym for
"octet".

Conventions:

- The singular form is chosen as the preferred one for the keywords defined here.

{::boilerplate bcp14-tagged}

# Overview

## Example Definition

We start with an example for the SDF definition of a simple sdfObject called "Switch" ({{example1}}).

~~~ json
{
  "info": {
    "title": "Example document for SDF (Semantic Definition Format)",
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
          "description":
"The state of the switch; false for off and true for on.",
          "type": "boolean"
        }
      },
      "sdfAction": {
        "on": {
          "description":
"Turn the switch on; equivalent to setting value to true."
        },
        "off": {
          "description":
"Turn the switch off; equivalent to setting value to false."
        },
        "toggle": {
          "description":
"Toggle the switch; equivalent to setting value to its complement."
        }
      }
    }
  }
}
~~~
{: #example1 title="A simple example of an SDF document"}
{: sourcecode-name="example1.sdf.json"}

This is a model of a switch.
The state `value` declared in the `sdfProperty` group, represented by a Boolean, will be true for "on" and will be false for "off".
The actions `on` or `off` declared in the `sdfAction` group are redundant with setting the `value` and are in the example to illustrate that there are often different ways of achieving the same effect.
The action `toggle` will invert the value of the sdfProperty value, so that 2-way switches can be created; having such action will avoid the need for first retrieving the current value and then applying/setting the inverted value.

The `sdfObject` group lists the affordances of Things modeled by this sdfObject.
The `sdfProperty` group lists the property affordances described by the model; these represent various perspectives on the state of the sdfObject.
Properties can have additional qualities to describe the state more precisely.
Properties can be annotated to be read, write or read/write; how this is actually done by the underlying transfer protocols is not described in the SDF model but left to companion protocol bindings.
Properties are often used with RESTful paradigms {{-rest-iot}}, describing state.
The `sdfAction` group is the mechanism to describe other interactions in terms of their names, input, and output data (no data are used in the example), as in a POST method in REST or in a remote procedure call.
The example `toggle` is an Action that
changes the state based on the current state of the Property named `value`.
(The third type of affordance is Events, which are not described in this example.)

In the JSON representation, note how (with the exception of the `info`
group) maps that have keys taken from the SDF vocabulary (`info`,
`namespace`, `sdfObject`) alternate in nesting with maps that have keys
that are freely defined by the model writer (`Switch`, `value`, `on`,
etc.); the latter usually use the `named<>` production in the [formal
syntax of SDF](#syntax), while the former SDF-defined vocabulary items
are often, but not always, called *qualities*.

## Elements of an SDF model

The SDF language uses six predefined Class Name Keywords for modeling connected
Things which are illustrated in {{fig-class-2}}.

~~~ plantuml-utxt
sdfThing --> "0+" sdfObject : hasObject
sdfThing --> "0+" sdfThing : hasThing
sdfThing --> "0+" sdfProperty : hasProperty
sdfThing --> "0+" sdfAction : hasAction
sdfThing --> "0+" sdfEvent : hasEvent

sdfObject --> "0+" sdfProperty : hasProperty
sdfObject --> "0+" sdfAction : hasAction
sdfObject --> "0+" sdfEvent : hasEvent

sdfAction --> "0+" sdfData : hasInputData
sdfAction --> "0+" sdfData : hasOutputData

sdfEvent --> "0+" sdfData : hasOutputData

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

The six main Class Name Keywords are discussed below.

### sdfObject

sdfObjects, the items listed in an `sdfObject` definition group, are
the main "atom" of reusable semantics for model construction.
The concept aligns in scope with common definition items from many IoT modeling
systems, for example ZigBee Clusters {{ZCL}}, OMA SpecWorks LwM2M
Objects {{OMA}}, and
OCF Resource Types {{OCF}}.

An sdfObject definition contains a set of `sdfProperty`, `sdfAction`, and
`sdfEvent` definitions that describe the interaction affordances
associated with some scope of functionality.

For the granularity of definition, sdfObject definitions are meant
to be kept narrow enough in scope to enable broad reuse and
interoperability.
For example, defining a light bulb using separate sdfObject
definitions for on/off control, dimming, and color control affordances
will enable interoperable functionality to be configured for diverse
product types.
An sdfObject definition for a common on/off control may be used to
control may different kinds of Things that require on/off control.

The presence of one or both of the optional qualities "`minItems`" and
"`maxItems`" defines the sdfObject as an array, i.e., all the
affordances defined for the sdfObject exist a number of times, indexed
by a number constrained to be between `minItems` and `maxItems`,
inclusive, if given.
(Note: Setting "`minItems`" to zero and leaving out "`maxItems`" puts the
minimum constraints on that array.)

### sdfProperty

`sdfProperty` is used to model elements of state within Things modeled
by the enclosing grouping.

A named definition entry in an sdfProperty may be associated with some protocol
affordance to enable the application to obtain the state variable and,
optionally, modify the state variable.
Additionally, some protocols provide for in-time reporting of state
changes.
(These three aspects are described by the qualities `readable`,
`writable`, and `observable` defined for an sdfProperty.)

Definitions in `sdfProperty` groups include the definitions from
`sdfData` groups, however, they actually also declare that a Property
with the given qualities potentially is present in the containing sdfObject.

For definitions in `sdfProperty` and `sdfData`, SDF provides qualities that can
constrain the structure and values of data allowed in the interactions
modeled by them, as well as qualities that associate semantics to these
data, such as engineering units and unit scaling information.

For the data definition within `sdfProperty` or `sdfData`, SDF borrows
some vocabulary proposed for the drafts 4 {{-jso4}} {{-jso4v}} and 7
{{-jso}} {{-jso7v}} of the json-schema.org "JSON Schema" format
(collectively called JSO here), enhanced by qualities that are
specific to SDF.
Details about the JSO-inspired vocabulary are in {{jso-inspired}}.
For base SDF, data are constrained to be of
simple types (number, string, Boolean),
JSON maps composed of named data, and arrays of these types.
Syntax extension points are provided that can be used to provide
richer types in a future extension of this specification (possibly more
of which can be borrowed from json-schema.org).

Note that sdfProperty definitions (and sdfData definitions in
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
modeled, an `"object"` type can be used to combine these parameters into one.)
<!-- (using `sdfData` definitions, i.e., the same entries as for `sdfProperty` declarations). -->
Actions may be long-running, that is to say that the effects may not
take place immediately as would be expected for an update to an
sdfProperty; the effects may play out over time and emit action
results.
Actions may also not always complete and may result in application
errors, such as an item blocking the closing of an automatic door.

One idiom for giving an action initiator status and control about the
ongoing action is to provide a URI for an ephemeral "action resource"
in the sdfAction output data, allowing the action to deliver
immediate feedback (including errors that prevent the action from
starting) and the action initiator to use the action resource
for further observation or modification of the ongoing action
(including canceling it).
Base SDF does not provide any tailored support for describing such
action resources; an extension for modeling links in more detail
(for instance, {{-sdflink}}) may be all that is needed to fully enable modeling
them.

Actions may have (or lack) qualities of idempotence and side-effect safety.

Base SDF only provides data constraint modeling and semantics for the input and output data of definitions in `sdfAction` groups.
Again, data definitions for payloads of protocol messages, and
detailed protocol settings for invoking the action, are expected to be
part of the protocol binding.

### sdfEvent {#sdfevent-overview}

The `sdfEvent` group contains declarations of Events, which can model
affordances that inform about "happenings" associated with a Thing
modeled by the enclosing sdfObject; these may result in a signal being
stored or emitted as a result.

Note that there is a trivial overlap with sdfProperty state changes,
which may also be defined as events but are not generally required to
be defined as such.
However, Events may exhibit certain ordering, consistency, and
reliability requirements that are expected to be supported in various
implementations of sdfEvent that do distinguish sdfEvent from
sdfProperty.
For instance, while a state change may simply be superseded by another
state change, some events are "precious" and need to be preserved even
if further events follow.

Base SDF only provides data constraint modeling and
semantics for the output data of Event affordances.
Again, data definitions for payloads of protocol messages, and
detailed protocol settings for invoking the action, are expected to be
part of the protocol binding.


### sdfData

Definitions in `sdfData` groups do not themselves specify affordances.
These definitions
are provided separately from those in
sdfProperty groups to enable common
modeling patterns, data constraints, and semantic anchor concepts to
be factored out for data items that make up sdfProperty items and
serve as input and output data for sdfAction and sdfEvent items.
The sdfData definitions only spring to life by being referenced in
one of these contexts (directly or indirectly via some other sdfData
definitions).

It is a common use case for such a data definition to be shared
between an sdfProperty item and input or output parameters of an
sdfAction or output data provided by an sdfEvent.
sdfData definitions also enable factoring out extended application
data types such as mode and machine state enumerations to be reused
across multiple definitions that have similar basic characteristics
and requirements.

### sdfThing

Back at the top level, the `sdfThing` group enables definition of models for
complex devices that will use one or more sdfObject definitions.
Like sdfObject, sdfThing groups also allow for including interaction
affordances, sdfData, as well as "`minItems`" and "`maxItems`" qualities.
Therefore, they can be seen as a superset of sdfObject groups, additionally
allowing for composition.

As a result, an sdfThing directly or indirectly contains a set of sdfProperty, sdfAction, and
sdfEvent definitions that describe the interaction affordances
associated with some scope of functionality.


A definition in an sdfThing group can refine the metadata of the definitions it
is composed of: other definitions in sdfThing groups or definitions in sdfObject groups.

## Member names: Given Names and Quality Names

SDF documents are JSON maps that mostly employ JSON maps as
member values, which in turn mostly employ JSON maps as their
member values, and so on.
This nested structure of JSON maps creates a tree, where the edges
are the member names (map keys) used in these JSON maps.
(In certain cases, where member names are not needed, JSON arrays may
be interspersed in this tree.)

### Given Names and Quality Names

For any particular JSON map in an SDF document, the set of member
names that are used is either of:

* A set of "*Quality Names*", where the entries in the map are
  Qualities.  Quality Names are defined by the present specification
  and its extensions, together with specific semantics to be
  associated with the member value given with a certain Quality Name.

* A set of "*Given Names*", where the entries in the map are separate
  entities (definitions, declarations, etc.) that each have names that
  are chosen by the SDF document author in order that these names can be
  employed by a user of that model.

In a path from the root of the tree to any leaf, Quality Names and
Given Names roughly alternate (with the information block,
{{information-block}}, as a prominent exception).

The meaning of the JSON map that is the member value associated
with a Given Name is derived from the Quality Name that was used as
the member name associated to the parent.
In the CDDL grammar given in {{syntax}}, JSON maps with member names that are
Given Names are defined using the CDDL generic rule reference `named<membervalues>`,
where `membervalues` is in turn the structure of the member values of the
JSON map, i.e., the value of the member named by the Given Name.
As quality-named maps and given-named maps roughly alternate in
a path down the tree, `membervalues` is usually a map built from
Quality Names as keys.

### Hierarchical Names

From the outside of a specification, Given Names are usually used as
part of a hierarchical name that looks like a JSON pointer {{-pointer}},
itself generally rooted in (used as the fragment identifier in) an
outer namespace that looks like an `https://` URL (see {{names-and-namespaces}}).

As Quality Names and Given Names roughly alternate in a path into the
model, the JSON pointer part of the hierarchical name also alternates
between Quality Names and Given Names.

Note that the actual Given Names may need to be encoded when specified
via the JSON pointer fragment identifier syntax, and that there are
two layers of such encoding: tilde encoding of `~` and `/` as per
{{Section 3 of -pointer}}, and then percent encoding of the
tilde-encoded name into a valid URI fragment as per {{Section 6 of
-pointer}}.
For example, when a model is using the Given Name

~~~
   warning/danger alarm
~~~

 (with an embedded slash and a space) for an
sdfObject, that sdfObject may need to be referenced as

~~~
   #/sdfObject/warning~1danger%20alarm
~~~

To sidestep potential interoperability problems, it is probably wise
to avoid characters in Given Names that need such encoding (Quality
Names are already defined in such a way that they never do).

### Extensibility of Given Names and Quality Names {#gnqn}

In SDF, both Quality Names and Given Names are *extension points*.
This is more obvious for Quality Names: Extending SDF is mostly done
by defining additional qualities.  To enable non-conflicting third
party extensions to SDF, qualified names (names with an embedded
colon) can be used as Quality Names.

A nonqualified Quality Name is composed of ASCII letters, digits, and
`$` signs, starting with a lower case letter or a `$` sign (i.e.,
using a pattern of "⁠`[a-z$][A-Za-z$0-9]*`").
Names with `$` signs are intended to be used for functions separate
from most other names; for instance, in this specification `$comment`
is used for the comment quality (the presence or absence of a
`$comment` quality does not change the meaning of the SDF model).
Names that are composed of multiple English words can use the
"lowerCamelCase" convention {{CamelCase}} for indicating the word
boundaries; no other use is intended for upper case letters in quality
names.

A qualified Quality Name is composed of a Quality Name Prefix, a `:`
(colon) character, and a nonqualified Quality Name.
Quality Name Prefixes are registered in the "Quality Name Prefixes"
sub-registry in the "SDF Parameters" registry ({{qnp}}); they are
composed of lower case ASCII letters and digits, starting with a lower
case ASCII letter (i.e., using a pattern of "⁠`[a-z][a-z0-9]*`").

Given Names are not restricted by the formal SDF syntax.
To enable non-surprising name translations in tools, combinations of
ASCII alphanumeric characters and `-` (ASCII hyphen/minus) are preferred,
typically employing kebab-case for names constructed out of multiple
words {{KebabCase}}.  ASCII hyphen/minus can then unambiguously be
translated to an ASCII `_` underscore character and back depending on
the programming environment.
Some styles also allow a dot `.` in given names.
Given Names are often sufficiently self-explanatory that they can be
used in place of the `label` quality if that is not given.
In turn, if a given name turns out too complicated, a more elaborate
`label` can be given and the given name kept simple.
Base SDF does not address internationalization of
given names.

Further, to enable Given Names to have a more powerful role in building
global hierarchical names, an extension is planned that makes use of
qualified names for Given Names.
So, until that extension is defined, Given Names with (one or more)
embedded colons are reserved and MUST NOT be used in an SDF document.

All names in SDF are case-sensitive.

# SDF structure

SDF definitions are contained in SDF documents, together with data
about the SDF document itself (information block).
Definitions and declarations from additional SDF documents can be
referenced; together with the definitions and declarations in the
referencing SDF document they build the SDF model expressed by that
SDF document.

Each SDF document is represented as a single JSON map.
This map has three blocks: the information block, the namespaces block, and the definitions block.

## Information block

The information block contains generic metadata for the SDF document
itself and all included definitions.
To enable tool integration, the information block is optional in the grammar
of SDF; most processes for working with SDF documents will have policies
that only SDF documents with an info block can be processed.
It is therefore RECOMMENDED that SDF validator tools emit a warning
when no information block is found.

The keyword (map key) that defines an information block is "info". Its
value is a JSON map in turn, with a set of entries that represent qualities that apply to the included definition.

Qualities of the information block are shown in {{infoblockqual}}.

| Quality     | Type             | Required | Description                                                 |
|-------------|------------------|----------|-------------------------------------------------------------|
| title       | string           | no       | A short summary to be displayed in search results, etc.     |
| description | string           | no       | Long-form text description (no constraints)                 |
| version     | string           | no       | The incremental version of the definition                   |
| modified    | string           | no       | Time of the latest modification                             |
| copyright   | string           | no       | Link to text or embedded text containing a copyright notice |
| license     | string           | no       | Link to text or embedded text containing license terms      |
| features    | array of strings | no       | List of extension features used                             |
| $comment    | string           | no       | Source code comments only, no semantics                     |
{: #infoblockqual title="Qualities of the Information Block"}

The version quality is used to indicate version information about the
set of definitions in the SDF document.
The version is RECOMMENDED to be lexicographically increasing over the life of a model: a newer model always has a version string that string-compares higher than all previous versions.
This is easily achieved by following the convention to start the version with an {{RFC3339}} `date-time` or, if new versions are generated less frequently than once a day, just the `full-date` (i.e., YYYY-MM-DD); in many cases, that will be all that is needed (see {{example1}} for an example).
This specification does not give a strict definition for the format of the version string but each using system or organization should define internal structure and semantics to the level needed for their use.
If no further details are provided, a `date-time` or `full-date` in
this field can be assumed to indicate the latest update time of the
definitions in the SDF document.

The modified quality can be used with a value using {{RFC3339}} `date-time` (with `Z` for time-zone) or `full-date` format to express time of the latest revision of the definitions.

The license string is preferably either a URI that points to a web page with an unambiguous definition of the license, or an {{SPDX}} license identifier.
(As an example, for models to be handled by the One Data Model liaison
group, this license identifier will typically be "BSD-3-Clause".)

The `features` quality can be used to list names of critical (i.e., cannot be safely ignored) SDF extension features that need to be understood for the definitions to be properly processed.
Extension feature names will be specified in extension documents.

## Namespaces block

The namespaces block contains the `namespace` map and the `defaultNamespace` setting.

The namespace map is a map from short names for URIs to the namespace URIs
themselves.

The defaultNamespace setting selects one of the entries in the
namespace map by giving its short name.  The associated URI (value of
this entry) becomes the default namespace for the SDF document.

| Quality          | Type   | Required | Description                                                                                          |
|------------------|--------|----------|------------------------------------------------------------------------------------------------------|
| namespace        | map    | no       | Defines short names mapped to namespace URIs, to be used as identifier prefixes                      |
| defaultNamespace | string | no       | Identifies one of the prefixes in the namespace map to be used as a default in resolving identifiers |
{: #nssec title="Namespaces Block"}

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
"defaultNamespace": "cap"
~~~

If no defaultNamespace setting is given, the SDF document does not
contribute to a global namespace (all definitions remain local to the
model and are not accessible for re-use by other models).
As the defaultNamespace is set by giving a
namespace short name, its presence requires a namespace map that contains a
mapping for that namespace short name.

If no namespace map is given, no short names for namespace URIs are
set up, and no defaultNamespace can be given.


## Definitions block

The Definitions block contains one or more groups, each identified by a Class Name Keyword (there can only be one group per keyword; the actual grouping is just a shortcut and does not carry any specific semantics).
The value of each group is a JSON map, the keys of which serve for naming the individual definitions in this group, and the corresponding values provide a set of qualities (name-value pairs) for the individual definition.
(In short, we speak of the map entries as "named sets of qualities".)

Each group may contain zero or more definitions.
Each identifier defined creates a new type and term in the target namespace.
Declarations have a scope of the definition block they are
directly contained in.

A definition may in turn contain other definitions. Each definition is a named set of qualities, i.e., it consists of the newly defined identifier and a set of key-value pairs that represent the defined qualities and contained definitions.

An example for an sdfObject definition is given in {{exobject}}:

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
{: #exobject title="Example sdfObject definition"}

This example defines an sdfObject "foo" that is defined in the default namespace (full address: `#/sdfObject/foo`), containing a property that can be addressed as
`#/sdfObject/foo/sdfProperty/bar`, with data of type boolean.
<!-- we could define a URN-style namespace that looks exactly that way -->

Often, definitions are also declarations: the definition of the
entry "bar" in the property "foo" means that data corresponding to the
"foo" property in a property interaction offered by Thing can have zero or
one components modeled by "bar".  Entries within `sdfProperty`,
`sdfAction`, and `sdfEvent`, in turn within `sdfObject` or `sdfThing` entries, are
declarations; entries within `sdfData` are not.
Similarly, `sdfObject` or `sdfThing` entries within an sdfThing
definition specify that the
interactions offered by a Thing modeled by this sdfThing include the
interactions modeled by the nested `sdfObject` or `sdfThing`.

## Top-level Affordances and sdfData

Besides their placement within an sdfObject or sdfThing, affordances
(i.e., `sdfProperty`, `sdfAction`, and `sdfEvent`) as well as `sdfData` can
also be placed at the top level of an SDF document.
Since they are not associated with an sdfObject or sdfThing, these kinds of
definitions are intended to be re-used via the `sdfRef` mechanism
(see {{sdfref}}).

# Names and namespaces

SDF documents may contribute to a global namespace, and may
reference elements from that global namespace.
(An SDF document that does not set a defaultNamespace does not
contribute to a global namespace.)

## Structure

Global names look exactly like `https://` URIs with attached fragment identifiers.

There is no intention to require that these URIs can be dereferenced.
<!-- Looking things up there is a convenience -->
(However, as future extensions of SDF might find a use for dereferencing
global names, the URI should be chosen in such a way that this may
become possible in the future.
See also {{-deref}} for a discussion of dereferenceable identifiers.)

The absolute URI of a global name should be a URI as per {{Section 3 of
-uri}}, with a scheme of "https" and a path (`hier-part` in {{-uri}}).
For base SDF, the query part should
not be used (it might be used in extensions).

The fragment identifier is constructed as per {{Section 6 of
-pointer}}.

## Contributing global names

The fragment identifier part of a global name defined in an SDF
document is constructed from a JSON pointer that selects the
element defined for this name in the SDF document.

The absolute URI part is a copy of the default namespace, i.e., the
default namespace is always the target namespace for a name for which
a definition is contributed.
When emphasizing that name definitions are contributed to the default namespace,
we therefore also call it the "target namespace" of the SDF document.

For instance, in {{example1}}, definitions for the following global names are contributed:

* https://example.com/capability/cap#/sdfObject/Switch
* https://example.com/capability/cap#/sdfObject/Switch/sdfProperty/value
* https://example.com/capability/cap#/sdfObject/Switch/sdfAction/on
* https://example.com/capability/cap#/sdfObject/Switch/sdfAction/off

Note the `#`, which separates the absolute-URI part ({{Section 4.3 of
-uri}}) from the fragment identifier part.

## Referencing global names

A name reference takes the form of the production `curie` in
{{-curie}} (note that this excludes the production `safe-curie`),
but also limiting the IRIs involved in that production to URIs as per {{-uri}}
and the prefixes to ASCII characters {{-ascii}}.

A name that is contributed by the current SDF document can be
referenced by a Same-Document Reference as per {{Section 4.4 of
-uri}}.
As there is little point in referencing the entire SDF document, this will be a `#` followed by a JSON pointer.
This is the only kind of name reference to itself that is possible in an SDF
document that does not set a default namespace.

Name references that point outside the current SDF document
need to contain curie prefixes.  These then reference namespace
declarations in the namespaces block.

For example, if a namespace prefix is defined:

~~~ json
"namespace": {
  "foo": "https://example.com/"
}
~~~

Then this reference to that namespace:

~~~ json
"sdfRef": "foo:#/sdfData/temperatureData"
~~~

references the global name:

~~~ json
"https://example.com/#/sdfData/temperatureData"
~~~

Note that there is no way to provide a URI scheme name in a curie, so
all references to outside of the document need to go through the
namespace map.

Name references occur only in specific elements of the syntax of SDF:

* copying elements via sdfRef values
* pointing to elements via sdfRequired value elements


## sdfRef {#sdfref}

In a JSON map establishing a definition, the keyword `sdfRef` is used
to copy all of the qualities and enclosed definitions of the referenced definition, indicated
by the included name reference, into the newly formed definition.
(This can be compared to the processing of the `$ref` keyword in {{-jso}}.)

For example, this reference:

~~~ json
"temperatureProperty": {
  "sdfRef": "#/sdfData/temperatureData"
}
~~~

creates a new definition "temperatureProperty" that contains all of the qualities defined in the definition at /sdfData/temperatureData.

The sdfRef member need not be the only member of a map.
Additional members may be present with the intention to override parts
of the referenced map or to add new qualities or definitions.

When processing sdfRef, if the target definition contains also sdfRef (i.e., is based on yet another definition), that MUST be processed as well.

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

Note that the formal syntaxes given in Appendices {{<syntax}} and {{<jso}}
generally describe the _result_ of applying a merge-patch; the notations
are not powerful enough to describe, for instance, the effect of null
values given with the sdfRef to remove members of JSON maps from
the referenced target.  Nonetheless, the syntaxes also give the syntax
of the sdfRef itself, which vanishes during the resolution; in many
cases therefore even merge-patch inputs will validate with these
formal syntaxes.

Given the example ({{example1}}), and the following definition:

~~~ json
{
  "info": {
    "title": "Example light switch using sdfRef"
  },
  "namespace": {
    "cap": "https://example.com/capability/cap"
  },
  "defaultNamespace": "cap",
  "sdfObject": {
    "BasicSwitch": {
      "sdfRef": "cap:#/sdfObject/Switch",
      "sdfAction": {
        "toggle": null
      }
    }
  }
}
~~~

The resulting definition of the "BasicSwitch" sdfObject would be identical to the definition of the "Switch" sdfObject except it would not contain the "toggle" Action.

~~~ json
{
  "info": {
    "title": "Example light switch using sdfRef"
  },
  "namespace": {
    "cap": "https://example.com/capability/cap"
  },
  "defaultNamespace": "cap",
  "sdfObject": {
    "BasicSwitch": {
      "sdfProperty": {
        "value": {
          "description":
"The state of the switch; false for off and true for on.",
          "type": "boolean"
        }
      },
      "sdfAction": {
        "on": {
          "description":
"Turn the switch on; equivalent to setting value to true."
        },
        "off": {
          "description":
"Turn the switch off; equivalent to setting value to false."
        }
      }
    }
  }
}
~~~
{: sourcecode-name="example1-without-toggle.sdf.json"}


### Resolved models

A model where all sdfRef references are processed as described in {{sdfref}} is called a resolved model.

For example, given the following sdfData definitions:

~~~ json
"sdfData": {
  "Coordinate" : {
    "type": "number", "unit": "m"
  },
  "X-Coordinate" : {
    "sdfRef" : "#/sdfData/Coordinate",
    "description":
"Distance from the base of the Thing along the X axis."
  },
  "Non-neg-X-Coordinate" : {
    "sdfRef": "#/sdfData/X-Coordinate",
    "minimum": 0
  }
}
~~~

After resolving the definitions would look as follows:

~~~ json
"sdfData": {
  "Coordinate" : {
    "type": "number", "unit": "m"
  },
  "X-Coordinate" : {
    "description":
"Distance from the base of the Thing along the X axis.",
    "type": "number", "unit": "m"
  },
  "Non-neg-X-Coordinate" : {
    "description":
"Distance from the base of the Thing along the X axis.",
    "minimum": 0, "type": "number", "unit": "m"
  }
}
~~~

## sdfRequired

The keyword `sdfRequired` is provided to apply a constraint that
defines for which declarations the corresponding data are mandatory in a
Thing modeled by the current definition.

The value of `sdfRequired` is an array of references, each indicating
one or more declarations that are mandatory to be represented.

References in this array can be SDF names (JSON Pointers), or one of
two abbreviated reference formats:

* a text string with a "referenceable-name", i.e., an affordance name or grouping name.
All affordance declarations that are directly (i.e., not nested further in another grouping) in the same grouping and that
carry this name (there can be multiple ones, one per affordance type)
are declared to be mandatory to be represented. The same applies for
groupings made mandatory within groupings containing them.
* the Boolean value `true`.
The affordance/grouping itself that carries the `sdfRequired` keyword is declared
to be mandatory to be represented.

Note that referenceable-names are not
subject to the encoding JSON pointers require as discussed in {{hierarchical-names}}.
To ensure that referenceable-names are reliably distinguished from JSON pointers,
they are defined such that they cannot contain ":" or
"#" characters (see rule `referenceable-name` in {{syntax}}).
(If these characters are indeed contained in a Given Name, a JSON
pointer needs to be formed instead in order to reference it in "sdfRequired",
potentially requiring further path elements as well as JSON pointer
encoding.  The need for this is best avoided by choosing Given Names
without these characters.)

The example in {{example-req}} shows two required elements in the sdfObject definition for "temperatureWithAlarm", the sdfProperty "currentTemperature", and the sdfEvent "overTemperatureEvent". The example also shows the use of JSON pointer with "sdfRef" to use a pre-existing definition in this definition, for the "alarmType" data (sdfOutputData) produced by the sdfEvent "overTemperatureEvent".

~~~ json
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
              "sdfRef": "cap:#/sdfData/alarmTypes/quantityAlarms",
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
~~~
{: #example-req title="Using sdfRequired"}

In {{example-req}}, the same sdfRequired can also be represented in
short form:

~~~ json
    "sdfRequired": ["currentTemperature", "overTemperatureEvent"]
~~~

Or, for instance "overTemperatureEvent" could carry

~~~ json
      "overTemperatureEvent": {
        "sdfRequired": [true],
        "...": "..."
      }
~~~

## Common Qualities

Definitions in SDF share a number of qualities that provide metadata for
them.  These are listed in {{tbl-common-qualities}}.  None of these
qualities are required or have default values that are assumed if the
quality is absent.
If a label is required for an application and no label is given in the SDF model, the
last part (`reference-token`, {{Section 3 of -pointer}}) of the JSON
pointer to the definition can be used.

| Quality     | Type         | Description                                          |
|-------------|--------------|------------------------------------------------------|
| description | string       | long text (no constraints)                           |
| label       | string       | short text (no constraints)                          |
| $comment    | string       | source code comments only, no semantics              |
| sdfRef      | sdf-pointer  | (see {{sdfref}})                                        |
| sdfRequired | pointer-list | (see {{sdfrequired}}, used in affordances or groupings) |
{: #tbl-common-qualities title="Common Qualities"}

## Data Qualities

Data qualities are used in sdfData and sdfProperty definitions,
which are named sets of data qualities (abbreviated as `named-sdq`).

{{jso-inspired}} lists data qualities inspired by the various
proposals at json-schema.org; the
intention is that these (information model level) qualities are
compatible with the (data model) semantics from the
versions of the json-schema.org proposal they were imported from.

{{sdfdataqual2}} lists data qualities defined specifically for the
present specification.

| Quality       | Type                                        | Description                                                              | Default |
|---------------+---------------------------------------------+--------------------------------------------------------------------------+---------|
| (common)      |                                             | {{common-qualities}}                                                     |         |
| unit          | string                                      | unit name (note 1)                                                       | N/A     |
| nullable      | boolean                                     | indicates a null value is available for this type                        | true    |
| contentFormat | string                                      | content type (IANA media type string plus parameters), encoding (note 2) | N/A     |
| sdfType       | string ({{sdftype}})                        | sdfType enumeration (extensible)                                         | N/A     |
| sdfChoice     | named set of data qualities ({{sdfchoice}}) | named alternatives                                                       | N/A     |
| enum          | array of strings                            | abbreviation for string-valued named alternatives                        | N/A     |
{: #sdfdataqual2 title="SDF-defined Qualities of sdfData"}


1. Note that the quality `unit` was called `units` in earlier drafts
   of SDF.
   The unit name SHOULD be as
   per the {{senml-units (SenML Units)<RFC8428}} Registry
   or the {{secondary-units (Secondary Units)<RFC8798}} Registry in {{-units}}
   as specified by
   {{Sections 4.5.1 and 12.1 of -senml}} and {{Section 3 of
   -senml-units-2}}, respectively.

   Exceptionally, if a registration in these registries cannot be
   obtained or would be inappropriate, the unit name can also be a URI
   that is pointing to a definition of the unit.  Note that SDF
   processors are not expected to (and normally SHOULD NOT)
   dereference these URIs (see also {{-deref}}); they may be useful to
   humans, though.
   A URI unit name is distinguished from a registered unit name by the
   presence of a colon; any registered unit names that contain a colon (at
   the time of writing, none) can therefore not be used in SDF.

   For use by translators into ecosystems that require URIs for unit
   names, the URN sub-namespace "urn:ietf:params:unit" is provided
   ({{unit-urn}}); URNs from this sub-namespace MUST NOT be used in a
   `unit` quality, in favor of simply notating the unit name (such as
   `kg` instead of `urn:ietf:params:unit:kg`).

2. The `contentFormat` quality follows the Content-Format-Spec as defined in
   {{Section 6 of RFC9193}}, allowing for expressing both numeric and string
   based Content-Formats.

### sdfType

SDF defines a number of basic types beyond those provided by JSON or
JSO.  These types are identified by the `sdfType` quality, which
is a text string from a set of type names defined by the  "sdfType
values" sub-registry in the "SDF Parameters" registry
({{sdftype-values}}).
The sdfType name is composed of lower case ASCII letters, digits,
and `-` (ASCII hyphen/minus) characters, starting
with a lower case ASCII letter (i.e., using a pattern of
"⁠`[a-z][-a-z0-9]*`"), typically employing kebab-case for
names constructed out of multiple words {{KebabCase}}.

To aid interworking with JSO implementations, it is RECOMMENDED
that sdfType is always used in conjunction with the `type` quality
inherited from {{-jso7v}}, in such a way as to yield a common
representation of the type's values in JSON.

Values for sdfType that are defined in this specification are shown in
{{sdftype1}}.
This table also gives a description of the semantics of the sdfType,
the conventional value for `type` to be used with the sdfType value,
and a conventional JSON representation for values of the type.

| sdfType     | Description                      | type   | JSON Representation                                        |
|-------------|----------------------------------|--------|------------------------------------------------------------|
| byte-string | A sequence of zero or more bytes | string | base64url without padding ({{Section 3.4.5.2 of RFC8949}}) |
| unix-time   | A point in civil time (note 1)   | number | POSIX time ({{Section 3.4.2 of RFC8949}})                  |
{: #sdftype1 title="Values defined in base SDF for the sdfType quality"}

(1) Note that the definition of `unix-time` does not imply the
capability to represent points in time that fall on leap seconds.
More date/time-related sdfTypes are likely to be added in the sdfType
value registry.

(In earlier drafts of this specification, a similar concept was called `subtype`.)

### sdfChoice

Data can be a choice of named alternatives, called `sdfChoice`.
Each alternative is identified by a name (string, key in the outer JSON
map used to represent the overall choice) and a set of dataqualities
(each in an inner JSON map, the value used to represent the
individual alternative in the outer JSON map).
Dataqualities that are specified at the same level as the sdfChoice
apply to all choices in the sdfChoice, except those specific choices
where the dataquality is overridden at the choice level.

sdfChoice merges the functions of two constructs found in {{-jso7v}}:

* `enum`

  What would have been

  ~~~ json
  "enum": ["foo", "bar", "baz"]
  ~~~

  in earlier drafts of this specification, is often best represented as:

  ~~~ json
  "sdfChoice": {
    "foo": { "description": "This is a foonly"},
    "bar": { "description":
  "As defined in the second world congress"},
    "baz": { "description": "From zigbee foobaz"}
  }
  ~~~

  This allows the placement of other dataqualities such as
  `description` in the example.

  If an enum needs to use a data type different from text string,
  what would for instance have been:

  ~~~ json
  "type": "number",
  "enum": [1, 2, 3]
  ~~~

  in earlier drafts of this specification, is represented as:

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
  example, for instance, if the actual string value is indeed a crucial
  element for the data model.)

* anyOf

  JSO provides a type union called `anyOf`, which provides a
  choice between anonymous alternatives.

  What could have been in JSO:

  ~~~ json
  "anyOf": [
    {"type": "array", "minItems": 3, "maxItems": "3",
     "items": {"$ref": "#/sdfData/rgbVal"}},
    {"type": "array", "minItems": 4, "maxItems": "4",
     "items": {"$ref": "#/sdfData/cmykVal"}}
  ]
  ~~~

  can be more descriptively notated in SDF as:

  ~~~ json
  "sdfChoice": {
    "rgb": {"type": "array", "minItems": 3, "maxItems": "3",
            "items": {"sdfRef": "#/sdfData/rgbVal"}},
    "cmyk": {"type": "array", "minItems": 4, "maxItems": "4",
             "items": {"sdfRef": "#/sdfData/cmykVal"}}
  }
  ~~~

Note that there is no need in SDF for the type intersection construct
`allOf` or the peculiar type-xor construct `oneOf` found in {{-jso7v}}.

As a simplification for users of SDF models who are accustomed to
the JSO enum keyword, this is retained, but limited to a choice
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

In a single definition, the keyword `enum` cannot be used at the same
time as the keyword `sdfChoice`, as the former is just syntactic
sugar for the latter.

# Keywords for definition groups {#kw-defgroups}

The following SDF keywords are used to create definition groups in the target namespace.
All these definitions share some common qualities as discussed in {{common-qualities}}.

## sdfObject

The `sdfObject` keyword denotes a group of zero or more sdfObject definitions.
sdfObject definitions may contain or include definitions of Properties, Actions, Events declared for the sdfObject, as well as data types (sdfData group) to be used in this or other sdfObjects.

The qualities of an sdfObject include the common qualities, additional qualities are shown in {{sdfobjqual}}.
None of these
qualities are required or have default values that are assumed if the
quality is absent.

| Quality     | Type      | Description                                                              |
|-------------+-----------+--------------------------------------------------------------------------|
| (common)    |           | {{common-qualities}}                                                     |
| sdfProperty | property  | zero or more named property definitions for this sdfObject               |
| sdfAction   | action    | zero or more named action definitions for this sdfObject                 |
| sdfEvent    | event     | zero or more named event definitions for this sdfObject                  |
| sdfData     | named-sdq | zero or more named data type definitions that might be used in the above |
| minItems    | number    | (array) Minimum number of multiplied affordances in array |
| maxItems    | number    | (array) Maximum number of multiplied affordances in array    |
{: #sdfobjqual title="Qualities of sdfObject"}


## sdfProperty

The `sdfProperty` keyword denotes a group of zero or more Property definitions.

Properties are used to model elements of state.

The qualities of a Property definition include the data qualities (and
thus the common qualities), see {{data-qualities}}, additional qualities are shown in {{sdfpropqual}}.

| Quality       | Type      | Description                                             | Default |
|---------------+-----------+---------------------------------------------------------|---------|
| (data)        |           | {{data-qualities}}                                      |         |
| readable      | boolean   | Reads are allowed                                       | true    |
| writable      | boolean   | Writes are allowed                                      | true    |
| observable    | boolean   | flag to indicate asynchronous notification is available | true    |
{: #sdfpropqual title="Qualities of sdfProperty"}

## sdfAction

The `sdfAction` keyword denotes a group of zero or more Action definitions.

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
type `"object"` can be used to substructure either data item, with
optionality indicated by the data quality `required`.

## sdfEvent

The `sdfEvent` keyword denotes zero or more Event definitions.

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
type `"object"` can be used to substructure the output data item, with
optionality indicated by the data quality `required`.

## sdfData

The `sdfData` keyword denotes a group of zero or more named data type
definitions (named-sdq).

An sdfData definition provides a reusable semantic identifier for a
type of data item and describes the constraints on the defined type.
It is not itself a declaration, i.e., it does not cause any of these
data items to be included in an affordance definition.

The qualities of sdfData include the data qualities (and thus the common qualities), see {{data-qualities}}.

# High Level Composition

The requirements for high level composition include the following:

- The ability to represent products, standardized product types, and modular products while maintaining the atomicity of sdfObjects.

- The ability to compose a reusable definition block from sdfObjects, for example a single plug unit of an outlet strip with on/off control, energy monitor, and optional dimmer sdfObjects, while retaining the atomicity of the individual sdfObjects.

- The ability to compose sdfObjects and other definition blocks into a higher level sdfThing that represents a product, while retaining the atomicity of sdfObjects.

- The ability to enrich and refine a base definition to have
  product-specific qualities and quality values, such as unit, range, and scale settings.

- The ability to reference items in one part of a complex definition from another part of the same definition, for example to summarize the energy readings from all plugs in an outlet strip.

## Paths in the model namespaces

The model namespace is organized according to terms that are defined
in the SDF documents that contribute to the namespace. For example, definitions that originate from an organization or vendor are expected to be in a namespace that is specific to that organization or vendor.

The structure of a path in a namespace is defined by the JSON Pointers
to the definitions in the SDF documents in that namespace.
For example, if there is an SDF document defining an sdfObject "`Switch`"
with an action "`on`", then the reference to the action would be
"`ns:/sdfObject/Switch/sdfAction/on`" where `ns` is the namespace prefix
(short name for the namespace).

## Modular Composition

Modular composition of definitions enables an existing definition
(could be in the same or another SDF document) to become part of a new definition by including a reference to the existing definition within the model namespace.

### Use of the "sdfRef" keyword to re-use a definition

An existing definition may be used as a template for a new definition, that is, a new definition is created in the target namespace which uses the defined qualities of some existing definition. This pattern will use the keyword `sdfRef` as a quality of a new definition with a value consisting of a reference to the existing definition that is to be used as a template.

In the definition that uses `sdfRef`, new qualities may be added
and existing qualities from the referenced definition may be
overridden.  (Note that JSON maps do not have a defined
order, so the SDF processor may see these overrides before seeing the
`sdfRef`.)

Note that if the referenced definition contains qualities or
definitions that are not valid in the context where the sdfRef is used
(for instance, if an sdfThing definition would be added in an sdfObject definition), the resulting model, when resolved, may be invalid.

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
    "minimum": 5e-2,
    "description": "Cables must be at least 5 cm."
  }
~~~
{: #exa-sdfref}

## sdfThing

An sdfThing is a set of declarations and qualities that may be part of
a more complex model. For example, the sdfObject declarations that make
up the definition of a single socket of an outlet strip could be
encapsulated in an sdfThing, which itself could be used in a declaration in the sdfThing definition for the outlet strip
(see {{exa-sdfthing-outlet-strip}} in {{outlet-strip-example}} for an example SDF model).

sdfThing definitions carry semantic meaning, such as a defined refrigerator compartment and a defined freezer compartment, making up a combination refrigerator-freezer product.
An sdfThing may be composed of sdfObjects and other sdfThings.
It can also contain sdfData definitions, as well as declarations of interaction affordances itself, such
as a status (on/off) for the refrigerator-freezer as a whole (see
{{exa-sdfthing-fridge-freezer}} in {{fridge-freezer-example}} for an example SDF
model illustrating these aspects).

The qualities of sdfThing are shown in {{sdfthingqual}}.
Analogous to sdfObject, the presence of one or both of the optional
qualities "`minItems`" and "`maxItems`" defines the sdfThing as an
array.

| Quality     | Type      | Description                                                              |
|-------------|-----------|--------------------------------------------------------------------------|
| (common)    |           | {{common-qualities}}                                                     |
| sdfThing    | thing     |                                                                          |
| sdfObject   | object    |                                                                          |
| sdfProperty | property  | zero or more named property definitions for this thing                   |
| sdfAction   | action    | zero or more named action definitions for this thing                     |
| sdfEvent    | event     | zero or more named event definitions for this thing                      |
| sdfData     | named-sdq | zero or more named data type definitions that might be used in the above |
| minItems    | number    | (array) Minimum number of multiplied affordances in array      |
| maxItems    | number    | (array) Maximum number of multiplied affordances in array                |
{: #sdfthingqual title="Qualities of sdfThing"}


IANA Considerations {#iana}
===================


[^replace-xxxx]

[^replace-xxxx]: RFC Ed.: throughout this section, please replace RFC XXXX with this RFC number, and remove this note.

Media Type
-----------

IANA is requested to add the following Media-Type to the "Media Types" registry.

| Name     | Template             | Reference                 |
| sdf+json | application/sdf+json | RFC XXXX, {{media-type}}  |
{: align="left" title="Media Type Registration for SDF"}

{:compact}
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
  and related environments

Fragment identifier considerations:
: A JSON Pointer fragment identifier may be used, as defined in
  {{Section 6 of RFC6901}}.

Additional information:
: Magic number(s):
  : n/a

  File extension(s):
  : .sdf.json

  Windows Clipboard Name:
  : "Semantic Definition Format (SDF) for Data and Interactions of Things"

  Macintosh file type code(s):
  : n/a

  Macintosh Universal Type Identifier code:
  : org.ietf.sdf-json<br>
    conforms to public.text

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

Content-Format
--------------

This document adds the following Content-Format to the "CoAP Content-Formats",
within the "Constrained RESTful Environments (CoRE) Parameters"
registry, where TBD1 comes from the "IETF Review" 256-999 range.

| Content Type         | Content Coding | ID   | Reference |
| application/sdf+json | -              | TBD1 | RFC XXXX  |
{: align="left" title="SDF Content-format Registration"}

// RFC Ed.: please replace TBD1 with the assigned ID, remove the
requested range, and remove this note.\\
// RFC Ed.: please replace RFC XXXX with this RFC number and remove this note.



IETF URN Sub-namespace for Unit Names (urn:ietf:params:unit) {#unit-urn}
-------------------------------------

IANA is requested to register the following value in the "{{params-1
(IETF URN Sub-namespace for Registered Protocol Parameter
Identifiers)<IANA.params}}" registry in {{IANA.params}}, following the template in
{{!RFC3553}}:

Registry name:
: unit

Specification:
: RFC XXXX

Repository:
:  combining the symbol values from the {{senml-units (SenML
   Units)<IANA.senml}} Registry and the {{secondary-units (Secondary
   Units)<IANA.senml}} Registry in {{-units}} as specified by {{Sections
   4.5.1 and 12.1 of -senml}} and {{Section 3 of -senml-units-2}},
   respectively (which by the registration policy are guaranteed to be
   non-overlapping).

Index value:
: Percent-encoding ({{Section 2.1 of -uri}}) is required of
  any characters in unit names as required by ABNF rule "pchar" in
  {{Section 3.3 of -uri}}, specifically at the time of writing for the
  unit names "%" (deprecated in favor of "/"), "%RH", "%EL".

Registries
----------

IANA is requested to create an "SDF Parameters" registry, with the
sub-registries defined in this Section.

### Quality Name Prefixes {#qnp}

IANA is requested to create a "Quality Name Prefixes" sub-registry in
the "SDF Parameters" registry, with the following template:

Prefix:
: A name composed of lower case ASCII letters and digits, starting
  with a lower case ASCII letter (i.e., using a pattern of "⁠`[a-z][a-z0-9]*`").

Contact:
: A contact point for the organization that assigns quality names with
  this prefix.

Quality Name Prefixes are intended to be registered by organizations
that intend to define quality names constructed with an
organization-specifix prefix ({{gnqn}}).

The registration policy is Expert Review as per {{Section 4.5 of -reg}}.
The instructions to the Expert are to ascertain that the organization
will handle quality names constructed using their prefix in a way that
roughly achieves the objectives for an IANA registry that support
interoperability of SDF models employing these quality names,
including:

* Stability, "stable and permanent";
* Transparency, "readily available", "in sufficient detail" ({{Section
  4.6 of -reg}}).

The Expert will take into account that other organizations operate in
different ways than the IETF, and that as a result some of these
overall objectives will be achieved in a different way and to a
different level of comfort.

The "Quality Name Prefixes" sub-registry starts out empty.

### sdfType Values

IANA is requested to create a "sdfType values" sub-registry in
the "SDF Parameters" registry, with the following template:

Name:
: A name composed of lower case ASCII letters, digits and `-` (ASCII
  hyphen/minus) characters, starting with a lower case ASCII letter
  (i.e., using a pattern of "⁠`[a-z][-a-z0-9]*`").

Description:
: A short description of the information model level structure and semantics

type:
: The value of the quality "type" to be used with this sdfType

JSON Representation
: A short description of a JSON representation that can be used for
  this sdfType.  This MUST be consistent with the type.

Reference:
: A more detailed specification of meaning and use of sdfType.

sdfType values are intended to be registered to enable modeling additional
SDF-specific types (see {{sdftype}}).

The registration policy is Specification Required as per {{Section 4.6 of
-reg}}.  The instructions to the Expert are to ascertain that the
specification provides enough detail to enable interoperability
between implementations of the sdfType being registered, and that
names are chosen with enough specificity that ecosystem-specific
sdfTypes will not be confused with more generally applicable ones.

The initial set of registrations is described in {{sdftype-r}}.

| Name        | Description                      | type   | JSON Representation       | Reference                    |
|-------------+----------------------------------+--------+---------------------------+------------------------------|
| byte-string | A sequence of zero or more bytes | string | base64url without padding | {{Section 3.4.5.2 of RFC8949}} |
| unix-time   | A point in civil time            | number | POSIX time                | {{Section 3.4.2 of RFC8949}}   |
{: #sdftype-r title="Initial set of sdfType values"}

Security Considerations {#seccons}
=======================

Some wider security considerations applicable to Things are discussed
in {{-seccons}}.
{{Section 5 of -cddl}} gives an overview over security considerations
that arise when formal description techniques are used to govern
interoperability; analogs of these security considerations can apply
to SDF.

The security considerations of underlying building blocks such as
those detailed in {{Section 10 of -utf8}} apply.
SDF uses JSON as a representation language; for a number of
cases {{-json}} indicates that implementation behavior for certain constructs
allowed by the JSON grammar is unpredictable.
Implementations need to be robust against invalid or unpredictable
cases on input, preferably by rejecting input that is invalid or
that would lead to unpredictable behavior, and need to avoid generating
these cases on output.

Implementations of model languages may also exhibit
performance-related availability issues when the attacker can control
the input, see {{Section 4.1 of -jsonpath}} for a brief discussion.

SDF may be used in two processes that are often security relevant:
model-based *validation* of data that is intended to be described by SDF models, and
model-based *augmentation* of these data with information obtained from the SDF
models that apply.

Implementations need to ascertain the provenance (and thus
authenticity and integrity) and applicability of
the SDF models they employ operationally in such security relevant ways.
Implementations that make use of the composition mechanisms defined in this
document need to do this for each of the components they combine
into the SDF models they employ.
Essentially, this process needs to undergo the same care and scrutiny
as any other introduction of source code into a build environment; the
possibility of supply-chain attacks on the modules imported needs to
be considered.

Specifically, implementations might rely on model-based input
validation for enforcing certain properties of the data structure
ingested (which, if not validated, could lead to malfunctions such as
crashes and remote code execution).
These implementations need to be particularly careful
about the data models they apply, including their provenance and
potential changes of these properties that upgrades to the referenced
modules may (inadvertently or as part of an attack) cause.
More generally speaking, implementations should strive to be robust
against expected and unexpected limitations of the model-based input
validation mechanisms and their implementations.

Similarly, implementations that rely on model-based augmentation may
generate false data from their inputs; this is an integrity violation
in any case but also can possibly be exploited for further attacks.

In applications that dynamically acquire models and obtain modules
from module references in these, the security considerations of
dereferenceable identifiers apply (see {{-deref}} for a more extensive
discussion of dereferenceable identifiers).

There may be confidentiality requirements on SDF models, both on their
content and on the fact that a specific model is used in a particular
Thing or environment.
The present specification does not discuss model discovery or define
an access control model for SDF models, nor does it define a way to
obtain selective disclosure where that may be required.
It is likely that these definitions require additional context from
underlying ecosystems and the characteristics of the protocols
employed there; this is therefore left as future work (e.g., for
documents such as {{-mapping}}).

--- back

# Formal Syntax of SDF {#syntax}

This normative appendix describes the syntax of SDF using CDDL {{-cddl}}.

This appendix shows the framework syntax only, i.e., a syntax with liberal extension points.
Since this syntax is nearly useless in finding typos in an SDF
specification, a second syntax, the validation syntax, is defined that
does not include the extension points.
The validation syntax can be generated from the framework syntax by
leaving out all lines containing the string `EXTENSION-POINT`; as this
is trivial, the result is not shown here.

This appendix makes use of CDDL "features" as defined in {{Section 4 of -control}}.
Features whose names end in "-ext" indicate extension points for
further evolution.

~~~ cddl
{::include sdf-framework.cddl}
~~~


# json-schema.org Rendition of SDF Syntax {#jso}

This informative appendix describes the syntax of SDF defined in {{syntax}}, but
using a version of the description techniques advertised on
json-schema.org {{-jso}} {{-jso7v}}.

The appendix shows both the validation and the framework syntax.
Since most of the lines are the same between these two files, those lines are shown only once, with a leading space, in the form of a unified diff.
Lines leading with a `-` are part of the validation syntax, and lines leading with a `+` are part of the framework syntax.

~~~ jso.json
{::include sdf.jso.json-unidiff}
~~~

# Data Qualities inspired by json-schema.org {#jso-inspired}

This appendix is normative.

Data qualities define data used in SDF affordances at an information
model level.
A popular way to describe JSON data at a data model level is proposed
by a number of drafts on json-schema.org (which collectively are
abbreviated JSO here); for reference to a popular version we will
point here to {{-jso}} and {{-jso7v}}.
As the vocabulary used by JSO is familiar to many JSON modelers, the
present specification borrows some of the terms and ports their
semantics to the information model level needed for SDF.

The main data quality imported is the "`type`".
In SDF, this can take one of six (text string) values, which are
discussed in the following subsections (note that the JSO type
"`null`" is not supported as a value of this data quality in SDF).

The additional quality "`const`" restricts the data to one specific
value (given as the value of the `const` quality).

Similarly, the additional quality "`default`" provides data that can
be used in the absence of the data (given as the value of the `const`
quality); this is mainly documentary and not very well-defined for SDF
as no process is defined that would add default values to an instance
of some interaction data.


## type "`number`", type "`integer`"

The types "`number`" and "`integer`" are associated with floating point
and integer numbers, as they are available in JSON.
A type value of `integer` means that only integer values of JSON
numbers can be used (note that `10.0` is an integer value, even if it
is in a notation that would also allow non-zero decimal fractions).

The additional data qualities "`minimum`", "`maximum`",
"`exclusiveMinimum`", "`exclusiveMaximum`" provide number values that
serve as inclusive/exclusive lower/upper bounds for the number.
(Note that the Boolean form of
"`exclusiveMinimum`"/"`exclusiveMaximum`" found in earlier JSO drafts {{-jso4v}}
is not used.)

The data quality "`multipleOf`" gives a positive number that
constrains the data value to be an integer multiple of the number
given.
(Type "`integer`" can also be expressed as a "`multipleOf`" quality of
value 1, unless another "`multipleOf`" quality is present.)


## type "`string`"

The type "`string`" is associated with Unicode text string values as
they can be represented in JSON.

The length (as measured in characters) can be constrained by the
additional data qualities "`minLength`" and "`maxLength`", which are
inclusive bounds.

(More specifically, Unicode text strings as defined in this
specification are sequences of Unicode scalar values, the number of
which is taken as the length of such a text string.
Note that earlier drafts of this specification explained
text string length values in bytes, which however is not meaningful
unless bound to a specific encoding — which could be UTF-8, if this
unusual behavior is to be provided in an extension.)

The data quality "`pattern`" takes a string value that is interpreted
as an [ECMA-262] regular expression in Unicode mode that constrains the
string (note that these are not anchored by default, so unless `^` and
`$` anchors are employed, ECMA-262 regular expressions match any string that *contains* a match).
The JSO proposals acknowledge that regular expression support is
rather diverse in various platforms, so the suggestion is to limit
them to:

{:compact}
* characters;
* character classes in square brackets, including ranges; their complements;
* simple quantifiers `*`, `+`, `?`, and range quantifiers `{n}`,
  `{n,m}`, and `{n,}`;
* grouping parentheses;
* the choice operator `|`;
* and anchors (beginning-of-input `^` and end-of-input `$`).

Note that this subset is somewhat similar to the subset introduced by
I-Regexps {{-iregexp}}, which however are anchored
regular expressions, and which include certain backslash escapes for
characters and character classes.

The additional data quality "`format`" can take one of the following
values.  Note that, at an information model level, the presence of
this data quality changes the type from being a simple text string to
the abstract meaning of the format given (i.e., the format "date-time"
is less about the specific syntax employed in {{RFC3339}} than about the usage
as an absolute point in civil time).

{:compact}
* "`date-time`", "`date`", "`time`":
  An {{RFC3339}} `date-time`, `full-date`, or `full-time`, respectively.
* "`uri`", "`uri-reference`":
  An {{RFC3986}} URI or URI Reference, respectively.
* "`uuid`": An {{RFC4122}} UUID.

## type "`boolean`"

The type "`boolean`" can take the values "`true`" or "`false`".

## type "`array`"

The type "`array`" is associated with arrays as they are available in
JSON.

The additional quality "`items`" gives the type that each of the
elements of the array must match.

The number of elements in the array can be constrained by the additional
data qualities "`minItems`" and "`maxItems`", which are inclusive
bounds.

The additional data quality "`uniqueItems`" gives a Boolean value
that, if true, requires the elements to be all different.

## type "`object`"

The type "`object`" is associated with maps, from strings to values, as
they are available in JSON.

The additional quality "`properties`" is a map the entries of which
describe entries in the specified JSON map: The key gives an
allowable map key for the specified JSON map, and the value is a
map with a named set of data qualities giving the type for the
corresponding value in the specified JSON map.

All entries specified this way are optional, unless they are listed in
the value of the additional quality "`required`", which is an array of
string values that give the key names of required entries.

Note that the term "properties" as an additional quality for
defining map entries is unrelated to sdfProperty.

## Implementation notes

JSO-based keywords are also used in the specification techniques of a
number of ecosystems, but some adjustments may be required.

For instance, {{OCF}} is based on Swagger 2.0 which appears to be based on
"draft-4" {{-jso4}}{{-jso4v}} (also called draft-5, but semantically intended to
be equivalent to draft-4).
The "`exclusiveMinimum`" and "`exclusiveMaximum`" keywords use the
Boolean form there, so on import to SDF their values have to be
replaced by the values of the respective "`minimum`"/"`maximum`"
keyword, which are themselves then removed; the reverse transformation
applies on export.

# Composition Examples {#composition-examples}

This informative appendix contains two examples illustrating different composition approaches
using the `sdfThing` quality.

## Outlet Strip Example {#outlet-strip-example}

~~~ json
{
  "sdfThing": {
    "outlet-strip": {
      "label": "Outlet strip",
      "description": "Contains a number of Sockets",
      "sdfObject": {
        "socket": {
          "description": "An array of sockets in the outlet strip",
          "minItems": 2,
          "maxItems": 10
        }
      }
    }
  }
}
~~~
{: sourcecode-name="example-sdfthing-outlet-strip.sdf.json"}
{: #exa-sdfthing-outlet-strip}

## Refrigerator-Freezer Example {#fridge-freezer-example}

~~~ json
{
  "sdfThing": {
    "refrigerator-freezer": {
      "description": "A refrigerator combined with a freezer",
      "sdfProperty": {
        "status": {
          "type": "boolean",
          "description":
"Indicates if the refrigerator-freezer is powered"
        }
      },
      "sdfObject": {
        "refrigerator": {
          "description": "A refrigerator compartment",
          "sdfProperty": {
            "temperature": {
              "sdfRef": "#/sdfProproperty/temperature",
              "maximum": 8
            }
          }
        },
        "freezer": {
          "label": "A freezer compartment",
          "sdfProperty": {
            "temperature": {
              "sdfRef": "#/sdfProproperty/temperature",
              "maximum": -6
            }
          }
        }
      }
    }
  },
  "sdfProperty": {
    "temperature": {
      "description": "The temperature for this compartment",
      "type": "number",
      "unit": "Cel"
    }
  }
}
~~~
{: sourcecode-name="example-sdfthing-refrigerator-freezer.sdf.json"}
{: #exa-sdfthing-fridge-freezer}

# Acknowledgements
{:unnumbered}

This specification is based on work by the One Data Model group.

<!--  LocalWords:  SDF namespace defaultNamespace instantiation OMA
 -->
<!--  LocalWords:  affordances ZigBee LWM OCF sdfObject sdfThing
 -->
<!--  LocalWords:  Thingness sdfProperty sdfEvent sdfRef
 -->
<!--  LocalWords:  namespaces sdfRequired Optionality sdfAction
 -->
<!--  LocalWords:  dereferenced dereferencing atomicity
 -->
<!--  LocalWords:  interworking
 -->
