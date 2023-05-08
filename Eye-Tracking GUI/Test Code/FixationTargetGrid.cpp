#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <math.h>
#include <stdio.h>

#include <glm/glm.hpp>
#include <glm/gtc/random.hpp>


// Window Dimensions
// Test window: 800 X 500
// Full screen Macbook: 1440 X 855
// Full screen samsung TV: 1920 X 1032
#define SCREEN_WIDTH 1440            // Test window with same ratio as full screen (800 X 500)
#define SCREEN_HEIGHT 700           // Test window with same ratio as full screen (800 X 500)


#define R 25       // radius of large circle
#define r 5        // radius of small circle

// Define global variables
float X = SCREEN_WIDTH / 2;                 // X position of fixation target (start at center of screen)
float Y = SCREEN_HEIGHT / 2;                // Y position of fixation target (start at center of screen)
int targetNum = 0;                          // Number of current target
int state = 0;                              // State of the program
int reach = 0;                              // Current reach number

void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods);
void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides );
void drawPlus( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius);
void processInput(GLFWwindow *window);
void changePos();

int main( void )
{
    GLFWwindow *window;
    
    // Initialize the library
    if ( !glfwInit( ) )
    {
        return -1;
    }
    
    // Seed random number generator (means RNG will be different every time)
    srand((int)time(NULL));
    //changePos();        // Changes the value of global variable 'angleValue'
    
    // Create a windowed mode window and its OpenGL context
    window = glfwCreateWindow( SCREEN_WIDTH, SCREEN_HEIGHT, "Hello World", NULL, NULL );
    glfwSetMouseButtonCallback(window, mouseButtonCallback);
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
    
    // Loop until the user closes the window
    while ( !glfwWindowShouldClose( window ) )
    {
        
        processInput( window );
        
        glClear( GL_COLOR_BUFFER_BIT );
        
        // render OpenGL here
        drawCircle( X, Y, 0, R, 10000 );
        glColor3f(0.0f, 0.0f, 0.0f);    // change draw color to black
        drawPlus(X, Y, 0, R, r);
        glColor3f(1.0f, 1.0f, 1.0f);    // change draw color to white
        drawCircle( X, Y, 0, r / 2.0, 10000 );
        
        // Swap front and back buffers
        glfwSwapBuffers( window );
        
        // Poll for and process events
        glfwPollEvents( );
    }
    
    glfwTerminate( );
    
    return 0;
}

void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods)
{
    if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE) {
        if (state == 0) {
            changePos();
            state = 1;
        }
        
        else if (state == 1) {
            reach++;
            printf("Reach: %i, Target: %i, X: %f, Y: %f\n", reach, targetNum, X, Y);
            X = SCREEN_WIDTH / 2;
            Y = SCREEN_HEIGHT / 2;
            state = 0;
        }
    }
}

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

void drawPlus(GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius)
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

// This function will close the window if the escape key is pressed
void processInput(GLFWwindow *window)
{
    
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
    {
        glfwSetWindowShouldClose(window, true);
    }
    
}

// This function changes the position of the fixation target
void changePos()
{
    int i;
    int ii;
    float xpositions[9] = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9};
    float ypositions[9] = {0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1};
    int numPositions = sizeof(xpositions)/sizeof(xpositions[0]);
    int numTargets = glm::pow(numPositions, 2);
    float xPos[numPositions];
    float yPos[numPositions];
    for(i = 0; i < numPositions; i++) xPos[i] = xpositions[i] * SCREEN_WIDTH;
    for(i = 0; i < numPositions; i++) yPos[i] = ypositions[i] * SCREEN_HEIGHT;
    targetNum = glm::linearRand(1, numTargets);
    
    for(ii = 1; ii <= numPositions; ii++) {
        if (targetNum <= numPositions * ii && targetNum > numPositions * (ii - 1)) {
            for (i = 0; i <= numPositions; i++) {
                if ((targetNum + i) / (numPositions * ii) == 1) {
                    break;
                }
            }
            break;
        }
    }
    X = xPos[numPositions - (i + 1)];
    Y = yPos[ii - 1];
}
