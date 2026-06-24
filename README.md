# McVicker's B statistic

This statistic estimates the force of stabilizing selection on
nucleotide sites within the genome. It ranges from 0 to 1, with values
near 0 implying strong selection, and values near 1 implying weak
selection.

This repo doesn't include the data files. Instead, it includes
`README.md` files, which explain how to download the files distributed
by McVicker et al and convert them into .bed files on hg19
coordinates. It also includes a Julia script that is used in this
process.

# B statistic

File `bkgd.tar.gz` was downloaded from `http://www.phrap.org`. It's in
hg18 coordinates. This contains estimates of B, which measures effect
of background selection, and was published by McVicker et al 2009.

It unpacks using `tar zxvf bkgd.tar.gz` into directory bkgd. For
further details, see `bkgd/README.md`.
