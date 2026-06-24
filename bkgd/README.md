# Downloaded files

After unpacking the gzipped tar archive `../bkgd.tar.gz`, the current
directory contains files with names like `chr1.bkgd`, `chr2.bkgd`, and
so on. These are not saved in the repo. In addition, there is a
`README` file (not to be confused with the curren file, `README.md`),
which explains how McVicker et al created these files in 2008.

# Constructing B-hg18.bed.gz

    julia mkbed.jl | gzip -c > B-hg18.bed.gz

This creates `B-hg18.bed.gz`, which is a gzipped .bed file associating
values of B with genomic intervals. This file isn't in the repo either.

# liftOver from hg18 to hg19

First download the liftOver utility from the UCSC website, along with
the chain file for converting from hg18 to hg19. On my computer, this
chain file is in `~/data/liftOver/hg18ToHg19.over.chain.gz`.

    liftOver B-hg18.bed.gz ~/data/liftOver/hg18ToHg19.over.chain.gz  \
	B-hg19.bed unlifted.bed

    gzip B-hg19.bed
	gzip unlifted.bed

This creates two files, `B-hg19.bed.gz` and `unlifted.bed.gz`. Neither
of these are in the repo.

# What the repo contains

In the repo, the current directory only contains `README.md`, `README`,
`mkbed.jl`. These explain how to convert the files provided by
McVicker et al into a .bed file in hg19 coordinates.
