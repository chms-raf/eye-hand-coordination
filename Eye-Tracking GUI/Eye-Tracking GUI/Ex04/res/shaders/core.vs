#version 330 core
layout (location = 0) in vec3 position;
//layout (location = 1) in vec3 color;

out vec3 ourColor;

uniform mat4 transform;
uniform vec3 colorChange;

void main()
{
    gl_Position = transform * vec4(position, 1.0f);
    //ourColor = vec3(0.0f, 1.0f, 1.0f);
    ourColor = colorChange;
}
