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
    set page(paper: "us-letter")
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


    // table-of-contents
    set par(justify:true, first-line-indent: 0em) // turn off first-line-indent for table-of-contents
    set heading(numbering: "I.1.")
    if show_contents {
        // formatting table-of-contents
        show outline.entry.where(
            level: 1
        ): it => {
            // linebreak()
            v(10pt, weak: true)
            [*#it*] // bold for the first level section
        }
        outline(
            title: [Contents],
            indent: 2em,
            depth: 2,
        )

    }
    v(15pt)

    // begin document
    set par(justify:true, first-line-indent: 1em) // recover the first-line-indent
    if two_columns {
        columns(2,gutter: 20pt, document)
    } else {
        document
    } 
    bibliography(bib_filename, title: "References")
    // end document
}