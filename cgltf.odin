// Compatible with cgltf version 1.10

package cgltf

import "core:c"

when ODIN_OS == "windows" {foreign import cgltf"cgltf.lib"}
when ODIN_OS == "linux" {foreign import cgltf"system:cgltf"}
when ODIN_OS == "darwin" {foreign import cgltf"system:cgltf"}
when ODIN_OS == "freebsd" {foreign import cgltf"system:cgltf"}

cgltf_size  :: c.size_t;
cgltf_bool  :: b32
cgltf_float :: c.float;
cgltf_int   :: c.int;
cgltf_uint  :: c.uint;

file_type :: enum u32 {
	file_type_invalid,
	file_type_gltf,
	file_type_glb,
}

result :: enum u32 {
	success,
	data_too_short,
	unknown_format,
	invalid_json,
	invalid_gltf,
	invalid_options,
	file_not_found,
	io_error,
	out_of_memory,
	legacy_gltf,
}

memory_options :: struct {
	alloc:     proc "c" (user: rawptr, size: cgltf_size) -> rawptr,
	free:      proc "c" (user: rawptr, ptr: rawptr),
	user_data: rawptr,
}

file_options :: struct {
	read:      proc "c" (memory_options: ^memory_options, file_options: ^file_options, path: cstring, size: ^cgltf_size, data: ^rawptr) -> result,
	release:   proc "c" (memory_options: ^memory_options, file_options: ^file_options, data: rawptr),
	user_data: rawptr,
}

options :: struct {
	type:             file_type, /*invalid == auto detect */
	json_token_count: cgltf_size, /*0 == auto */
	memory:           memory_options,
	file:             file_options,
}

buffer_view_type :: enum u32 {
	invalid,
	indices,
	vertices,
}

attribute_type :: enum u32 {
	invalid,
	position,
	normal,
	tangent,
	texcoord,
	color,
	joints,
	weights,
}

component_type :: enum u32 {
	invalid,
	r_8,   /*BYTE */
	r_8u,  /*UNSIGNED_BYTE */
	r_16,  /*SHORT */
	r_16u, /*UNSIGNED_SHORT */
	r_32u, /*UNSIGNED_INT */
	r_32f, /*FLOAT */
}

type :: enum u32 {
	invalid,
	scalar,
	vec2,
	vec3,
	vec4,
	mat2,
	mat3,
	mat4,
}

primitive_type :: enum u32 {
	points,
	lines,
	line_loop,
	line_strip,
	triangles,
	triangle_strip,
	triangle_fan,
}

alpha_mode :: enum u32 {
	opaque,
	mask,
	blend,
}

animation_path_type :: enum u32 {
	invalid,
	translation,
	rotation,
	scale,
	weights,
}

interpolation_type :: enum u32 {
	linear,
	step,
	cubic_spline,
}

camera_type :: enum u32 {
	invalid,
	perspective,
	orthographic,
}

light_type :: enum u32 {
	invalid,
	directional,
	point,
	spot,
}

extras :: struct {
	start_offset: cgltf_size,
	end_offset:   cgltf_size,
}

extension :: struct {
	name: cstring,
	data: cstring,
}

buffer :: struct {
	name:             cstring,
	size:             cgltf_size,
	uri:              cstring,
	data:             rawptr, /*loaded by load_buffers */
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       ^extension,
}

meshopt_compression_mode :: enum u32 {
	invalid,
	attributes,
	triangles,
	indices,
}

meshopt_compression_filter :: enum u32 {
	none,
	octahedral,
	quaternion,
	exponential,
}

meshopt_compression :: struct {
	buffer: ^buffer,
	offset: cgltf_size,
	size:   cgltf_size,
	stride: cgltf_size,
	count:  cgltf_size,
	mode:   meshopt_compression_mode,
	filter: meshopt_compression_filter,
}

buffer_view :: struct {
	name:                    cstring,
	buffer:                  ^buffer,
	offset:                  cgltf_size,
	size:                    cgltf_size,
	stride:                  cgltf_size, /*0 == automatically determined by accessor */
	type:                    buffer_view_type,
	data:                    rawptr, /*overrides buffer->data if present, filled by extensions */
	has_meshopt_compression: cgltf_bool,
	meshopt_compression:     meshopt_compression,
	extra:                   extras,
	extensions_count:        cgltf_size,
	extensions:              [^]extension,
}

