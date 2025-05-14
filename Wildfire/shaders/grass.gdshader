shader_type spatial;
render_mode cull_disabled, unshaded; // Disable backface culling for quads, no built-in lighting for now

uniform sampler2D leaf_texture : hint_albedo; // Leaf sprite texture
uniform vec3 floor_color = vec3(0.2, 0.5, 0.1); // Default floor color to match

void vertex() {
    // Get the camera's view matrix
    mat4 cam_matrix = INV_VIEW_MATRIX;
    vec3 cam_right = vec3(cam_matrix[0][0], cam_matrix[0][1], cam_matrix[0][2]);
    vec3 cam_up = vec3(cam_matrix[1][0], cam_matrix[1][1], cam_matrix[1][2]);

    // Billboard: Adjust vertex positions to face the camera
    vec3 vertex_local = VERTEX;
    VERTEX = vec3(0.0); // Reset to origin initially
    VERTEX += vertex_local.x * cam_right * 0.5; // Scale width (0.5 = half of 1x1 quad)
    VERTEX += vertex_local.y * cam_up * 0.5;    // Scale height

    // Move the quad to the instance's world position (model origin)
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Pass the model origin to the fragment shader for consistent lighting
    VARYING = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
}

void fragment() {
    // Sample the leaf texture
    vec4 leaf_color = texture(leaf_texture, UV);

    // Set albedo to floor color, modulated by leaf texture
    ALBEDO = floor_color * leaf_color.rgb;

    // Use alpha from the leaf texture for transparency
    ALPHA = leaf_color.a;
}

void light() {
    // Calculate lighting based on the model origin (passed via VARYING)
    vec3 light_dir = normalize(LIGHT - VARYING);
    vec3 normal = normalize(NORMAL); // Normal from the quad
    float diffuse = max(0.0, dot(normal, light_dir));

    // Apply lighting to albedo
    DIFFUSE_LIGHT = ALBEDO * diffuse * LIGHT_COLOR;
}