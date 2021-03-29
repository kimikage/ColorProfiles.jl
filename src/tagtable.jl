
struct TagTable <: AbstractDict{Signature, AbstractTag}
    tags::Vector{AbstractTag}
    positions::Vector{Position}
end

rawsize(table::TagTable) = length(table) * 12 + 4 + tag_data_size(table)

function Base.iterate(table::TagTable, state::Int=0)
    length(table.tags) <= state && return nothing
    next = state + 1
    return table.tags[next], next
end

Base.length(table::TagTable) = length(table.tags)

Base.getindex(table::TagTable, inds...) = _getindex(table, inds...)

_getindex(table::TagTable, i::Integer) = table.tags[i]
_getindex(table::TagTable, sig::Symbol) = _getindex(table, Signature(sig))
_getindex(table::TagTable, sig::AbstractString) = _getindex(table, Signature(sig))

function _getindex(table::TagTable, sig::Signature)
    for tag in table.tags
        signature(tag) === sig && return tag
    end
    throw(KeyError(sig))
end

function update!(table::TagTable; version=ICC_VERSION)
    typemap = Dict{Signature, Vector{AbstractTag}}()
    for tag in table.tags
        cs = element_signature(t, version)
        v = get(typemap, cs, AbstractTag[])
        push!(v, tag)
        typemap[cs] = v
    end
end

function read_icc_tag_table(io::IO; version=ICC_VERSION)
    head = position(io) - 128
    n = read_u32(io)
    table = TagTable(Vector{AbstractTag}(undef, n), Vector{Position}(undef, n))
    sig32 = Vector{UInt32}(undef, n)
    for i in eachindex(sig32)
        sig32[i] = read_u32(io)
        offset = read_u32(io)
        size = read_u32(io)
        table.positions[i] = Position(offset, size)
    end
    for i in eachindex(table.tags)
        pos = table.positions[i]
        seek(io, head + pos.offset)
        table.tags[i] = read_tag(io, Signature{sig32[i]}(), pos.size, version)
    end
    return table
end