accessor_sparse :: struct {
	count:                    cgltf_size,
	indices_buffer_view:      ^buffer_view,
	indices_byte_offset:      cgltf_size,
	indices_component_type:   component_type,
	values_buffer_view:       ^buffer_view,
	values_byte_offset:       cgltf_size,
	extra:                    extras,
	indices_extras:           extras,
	values_extras:            extras,
	extensions_count:         cgltf_size,
	extensions:               [^]extension,
	indices_extensions_count: cgltf_size,
	indices_extensions:       [^]extension,
	values_extensions_count:  cgltf_size,
	values_extensions:        [^]extension,
}

accessor :: struct {
	name:             cstring,
	component_type:   component_type,
	normalized:       cgltf_bool,
	type:             type,
	offset:           cgltf_size,
	count:            cgltf_size,
	stride:           cgltf_size,
	buffer_view:      ^buffer_view,
	has_min:          cgltf_bool,
	min:              [16]cgltf_float,
	has_max:          cgltf_bool,
	max:              [16]cgltf_float,
	is_sparse:        cgltf_bool,
	sparse:           accessor_sparse,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

attribute :: struct {
	name:  cstring,
	type:  attribute_type,
	index: cgltf_int,
	data:  ^accessor,
}

image :: struct {
	name:             cstring,
	uri:              cstring,
	buffer_view:      ^buffer_view,
	mime_type:        cstring,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

sampler :: struct {
	name:             cstring,
	mag_filter:       cgltf_int,
	min_filter:       cgltf_int,
	wrap_s:           cgltf_int,
	wrap_t:           cgltf_int,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

texture :: struct {
	name:             cstring,
	image:            ^image,
	sampler:          ^sampler,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

texture_transform :: struct {
	offset:   [2]cgltf_float,
	rotation: cgltf_float,
	scale:    [2]cgltf_float,
	texcoord: cgltf_int,
}

texture_view :: struct {
	texture:          ^texture,
	texcoord:         cgltf_int,
	scale:            cgltf_float, /*equivalent to strength for occlusion_texture */
	has_transform:    cgltf_int,
	transform:        texture_transform,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

pbr_metallic_roughness :: struct {
	base_color_texture:         texture_view,
	metallic_roughness_texture: texture_view,
	base_color_factor:          [4]cgltf_float,
	metallic_factor:            cgltf_float,
	roughness_factor:           cgltf_float,
	extra:                      extras,
}

pbr_specular_glossiness :: struct {
	diffuse_texture:             texture_view,
	specular_glossiness_texture: texture_view,
	diffuse_factor:              [4]cgltf_float,
	specular_factor:             [3]cgltf_float,
	glossiness_factor:           cgltf_float,
}

clearcoat :: struct {
	clearcoat_texture:           texture_view,
	clearcoat_roughness_texture: texture_view,
	clearcoat_normal_texture:    texture_view,
	clearcoat_factor:            cgltf_float,
	clearcoat_roughness_factor:  cgltf_float,
}

transmission :: struct {
	transmission_texture: texture_view,
	transmission_factor:  cgltf_float,
}

ior :: struct {
	ior: cgltf_float,
}

specular :: struct {
	specular_texture:       texture_view,
	specular_color_texture: texture_view,
	specular_color_factor:  [3]cgltf_float,
	specular_factor:        cgltf_float,
}

volume :: struct {
	thickness_texture:    texture_view,
	thickness_factor:     cgltf_float,
	attenuation_color:    [3]cgltf_float,
	attenuation_distance: cgltf_float,
}

sheen :: struct {
	sheen_color_texture:     texture_view,
	sheen_color_factor:      [3]cgltf_float,
	sheen_roughness_texture: texture_view,
	sheen_roughness_factor:  cgltf_float,
}

material :: struct {
	name:                        cstring,
	has_pbr_metallic_roughness:  cgltf_bool,
	has_pbr_specular_glossiness: cgltf_bool,
	has_clearcoat:               cgltf_bool,
	has_transmission:            cgltf_bool,
	has_volume:                  cgltf_bool,
	has_ior:                     cgltf_bool,
	has_specular:                cgltf_bool,
	has_sheen:                   cgltf_bool,
	pbr_metallic_roughness:      pbr_metallic_roughness,
	pbr_specular_glossiness:     pbr_specular_glossiness,
	clearcoat:                   clearcoat,
	ior:                         ior,
	specular:                    specular,
	sheen:                       sheen,
	transmission:                transmission,
	volume:                      volume,
	normal_texture:              texture_view,
	occlusion_texture:           texture_view,
	emissive_texture:            texture_view,
	emissive_factor:             [3]cgltf_float,
	alpha_mode:                  alpha_mode,
	alpha_cutoff:                cgltf_float,
	double_sided:                cgltf_bool,
	unlit:                       cgltf_bool,
	extra:                       extras,
	extensions_count:            cgltf_size,
	extensions:                  [^]extension,
}

material_mapping :: struct {
	variant:  cgltf_size,
	material: ^material,
	extra:    extras,
}

morph_target :: struct {
	attributes:       [^]attribute,
	attributes_count: cgltf_size,
}

draco_mesh_compression :: struct {
	buffer_view:      ^buffer_view,
	attributes:       [^]attribute,
	attributes_count: cgltf_size,
}

primitive :: struct {
	type:                       primitive_type,
	indices:                    ^accessor,
	material:                   ^material,
	attributes:                 [^]attribute,
	attributes_count:           cgltf_size,
	targets:                    [^]morph_target,
	targets_count:              cgltf_size,
	extra:                      extras,
	has_draco_mesh_compression: cgltf_bool,
	draco_mesh_compression:     draco_mesh_compression,
	mappings:                   [^]material_mapping,
	mappings_count:             cgltf_size,
	extensions_count:           cgltf_size,
	extensions:                 [^]extension,
}

mesh :: struct {
	name:               cstring,
	primitives:         [^]primitive,
	primitives_count:   cgltf_size,
	weights:            [^]cgltf_float,
	weights_count:      cgltf_size,
	target_names:       [^]cstring,
	target_names_count: cgltf_size,
	extra:              extras,
	extensions_count:   cgltf_size,
	extensions:         [^]extension,
}

skin :: struct {
	name:                  cstring,
	joints:                [^]^node,
	joints_count:          cgltf_size,
	skeleton:              ^node,
	inverse_bind_matrices: ^accessor,
	extra:                 extras,
	extensions_count:      cgltf_size,
	extensions:            [^]extension,
}

camera_perspective :: struct {
	aspect_ratio: cgltf_float,
	yfov:         cgltf_float,
	zfar:         cgltf_float,
	znear:        cgltf_float,
	extra:        extras,
}

camera_orthographic :: struct {
	xmag:  cgltf_float,
	ymag:  cgltf_float,
	zfar:  cgltf_float,
	znear: cgltf_float,
	extra: extras,
}

camera_data :: struct #raw_union {
	perspective:  camera_perspective,
	orthographic: camera_orthographic,
}

camera :: struct {
	name:             cstring,
	type:             camera_type,
	data:             camera_data,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

light :: struct {
	name:                  cstring,
	color:                 [3]cgltf_float,
	intensity:             cgltf_float,
	type:                  light_type,
	range:                 cgltf_float,
	spot_inner_cone_angle: cgltf_float,
	spot_outer_cone_angle: cgltf_float,
}

node :: struct {
	name:             cstring,
	parent:           ^node,
	children:         [^]^node,
	children_count:   cgltf_size,
	skin:             ^skin,
	mesh:             ^mesh,
	camera:           ^camera,
	light:            ^light,
	weights:          [^]cgltf_float,
	weights_count:    cgltf_size,
	has_translation:  cgltf_bool,
	has_rotation:     cgltf_bool,
	has_scale:        cgltf_bool,
	has_matrix:       cgltf_bool,
	translation:      [3]cgltf_float,
	rotation:         [4]cgltf_float,
	scale:            [3]cgltf_float,
	matrix:           [16]cgltf_float,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

scene :: struct {
	name:             cstring,
	nodes:            [^]^node,
	nodes_count:      cgltf_size,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

animation_sampler :: struct {
	input:            ^accessor,
	output:           ^accessor,
	interpolation:    interpolation_type,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

animation_channel :: struct {
	sampler:          ^animation_sampler,
	target_node:      ^node,
	target_path:      animation_path_type,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

animation :: struct {
	name:             cstring,
	samplers:         [^]animation_sampler,
	samplers_count:   cgltf_size,
	channels:         [^]animation_channel,
	channels_count:   cgltf_size,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

material_variant :: struct {
	name:  cstring,
	extra: extras,
}

asset :: struct {
	copyright:        cstring,
	generator:        cstring,
	version:          cstring,
	min_version:      cstring,
	extra:            extras,
	extensions_count: cgltf_size,
	extensions:       [^]extension,
}

data :: struct {
	file_type:                 file_type,
	file_data:                 rawptr,
	asset:                     asset,
	meshes:                    [^]mesh,
	meshes_count:              cgltf_size,
	materials:                 [^]material,
	materials_count:           cgltf_size,
	accessors:                 [^]accessor,
	accessors_count:           cgltf_size,
	buffer_views:              [^]buffer_view,
	buffer_views_count:        cgltf_size,
	buffers:                   [^]buffer,
	buffers_count:             cgltf_size,
	images:                    [^]image,
	images_count:              cgltf_size,
	textures:                  [^]texture,
	textures_count:            cgltf_size,
	samplers:                  [^]sampler,
	samplers_count:            cgltf_size,
	skins:                     [^]skin,
	skins_count:               cgltf_size,
	cameras:                   [^]camera,
	cameras_count:             cgltf_size,
	lights:                    [^]light,
	lights_count:              cgltf_size,
	nodes:                     [^]node,
	nodes_count:               cgltf_size,
	scenes:                    [^]scene,
	scenes_count:              cgltf_size,
	scene:                     ^scene,
	animations:                [^]animation,
	animations_count:          cgltf_size,
	variants:                  [^]material_variant,
	variants_count:            cgltf_size,
	extra:                     extras,
	data_extensions_count:     cgltf_size,
	data_extensions:           [^]extension,
	extensions_used:           [^]cstring,
	extensions_used_count:     cgltf_size,
	extensions_required:       [^]cstring,
	extensions_required_count: cgltf_size,
	json:                      cstring,
	json_size:                 cgltf_size,
	bin:                       rawptr,
	bin_size:                  cgltf_size,
	memory:                    memory_options,
	file:                      file_options,
}

@(link_prefix = "cgltf_")
@(default_calling_convention = "c")
foreign cgltf
{
	parse                  :: proc "c" (options: ^options, in_data: cstring, size: cgltf_size, out_data: ^^data) -> result ---
	parse_file             :: proc "c" (options: ^options, path: cstring, out_data: ^^data) -> result ---
	load_buffers           :: proc "c" (options: ^options, in_data: ^data, gltf_path: cstring) -> result ---
	load_buffer_base64     :: proc "c" (options: ^options, size: cgltf_size, base64: cstring, out_data: ^rawptr) -> result ---
	decode_uri             :: proc "c" (uri: cstring) ---
	validate               :: proc "c" (data: ^data) -> result ---
	free                   :: proc "c" (data: ^data) ---
	node_transform_local   :: proc "c" (node: ^node, out_matrix: ^cgltf_float) ---
	node_transform_world   :: proc "c" (node: ^node, out_matrix: ^cgltf_float) ---
	accessor_read_float    :: proc "c" (accessor: ^accessor, index: cgltf_size, out: ^cgltf_float, element_size: cgltf_size) -> c.int ---
	accessor_read_uint     :: proc "c" (accessor: ^accessor, index: cgltf_size, out: ^uint, element_size: cgltf_size) -> c.int ---
	accessor_read_index    :: proc "c" (accessor: ^accessor, index: cgltf_size) -> cgltf_size ---
	num_components         :: proc "c" (type: type) -> cgltf_size ---
	accessor_unpack_floats :: proc "c" (accessor: ^accessor, out: ^cgltf_float, float_count: cgltf_size) -> cgltf_size ---
	copy_extras_json       :: proc "c" (data: ^data, extras: ^extras, dest: cstring, dest_size: ^cgltf_size) -> result ---
}
