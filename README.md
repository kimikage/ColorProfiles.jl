# ColorProfiles.jl
[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kimikage.github.io/ColorProfiles.jl/stable)
[![Docs Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kimikage.github.io/ColorProfiles.jl/dev)
[![CI](https://github.com/kimikage/ColorProfiles.jl/workflows/CI/badge.svg)](https://github.com/kimikage/ColorProfiles.jl/actions?query=workflow%3ACI)
[![Codecov](https://codecov.io/gh/kimikage/ColorProfiles.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kimikage/ColorProfiles.jl)

ColorProfiles provides the types to represent ICC profile data and a reader for
ICC profiles. This package supports the ICC Profile
[version 4.4.0.0](https://www.color.org/v4spec.xalter) (ICC.1:2022-05) and
version 2 (ICC.1:2001-04).

Note that ColorProfiles.jl does NOT provide features for color management
itself.
