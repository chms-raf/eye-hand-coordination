//-----------------------------------------------------------------------
//                              Eye-Hand Coordination Experiment
//
// This program displays target info from dSPACE
//-----------------------------------------------------------------------

// openGL specific includes
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>

// UDP required includes
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

// Other includes
#include <vector>                           // needed for vector<>
#include <unistd.h>                         // needed for usleep()

// UDP Definitions
#define DSPACE_RECEIVE_PORT 9930            // receive from dSPACE
#define DSPACE_SEND_PORT 9931               // send to dSPACE
#define BUFLEN 40                           // Length of send UDP buffer (8 * number of UDP send elements)
#define MAXLINE 40                          // Maximum buffer length that can be received
#define DSPACE_IP "137.148.205.248"          // IP address of dSPACE

// Window Dimension Definitions
// Test window: 800 X 500
// Full screen Macbook: 1440 X 855
// Full screen samsung TV: 1920 X 1032
#define SCREEN_WIDTH 1920                 // Width of openGL window
#define SCREEN_HEIGHT 1032                   // Height of openGL window

// Fixation target definitions
#define R 25                                // radius of large circle
#define r 5                                 // radius of small circle

// Global Variables
float defaultX = SCREEN_WIDTH * 0.5;          // X default position of fixation target (screen coordinates)
float defaultY = SCREEN_HEIGHT * 0.7;       // Y default position of fixation target (screen coordinates)
float X;                                    // X position of fixation target (screen coordinates)
float Y;                                    // Y position of fixation target (screen coordinates)
float eyeX;                                 // X position of the eyes (iSCAN coordinates)
float eyeY;                                 // Y position of the eyes (iSCAN coordinates)
float eyeX_Screen;                          // X position of the eyes (Screen Coordinates)
float eyeY_Screen;                          // Y position of the eyes (Screen Coordinates)
float alphaX;                               // scale factor received from dSPACE that tells us where targets are
float alphaY;                               // scale factor received from dSPACE that tells us where targets are

bool startVal = false;                      // If value is true, program will start
float run;

// Function Declarations
void drawCursor( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius );
void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides );
void drawPlus( GLfloat x, GLfloat y, GLfloat z );
void processInput( GLFWwindow *window );
double round( double d );
void Send_UDP( float time, float timer );
void Receive_UDP( );
double linearMap( int x1, int x2, int y1, int y2, double x );
double inverselinearMap( int x1, int x2, int y1, int y2, double x );
static void cursorPositionCallback(GLFWwindow *window, double xPos, double yPos);

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
    window = glfwCreateWindow( SCREEN_WIDTH, SCREEN_HEIGHT, "Eye-Hand Coordination Experiment", NULL, NULL );
    glfwSetCursorPosCallback(window, cursorPositionCallback);
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_HIDDEN);
    
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
    glOrtho( 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 1 ); // essentially set coordinate system
    glMatrixMode( GL_MODELVIEW ); // (default matrix mode) modelview matrix defines how your objects are transformed (meaning translation, rotation and scaling) in your world
    glLoadIdentity( ); // same as above comment
    
    
    // Beginning of experiment specific code -->
    
    // Game Loop
    while ( !glfwWindowShouldClose( window ) )  // Will run until the window is closed
    {
        processInput( window );                 // Processes user input
        glClear( GL_COLOR_BUFFER_BIT );         // clears the openGL window at the start of each frame
        
        // Receive UDP packets
        Receive_UDP();
        
        if (run == 1.0) {                         // Program will start when it receives a run value of 1
            
            X = SCREEN_WIDTH * alphaX;
            Y = SCREEN_HEIGHT * alphaY;
            
            // Draw fixation target
            drawCircle( X, Y, 0, R, 100 );
            glColor3f(0.0f, 0.0f, 0.0f);        // change draw color to black
            drawPlus(X, Y, 0);
            glColor3f(1.0f, 1.0f, 1.0f);        // change draw color to white
            drawCircle( X, Y, 0, r / 2.0, 10 );
            
            // Draw cursor
            eyeX_Screen = linearMap(18, 511, 0, SCREEN_WIDTH, eyeX);
            eyeY_Screen = linearMap(34, 468, 0, SCREEN_HEIGHT, eyeY);
            //drawCursor(eyeX_Screen, eyeY_Screen, 0, SCREEN_WIDTH, 1);     //Provides eye feedback
            //printf("eyeX: %f, eyeY: %f\n", eyeX, eyeY);
            
            // Swap front and back buffers
            glfwSwapBuffers( window );
            usleep(1000);                       // Sleep for 1 ms or 1000 microseconds; This conserves CPU usage
            
            // Poll for and process events
            glfwPollEvents();
        }
        
        else {
            // Draw fixation target
            glColor3f( 1.0f, 0.0f, 0.0f );      // change draw color to red
            drawCircle( defaultX, defaultY, 0, R, 100 );
            glColor3f( 0.0f, 0.0f, 0.0f );      // change draw color to black
            drawPlus( defaultX, defaultY, 0 );
            glColor3f( 1.0f, 0.0f, 0.0f );      // change draw color to red
            drawCircle( defaultX, defaultY, 0, r / 2.0, 10 );
            glColor3f( 1.0f, 1.0f, 1.0f );      // change draw color to white
            
            // Swap front and back buffers
            glfwSwapBuffers( window );
            usleep(1000);
            
            // Poll for and process events
            //glfwWaitEventsTimeout(3.0);
            //glfwWaitEvents( );
            glfwPollEvents();
        }
    }
    
    glfwTerminate( );
    
    return 0;
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
        circleVerticesX[i] = x + ( Radius * cos( i * twicePi / numberOfSides ) );
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
    
    if(glfwGetKey(window, GLFW_KEY_ENTER) == GLFW_PRESS)
    {
        startVal = true;
        glfwSetTime(0.0);
    }
    
}

