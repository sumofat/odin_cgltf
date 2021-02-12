package cgltf

import "core:c"

foreign import cgltf "your project directory here!/cgltf.lib"

cgltf_size :: c.size_t;
cgltf_bool :: c.int;
cgltf_float :: f32;
cgltf_int :: c.int;
cgltf_uint :: c.uint;//unsigned int 

file_type :: enum 
{
	file_type_invalid,
	file_type_gltf,
	file_type_glb,
};

cgltf_result :: enum 
{
	result_success,
	result_data_too_short,
	result_unknown_format,
	result_invalid_json,
	result_invalid_gltf,
	result_invalid_options,
	result_file_not_found,
	result_io_error,
	result_out_of_memory,
	result_legacy_gltf,
};

memory_options :: struct
{
    alloc:     proc(user: rawptr, size: cgltf_size) -> rawptr,
    free:      proc(user: rawptr, ptr: rawptr),
    user_data: rawptr,
};

file_options ::  struct 
{
    read : proc(memory_options : ^memory_options,file_options : ^file_options,path : cstring,size : ^cgltf_size,data :  ^rawptr) -> cgltf_result,
    release : proc(memory_options : ^memory_options,file_options : ^file_options,data : rawptr),
    user_data : rawptr,
};

options :: struct
{
    type : file_type , /* invalid == auto detect */
    json_token_count : cgltf_size, /* 0 == auto */
    memory : memory_options ,
    file : file_options ,
};

buffer_view_type :: enum
{
	buffer_view_type_invalid,
	buffer_view_type_indices,
	buffer_view_type_vertices,
};

attribute_type :: enum
{
	attribute_type_invalid,
	attribute_type_position,
	attribute_type_normal,
	attribute_type_tangent,
	attribute_type_texcoord,
	attribute_type_color,
	attribute_type_joints,
	attribute_type_weights,
};

component_type :: enum
{
    component_type_invalid,
    component_type_r_8, /* BYTE */
    component_type_r_8u, /* UNSIGNED_BYTE */
    component_type_r_16, /* SHORT */
    component_type_r_16u, /* UNSIGNED_SHORT */
    component_type_r_32u, /* UNSIGNED_INT */
    component_type_r_32f, /* FLOAT */
};

type :: enum
{
    type_invalid,
    type_scalar,
    type_vec2,
    type_vec3,
    type_vec4,
    type_mat2,
    type_mat3,
    type_mat4,
};

primitive_type  :: enum
{
    primitive_type_points,
    primitive_type_lines,
    primitive_type_line_loop,
    primitive_type_line_strip,
    primitive_type_triangles,
    primitive_type_triangle_strip,
    primitive_type_triangle_fan,
};

alpha_mode :: enum
{
	alpha_mode_opaque,
	alpha_mode_mask,
	alpha_mode_blend,
};

animation_path_type :: enum
{
	animation_path_type_invalid,
	animation_path_type_translation,
	animation_path_type_rotation,
	animation_path_type_scale,
	animation_path_type_weights,
};

interpolation_type :: enum
{
	interpolation_type_linear,
	interpolation_type_step,
	interpolation_type_cubic_spline,
};

camera_type :: enum
{
	camera_type_invalid,
	camera_type_perspective,
	camera_type_orthographic,
};

light_type :: enum
{
    light_type_invalid,
    light_type_directional,
    light_type_point,
    light_type_spot,
};

extras :: struct
{
      start_offset : cgltf_size,
      end_offset :cgltf_size,
};

extension :: struct
{
      name : cstring,
      data : cstring,
};

