read_u8(io::IO) = read(io, UInt8)
write_u8(io::IO, x::UInt8) = write(io, x)

read_u16(io::IO) = ntoh(read(io, UInt16))
write_u16(io::IO, x::UInt16) = write(io, hton(x))

read_u32(io::IO) = ntoh(read(io, UInt32))
write_u32(io::IO, x::UInt32) = write(io, hton(x))
write_u32(io::IO, x::Integer) = write_u32(io, convert(UInt32, x))
write_u32(io::IO, x) = write_u32(io, idnumber(x))

read_s32(io::IO) = ntoh(read(io, Int32))
write_s32(io::IO, x::Int32) = write(io, hton(x))

read_u64(io::IO) = ntoh(read(io, UInt64))
write_u64(io::IO, x::UInt64) = write(io, hton(x))

read_u128(io::IO) = ntoh(read(io, UInt128))
write_u128(io::IO, x::UInt128) = write(io, hton(x))

read_q15f16(io::IO) = reinterpret(Q15f16, read_s32(io))
write_q15f16(io::IO, x::Q15f16) = write_s32(io, reinterpret(Q15f16(x)))
write_q15f16(io::IO, x) = write_q15f16(io, convert(Q15f16, x))


function read_xyz(io)
    x = read_q15f16(io)
    y = read_q15f16(io)
    z = read_q15f16(io)
    return XYZ{Float64}(x, y, z)
end

function write_xyz(io, xyz::XYZ)
    write_q15f16(io, xyz.x)
    write_q15f16(io, xyz.y)
    write_q15f16(io, xyz.z)
    return 12
end

function read_datetime(io)
    return DateTime(
        read_u16(io), # year
        read_u16(io), # month
        read_u16(io), # day
        read_u16(io), # hour
        read_u16(io), # minute
        read_u16(io), # second
    )
end

function write_datetime(io, datetime::DateTime)
    write_u16(io, year(datetime) % UInt16)
    write_u16(io, month(datetime) % UInt16)
    write_u16(io, day(datetime) % UInt16)
    write_u16(io, hour(datetime) % UInt16)
    write_u16(io, minute(datetime) % UInt16)
    write_u16(io, second(datetime) % UInt16)
    return 12
end

function read_ascii(io, nbytes)
    nbytes == 0 && return ""
    codes = read(io, nbytes)
    i = 1
    for c in codes
        c === 0x0 && break
        c >> 0x7 === 0x0 || @warn("non-ASCII character found: $(Char(c))")
        i += 1
    end
    return String(codes[1:i-1])
end

function write_ascii(io, text, nbytes=length(text) + 1)
    nbytes == 0 && return 0
    for i in 1:nbytes
        c = i <= length(ascii) ? UInt32(ascii[i]) : zero(UInt32)
        if c >> 0x7 !== zero(UInt32)
            @warn("non-ASCII character found: $(Char(c))")
            c = UInt32('?')
        end
        write_u8(io, c % UInt8)
    end
    return nbytes
end

function read_utf16be(io, nbytes)
    nbytes == 0 && return ""
    codes = Vector{Char}()
    for i = 1:2:nbytes
        c = UInt32(read_u16(io))
        if (c & 0b111111_0000_000000) === 0b110110_0000_000000
            c2 = UInt32(read_u16(io))
            if (c2 & 0b111111_0000_000000) !== 0b110111_0000_000000
                error("invalid UTF-16BE sequence")
            end
            c = ((c & 0b000000_1111_111111) + 0b1_000000) << 0xa
            c += c2 & 0b1111_111111
        end
        push!(codes, c)
    end
    return String(codes)
end

function read_3x3(io, reader)
    mat = Matrix{Float64}(undef, 3, 3)
    for j in 1:3, i in 1:3
        @inbounds mat[i, j] = Float64(reader(io))
    end
    return mat
end

read_u16_3x3(io) = read_3x3(io, read_u16)
read_q15f16_3x3(io) = read_3x3(io, read_q15f16)
