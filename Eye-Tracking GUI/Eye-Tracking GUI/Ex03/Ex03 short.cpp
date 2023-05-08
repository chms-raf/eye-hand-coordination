//-----------------------------------------------------------------------
//                              EXPERIMENT 03
//
// This experiment displays a bullseye/crosshair target in randomized
// horizontal and vertical positions at random time intervals
//-----------------------------------------------------------------------

// openGL specific includes
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/random.hpp>

// UDP required includes
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

// Other includes
#include <random>                           // needed for iota()
#include <vector>                           // needed for vector<>
#include <unistd.h>                         // needed for usleep()

// UDP Definitions
#define OPTOTRAK_RECEIVE_PORT 25000         // receive from optotrak
#define DSPACE_RECEIVE_PORT 9930            // receive from dSPACE
#define DSPACE_SEND_PORT 9931               // send to dSPACE
#define BUFLEN 96                           // Length of send UDP buffer (8 * number of UDP send elements)
#define MAXLINE 24                          // Maximum buffer length that can be received
#define DSPACE_IP "137.148.205.59"          // IP address of dSPACE

// Window Dimension Definitions
// Test window: 800 X 500
// Full screen Macbook: 1440 X 855
// Full screen samsung TV: 1920 X 1032
#define SCREEN_WIDTH 1920                   // Width of openGL window
#define SCREEN_HEIGHT 1032                   // Height of openGL window

// Fixation target definitions
#define R 25                                // radius of large circle
#define r 5                                 // radius of small circle
#define numTargets 6                        // number of possible fixation targets

// Global Variables
float defaultX = SCREEN_WIDTH / 2;          // X default position of fixation target
float defaultY = SCREEN_HEIGHT * 0.2;       // Y default position of fixation target
float X = defaultX;                         // X position of fixation target (start at default)
float Y = defaultY;                         // Y position of fixation target (start at default)
int targetIndex = 0;                        // Index of current target
int targetNum = 0;                          // Number of current target
int state = 0;                              // State of the program (0 for initial target, 1 for fixation target)
int reach = 0;                              // Current reach number
bool changePosition = false;                // If value is true, target will change positions
bool startVal = false;                      // If value is true, program will start
float resetVal = 0;                         // Set this value to current time to reset timer
float fixationTime = 0;                     // Specified time to delay targets until
double udpData[BUFLEN / 8];                 // All data to send over UDP to dSPACE
double handX;                               // X position of hand (mm)
double handY;                               // Y position of hand (mm)
double handZ;                               // Z position of hand (mm)
double eyeX;                                // X position of eyes (mm)
double eyeY;                                // Y position of eyes (mm)
double eyeX_Screen;
double eyeY_Screen;
double X_mm;
double Y_mm;

// Fixation target positions
static float targets [numTargets][2]= {
    {0.2 * SCREEN_WIDTH, defaultY},
    {0.3 * SCREEN_WIDTH, defaultY},
    {0.7 * SCREEN_WIDTH, defaultY},
    {0.8 * SCREEN_WIDTH, defaultY},
    {defaultX, 0.4 * SCREEN_HEIGHT},
    {defaultX, 0.7 * SCREEN_HEIGHT}
};

