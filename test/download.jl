if !isdefined(Main, :profile_path)

    profile_path(filename) = joinpath(@__DIR__, "profiles", filename)

    demoiccmax_url = "https://github.com/InternationalColorConsortium/DemoIccMAX/raw/Ver2.2.3/Testing/"

    srgb_v4 = "sRGB_v4_ICC_preference.icc"

    import Downloads

    function dl(url, filename)
        isfile(profile_path(filename)) && return
        Downloads.download(url * filename, profile_path(filename))
    end

end

dl(demoiccmax_url, srgb_v4)
