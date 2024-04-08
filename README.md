# Example Usage

```typst
#import "./note_template.typ": *

#show: document => note(
  title: [Notes for blablabla],
  authors: ( // array to support multiple authors
    (
      name: [author one],
      affiliations: (1,) // array to support multiple affiliations
    ),
    (
      name: [author two],
      affiliations: (1,2)
    ),
  ),

  insitutes: (
    [institute one shared by both authors],
    [institue two]
  )

  abstract: lorem(100),
  two_columns: false,
  show_contents: false,
  show_references: false, # specify `bib_filename` if is true
  document,
)

// begin documents
This is main text \
lorem(500),
```
