#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <math.h>
#include <stdio.h>

#include <glm/glm.hpp>
#include <glm/gtc/random.hpp>

#include <algorithm>
#include <iostream>
#include <list>
#include <numeric>
#include <random>
#include <vector>

// Window Dimensions
// Test window: 800 X 500
// Full screen Macbook: 1440 X 855
// Full screen samsung TV: 1920 X 1032
#define SCREEN_WIDTH 1440            // Test window with same ratio as full screen (800 X 500)
#define SCREEN_HEIGHT 655           // Test window with same ratio as full screen (800 X 500)

#define R 25       // radius of large circle
#define r 5       // radius of small circle
#define numTargets 6

// Define global variables
float defaultX = SCREEN_WIDTH / 2;         // X default position of fixation target
float defaultY = SCREEN_HEIGHT * 0.2;      // Y default position of fixation target
float X = defaultX;                        // X position of fixation target (start at center of screen)
float Y = defaultY;                        // Y position of fixation target (start at center of screen)
int targetIndex = 0;                        // Index of current target
int targetNum = 0;                          // Number of current target
int state = 0;                              // State of the program
int reach = 0;                              // Current reach number
float eyeX;
float eyeY;
bool changePosition = false;

// Define Targets
static float targets [numTargets][2]= {
    {0.2 * SCREEN_WIDTH, defaultY},
    {0.4 * SCREEN_WIDTH, defaultY},
    {0.6 * SCREEN_WIDTH, defaultY},
    {0.8 * SCREEN_WIDTH, defaultY},
    {defaultX, 0.4 * SCREEN_HEIGHT},
    {defaultX, 0.7 * SCREEN_HEIGHT}
};
//static int numTargets = sizeof(targets)/sizeof(targets[0]);

// Declare functions
void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods);
static void cursorPositionCallback(GLFWwindow *window, double xPos, double yPos);
void drawCursor(GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius);
void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides );
void drawPlus( GLfloat x, GLfloat y, GLfloat z);
void processInput(GLFWwindow *window);
void changePos(int array[], int count);
int * shuffleTargets();

//-----------------------------------------------------------------------
//                              M A I N
//
// From here we start the application and run the game loop
//-----------------------------------------------------------------------
int main( void )
{
    // All necessary OpenGL setup functions below
    GLFWwindow *window;
    
    // Initialize the library
    if ( !glfwInit( ) )
    {
        return -1;
    }
    
    // Create a windowed mode window and its OpenGL context
    window = glfwCreateWindow( SCREEN_WIDTH, SCREEN_HEIGHT, "Experiment 03", NULL, NULL );
    glfwSetMouseButtonCallback(window, mouseButtonCallback);
    glfwSetCursorPosCallback(window, cursorPositionCallback);
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);
    
    if ( !window )
    {
        glfwTerminate( );
        return -1;
    }
    
    // Make the window's context current
    glfwMakeContextCurrent( window );
    glViewport( 0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT ); // specifies the part of the window to which OpenGL will draw (in pixels), convert from normalised to pixels
    glMatrixMode( GL_PROJECTION ); // projection matrix defines the properties of the camera that views the objects in the world coordinate frame. Here you typically set the zoom factor, aspect ratio and the near and far clipping planes
    glLoadIdentity( ); // replace the current matrix with the identity matrix and starts us a fresh because matrix transforms such as glOrpho and glRotate cumulate, basically puts us at (0, 0, 0)
    glOrtho( 0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 1 ); // essentially set coordinate system
    glMatrixMode( GL_MODELVIEW ); // (default matrix mode) modelview matrix defines how your objects are transformed (meaning translation, rotation and scaling) in your world
    glLoadIdentity( ); // same as above comment
    
    
    // Beginning of experiment specific code
    
    // Randomize initial target array
    srand((int)time(NULL));         // Seed random number generator (means RNG will be different every time)
    int * array;
    array = shuffleTargets();
    
    int targetCounter = 0;                      // Counter that tells program when to re-shuffle target array
    
    
    // Loop until the user closes the window
    while ( !glfwWindowShouldClose( window ) )
    {
        processInput( window );
        
        glClear( GL_COLOR_BUFFER_BIT );
        
        if (changePosition) {
            if (targetCounter > numTargets - 1) {
                targetCounter = 0;
                array = shuffleTargets();
            }
            changePos(array, targetCounter);
            changePosition = false;
            targetCounter++;
        }
        
        // render OpenGL here
        // Draw fixation target
        drawCircle( X, Y, 0, R, 10000 );
        glColor3f(0.0f, 0.0f, 0.0f);    // change draw color to black
        drawPlus(X, Y, 0);
        glColor3f(1.0f, 1.0f, 1.0f);    // change draw color to white
        drawCircle( X, Y, 0, r / 2.0, 10000 );
        
        // Draw feedback cursor
        drawCursor(eyeX, eyeY, 0, SCREEN_WIDTH, 1);     //Provides eye feedback
        
        // Swap front and back buffers
        glfwSwapBuffers( window );
        
        // Poll for and process events
        glfwWaitEvents( );
    }
    
    glfwTerminate( );
    
    return 0;
}

//-----------------------------------------------------------------------
//                              mouseButtonCallback
//
// This function processess the input from the mouse
//-----------------------------------------------------------------------
void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods)
{
    if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE) {
        if (state == 0) {
            // If user selects initial target, we want the target to change to the next target position in the sequence
            changePosition = true;
            state = 1;
        }
        
        else if (state == 1) {
            // If user selects fixation target, we want the target to return to the defaul position.
            reach++;
            //printf("Reach: %i, Target: %i, X: %f, Y: %f\n", reach, targetNum, X, Y);
            X = defaultX;
            Y = defaultY;
            state = 0;
        }
    }
}