//-----------------------------------------------------------------------
//                              round
//
// This function rounds a double to the nearest integer
//-----------------------------------------------------------------------
double round(double d)
{
    return floor(d + 0.5);
}

//-----------------------------------------------------------------------
//                              Send_UDP
//
// This function sends optotrak data, target positions and time to dSPACE
//-----------------------------------------------------------------------
void Send_UDP(float time, float timer)
{
    int send_socket;
    struct sockaddr_in dSPACEaddr;
    double udpSendData[BUFLEN / 8];             // All data to send to dSPACE via UDP
    
    // Create test data
    //udpSendData[0] = time;
    //udpSendData[1] = X_mm;
    //udpSendData[2] = Y_mm;
    //udpSendData[3] = eyeX;
    //udpSendData[4] = eyeY;
    
    // encode data into byte stream
    std::vector<int> g1;
    union{ double myDouble1; unsigned char myChars1[sizeof(double)]; };
    myDouble1 = udpSendData[0];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g1.push_back((int)myChars1[k]);
        //std::cout << (int)myChars1[k] << ' ';
    }
    
    std::vector<int> g2;
    union{ double myDouble2; unsigned char myChars2[sizeof(double)]; };
    myDouble2 = udpSendData[1];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g2.push_back((int)myChars2[k]);
    }
    
    std::vector<int> g3;
    union{ double myDouble3; unsigned char myChars3[sizeof(double)]; };
    myDouble3 = udpSendData[2];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g3.push_back((int)myChars3[k]);
    }
    
    std::vector<int> g4;
    union{ double myDouble4; unsigned char myChars4[sizeof(double)]; };
    myDouble4 = udpSendData[3];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g4.push_back((int)myChars4[k]);
    }
    
    std::vector<int> g5;
    union{ double myDouble5; unsigned char myChars5[sizeof(double)]; };
    myDouble5 = udpSendData[4];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g5.push_back((int)myChars5[k]);
    }
    
    // Concatenate byte stream vectors into a single vector
    std::vector<int> results;
    results.reserve(g1.size() + g2.size() + g3.size() + g4.size() + g5.size());
    results.insert(results.end(), g1.begin(), g1.end());
    results.insert(results.end(), g2.begin(), g2.end());
    results.insert(results.end(), g3.begin(), g3.end());
    results.insert(results.end(), g4.begin(), g4.end());
    results.insert(results.end(), g5.begin(), g5.end());
    
    // Send Packet
    uint8_t buf_send[BUFLEN];
    for (int c = 0; c < BUFLEN; c++) {
        buf_send[c] = results[c];
    }
    
    // Creating socket file descriptor
    if ( (send_socket = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    memset(&dSPACEaddr, 0, sizeof(dSPACEaddr));
    
    // Filling server information
    dSPACEaddr.sin_family = AF_INET; // IPv4
    dSPACEaddr.sin_port = htons(DSPACE_SEND_PORT);
    //dSPACEaddr.sin_addr.s_addr = INADDR_ANY;       // Doesn't seem to work
    dSPACEaddr.sin_addr.s_addr = inet_addr(DSPACE_IP);  //dSPACE
    
    sendto(send_socket, buf_send, BUFLEN,
           0, (const struct sockaddr *) &dSPACEaddr,
           sizeof(dSPACEaddr));
    
    close(send_socket);
}

//-----------------------------------------------------------------------
//                              Receive_UDP
//
// This function receives data from dSPACE
//-----------------------------------------------------------------------
void Receive_UDP(void)
{
    int receive_socket;
    uint8_t buffer[MAXLINE];
    struct sockaddr_in dSPACEaddr, cliaddr;
    
    // Creating socket file descriptor
    if ( (receive_socket = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    memset(&dSPACEaddr, 0, sizeof(dSPACEaddr));
    memset(&cliaddr, 0, sizeof(cliaddr));
    
    // Filling server information
    dSPACEaddr.sin_family = AF_INET; // IPv4
    dSPACEaddr.sin_port = htons(DSPACE_RECEIVE_PORT);
    
    // Bind the socket with the server address
    if ( bind(receive_socket, (const struct sockaddr *)&dSPACEaddr,
              sizeof(dSPACEaddr)) < 0 )
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    socklen_t len = sizeof(dSPACEaddr);
    long retval;
    
    // Receive packet
    retval = recvfrom(receive_socket, buffer, MAXLINE,
                      MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                      &len);
    
    // Decode Byte Stream into data
    std::vector<double> destination;
    
    for (int s = 0; s<MAXLINE; s+=8)
    {
        union { uint8_t b[8]; double d; };
        
        b[7] = (uint8_t)buffer[s];
        b[6] = (uint8_t)buffer[s+1];
        b[5] = (uint8_t)buffer[s+2];
        b[4] = (uint8_t)buffer[s+3];
        b[3] = (uint8_t)buffer[s+4];
        b[2] = (uint8_t)buffer[s+5];
        b[1] = (uint8_t)buffer[s+6];
        b[0] = (uint8_t)buffer[s+7];
        
        destination.push_back(d);
    }
    
    alphaX = destination[0]; alphaY = destination[1];
    eyeX = destination[2]; eyeY = destination[3];
    run = destination[4];
    
    //printf("UDP_Data: %f, %f, %f, %f\n", alphaX, alphaY, eyeX, eyeY);
    // Map eye (iSCAN coordinates) to screen coordinates
    //eyeX_Screen = linearMap(18, 511, 0, SCREEN_WIDTH, destination[0]);
    //eyeY_Screen = inverselinearMap(18, 467, 0, SCREEN_HEIGHT, destination[1]);
    
    // Map eye (iSCAN coordinates) to mm
    //eyeX = linearMap(18, 511, 0, 1210, destination[0]);
    //eyeY = inverselinearMap(18, 467, 0, 651, destination[1]);
    
    close(receive_socket);
}

//-----------------------------------------------------------------------
//                             linearMap
//
// This function linearly maps one coordinate system to another
// Inputs: x1 -first coordinate of original coordinate system
//         x2 - second coordinate of original coordinate system
//         y1 -first coordinate of new coordinate system
//         y2 - second coordinate of new coordinate system
//          x - value of first coordinate system we want to transform
// Output:  y - value of transformed coordinate
//-----------------------------------------------------------------------
double linearMap(int x1, int x2, int y1, int y2, double x)
{
    double slope = 1.0 * (y2 - y1) / (x2 - x1);
    double y = slope * (x - x1);
    // Should this be instead y = slope * (x - x1) + y1???
    
    return y;
}

//-----------------------------------------------------------------------
//                             inverselinearMap
//
// This function inversely linearly maps one coordinate system to another
// Inputs: x1 -first coordinate of original coordinate system
//         x2 - second coordinate of original coordinate system
//         y1 -first coordinate of new coordinate system
//         y2 - second coordinate of new coordinate system
//          x - value of first coordinate system we want to transform
// Output:  y - value of transformed coordinate
//-----------------------------------------------------------------------
double inverselinearMap(int x1, int x2, int y1, int y2, double x)
{
    double slope = 1.0 * (y1 - y2) / (x2 - x1);
    double y = slope * (x - x2);
    // Should this be instead y = ???
    
    return y;
}

static void cursorPositionCallback( GLFWwindow *window, double xPos, double yPos)
{
    
     //X = (xPos-(SCREEN_WIDTH/2))/(SCREEN_WIDTH/2);
     //Y = -(yPos-(SCREEN_HEIGHT/2))/(SCREEN_HEIGHT/2);
     //std::cout << xPos << ":" << yPos << std::endl;
    //printf("x-coord: %f, y-coord: %f\n", xPos, yPos);

    
}
