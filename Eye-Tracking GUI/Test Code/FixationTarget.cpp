#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <math.h>

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

#define R 50       // radius of large circle
#define r 5        // radius of small circle

void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides );
void drawPlus( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius);
void processInput(GLFWwindow *window);

int main( void )
{
    GLFWwindow *window;
    
    // Initialize the library
    if ( !glfwInit( ) )
    {
        return -1;
    }
    
    // Create a windowed mode window and its OpenGL context
    window = glfwCreateWindow( SCREEN_WIDTH, SCREEN_HEIGHT, "Hello World", NULL, NULL );
    
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
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents( );
        
        glClear( GL_COLOR_BUFFER_BIT );
        
        // render OpenGL here
        drawCircle( SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, R, 10000 );
        glColor3f(0.0f, 0.0f, 0.0f);    // change draw color to black
        drawPlus(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, R, r);
        glColor3f(1.0f, 1.0f, 1.0f);    // change draw color to white
        drawCircle( SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, r / 2.0, 10000 );
        
        // Swap front and back buffers
        glfwSwapBuffers( window );
        
        // Poll for and process events
        glfwPollEvents( );
    }
    
    glfwTerminate( );
    
    return 0;
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