buffer :: struct
{
    size : 	cgltf_size, 
    uri : cstring,
    data : rawptr, /* loaded by load_buffers */
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

meshopt_compression_mode :: enum
{
	meshopt_compression_mode_invalid,
	meshopt_compression_mode_attributes,
	meshopt_compression_mode_triangles,
	meshopt_compression_mode_indices,
};

meshopt_compression_filter :: enum
{
	meshopt_compression_filter_none,
	meshopt_compression_filter_octahedral,
	meshopt_compression_filter_quaternion,
	meshopt_compression_filter_exponential,
};

meshopt_compression:: struct
{
    buffer : ^buffer,
    offset : cgltf_size,
    size : cgltf_size,
    stride : cgltf_size,
    count : cgltf_size,
    mode : meshopt_compression_mode,
    filter : meshopt_compression_filter,
};

buffer_view :: struct
{
    buffer : ^buffer,
    offset : cgltf_size,
    size : cgltf_size,
    stride : cgltf_size, /* 0 == automatically determined by accessor */
    type : buffer_view_type,
    data : rawptr, /* overrides buffer->data if present, filled by extensions */
    has_meshopt_compression : bool,
    meshopt_compression : meshopt_compression,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

accessor_sparse :: struct
{
    count : cgltf_size,
    indices_buffer_view : ^buffer_view,
    indices_byte_offset : cgltf_size,
    indices_component_type : component_type,
    values_buffer_view : ^buffer_view,
    values_byte_offset : cgltf_size,
    extra : extras,
    indices_extras : extras,
    values_extras : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
    indices_extensions_count : cgltf_size,
    indices_extensions : ^extension,
    values_extensions_count : cgltf_size,
    values_extensions : ^extension,
};

accessor :: struct
{
    component_type : component_type,
    normalized : bool,
    type : type,
    offset : cgltf_size,
    count : cgltf_size,
    stride : cgltf_size,
    buffer_view : buffer_view,
    has_min : bool,
    min : [16]f32,
    has_max : bool,
    max : [16]f32,
    is_sparse : bool,
    sparse : accessor_sparse,
    extra : 	extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

attribute :: struct
{
    name : cstring,
    type : attribute_type,
    index : int,
    data : ^accessor,
};

image :: struct
{
    name : cstring,
    uri : cstring,
    buffer_view : ^buffer_view,
    mime_type : cstring,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

sampler :: struct
{
    mag_filter : int,
    min_filter: int,
    wrap_s : int,
    wrap_t : int,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

texture :: struct
{
    name : cstring,
    image : ^image,
    sampler : ^sampler,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : extension,
};

texture_transform :: struct
{
    offset : 	[2]f32,
    rotation : f32,
    scale : [2]f32,
    texcoord    : int,
};

texture_view :: struct
{
    texture : 	^texture,
    texcoord : int,
    scale : f32, /* equivalent to strength for occlusion_texture */
    has_transform : bool,
    transform : texture_transform,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};

pbr_metallic_roughness :: struct
{
    base_color_texture : 	texture_view,
    metallic_roughness_texture : texture_view,

    base_color_factor : [4]f32,
    metallic_factor   : f32 ,
    roughness_factor : f32,

    extra : extras,
};

pbr_specular_glossiness :: struct
{
    diffuse_texture : 	texture_view,
    specular_glossiness_texture : texture_view,

    diffuse_factor : [4]f32,
    specular_factor : [3]f32,
    glossiness_factor : f32,
};

clearcoat :: struct
{
    clearcoat_texture : 	texture_view,
    clearcoat_roughness_texture : texture_view,
    clearcoat_normal_texture : texture_view, 

    clearcoat_factor : f32,
    clearcoat_roughness_factor : f32, 
};

transmission :: struct
{
    transmission_texture : 	texture_view ,
    transmission_factor : f32,
};

ior :: struct
{
    ior : 	f32,
};

specular :: struct
{
    specular_texture : 	texture_view ,
    specular_color_texture : texture_view, 
    specular_color_factor  : [3]f32,
    specular_factor : f32,
};

volume :: struct
{
    thickness_texture : 	texture_view ,
    thickness_factor : f32,
    attenuation_color :  [3]f32,
    attenuation_distance : f32,
};

sheen :: struct
{
    sheen_color_texture : 	texture_view,
    sheen_color_factor  :  [3]f32,
    sheen_roughness_texture : texture_view,
    sheen_roughness_factor : f32,
};

material :: struct
{
    name : cstring,
    has_pbr_metallic_roughness : bool,
    has_pbr_specular_glossiness : bool,
    has_clearcoat : bool,
    has_transmission : bool,
    has_volume : bool,
    has_ior : bool,
    has_specular : bool,
    has_sheen : bool,
    pbr_metallic_roughness : 	pbr_metallic_roughness, 
    pbr_specular_glossiness : pbr_specular_glossiness,
    clearcoat : clearcoat,
    ior : ior,
    specular : 	specular,
    sheen : sheen,
    transmission : transmission ,
    volume : volume,
    normal_texture : texture_view ,
    occlusion_texture : texture_view ,
    emissive_texture : texture_view ,
    emissive_factor : [3]f32,
    alpha_mode : alpha_mode,
    alpha_cutoff : f32,
    double_sided : 	bool,
    unlit : bool,
    extra : extras,
    extensions_count : cgltf_size, 
    extensions : ^extension,
};

material_mapping :: struct
{
    variant : 	cgltf_size,
    material : ^material,
    extra : extras,
};

morph_target :: struct
{
    attributes : ^attribute,
    attributes_count : cgltf_size,
};

draco_mesh_compression :: struct
{
    buffer_view : 	^buffer_view,
    attributes  : ^attribute,
    attributes_count : cgltf_size,
};

primitive :: struct
{
    type : 	primitive_type ,
    indices : ^accessor ,
    material : ^material ,
    attributes : ^attribute,
    attributes_count : cgltf_size ,
    targets : ^morph_target ,
    targets_count : cgltf_size ,
    extra : extras ,
    has_draco_mesh_compression : bool ,
    draco_mesh_compression : draco_mesh_compression,
    mappings  : ^material_mapping,
    mappings_count : cgltf_size ,
    extensions_count : cgltf_size ,
    extensions : 	^extension,
};

mesh :: struct
{
    name : cstring,
    primitives : ^primitive,
    primitives_count : cgltf_size ,
    weights : ^f32,
    weights_count : cgltf_size ,
    target_names : ^cstring,//char** ,
    target_names_count : cgltf_size ,
    extra : extras ,
    extensions_count : cgltf_size ,
    extensions : ^extension,
};

//  node node;

skin :: struct
{
    name : cstring,
    joints : ^^node,
    joints_count : cgltf_size,
    skeleton : ^node ,
    inverse_bind_matrices : ^accessor,
    extra : extras ,
    extensions_count : cgltf_size ,
    extensions : ^extension,
};

camera_perspective :: struct
{
    aspect_ratio : 	f32,
    yfov : f32,
    zfar : f32, 
    znear : f32, 
    extra : extras,
};

camera_orthographic :: struct
{
    xmag : 	f32,
    ymag : f32,
    zfar : f32,
    znear : f32,
    extra : extras,
};

camera_data :: struct #raw_union
{
    perspective : camera_perspective ,
    orthographic : camera_orthographic,
}

camera :: struct
{
    name : cstring,
    type : camera_type,
    data : camera_data,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
};
 
light :: struct
{
    name : cstring,
    color : [3]f32,
    intensity : f32,
    type : light_type ,
    range : f32 ,
    spot_inner_cone_angle  : f32 ,
    spot_outer_cone_angle : f32 ,
};

node :: struct
{
    name : cstring,
    parent : ^node,
    children : ^^node,
    children_count : ^cgltf_size ,
    skin : ^skin ,
    mesh : ^mesh ,
    camera : ^camera ,
    light : ^light ,
    weights : ^f32 ,
    weights_count : cgltf_size ,
    has_translation : bool ,
    has_rotation : bool ,
    has_scale : bool ,
    has_matrix : bool ,
    translation :  [3]f32,
    rotation : [4]f32,
    scale :  [3]f32,
    matrix : [16]f32 ,
    extra : extras ,
    extensions_count : cgltf_size,
    extensions : ^extension,
}

scene :: struct
{
    name : cstring,
    nodes : ^^node,
    nodes_count : cgltf_size,
    extra : 	extras,
    extensions_count : cgltf_size ,
    extensions : ^extension,
}

animation_sampler :: struct
{
    input : 	^accessor,
    output : ^accessor,
    interpolation : interpolation_type,
    extra : extras ,
    extensions_count : cgltf_size ,
    extensions : ^extension,
}

animation_channel :: struct
{
    sampler : 	^animation_sampler,
    target_node : ^node,
    target_path : animation_path_type,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
}

animation :: struct
{
    name : 	cstring,
    samplers : ^animation_sampler,
    samplers_count : cgltf_size,
    channels : ^animation_channel,
    channels_count : cgltf_size ,
    extra : extras ,
    extensions_count : cgltf_size ,
    extensions : ^extension,
}

material_variant :: struct
{
    name : cstring,
    extra : 	extras,
}

asset :: struct
{
    copyright : cstring,
    generator : cstring,
    version : cstring,
    min_version : cstring,
    extra : extras,
    extensions_count : cgltf_size,
    extensions : ^extension,
}

data :: struct
{
    file_type : 	file_type,
    file_data : rawptr,

    asset : asset,

    meshes : ^mesh,
    meshes_count : cgltf_size,

    materials : ^material,
    materials_count : cgltf_size,

    accessors : ^accessor,
    accessors_count : cgltf_size,

    buffer_views : ^buffer_view,
    buffer_views_count : cgltf_size,

    buffers : 	^buffer,
    buffers_count :  cgltf_size,

    images : ^image,
    images_count : cgltf_size,

    textures : ^texture,
    textures_count : cgltf_size,

    samplers : ^sampler,
    samplers_count : cgltf_size,

    skins : ^skin,
    skins_count : cgltf_size,

    cameras : ^camera,
    cameras_count :cgltf_size,

    lights : ^light,
    lights_count : cgltf_size ,

    nodes : ^node,
    nodes_count : cgltf_size,

    scenes : 	^scene,
    scenes_count : cgltf_size,

    scene : ^scene,

    animations : ^animation,
    animations_count : cgltf_size,

    variants : ^material_variant,
    variants_count : cgltf_size,

    extra : extras,

    data_extensions_count : cgltf_size ,
    data_extensions : ^extension,

    extensions_used : 	^^cstring,//char**,
    extensions_used_count : cgltf_size,

    extensions_required : ^^cstring,
    extensions_required_count : cgltf_size,

    json : cstring,
    json_size : cgltf_size,

    bin : rawptr,
    bin_size : cgltf_size,

    memory : memory_options,
    file : file_options,
};

@(link_prefix = "cgltf_")
@(default_calling_convention="c")
foreign cgltf
{
    parse :: proc "c"(options : ^options,in_data : cstring,size : cgltf_size,out_data : ^^data) -> cgltf_result ---;
    parse_file :: proc "c"( options : ^options,path : cstring,out_data : ^^data) ->cgltf_result ---;
    load_buffers :: proc "c"(options : ^options,in_data : ^data,gltf_path : cstring) ->cgltf_result ---;
    load_buffer_base64 :: proc "c"(options :  ^options, size : cgltf_size, base64 : cstring, out_data : ^rawptr ) ->cgltf_result ---;
    decode_uri :: proc "c"(uri : cstring) ---;
    validate :: proc "c"( data : ^data) ->cgltf_result ---;
    free :: proc "c"(data : ^data) ---;
    node_transform_local :: proc "c"(node : ^node,out_matrix :  ^f32) ---;
    node_transform_world :: proc "c"(node : ^node,out_matrix :  ^f32) ---;
    accessor_read_float :: proc "c"(accessor : ^accessor,index  :  cgltf_size, out : ^f32, element_size : cgltf_size) -> bool  ---;
    accessor_read_uint :: proc "c"(accessor : ^accessor, index : cgltf_size , out : ^uint,  element_size : cgltf_size)-> bool  ---;

    accessor_read_index :: proc "c"(accessor  : ^accessor,  index : cgltf_size)-> cgltf_size  ---;
    num_components :: proc "c"(type : type) -> cgltf_size ---;    
    accessor_unpack_floats :: proc "c"(accessor : ^accessor,out :  ^f32,float_count :  cgltf_size) ->cgltf_size ---;
    copy_extras_json :: proc "c"(data : ^data, extras : ^extras,dest : cstring,dest_size :  ^cgltf_size)  -> cgltf_result ---;
}
