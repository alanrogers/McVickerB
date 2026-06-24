const agpdir = joinpath(homedir(), "data", "hg18", "agp")

"""
Parse one .agp file. Output is written to channel `ch` and consists
integers representing base-1 nucleotide positions that are present in
the current chromosome.
"""
function parseagp(agp::IO, ch::Channel{Any})
    while !eof(agp)
        line = readline(agp)
        line = split(line, '\t')
        if length(line) < 5
            error("Expecting at least 5 columns; got $(length(line))")
        end
        component_type = line[5]

        # ignore gaps
        if component_type=='N' || component_type=='U'
            continue
        end

        component_begin = parse(Int, line[2])
        component_end = parse(Int, line[3])
        for i in component_begin:component_end
            put!(ch, i)
        end
    end
end

"""
Write a bed file to stdout. The output contains intervals with
associated B values in hg18 coordinates.
"""
function mkbed(dir::AbstractString = pwd())
    local bkgd, agp
    for Bfname in readdir(dir)
        if !endswith(Bfname, ".bkgd")
            # ignore if not a .bkgd file
            continue
        end
        chr, _ = splitext(Bfname) # chromosome
        try
            bkgd = open(Bfname, "r")
        catch e
            error("can't open .bkgd file $Bfname")
        end
        agpfname = joinpath(agpdir, chr * ".agp")
        try
            agp = open(agpfname, "r")
        catch e
            error("can't open .agp file $agpfname")
        end

        # Open a Channel, which will feed assembled position numbers
        # to function mkbed.
        agpchannel = Channel(128) do ch
            parseagp(agp, ch)
        end;

        # Write bed file for one chromosome.
        mkbed(chr, bkgd, agpchannel)
    end
end

function mkbed(chr::AbstractString, bkgd::IO, agpchannel::Channel{Any})
    while !eof(bkgd)
        s = readline(bkgd)
        if length(s) == 0
            continue
        end
        
        s = split(s)
        B = s[1]      # B statistic
        bp = parse(Int, s[2])     # base pairs of current block

        start = stop = take!(agpchannel)

        if bp == 1
            println(chr, "\t", start-1, "\t", stop, "\t", B)
        else
            while bp > 1
                next = take!(agpchannel)
                if next == stop+1
                    stop = next
                else
                    println(chr, "\t", start-1, "\t", stop, "\t", B)
                    start = stop = next
                end
                bp -= 1
            end

            # If no line was printed on the last pass through the loop,
            # then start < stop, and we need to print a final line.
            if start < stop
                println(chr, "\t", start-1, "\t", stop, "\t", B)
            end
        end
    end
end

mkbed()
