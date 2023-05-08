#include <iostream>

// GLEW
#define GLEW_STATIC
#include <GL/glew.h>

// GLFW
#include <GLFW/glfw3.h>

// Other Libs
#include "SOIL2/SOIL2.h"

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtc/random.hpp>

// Other includes
#include "Shader.h"

// Global Variables
float angleValue = 0;                       // angle of transform
glm::vec4 transformedLocationInitial;       // Position of white block (initial reach point)
glm::vec4 transformedLocationFinal;         // Position of green block (final reach point)
float X = 0;                                // Cursor x-position from -1 to 1
float Y = 0;                                // Cursor y-position from -1 to 1
float xEdge = 0.05;                         // x dimension of triangle vertices from -1 to 1 (.05)
float yEdge = 0.08;                         // y dimension of triangle vertices from -1 to 1 (.08)
int state = 0;                              // state determines which block appears next
int reachNumber = 1;                        // Reach number
bool whiteSquare = false;                   // True if cursor is within bounds of white square
bool greenSquare = false;                   // True if cursor is within bounds of green square
int temp = 0;                               // Variable that determines where we are in the program

// Variables for cursor velocity
float startReachTime;                       // Time at the start of a reach
float currentVelocity;                      // Velocity of the cursor in the current frame
float previousTime;                         // Time in the previous frame
float currentTime;                          // Time in the current frame
float previousX;
float previousY;
int frame = 0;

// Declare Functions
void processInput(GLFWwindow *window);
static void cursorPositionCallback(GLFWwindow *window, double xPos, double yPos);
void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods);
void changePos();

// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 500;         // Test window with same ratio as full screen (800 X 500)
//const GLuint WIDTH = 1440, HEIGHT = 900;      // Full screen (1440 X 900)

