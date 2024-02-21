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
    // date: none,
    abstract: none,
    show_contents: false,
    two_columns: false,
    document,
    bib_filename: ()
) = {
    set page(paper: "us-letter", margin: (x: 2cm, y: 2cm),)
    set par(justify:true, first-line-indent: 1em)
    set text(
        // font: "stix2",
        size: 10pt
    )

    /// maketitle and abstract
    set align(center)
    text(12pt, weight: "bold")[#title]
    linebreak()
    v(3pt)
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
    [(Dated: #datetime.today().display())] // default date
    v(10pt,weak: true)
    
    box(
        width: 40em,
        // first-line-indent: 1em,
        [
            // *Abstract*
            #set align(left)
            #h(1em) // manual indent
            #abstract
        ]
    )
    // abstract
    v(15pt)

    /// customize the appearance
    set align(left)
    set heading(numbering: "I.A.") // customize heading numbering
    show heading: self => [
        #set align(center)
        #text(fill: mycolor.celestial_blue, 10pt)[
            #v(25pt,weak: true)
            #self 
            #v(15pt,weak: true)
        ] // customize heading style
    ]
    show link: set text(fill: mycolor.cerise_pink) // customize link color
    show ref: set text(fill: mycolor.cerise_pink) // customize reference color

    show emph: set text(fill: mycolor.cerise_pink) // customize emphasis style 
    show strong: set text(fill: mycolor.cerise_pink) // customize strong style

    /// table-of-contents
    {
        set par(justify:true, first-line-indent: 0em) // turn off first-line-indent for table-of-contents
        if show_contents {
            show outline.entry: it => {
                // we will customize the outline using the original definitions. To avoid infinite recursion, we will use a tag to mark the modified outline entries. The trick is used in https://stackoverflow.com/questions/77031078/how-to-remove-numbers-from-outline
                let outline_contents =  if it.at("label", default: none) == <modified-tag> {
                    it // just return itself if is already modified 
                } else {
                    [
                        #outline.entry(
                            it.level,
                            it.element,
                            it.body,
                            [],  // remove fill
                            it.page
                        )<modified-tag>
                        #linebreak()
                        #v(-7.5pt, weak: true)
                    ] 
                }
                if it.level == 1 {
                    v(10pt,weak: true)
                }
                if it.level == 1 {
                    text(fill: mycolor.celestial_blue, weight: "bold")[#outline_contents]
                } else {
                    text(fill: mycolor.celestial_blue)[#outline_contents]
                }
            }

            outline(
                title: [Contents],
                indent: 1em,
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