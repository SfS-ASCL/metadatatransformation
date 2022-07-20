# XSLT 

## Important files

`CMDI2HTML.xsl` is the main stylesheet for converting CMDI files to
HTML. The code has been significantly refactored and split into a set
of sub-stylesheets which deal with the different portions of CMDI
files. These sub-stylesheets can be found in the `xsl/` subdirectory.

`cmd-record-1_1-to-1_2.xsl` is the stylesheet taken from the
[CLARIN-ERIC github repository (cmdi-toolkit)](https://github.com/clarin-eric/cmdi-toolkit/blob/master/src/main/resources/toolkit/upgrade/cmd-record-1_1-to-1_2.xsl)

## Code structure and style

The refactored code is organized into sub-stylesheets which each deal
with a component that appears in CMDI files: e.g. `Creation.xsl` deals
with rendering the CMDI `<Creation>` component. `CommonComponents.xsl`
contains templates for rendering CMDI components that show up in
multiple places in the document (e.g. `<Descriptions>`). `Utils.xsl`
contains low-level templates that help with common tasks like
generating links. These sub-stylesheets are all imported from
`CMDI2HTML.xsl`.

The refactored code focuses on producing modern, semantic HTML that
should remain readable even as browsers and Web standards evolve.
Among other things, that means:

  - tables are only used to display genuinely tabular data
  - key-value pairs are displayed as definition lists
  - `<article>`, `<section>`, `<details>` and `<hN>` are used to
    represent document structure
  - the HTML should display well even in a text-based browser; all
    styling is done with CSS, and no JavaScript is used
    
The refactored XSLT code emphasizes local recursion via
`apply-templates` and making output types explicit in template modes.
See tips below for an explanation of why this style was chosen.
  
## Some tips

XSLT is not a nice language. It's ugly, verbose, very "enterprisey".
It's missing things that ought to be essential in a templating
language, like good string manipulation functions. Some of these
issues are alleviated in XSLT 2.0 and 3.0; but those standards have
essentially only one implementation, and more or less require
proprietary tools. It makes sense to stick to XSLT 1.0, even though it
is annoyingly limited in places.

Still, there are ways to make it easier on yourself and get the most
out of it. Here are some thing I have learned as I have refactored the
code here:

1. Work locally, not globally. That means: use recursion to apply
   templates down the document tree. You want to be updating the
   context node whenever you transform a particular part of the
   document.

   Updating the context node keeps your XPath expressions shorter.
   This is good because XPath expressions don't combine well with
   namespaces. Because they live inside attribute values, they also
   have poor syntax highlighting support in editors. You want to keep
   them short and easy to read.

1. Prefer `apply-templates` to `for-each`. Both allow you to update
   the context node by making a new selection, but with `for-each`,
   you must work inside an existing template -- which makes that
   template longer and more difficult to understand. XPath functions
   like `position()` also work with `apply-templates`, so they don't
   provide any advantage to `for-each`.

   `for-each` can make sense if you have some important context (e.g.,
   a variable) that you don't want to lose by calling another
   template. But you should generally avoid it for all but simple
   cases.

1. Prefer `apply-templates` to `call-template`. `call-template`
   doesn't update the context node, which means that any XPath
   expressions you use inside the template will be longer and uglier.
   It basically only makes sense to use `call-template` when you have
   a separate chunk of logic that you want to extract out, but without
   changing the context node. This is rare.

1. Use template modes. The main disadvantage of using
   `apply-templates` everywhere is that it's hard to tell, at the
   point a template is applied, what it's expected to produce. You
   don't know which templates will match or what they'll return.
   
   Specifying a mode helps fix this. When you call `apply-templates`,
   both the node *and* the mode must match for a template to be
   applied. The mode is just an arbitrary string, so you can use it to
   describe the expected output. (For example, I've generally used the
   name of the HTML element the template produces.) This ensures you
   don't match a template that will produce unexpected output, and
   makes the expected output explicit.

   It also prevents `apply-templates` from applying default templates
   recursively to the selection, which means you won't get unexpected
   output from them, either.

## Areas for further improvement

The CSS currently embedded in the `style` tag of the output HTML
should probably be merged into the main stylesheet for the talar
website (see: https://github.com/SfS-ASCL/erdora-website). (There are
a couple of reasons this hasn't been done yet. First, the main
stylesheet is not stored as CSS, but SCSS, so editing it requires a
compilation step. Second, the only person who can redeploy it at the
moment is Thorsten Trippel, who doesn't have a lot of time for
development tasks.)

Two less-important sub-stylesheets, `CourseSpecificProfile.xsl` and
`ToolContext.xsl`, have not yet been refactored.

The other metadata conversion stylesheets have also not yet been
refactored. These could be brought into line with the coding style of
`CMDI2HTML.xsl` and its sub-stylesheets, and could possibly even share
some code with them.

There are probably a lot of small bugs that could be found with a
better testing setup. An automated conversion of all our existing CMDI
files would be ideal; but even a curated set of examples for manual
testing would help a lot. The CMDI files we're working with are
hand-generated by researchers who rarely know much about XML. There
are surely quite a few corner cases where our XSLT could better handle
their choices about how to describe their data.

## Resources for getting started

This [O'Reilly
book](https://www.oreilly.com/library/view/learning-xslt/0596003277/ch01.html)
is a good introduction to XSLT; only chapter 1 is available for free, though.

Here is [another introduction](https://www.xml.com/pub/a/2000/08/holman/) available
entirely on the web.

Mozilla Developer Network documentation on XSLT and XPath:

  - https://developer.mozilla.org/en-US/docs/Web/XSLT
  - https://developer.mozilla.org/en-US/docs/Web/XPath

This was a good resource when I wanted to understand default
templates:

  - https://www.lenzconsulting.com/how-xslt-works/

You can test stylesheets locally, just with a browser. Both Firefox
and Chrome have built-in support for XSLT 1.0. However, CORS settings
by default disable fetching other local files. See
https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors/CORSRequestNotHttp
Turn off privacy.file_unique_origin setting in FF to make this work
again.

The [CLARIN Component Registry](https://catalog.clarin.eu/ds/ComponentRegistry/)
is a useful way to browse the definitions of individual CMDI components.
