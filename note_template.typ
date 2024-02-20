#let mycolor = (
    celestial_blue: rgb(74, 150, 209), // `Celestial blue: \definecolor{celestialblue}{rgb}{0.29, 0.59, 0.82}` from `https://latexcolor.com/`
    amber_orange: rgb(255, 128, 0), // `Amber (SAE/ECE): \definecolor{amber(sae/ece)}{rgb}{1.0, 0.75, 0.0}` from `https://latexcolor.com/`
    cerise_pink: rgb(237, 58, 130), // `Cerise pink: \definecolor{cerisepink}{rgb}{0.93, 0.23, 0.51}` from `https://latexcolor.com/`
    coral_red: rgb(255, 64, 64) // `Coral red: \definecolor{coralred}{rgb}{1.0, 0.25, 0.25}` from `https://latexcolor.com/`
)

#let note(
    title: none,
    authors: (), // empty array for multiple authors. Here each author is a dictionary of `name: str` and `affiliations: int`
    intitutions: (), // empty array for multiple affiliations
    abstract: none,
    show_contents: false,
    two_columns: false,
    document,
    bib_filename: ()
) = {
    set page(paper: "us-letter")
    set par(justify:true, first-line-indent: 1em)

    /// maketitle and abstract
    {
        set align(center)
        text(18pt, weight: "bold")[#title]

        v(-7.5pt)
        let n_author = 1;
        for author in authors {
            text(author.name)

            let n_affiliation = 1;
            for affiliation in author.affiliations {
                assert(affiliation <= intitutions.len(), message: "affiation label NOT match with the number of intitutions!")
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
        for i in range(0, intitutions.len()) {
            text(blue)[$""^#(i+1)$]
            text(black)[_#intitutions.at(i)_]
            linebreak()
        }
        v(10pt)
        set align(left)
        abstract
        v(15pt)
    }

    /// customize the appearance
    show heading: set text(fill: mycolor.celestial_blue) // customize heading style
    show link: set text(fill: mycolor.cerise_pink) // customize link color
    show ref: set text(fill: mycolor.cerise_pink) // customize reference color

    show emph: set text(fill: mycolor.cerise_pink) // customize emphasis style 
    show strong: set text(fill: mycolor.cerise_pink) // customize strong style

    /// table-of-contents
    {
        set par(justify:true, first-line-indent: 0em) // turn off first-line-indent for table-of-contents
        set heading(numbering: "I.1.")
        if show_contents {
            // formatting table-of-contents
            show outline.entry: self => {
                text(fill: mycolor.celestial_blue)[#self]
            }
            show outline.entry.where(
                level: 1
            ): self => {
                // linebreak()
                v(10pt, weak: true)
                // [*#self*] // bold for the first level section
                text(weight: "semibold")[#self]
            }
            outline(
                title: [Contents],
                indent: 2em,
                depth: 2,
            )
        }
        v(15pt)
    }

    /// begin document
    // set par(justify:true, first-line-indent: 1em) // recover the first-line-indent
    if two_columns {
        columns(2,gutter: 20pt, document)
    } else {
        document
    } 
    /// references
    bibliography(bib_filename, title: "References")
}