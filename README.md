# cgltf_odin
Odin bindings for cgltf project.

#Notes
Not all api's bindings or structs are tested for proper compatibility yet.
If you find any issues please let me know right away via an issue or PR.

The cgltf prefix removed from struct and procedure names.

The extras variable naming was renamed to singuar version where circular naming references and conflicts ocuured.
The data variable naming also renamed in some places for the same reason.

One worded struct names such as result and options retain their prefix for clarity and sanity.

#Instructions

1. Download CGLTF and build it for your platform.
2. Replace the lib directory in cgltf.odin with the location to your direction relatively.

