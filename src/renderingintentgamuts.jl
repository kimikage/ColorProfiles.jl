"""
`RenderingIntentGamuts` module defines the type for identifying
rendering intent gamuts.
"""
module RenderingIntentGamuts

import ..ColorProfiles: TypedSignature, @sig_str

export RenderingIntentGamut
export PerceptualReferenceMediumGamut

"""
    RenderingIntentGamut{sig}
"""
struct RenderingIntentGamut{sig} <: TypedSignature{sig} end

const PerceptualReferenceMediumGamut = RenderingIntentGamut(:prmg)

end # module