// Function Declarations
void drawCursor( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLfloat radius );
void drawCircle( GLfloat x, GLfloat y, GLfloat z, GLfloat Radius, GLint numberOfSides );
void drawPlus( GLfloat x, GLfloat y, GLfloat z );
void processInput( GLFWwindow *window );
void changePos( int array[], int count );
int * shuffleTargets( );
void randomizeTime( );
double round( double d );
void Send_UDP( float time, float timer );
void Receive_UDP_Hand( );
void Receive_UDP_Eye( );

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
    
    
    // Beginning of experiment specific code -->
    
    // Randomize initial target array
    srand((int)time(NULL));                     // Seed random number generator (means RNG will be different every time)
    int * array;                                // Create pointer to array
    array = shuffleTargets();                   // Randomize array of fixation target indices
    
    int targetCounter = 0;                      // Counter that tells program when to re-shuffle target array
    float time;                                 // Running clock
    float timer;                                // Timer that can be reset to zero. Determines when targets change positions
    randomizeTime();
    
    // Game Loop
    while ( !glfwWindowShouldClose( window ) )  // Will run until the window is closed
    {
        processInput( window );                 // Processes user input
        glClear( GL_COLOR_BUFFER_BIT );         // clears the openGL window at the start of each frame
        
        if (startVal) {                         // Program will start when the ENTER key is pressed
            time = glfwGetTime();
            timer = glfwGetTime() - resetVal;
            
            // Receive UDP packets
            Receive_UDP_Eye();
            Receive_UDP_Hand();
            
            // If specified time has passed, display fixation target
            if (state == 0 && timer >= fixationTime)
            {
                changePosition = true;
                resetVal = glfwGetTime();
                state = 1;
                reach++;
                fixationTime = 3.0;
                
            }
            
            // If target has been displayed for 3 seconds, display starting target
            else if (state == 1 && timer >= fixationTime)
            {
                X = defaultX;
                Y = defaultY;
                state = 0;
                targetNum = 0;
                resetVal = glfwGetTime();
                randomizeTime();
            }
            
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
            drawCursor(eyeX_Screen, eyeY_Screen, 0, SCREEN_WIDTH, 1);     //Provides eye feedback
            
            // Map target data to mm
            double slopeX = 1.0 * (1210 - 0) / (SCREEN_WIDTH - 0);               // Slope for mapping POG X coordinates to screen coordinates (inches)
            double slopeY = 1.0 * (651 - 0) / (SCREEN_HEIGHT - 0);              // Slope for mapping POG Y coordinates to screen coordinates (inches)
            double outputX = 0 + round(slopeX * (X - 0));
            double outputY = 0 + round(slopeY * (Y - 0));
            
            X_mm = outputX;
            Y_mm = outputY;
            
            // Send UDP packet
            //printf("UDP Packet: Time, Timer, Fixation Time, Reach, Target, Target X, Target Y, Eye X, Eye Y, Hand X, Hand Y, Hand Z\n");
            //printf("UDP Packet: %f, %f, %f, %i, %i, %f, %f, %f, %f, %f, %f, %f\n\n", time, timer, fixationTime, reach, targetNum, X, Y, eyeX, eyeY, handX, handY, handZ);
            Send_UDP(time, timer);
            
            // Swap front and back buffers
            glfwSwapBuffers( window );
            usleep(1000);           // Sleep for 1 ms or 1000 microseconds; This conserves CPU usage
            
            glfwPollEvents();
        }
        
        else {
            // Draw fixation target
            drawCircle( defaultX, defaultY, 0, R, 10000 );
            glColor3f( 0.0f, 0.0f, 0.0f );    // change draw color to black
            drawPlus( defaultX, defaultY, 0 );
            glColor3f( 1.0f, 1.0f, 1.0f );    // change draw color to white
            drawCircle( defaultX, defaultY, 0, r / 2.0, 10000 );
            // Swap front and back buffers
            glfwSwapBuffers( window );
            
            // Poll for and process events
            //glfwWaitEventsTimeout(3.0);
            glfwWaitEvents( );
            //glfwPollEvents();
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
    
    if(glfwGetKey(window, GLFW_KEY_ENTER) == GLFW_PRESS)
    {
        startVal = true;
        glfwSetTime(0.0);
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
    
    return array;
}

//-----------------------------------------------------------------------
//                              randomizeTime
//
// This function chooses a random fixation time value between a specified
// interval
//-----------------------------------------------------------------------
void randomizeTime(void)
{
    float tempTime = glm::linearRand(2, 5);;    // Random number between specified interval
    float tempNum = glm::linearRand(1,2);
    float num = round(tempNum);
    if (num > 1.0) {
        fixationTime = round(tempTime) + 0.5;   // Round number to nearest half integer. Determines when targets change positions
    }
    else {
        fixationTime = round(tempTime);         // Round number to nearest integer. Determines when targets change positions
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
    
    // Create test data
    udpData[0] = time;
    udpData[1] = timer;
    udpData[2] = fixationTime;
    udpData[3] = reach;
    udpData[4] = targetNum;
    udpData[5] = X_mm;
    udpData[6] = Y_mm;
    udpData[7] = eyeX;
    udpData[8] = eyeY;
    udpData[9] = handX;
    udpData[10] = handY;
    udpData[11] = handZ;
    
    // encode data into byte stream
    std::vector<int> g1;
    union{ double myDouble1; unsigned char myChars1[sizeof(double)]; };
    myDouble1 = udpData[0];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g1.push_back((int)myChars1[k]);
        //std::cout << (int)myChars1[k] << ' ';
    }
    
    std::vector<int> g2;
    union{ double myDouble2; unsigned char myChars2[sizeof(double)]; };
    myDouble2 = udpData[1];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g2.push_back((int)myChars2[k]);
    }
    
    std::vector<int> g3;
    union{ double myDouble3; unsigned char myChars3[sizeof(double)]; };
    myDouble3 = udpData[2];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g3.push_back((int)myChars3[k]);
    }
    
    std::vector<int> g4;
    union{ double myDouble4; unsigned char myChars4[sizeof(double)]; };
    myDouble4 = udpData[3];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g4.push_back((int)myChars4[k]);
    }
    
    std::vector<int> g5;
    union{ double myDouble5; unsigned char myChars5[sizeof(double)]; };
    myDouble5 = udpData[4];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g5.push_back((int)myChars5[k]);
    }
    
    std::vector<int> g6;
    union{ double myDouble6; unsigned char myChars6[sizeof(double)]; };
    myDouble6 = udpData[5];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g6.push_back((int)myChars6[k]);
    }
    
    std::vector<int> g7;
    union{ double myDouble7; unsigned char myChars7[sizeof(double)]; };
    myDouble7 = udpData[6];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g7.push_back((int)myChars7[k]);
    }
    
    std::vector<int> g8;
    union{ double myDouble8; unsigned char myChars8[sizeof(double)]; };
    myDouble8 = udpData[7];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g8.push_back((int)myChars8[k]);
    }
    
    std::vector<int> g9;
    union{ double myDouble9; unsigned char myChars9[sizeof(double)]; };
    myDouble9 = udpData[8];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g9.push_back((int)myChars9[k]);
    }
    
    std::vector<int> g10;
    union{ double myDouble10; unsigned char myChars10[sizeof(double)]; };
    myDouble10 = udpData[9];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g10.push_back((int)myChars10[k]);
    }
    
    std::vector<int> g11;
    union{ double myDouble11; unsigned char myChars11[sizeof(double)]; };
    myDouble11 = udpData[10];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g11.push_back((int)myChars11[k]);
    }
    
    std::vector<int> g12;
    union{ double myDouble12; unsigned char myChars12[sizeof(double)]; };
    myDouble12 = udpData[11];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g12.push_back((int)myChars12[k]);
    }
    
    // Concatenate byte stream vectors into a single vector
    std::vector<int> results;
    results.reserve(g1.size() + g2.size() + g3.size() + g4.size() + g5.size() + g6.size() + g7.size() + g8.size() + g9.size() + g10.size() + g11.size() + g12.size());
    results.insert(results.end(), g1.begin(), g1.end());
    results.insert(results.end(), g2.begin(), g2.end());
    results.insert(results.end(), g3.begin(), g3.end());
    results.insert(results.end(), g4.begin(), g4.end());
    results.insert(results.end(), g5.begin(), g5.end());
    results.insert(results.end(), g6.begin(), g6.end());
    results.insert(results.end(), g7.begin(), g7.end());
    results.insert(results.end(), g8.begin(), g8.end());
    results.insert(results.end(), g9.begin(), g9.end());
    results.insert(results.end(), g10.begin(), g10.end());
    results.insert(results.end(), g11.begin(), g11.end());
    results.insert(results.end(), g12.begin(), g12.end());
    
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
//                              Receive_UDP_Hand
//
// This function receives Optotrak data from the windows desktop
//-----------------------------------------------------------------------
void Receive_UDP_Hand(void)
{
    int receive_socket;
    double buffer[MAXLINE];
    struct sockaddr_in optotrakaddr, cliaddr;
    
    // Creating socket file descriptor
    if ( (receive_socket = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    memset(&optotrakaddr, 0, sizeof(optotrakaddr));
    memset(&cliaddr, 0, sizeof(cliaddr));
    
    // Filling server information
    optotrakaddr.sin_family = AF_INET; // IPv4
    optotrakaddr.sin_port = htons(OPTOTRAK_RECEIVE_PORT);
    
    // Bind the socket with the server address
    if ( bind(receive_socket, (const struct sockaddr *)&optotrakaddr,
              sizeof(optotrakaddr)) < 0 )
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    socklen_t len = sizeof(optotrakaddr);
    long retval;
    
    // Receive packet
    retval = recvfrom(receive_socket, (double *)buffer, MAXLINE,
                      MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                      &len);
    buffer[retval] = '\0';
    
    handX = buffer[0];      // optotrak coordinates (mm)
    handY = buffer[1];      // optotrak coordinates (mm)
    handZ = buffer[2];      // optotrak coordinates (mm)
    
    close(receive_socket);
}

//-----------------------------------------------------------------------
//                              Receive_UDP_Eye
//
// This function receives eye gaze data from dSPACE
//-----------------------------------------------------------------------
void Receive_UDP_Eye(void)
{
    int receive_socket2;
    uint8_t buffer[BUFLEN];
    struct sockaddr_in dSPACEaddr2, cliaddr;
    
    // Creating socket file descriptor
    if ( (receive_socket2 = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    memset(&dSPACEaddr2, 0, sizeof(dSPACEaddr2));
    memset(&cliaddr, 0, sizeof(cliaddr));
    
    // Filling server information
    dSPACEaddr2.sin_family = AF_INET; // IPv4
    dSPACEaddr2.sin_port = htons(DSPACE_RECEIVE_PORT);
    
    // Bind the socket with the server address
    if ( bind(receive_socket2, (const struct sockaddr *)&dSPACEaddr2,
              sizeof(dSPACEaddr2)) < 0 )
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    socklen_t len = sizeof(dSPACEaddr2);
    long retval;
    
    // Receive packet
    retval = recvfrom(receive_socket2, buffer, BUFLEN,
                      MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                      &len);
    
    // Decode Byte Stream into point of gaze
    std::vector<double> destination;
    
    for (int s = 0; s<16; s+=8)
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
    
    // Map eye data to screen coordinates
    double slopeX = 1.0 * (SCREEN_WIDTH - 0) / (511 - 0);               // Slope for mapping POG X coordinates to screen coordinates (inches)
    double slopeY = 1.0 * (SCREEN_HEIGHT - 0) / (0 - 511);              // Slope for mapping POG Y coordinates to screen coordinates (inches)
    double outputX = 0 + round(slopeX * (destination[0] - 0));
    double outputY = 0 + round(slopeY * (destination[1] - 511));
    
    eyeX_Screen = outputX;
    eyeY_Screen = outputY;
    
    // Map eye data to mm
    slopeX = 1.0 * (1210 - 0) / (511 - 0);               // Slope for mapping POG X coordinates to screen coordinates (inches)
    slopeY = 1.0 * (651 - 0) / (0 - 511);              // Slope for mapping POG Y coordinates to screen coordinates (inches)
    outputX = 0 + round(slopeX * (destination[0] - 0));
    outputY = 0 + round(slopeY * (destination[1] - 511));
    
    eyeX = outputX;
    eyeY = outputY;
    
    close(receive_socket2);
}
