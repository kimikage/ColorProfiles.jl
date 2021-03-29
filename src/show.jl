
function Base.show(io::IO, mime::MIME"text/plain", profile::ICCProfile)
    println(io, typeof(profile), ":")
    show(io, mime, profile.header)
    println(io)
    show(io, mime, profile.table)
end

function Base.print(io::IO, @nospecialize(x::Signature))
    id = idnumber(x)
    id === 0x00000000 && return
    for i in 0x0:0x8:0x18
        0x20 <= ((id >> i) % UInt8) < 0x80 && continue
        throw(ArgumentError("cannot be printed: 0x$(string(id, base=16, pad=8))"))
    end
    write(io, hton(id))
    return
end

function Base.show(io::IO, tag::UnknownTag)
    print(io, typeof(tag), "()")
end

function Base.summary(io::IO, table::TagTable)
    n = length(table)
    entry = n == 1 ? " entry" : " entries"
    print(io, typeof(table), " with ", n, entry, ":")
end

function Base.show(io::IO, ::MIME"text/plain", table::TagTable)
    summary(io, table)
    println(io)
    for (tag, pos) in zip(table.tags, table.positions)
        offset = string(pos.offset, base = 16, pad = 8)
        print(io, "  sig\"", signature(tag), "\" => ")
        show(io, typeof(tag))
        println(io, " @ 0x", offset)
    end
end
