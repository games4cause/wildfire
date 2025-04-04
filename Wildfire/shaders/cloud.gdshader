shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D noise;
uniform float speed = 0.01;     // Movement speed of the clouds
uniform float scale = 1.0;      // Scale of the cloud texture
uniform float opacity = 1.0;    // Opacity of the cloud shadow
uniform vec2 direction = vec2(1.0, 0.0); // Movement direction
uniform float threshold = 0.5;  // Alpha scissor threshold

void fragment() {
    // Calculate moving UVs based on speed, direction, and time
    vec2 uv_offset = (UV * scale) + (TIME * speed * direction);
    float cloud_density = texture(noise, uv_offset).r;

    // Set alpha based on cloud density and opacity
    ALPHA = cloud_density * opacity;
    ALPHA_SCISSOR_THRESHOLD = threshold;
}