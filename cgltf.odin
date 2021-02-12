package cgltf

import "core:c"

foreign import cgltf "../../../library/cgltf/build/cgltf.lib"

cgltf_size :: c.size_t;
cgltf_bool :: c.int;
cgltf_float :: f32;
cgltf_int :: c.int;
cgltf_uint :: c.uint;//unsigned int 

cgltf_file_type :: enum 
{
	cgltf_file_type_invalid,
	cgltf_file_type_gltf,
	cgltf_file_type_glb,
};

cgltf_result :: enum 
{
	cgltf_result_success,
	cgltf_result_data_too_short,
	cgltf_result_unknown_format,
	cgltf_result_invalid_json,
	cgltf_result_invalid_gltf,
	cgltf_result_invalid_options,
	cgltf_result_file_not_found,
	cgltf_result_io_error,
	cgltf_result_out_of_memory,
	cgltf_result_legacy_gltf,
};

cgltf_memory_options :: struct
{
    alloc:     proc(user: rawptr, size: cgltf_size) -> rawptr,
    free:      proc(user: rawptr, ptr: rawptr),
    user_data: rawptr,
};

cgltf_file_options ::  struct 
{
    read : proc(memory_options : ^cgltf_memory_options,file_options : ^cgltf_file_options,path : cstring,size : ^cgltf_size,data :  ^rawptr) -> cgltf_result,
    release : proc(memory_options : ^cgltf_memory_options,file_options : ^cgltf_file_options,data : rawptr),
    user_data : rawptr,
};

cgltf_options :: struct
{
    type : cgltf_file_type , /* invalid == auto detect */
    json_token_count : cgltf_size, /* 0 == auto */
    memory : cgltf_memory_options ,
    file : cgltf_file_options ,
};

cgltf_buffer_view_type :: enum
{
	cgltf_buffer_view_type_invalid,
	cgltf_buffer_view_type_indices,
	cgltf_buffer_view_type_vertices,
};

cgltf_attribute_type :: enum
{
	cgltf_attribute_type_invalid,
	cgltf_attribute_type_position,
	cgltf_attribute_type_normal,
	cgltf_attribute_type_tangent,
	cgltf_attribute_type_texcoord,
	cgltf_attribute_type_color,
	cgltf_attribute_type_joints,
	cgltf_attribute_type_weights,
};

cgltf_component_type :: enum
{
    cgltf_component_type_invalid,
    cgltf_component_type_r_8, /* BYTE */
    cgltf_component_type_r_8u, /* UNSIGNED_BYTE */
    cgltf_component_type_r_16, /* SHORT */
    cgltf_component_type_r_16u, /* UNSIGNED_SHORT */
    cgltf_component_type_r_32u, /* UNSIGNED_INT */
    cgltf_component_type_r_32f, /* FLOAT */
};

cgltf_type :: enum
{
    cgltf_type_invalid,
    cgltf_type_scalar,
    cgltf_type_vec2,
    cgltf_type_vec3,
    cgltf_type_vec4,
    cgltf_type_mat2,
    cgltf_type_mat3,
    cgltf_type_mat4,
};

cgltf_primitive_type  :: enum
{
    cgltf_primitive_type_points,
    cgltf_primitive_type_lines,
    cgltf_primitive_type_line_loop,
    cgltf_primitive_type_line_strip,
    cgltf_primitive_type_triangles,
    cgltf_primitive_type_triangle_strip,
    cgltf_primitive_type_triangle_fan,
};

cgltf_alpha_mode :: enum
{
	cgltf_alpha_mode_opaque,
	cgltf_alpha_mode_mask,
	cgltf_alpha_mode_blend,
};

cgltf_animation_path_type :: enum
{
	cgltf_animation_path_type_invalid,
	cgltf_animation_path_type_translation,
	cgltf_animation_path_type_rotation,
	cgltf_animation_path_type_scale,
	cgltf_animation_path_type_weights,
};

cgltf_interpolation_type :: enum
{
	cgltf_interpolation_type_linear,
	cgltf_interpolation_type_step,
	cgltf_interpolation_type_cubic_spline,
};

