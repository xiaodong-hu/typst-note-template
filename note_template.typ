#let note(
  title: none,
  authors: (), // empty array for multiple authors: each author is a dictionary of `name: str` and `affiliation: int`
  institutes: (), // empty array for multiple affiliations
  abstract: none,
  show_contents: false,
  two_columns: false,
  document,
  bib_filename: ()
) = {
  set page(
    paper: "us-letter"
  )
  set par(justify:true, first-line-indent: 1em)

  // maketitle and abstract
  set align(center)
  text(18pt, weight: "bold")[#title]

  v(-7.5pt)
  let n_author = 1;
  for author in authors {
    text(author.name)

    let n_affiliation = 1;
    for affiliation in author.affiliations {
      assert(affiliation <= institutes.len(), message: "affiation label NOT match with the number of institutes!")
      text(blue)[$""^#affiliation$]
      if n_affiliation != author.affiliations.len() {
        text(black)[$""^,$]
      }
      n_affiliation += 1
    }
    if n_author != authors.len() {
      [, ]
    }
    n_author += 1
    h(5pt)
  }
  linebreak()
  for i in range(0, institutes.len()) {
    text(blue)[$""^#(i+1)$]
    text(black)[_#institutes.at(i)_]
    linebreak()
  }
  v(10pt)
  set align(left)
  abstract
  v(15pt)

  
  // begin document
  set heading(numbering: "I.")  

  if show_contents {
    outline()
  }
  if two_columns {
    columns(2,gutter: 20pt, document)
  } else {
    document
  } 
  bibliography(bib_filename)
  // end document
}