// The MAIN function, from here we start the application and run the game loop
int main( )
{
    // Init GLFW
    glfwInit( );
    
    // Seed random number generator (means RNG will be different every time)
    srand((int)time(NULL));
    changePos();        // Changes the value of global variable 'angleValue'
    
    // Set all the required options for GLFW
    glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
    glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
    glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );
    glfwWindowHint( GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE );
    
    glfwWindowHint( GLFW_RESIZABLE, GL_FALSE );
    
    // Create a GLFWwindow object that we can use for GLFW's functions
    GLFWwindow *window = glfwCreateWindow( WIDTH, HEIGHT, "LearnOpenGL", nullptr, nullptr );
    
    glfwSetMouseButtonCallback(window, mouseButtonCallback);
    glfwSetCursorPosCallback(window, cursorPositionCallback);
    
    int screenWidth, screenHeight;
    glfwGetFramebufferSize( window, &screenWidth, &screenHeight );
    
    if ( nullptr == window )
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate( );
        
        return EXIT_FAILURE;
    }
    
    glfwMakeContextCurrent( window );
    
    // Set this to true so GLEW knows to use a modern approach to retrieving function pointers and extensions
    glewExperimental = GL_TRUE;
    // Initialize GLEW to setup the OpenGL Function pointers
    if ( GLEW_OK != glewInit( ) )
    {
        std::cout << "Failed to initialize GLEW" << std::endl;
        return EXIT_FAILURE;
    }
    
    // Define the viewport dimensions
    glViewport( 0, 0, screenWidth, screenHeight );
    
    // enable alpha support
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    // Build and compile our shader program
    Shader ourShader( "res/shaders/core.vs", "res/shaders/core.frag" );
    
    // Set up vertex data (and buffer(s)) and attribute pointers
    GLfloat vertices[] =
    {
        // Positions                // Colors
        xEdge,  yEdge, 0.0f,        //1.0f, 0.0f, 0.0f,       // Top Right
        -xEdge,  yEdge, 0.0f,       //1.0f, 0.0f, 0.0f,        // Top Left
        xEdge, -yEdge, 0.0f,        //1.0f, 0.0f, 0.0f,       // Bottom Right
        -xEdge,  yEdge, 0.0f,       //1.0f, 0.0f, 0.0f,       // Top Left
        xEdge, -yEdge, 0.0f,        //1.0f, 0.0f, 0.0f,       // Bottom Right
        -xEdge, -yEdge, 0.0f       //1.0f, 0.0f, 0.0f       // Bottom Left
    };
    
    glm::vec4 cubePositionInitial(0.0f, 0.0f, 0.0f, 1.0f);       // Position of initial point
    glm::vec4 cubePositionFinal(0.0f, 0.0f, 0.0f, 1.0f);          // Position of final point
    
    glm::vec3 cubePositions[] =
    {
        glm::vec3( cubePositionInitial[0], cubePositionInitial[1], cubePositionInitial[2] ),
        glm::vec3( cubePositionFinal[0], cubePositionFinal[1], cubePositionFinal[2] )
    };
    
    GLuint VBO, VAO;
    glGenVertexArrays( 1, &VAO );
    glGenBuffers( 1, &VBO );
    
    glBindVertexArray( VAO );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO );
    glBufferData( GL_ARRAY_BUFFER, sizeof( vertices ), vertices, GL_STATIC_DRAW );
    
    // Position attribute
    glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof( GLfloat ), ( GLvoid * ) 0 );
    glEnableVertexAttribArray(0);
    // Color attribute
    //glVertexAttribPointer( 1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof( GLfloat ), ( GLvoid * )( 3 * sizeof( GLfloat ) ) );
    //glEnableVertexAttribArray(1);
    
    glBindVertexArray( 0 ); // Unbind VAO
    
    //float angleValue = glm::linearRand(0, 360);
    //angleValue = glm::radians(angleValue);
    //changePos(angleValue);
    
    // Game loop
    while ( !glfwWindowShouldClose( window ) )
    {
        
        frame++;
        
        processInput( window );
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents( );
        //glfwWaitEvents();
        
        // Solve for cursor instantaneous velocity
        currentTime = glfwGetTime();
        
        if (frame > 1)
        {
            currentVelocity = sqrt(pow(((X - previousX)/(currentTime - previousTime)), 2.0) + pow(((Y - previousY)/(currentTime - previousTime)), 2.0));
        }
        
        previousX = X;
        previousY = Y;
        previousTime = currentTime;
        
        switch (temp) {
            case 0:
                if (whiteSquare)
                {
                    glfwSetTime(0);
                    temp = 1;
                    std::cout << "Attempting Reach " << reachNumber << "..." << std::endl;
                    //std::cout << "Cursor has entered white square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 1:
                if (glfwGetTime() >= 2.0)
                {
                    state = 1;
                    temp = 2;
                    std::cout << "\nReach " << reachNumber << ": " << std::endl;
                    std::cout << "Time: " << glfwGetTime() << ", Target: (" << transformedLocationInitial[0] << " , " << transformedLocationInitial[1] << "), Actual: (" << X << " , " << Y << ")" << std::endl;
                    //std::cout << "Green square appears" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                
                if (!whiteSquare)
                {
                    temp = 0;
                    std::cout << "Reach " << reachNumber << " aborted.\n" << std::endl;
                    reachNumber++;
                    //std::cout << "Cursor has exited white square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 2:
                if (greenSquare)
                {
                    temp = 3;
                    //std::cout << "Cursor has entered green square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 3:
                if (currentVelocity != 0 && currentVelocity < 1.5)      // This will need to be tweaked...
                {
                    changePos();
                    state = 0;
                    temp = 0;
                    //std::cout << "Reach " << reachNumber << " complete." << std::endl;
                    std::cout << "Time: " << glfwGetTime() << ", Target: (" << transformedLocationFinal[0] << " , " << transformedLocationFinal[1] << "), Actual: (" << X << " , " << Y << ")\n" << std::endl;
                    reachNumber++;
                    //std::cout << "Green square dissappears" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            default:
                break;
        }
        
        // Render
        // Clear the colorbuffer
        glClearColor( 0.2f, 0.3f, 0.3f, 1.0f );
        glClear( GL_COLOR_BUFFER_BIT );
        
        // Draw the triangle
        ourShader.Use( );
        
        // Draw container
        glBindVertexArray( VAO );
        
        // Calculate the model matrix for each object and pass it to shader before drawing
        glm::mat4 transform(1);
        GLint transformLocation = glGetUniformLocation( ourShader.Program, "transform" );
        glUniformMatrix4fv( transformLocation, 1, GL_FALSE, glm::value_ptr( transform ) );
        transformedLocationInitial = transform * cubePositionInitial;
        
        float redValue = 1.0f;
        float greenValue = 1.0f;
        float blueValue = 1.0f;
        int vertexColorLocation = glGetUniformLocation(ourShader.Program, "colorChange");
        glUniform3f(vertexColorLocation, redValue, greenValue, blueValue);
        glDrawArrays( GL_TRIANGLES, 0, 6 );
        //glm::vec4 transformedLocationInitial = transform * cubePositionInitial;
        //std::cout << "Initial Position: " << transformedLocationInitial[0] << ":" << transformedLocationInitial[1] << std::endl;
        
        transform = glm::translate( transform, cubePositions[1] );
        transform = glm::rotate( transform, angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transform = glm::translate( transform, glm::vec3( 0.75f, 0.0f, 0.0f ) );
        transform = glm::rotate( transform, -angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transformLocation = glGetUniformLocation( ourShader.Program, "transform" );
        glUniformMatrix4fv( transformLocation, 1, GL_FALSE, glm::value_ptr( transform ) );
        
        transformedLocationFinal = transform * cubePositionFinal;
        //std::cout << "Final Position: " << transformedLocationFinal[0] << ":" << transformedLocationFinal[1] << std::endl;
        
        vertexColorLocation = glGetUniformLocation(ourShader.Program, "colorChange");
        glUniform3f(vertexColorLocation, 0.0f, 1.0f, 0.0f);
        
        if (state == 1)
        {
            glDrawArrays( GL_TRIANGLES, 0, 6 );
        }
        
        glBindVertexArray( 0 );
        
        // Swap the screen buffers
        glfwSwapBuffers( window );
    }
    
    // Properly de-allocate all resources once they've outlived their purpose
    glDeleteVertexArrays( 1, &VAO );
    glDeleteBuffers( 1, &VBO );
    
    // Terminate GLFW, clearing any resources allocated by GLFW.
    glfwTerminate( );
    
    return EXIT_SUCCESS;
}

// This function will close the window if the escape key is pressed
void processInput(GLFWwindow *window)
{
    
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
    {
        glfwSetWindowShouldClose(window, true);
    }
    
}

static void cursorPositionCallback( GLFWwindow *window, double xPos, double yPos)
{
    X = (xPos-(WIDTH/2))/(WIDTH/2);
    Y = -(yPos-(HEIGHT/2))/(HEIGHT/2);
    //std::cout << X << ":" << Y << std::endl;
    
    
    // Detect where cursor is
    if (X < xEdge && X > -xEdge && Y < yEdge && Y > -yEdge)
    {
        whiteSquare = true;
    }
    else
    {
        whiteSquare = false;
    }
    
    if ( X < transformedLocationFinal[0] + xEdge && X > transformedLocationFinal[0] - xEdge && Y < transformedLocationFinal[1] + yEdge && Y > transformedLocationFinal[1] - yEdge)
    {
        greenSquare = true;
    }
    else
    {
        greenSquare = false;
    }
}

void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods)
{
    /*
     if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE)
     {
     if (state == 0)
     {
     if ( whiteSquare )
     {
     //std::cout << "Block 1 Position (x,y): (" << transformedLocationInitial[0] << ", " << transformedLocationInitial[1] << ")" << std::endl;
     //std::cout << "Cursor Position: (x,y): (" << X << ", " << Y << ")\n" << std::endl;
     std::cout << "Reach " << reachNumber << ": " << std::endl;
     std::cout << "\tBlock 1 Error: " << sqrt(pow(abs(transformedLocationInitial[0] - X), 2.0) + pow(abs(transformedLocationInitial[1] - Y), 2.0)) << std::endl;
     //std::cout << "Block 1 Error: " << (sqrt(pow(abs((transformedLocationInitial[0] - X)/xEdge), 2.0) + pow(abs((transformedLocationInitial[1] - Y)/yEdge), 2.0))) * 100 << "%" << std::endl;
     state = 1;
     reachNumber++;
     }
     }
     
     if ( greenSquare )
     {
     //std::cout << "Block 2 Position (x,y): (" << transformedLocationFinal[0] << ", " << transformedLocationFinal[1] << ")" << std::endl;
     //std::cout << "Cursor Position: (x,y): (" << X << ", " << Y << ")\n" << std::endl;
     std::cout << "\tBlock 2 Error: " << sqrt(pow(abs(transformedLocationFinal[0] - X), 2.0) + pow(abs(transformedLocationFinal[1] - Y), 2.0)) << "\n" << std::endl;
     //std::cout << "Block 1 Error: " << (sqrt(pow(abs((transformedLocationFinal[0] - X)/xEdge), 2.0) + pow(abs((transformedLocationFinal[1] - Y)/yEdge), 2.0))) * 100 << "%\n" << std::endl;
     changePos();
     state = 0;
     }
     }
     */
}

void changePos()
{
    angleValue = glm::linearRand(0, 360);
    angleValue = glm::radians(angleValue);
}