//-----------------------------------------------------------------------
//                              cursorPositionCallback
//
// This function processess the input from the mouse
//-----------------------------------------------------------------------
static void cursorPositionCallback( GLFWwindow *window, double xPos, double yPos)
{
    // For now, I am tying the eye positions to the cursor positions. This will change
    eyeX = xPos;
    eyeY = -yPos + SCREEN_HEIGHT;
    //printf("EyeX: %f, EyeY: %f\n", eyeX, eyeY);
    
    
}

//-----------------------------------------------------------------------
//                              drawCursor
//
// This function draws the cursor for visual feedback
//-----------------------------------------------------------------------
void drawCursor(GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius)
{
    GLfloat plusVertices[] =
    {
        x - radius, y + radius, 0,
        x - radius, y + Radius, 0,
        x + radius, y + Radius, 0,
        x + radius, y + radius, 0,
        
        x + Radius, y + radius, 0,
        x + Radius, y - radius, 0,
        x + radius, y - radius, 0,
        
        x + radius, y - Radius, 0,
        x - radius, y - Radius, 0,
        x - radius, y - radius, 0,
        
        x - Radius, y - radius, 0,
        x - Radius, y + radius, 0
    };
    
    glPolygonMode( GL_FRONT_AND_BACK, GL_FILL ); // polygon drawing mode (GL_POINT, GL_LINE, GL_FILL)
    
    glEnableClientState( GL_VERTEX_ARRAY );
    glVertexPointer( 3, GL_FLOAT, 0, plusVertices );
    glDrawArrays( GL_POLYGON, 0, 12);
    glDisableClientState( GL_VERTEX_ARRAY );
}

//-----------------------------------------------------------------------
//                              drawCircle
//
// This function draws a circle
//-----------------------------------------------------------------------
void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides )
{
    int numberOfVertices = numberOfSides + 2;
    
    GLfloat twicePi = 2.0f * M_PI;
    
    GLfloat circleVerticesX[numberOfVertices];
    GLfloat circleVerticesY[numberOfVertices];
    GLfloat circleVerticesZ[numberOfVertices];
    
    circleVerticesX[0] = x;
    circleVerticesY[0] = y;
    circleVerticesZ[0] = z;
    
    for ( int i = 1; i < numberOfVertices; i++ )
    {
        circleVerticesX[i] = x + ( Radius * cos( i *  twicePi / numberOfSides ) );
        circleVerticesY[i] = y + ( Radius * sin( i * twicePi / numberOfSides ) );
        circleVerticesZ[i] = z;
    }
    
    GLfloat allCircleVertices[( numberOfVertices ) * 3];
    
    for ( int i = 0; i < numberOfVertices; i++ )
    {
        allCircleVertices[i * 3] = circleVerticesX[i];
        allCircleVertices[( i * 3 ) + 1] = circleVerticesY[i];
        allCircleVertices[( i * 3 ) + 2] = circleVerticesZ[i];
    }
    
    glEnableClientState( GL_VERTEX_ARRAY );
    glVertexPointer( 3, GL_FLOAT, 0, allCircleVertices );
    glDrawArrays( GL_TRIANGLE_FAN, 0, numberOfVertices);
    glDisableClientState( GL_VERTEX_ARRAY );
}

//-----------------------------------------------------------------------
//                              drawPlus
//
// This function draws a plus
//-----------------------------------------------------------------------
void drawPlus(GLfloat x, GLfloat y, GLfloat z)
{
    GLfloat plusVertices[] =
    {
        x - r, y + r, 0,
        x - r, y + R, 0,
        x + r, y + R, 0,
        x + r, y + r, 0,
        
        x + R, y + r, 0,
        x + R, y - r, 0,
        x + r, y - r, 0,
        
        x + r, y - R, 0,
        x - r, y - R, 0,
        x - r, y - r, 0,
        
        x - R, y - r, 0,
        x - R, y + r, 0
    };
    
    glPolygonMode( GL_FRONT_AND_BACK, GL_FILL ); // polygon drawing mode (GL_POINT, GL_LINE, GL_FILL)
    
    glEnableClientState( GL_VERTEX_ARRAY );
    glVertexPointer( 3, GL_FLOAT, 0, plusVertices );
    glDrawArrays( GL_POLYGON, 0, 12);
    glDisableClientState( GL_VERTEX_ARRAY );
}

//-----------------------------------------------------------------------
//                              processInput
//
// This function will perform an action when a key is pressed
//-----------------------------------------------------------------------
void processInput(GLFWwindow *window)
{
    
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
    {
        glfwSetWindowShouldClose(window, true);
    }
    
}

//-----------------------------------------------------------------------
//                              changePos
//
// This function randomly changes the position of the fixation target
//-----------------------------------------------------------------------
void changePos(int array[], int count)
{
    targetNum = array[count];
    X = targets[targetNum - 1][0];
    Y = targets[targetNum - 1][1];
}

//-----------------------------------------------------------------------
//                              shuffleTargets
//
// This function randomly shuffles the target position vector
//-----------------------------------------------------------------------
int * shuffleTargets()
{
    static int array[numTargets];
    std::iota(array, array + numTargets, 1);
    
    for (int i = 0; i < numTargets; i++)
    {
        int index = rand() % numTargets;
        int temp = array[i];
        array[i] = array[index];
        array[index] = temp;
    }
    
    std::cout << "Shuffled Elements are :";
    for (auto i : array)
        std::cout << ' ' << i;
    std::cout << '\n';
    
    return array;
}
