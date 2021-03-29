# Loader/Saver

!!! warning
    ColorProfiles assumes that the profile data to be loaded is valid and
    appropriate. Attempting to load a maliciously crafted profile may use up
    memory and CPU resources.


## Loader
ColorProfiles will create different instances of tags, even if they share the
same data.

```@docs
read_icc_profile
```

### Embedded Profile Loader
```@docs
read_icc_profile_in_jpeg
```

## Saver

Currently, saver is not implemented.

## FileIO extension

```@docs
add_icc_profile_format
```