cgltf_camera_type :: enum
{
	cgltf_camera_type_invalid,
	cgltf_camera_type_perspective,
	cgltf_camera_type_orthographic,
};

cgltf_light_type :: enum
{
    cgltf_light_type_invalid,
    cgltf_light_type_directional,
    cgltf_light_type_point,
    cgltf_light_type_spot,
};

cgltf_extras :: struct
{
      start_offset : cgltf_size,
      end_offset :cgltf_size,
};

cgltf_extension :: struct
{
      name : cstring,
      data : cstring,
};

cgltf_buffer :: struct
{
    size : 	cgltf_size, 
    uri : cstring,
    data : rawptr, /* loaded by cgltf_load_buffers */
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_meshopt_compression_mode :: enum
{
	cgltf_meshopt_compression_mode_invalid,
	cgltf_meshopt_compression_mode_attributes,
	cgltf_meshopt_compression_mode_triangles,
	cgltf_meshopt_compression_mode_indices,
};

cgltf_meshopt_compression_filter :: enum
{
	cgltf_meshopt_compression_filter_none,
	cgltf_meshopt_compression_filter_octahedral,
	cgltf_meshopt_compression_filter_quaternion,
	cgltf_meshopt_compression_filter_exponential,
};

cgltf_meshopt_compression:: struct
{
    buffer : ^cgltf_buffer,
    offset : cgltf_size,
    size : cgltf_size,
    stride : cgltf_size,
    count : cgltf_size,
    mode : cgltf_meshopt_compression_mode,
    filter : cgltf_meshopt_compression_filter,
};

cgltf_buffer_view :: struct
{
    buffer : ^cgltf_buffer,
    offset : cgltf_size,
    size : cgltf_size,
    stride : cgltf_size, /* 0 == automatically determined by accessor */
    type : cgltf_buffer_view_type,
    data : rawptr, /* overrides buffer->data if present, filled by extensions */
    has_meshopt_compression : cgltf_bool,
    meshopt_compression : cgltf_meshopt_compression,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_accessor_sparse :: struct
{
    count : cgltf_size,
    indices_buffer_view : ^cgltf_buffer_view,
    indices_byte_offset : cgltf_size,
    indices_component_type : cgltf_component_type,
    values_buffer_view : ^cgltf_buffer_view,
    values_byte_offset : cgltf_size,
    extras : cgltf_extras,
    indices_extras : cgltf_extras,
    values_extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
    indices_extensions_count : cgltf_size,
    indices_extensions : ^cgltf_extension,
    values_extensions_count : cgltf_size,
    values_extensions : ^cgltf_extension,
};

cgltf_accessor :: struct
{
    component_type : cgltf_component_type,
    normalized : cgltf_bool,
    type : cgltf_type,
    offset : cgltf_size,
    count : cgltf_size,
    stride : cgltf_size,
    buffer_view : cgltf_buffer_view,
    has_min : cgltf_bool,
    min : [16]cgltf_float,
    has_max : cgltf_bool,
    max : [16]cgltf_float,
    is_sparse : cgltf_bool,
    sparse : cgltf_accessor_sparse,
    extras : 	cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_attribute :: struct
{
    name : cstring,
    type : cgltf_attribute_type,
    index : cgltf_int,
    data : ^cgltf_accessor,
};

cgltf_image :: struct
{
    name : cstring,
    uri : cstring,
    buffer_view : ^cgltf_buffer_view,
    mime_type : cstring,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_sampler :: struct
{
    mag_filter : cgltf_int,
    min_filter: cgltf_int,
    wrap_s : cgltf_int,
    wrap_t : cgltf_int,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_texture :: struct
{
    name : cstring,
    image : ^cgltf_image,
    sampler : ^cgltf_sampler,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : cgltf_extension,
};

cgltf_texture_transform :: struct
{
    offset : 	[2]cgltf_float,
    rotation : cgltf_float,
    scale : [2]cgltf_float,
    texcoord    : cgltf_int,
};

cgltf_texture_view :: struct
{
    texture : 	^cgltf_texture,
    texcoord : cgltf_int,
    scale : cgltf_float, /* equivalent to strength for occlusion_texture */
    has_transform : cgltf_bool,
    transform : cgltf_texture_transform,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};

cgltf_pbr_metallic_roughness :: struct
{
    base_color_texture : 	cgltf_texture_view,
    metallic_roughness_texture : cgltf_texture_view,

    base_color_factor : [4]cgltf_float,
    metallic_factor   : cgltf_float ,
    roughness_factor : cgltf_float,

    extras : cgltf_extras,
};

cgltf_pbr_specular_glossiness :: struct
{
    diffuse_texture : 	cgltf_texture_view,
    specular_glossiness_texture : cgltf_texture_view,

    diffuse_factor : [4]cgltf_float,
    specular_factor : [3]cgltf_float,
    glossiness_factor : cgltf_float,
};

cgltf_clearcoat :: struct
{
    clearcoat_texture : 	cgltf_texture_view,
    clearcoat_roughness_texture : cgltf_texture_view,
    clearcoat_normal_texture : cgltf_texture_view, 

    clearcoat_factor : cgltf_float,
    clearcoat_roughness_factor : cgltf_float, 
};

cgltf_transmission :: struct
{
    transmission_texture : 	cgltf_texture_view ,
    transmission_factor : cgltf_float,
};

cgltf_ior :: struct
{
    ior : 	cgltf_float,
};

cgltf_specular :: struct
{
    specular_texture : 	cgltf_texture_view ,
    specular_color_texture : cgltf_texture_view, 
    specular_color_factor  : [3]cgltf_float,
    specular_factor : cgltf_float,
};

cgltf_volume :: struct
{
    thickness_texture : 	cgltf_texture_view ,
    thickness_factor : cgltf_float,
    attenuation_color :  [3]cgltf_float,
    attenuation_distance : cgltf_float,
};

cgltf_sheen :: struct
{
    sheen_color_texture : 	cgltf_texture_view,
    sheen_color_factor  :  [3]cgltf_float,
    sheen_roughness_texture : cgltf_texture_view,
    sheen_roughness_factor : cgltf_float,
};

cgltf_material :: struct
{
    name : cstring,
    has_pbr_metallic_roughness : cgltf_bool,
    has_pbr_specular_glossiness : cgltf_bool,
    has_clearcoat : cgltf_bool,
    has_transmission : cgltf_bool,
    has_volume : cgltf_bool,
    has_ior : cgltf_bool,
    has_specular : cgltf_bool,
    has_sheen : cgltf_bool,
    pbr_metallic_roughness : 	cgltf_pbr_metallic_roughness, 
    pbr_specular_glossiness : cgltf_pbr_specular_glossiness,
    clearcoat : cgltf_clearcoat,
    ior : cgltf_ior,
    specular : 	cgltf_specular,
    sheen : cgltf_sheen,
    transmission : cgltf_transmission ,
    volume : cgltf_volume,
    normal_texture : cgltf_texture_view ,
    occlusion_texture : cgltf_texture_view ,
    emissive_texture : cgltf_texture_view ,
    emissive_factor : [3]cgltf_float,
    alpha_mode : cgltf_alpha_mode,
    alpha_cutoff : cgltf_float,
    double_sided : 	cgltf_bool,
    unlit : cgltf_bool,
    extras : cgltf_extras,
    extensions_count : cgltf_size, 
    extensions : ^cgltf_extension,
};

cgltf_material_mapping :: struct
{
    variant : 	cgltf_size,
    material : ^cgltf_material,
    extras : cgltf_extras,
};

cgltf_morph_target :: struct
{
    attributes : ^cgltf_attribute,
    attributes_count : cgltf_size,
};

cgltf_draco_mesh_compression :: struct
{
    buffer_view : 	^cgltf_buffer_view,
    attributes  : ^cgltf_attribute,
    attributes_count : cgltf_size,
};

cgltf_primitive :: struct
{
    type : 	cgltf_primitive_type ,
    indices : ^cgltf_accessor ,
    material : ^cgltf_material ,
    attributes : ^cgltf_attribute,
    attributes_count : cgltf_size ,
    targets : ^cgltf_morph_target ,
    targets_count : cgltf_size ,
    extras : cgltf_extras ,
    has_draco_mesh_compression : cgltf_bool ,
    draco_mesh_compression : cgltf_draco_mesh_compression,
    mappings  : ^cgltf_material_mapping,
    mappings_count : cgltf_size ,
    extensions_count : cgltf_size ,
    extensions : 	^cgltf_extension,
};

cgltf_mesh :: struct
{
    name : cstring,
    primitives : ^cgltf_primitive,
    primitives_count : cgltf_size ,
    weights : ^cgltf_float,
    weights_count : cgltf_size ,
    target_names : ^cstring,//char** ,
    target_names_count : cgltf_size ,
    extras : cgltf_extras ,
    extensions_count : cgltf_size ,
    extensions : ^cgltf_extension,
};

//  cgltf_node cgltf_node;

cgltf_skin :: struct
{
    name : cstring,
    joints : ^^cgltf_node,
    joints_count : cgltf_size,
    skeleton : ^cgltf_node ,
    inverse_bind_matrices : ^cgltf_accessor,
    extras : cgltf_extras ,
    extensions_count : cgltf_size ,
    extensions : ^cgltf_extension,
};

cgltf_camera_perspective :: struct
{
    aspect_ratio : 	cgltf_float,
    yfov : cgltf_float,
    zfar : cgltf_float, 
    znear : cgltf_float, 
    extras : cgltf_extras,
};

cgltf_camera_orthographic :: struct
{
    xmag : 	cgltf_float,
    ymag : cgltf_float,
    zfar : cgltf_float,
    znear : cgltf_float,
    extras : cgltf_extras,
};

cgltf_camera_data :: struct #raw_union
{
    perspective : cgltf_camera_perspective ,
    orthographic : cgltf_camera_orthographic,
}

cgltf_camera :: struct
{
    name : cstring,
    type : cgltf_camera_type,
    data : cgltf_camera_data,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
};
 
cgltf_light :: struct
{
    name : cstring,
    color : [3]cgltf_float,
    intensity : cgltf_float,
    type : cgltf_light_type ,
    range : cgltf_float ,
    spot_inner_cone_angle  : cgltf_float ,
    spot_outer_cone_angle : cgltf_float ,
};

cgltf_node :: struct
{
    name : cstring,
    parent : ^cgltf_node,
    children : ^^cgltf_node,
    children_count : ^cgltf_size ,
    skin : ^cgltf_skin ,
    mesh : ^cgltf_mesh ,
    camera : ^cgltf_camera ,
    light : ^cgltf_light ,
    weights : ^cgltf_float ,
    weights_count : cgltf_size ,
    has_translation : cgltf_bool ,
    has_rotation : cgltf_bool ,
    has_scale : cgltf_bool ,
    has_matrix : cgltf_bool ,
    translation :  [3]cgltf_float,
    rotation : [4]cgltf_float,
    scale :  [3]cgltf_float,
    matrix : [16]cgltf_float ,
    extras : cgltf_extras ,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
}

cgltf_scene :: struct
{
    name : cstring,
    nodes : ^^cgltf_node,
    nodes_count : cgltf_size,
    extras : 	cgltf_extras,
    extensions_count : cgltf_size ,
    extensions : ^cgltf_extension,
}

cgltf_animation_sampler :: struct
{
    input : 	^cgltf_accessor,
    output : ^cgltf_accessor,
    interpolation : cgltf_interpolation_type,
    extras : cgltf_extras ,
    extensions_count : cgltf_size ,
    extensions : ^cgltf_extension,
}

cgltf_animation_channel :: struct
{
    sampler : 	^cgltf_animation_sampler,
    target_node : ^cgltf_node,
    target_path : cgltf_animation_path_type,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
}

cgltf_animation :: struct
{
    name : 	cstring,
    samplers : ^cgltf_animation_sampler,
    samplers_count : cgltf_size,
    channels : ^cgltf_animation_channel,
    channels_count : cgltf_size ,
    extras : cgltf_extras ,
    extensions_count : cgltf_size ,
    extensions : ^cgltf_extension,
}

cgltf_material_variant :: struct
{
    name : cstring,
    extras : 	cgltf_extras,
}

cgltf_asset :: struct
{
    copyright : cstring,
    generator : cstring,
    version : cstring,
    min_version : cstring,
    extras : cgltf_extras,
    extensions_count : cgltf_size,
    extensions : ^cgltf_extension,
}

cgltf_data :: struct
{
    file_type : 	cgltf_file_type,
    file_data : rawptr,

    asset : cgltf_asset,

    meshes : ^cgltf_mesh,
    meshes_count : cgltf_size,

    materials : ^cgltf_material,
    materials_count : cgltf_size,

    accessors : ^cgltf_accessor,
    accessors_count : cgltf_size,

    buffer_views : ^cgltf_buffer_view,
    buffer_views_count : cgltf_size,

    buffers : 	^cgltf_buffer,
    buffers_count :  cgltf_size,

    images : ^cgltf_image,
    images_count : cgltf_size,

    textures : ^cgltf_texture,
    textures_count : cgltf_size,

    samplers : ^cgltf_sampler,
    samplers_count : cgltf_size,

    skins : ^cgltf_skin,
    skins_count : cgltf_size,

    cameras : ^cgltf_camera,
    cameras_count :cgltf_size,

    lights : ^cgltf_light,
    lights_count : cgltf_size ,

    nodes : ^cgltf_node,
    nodes_count : cgltf_size,

    scenes : 	^cgltf_scene,
    scenes_count : cgltf_size,

    scene : ^cgltf_scene,

    animations : ^cgltf_animation,
    animations_count : cgltf_size,

    variants : ^cgltf_material_variant,
    variants_count : cgltf_size,

    extras : cgltf_extras,

    data_extensions_count : cgltf_size ,
    data_extensions : ^cgltf_extension,

    extensions_used : 	^^cstring,//char**,
    extensions_used_count : cgltf_size,

    extensions_required : ^^cstring,
    extensions_required_count : cgltf_size,

    json : cstring,
    json_size : cgltf_size,

    bin : rawptr,
    bin_size : cgltf_size,

    memory : cgltf_memory_options,
    file : cgltf_file_options,
};



@(default_calling_convention="c")
foreign cgltf
{

    cgltf_parse :: proc "c"(options : ^cgltf_options,data : cstring,size : cgltf_size,out_data : ^^cgltf_data) -> cgltf_result ---;
    cgltf_parse_file :: proc "c"( options : ^cgltf_options,path : cstring,out_data : ^^cgltf_data) ->cgltf_result ---;
    cgltf_load_buffers :: proc "c"(options : ^cgltf_options,data : ^cgltf_data,gltf_path : cstring) ->cgltf_result ---;
    cgltf_load_buffer_base64 :: proc "c"(options :  ^cgltf_options, size : cgltf_size, base64 : cstring, out_data : ^rawptr ) ->cgltf_result ---;
    cgltf_decode_uri :: proc "c"(uri : cstring) ---;
    cgltf_validate :: proc "c"( data : ^cgltf_data) ->cgltf_result ---;
    cgltf_free :: proc "c"(data : ^cgltf_data) ---;
    cgltf_node_transform_local :: proc "c"(node : ^cgltf_node,out_matrix :  ^cgltf_float) ---;
    cgltf_node_transform_world :: proc "c"(node : ^cgltf_node,out_matrix :  ^cgltf_float) ---;
    cgltf_accessor_read_float :: proc "c"(accessor : ^cgltf_accessor,index  :  cgltf_size, out : ^cgltf_float, element_size : cgltf_size) -> cgltf_bool  ---;
    cgltf_accessor_read_uint :: proc "c"(accessor : ^cgltf_accessor, index : cgltf_size , out : ^cgltf_uint,  element_size : cgltf_size)-> cgltf_bool  ---;

    cgltf_accessor_read_index :: proc "c"(accessor  : ^cgltf_accessor,  index : cgltf_size)-> cgltf_size  ---;
    cgltf_num_components :: proc "c"(type : cgltf_type) -> cgltf_size ---;    
    cgltf_accessor_unpack_floats :: proc "c"(accessor : ^cgltf_accessor,out :  ^cgltf_float,float_count :  cgltf_size) ->cgltf_size ---;
    cgltf_copy_extras_json :: proc "c"(data : ^cgltf_data, extras : ^cgltf_extras,dest : cstring,dest_size :  ^cgltf_size)  -> cgltf_result ---;
}
