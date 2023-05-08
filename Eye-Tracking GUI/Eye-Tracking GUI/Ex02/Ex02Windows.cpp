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
//#include <irrKlang.h>
#include "Shader.h"
#include <stdio.h>
#include <stdlib.h>
#include <io.h>             // Replaces #include <unistd.h>
#include <string.h>
#include <sys/types.h>
//#include <sys/socket.h>
//#include <arpa/inet.h>
//#include <netinet/in.h>
// Above 3 libraries replaced by...
#include <winsock2.h>
#include <WS2tcpip.h>

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>  // For strtod()
#include <math.h>

#define DSPACE_PORT 9931                    // to dSPACE
#define DSPACE_PORT2 9930                   // from dSPACE
#define RECEIVE_PORT 25000                  // from windows desktop
#define MAXLINE 1024
#define BUFLEN 80
#define DSPACE_IP "137.148.205.33"          // dSPACE
//#define HOSTIP "192.168.0.170"            // my macbook
//#define HOSTIP "137.148.205.62"           // linux desktop
//#define WD_IP "137.148.204.48"            // windows desktop
//#define WD_IP "192.168.140.7"             // windows desktop

// Global Variables
float angleValue = 0;                       // angle of transform
int targetNum = 0;                          // Number of current target
glm::vec4 transformedLocationInitial;       // Position of white block (initial reach point)
glm::vec4 transformedLocationFinal;         // Position of green block (final reach point)
float handX = 0;                          // Hand x-position from -1 to 1
float handY = 0;                            // Hand y-position from -1 to 1
float eyeX = 0;                             // Eye x-position from -1 to 1
float eyeY = 0;                             // Eye y-position from -1 to 1
float xEdge = 0.03;                         // x dimension of triangle vertices from -1 to 1 (.05)
float yEdge = 0.055;                        // y dimension of triangle vertices from -1 to 1 (.08)
int state = 0;                              // state determines which block appears next
int reachNumber = 1;                        // Reach number
bool whiteSquareHand = false;               // True if hand is within bounds of white square
bool greenSquareHand = false;               // True if hand is within bounds of green square
bool whiteSquareEye = false;                // True if eye is within bounds of white square
bool greenSquareEye = false;                // True if eye is within bounds of green square
int temp = 0;                               // Variable that determines where we are in the program
bool eyeStable = false;

double udpData[10];                         // UDP packet to send (time, target #, target (x,y), POG(x,y,z), opto(x,y,z))
double POG[3];                              // Raw POG data in inches
double optoData[3];                         // Raw optotrak data in mm
double PIH1;
double PIV1;

// Variables for cursor velocity
float currentTime;                          // Time in the current frame
float timer;
float stabilityTimer;
float stabilityVal;
float stabilityX;
float stabilityY;
float val;                                  // Stored clock value for timer reset
int frame = 0;                              // Frame number

// Declare Functions
void processInput(GLFWwindow *window);
static void cursorPositionCallback(GLFWwindow *window, double xPos, double yPos);
void changePos(void);
void checkPos(void);
void whatStep(void);

// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 500;     // Test window with same ratio as full screen (800 X 500)
//const GLuint WIDTH = 1920, HEIGHT = 1032; // Full screen Samsung TV (1920 X 1032)
//const GLuint WIDTH = 1440, HEIGHT = 855;  // Full screen Macbook

//-----------------------------------------------------------------------
//                              Receive_UDP
//
// This function receives Optotrak data from the windows desktop
//-----------------------------------------------------------------------
void Receive_UDP(void)
{
    // Extra initialization needed for winsock.h
    int iResult;
    WSADATA wsaData;
    // Initialize Winsock
    iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (iResult != 0) {
        std::cerr << "WSAStartup failed: " << iResult << "\n";
    }
    
    int receive_socket;
    uint8_t buffer[BUFLEN];
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
    optotrakaddr.sin_port = htons(RECEIVE_PORT);
    
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
    retval = recvfrom(receive_socket, buffer, MAXLINE,
                      MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                      &len);
    
    // Decode Byte Stream into point of gaze
    std::vector<double> destination;
    
    for (int r = 0; r<24; r+=8)
    {
        union { uint8_t b[8]; double d; };
        
        b[7] = (uint8_t)buffer[r];
        b[6] = (uint8_t)buffer[r+1];
        b[5] = (uint8_t)buffer[r+2];
        b[4] = (uint8_t)buffer[r+3];
        b[3] = (uint8_t)buffer[r+4];
        b[2] = (uint8_t)buffer[r+5];
        b[1] = (uint8_t)buffer[r+6];
        b[0] = (uint8_t)buffer[r+7];
        
        destination.push_back(d);
    }
    
    optoData[0] = destination[0];
    optoData[1] = destination[1];
    optoData[2] = destination[2];
    //printf("Buffer: %f, %f, %f\n", optoData[0], optoData[1], optoData[2]);
    
    // Map optotrak coordinates to screen coordinates
    double slopeX = 1.0 * (WIDTH - 0) / (1208.087 - 0);     // Slope for mapping optotrak X coordinates to screen coordinates
    double slopeY = 1.0 * (HEIGHT - 0) / (649.2875 - 0);    // Slope for mapping optotrak Y coordinates to screen coordinates
    double outputX = 0 + round(slopeX * (optoData[0] - 0));
    double outputY = 0 + round(slopeY * (optoData[1] - 0));
    
    handX = (outputX-(WIDTH/2))/(WIDTH/2);                  // in screen coordinates from -1 to 1
    handY = -(outputY-(HEIGHT/2))/(HEIGHT/2);               // in screen coordinates from -1 to 1
    //std::cout << outputX << ":" << outputY << std::endl;
    
    WSACleanup();           //Replaces close(receive_socket);
}

//-----------------------------------------------------------------------
//                              Receive_UDP2
//
// This function receives eye gaze data from dSPACE
//-----------------------------------------------------------------------
void Receive_UDP2(void)
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
    dSPACEaddr2.sin_port = htons(DSPACE_PORT2);
    
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
    
    for (int r = 0; r<16; r+=8)
    {
        union { uint8_t b[8]; double d; };
        
        b[7] = (uint8_t)buffer[r];
        b[6] = (uint8_t)buffer[r+1];
        b[5] = (uint8_t)buffer[r+2];
        b[4] = (uint8_t)buffer[r+3];
        b[3] = (uint8_t)buffer[r+4];
        b[2] = (uint8_t)buffer[r+5];
        b[1] = (uint8_t)buffer[r+6];
        b[0] = (uint8_t)buffer[r+7];
        
        destination.push_back(d);
    }
    
    PIH1 = destination[0];
    PIV1 = destination[1];
    
    //printf("Eye Gaze Data - x: %f y: %f z: %f\n", POG[0], POG[1], POG[2]);
    
    // Map POG data to screen coordinates
    double slopeX = 1.0 * (WIDTH - 0) / (511 - 0);     // Slope for mapping POG X coordinates to screen coordinates (inches)
    double slopeY = 1.0 * (HEIGHT - 0) / (511 - 0);    // Slope for mapping POG Y coordinates to screen coordinates (inches)
    double outputX = 0 + round(slopeX * (PIH1 - 0));
    double outputY = 0 + round(slopeY * (PIV1 - 0));
    
    eyeX = (outputX-(WIDTH/2))/(WIDTH/2);                   // in screen coordinates from -1 to 1
    eyeY = -(outputY-(HEIGHT/2))/(HEIGHT/2);                // in screen coordinates from -1 to 1
    //std::cout << eyeX << ":" << eyeY << std::endl;
    
    close(receive_socket2);
}

//-----------------------------------------------------------------------
//                              Send_UDP
//
// This function sends optotrak data, target positions and time to dSPACE
//-----------------------------------------------------------------------
void Send_UDP(void)
{
    int send_socket;
    struct sockaddr_in dSPACEaddr;
    
    // Create test data
    udpData[0] = currentTime;
    udpData[1] = targetNum;
    udpData[2] = transformedLocationFinal[0];
    udpData[3] = transformedLocationFinal[1];
    udpData[4] = POG[0];
    udpData[5] = POG[1];
    udpData[6] = POG[2];
    udpData[7] = optoData[0];
    udpData[8] = optoData[1];
    udpData[9] = optoData[2];
    
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
    
    // Concatenate byte stream vectors into a single vector
    std::vector<int> results;
    results.reserve(g1.size() + g2.size() + g3.size() + g4.size() + g5.size() + g6.size() + g7.size() + g8.size() + g9.size() + g10.size());
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
    dSPACEaddr.sin_port = htons(DSPACE_PORT);
    //dSPACEaddr.sin_addr.s_addr = INADDR_ANY;       // Doesn't seem to work
    dSPACEaddr.sin_addr.s_addr = inet_addr(DSPACE_IP);  //dSPACE
    
    sendto(send_socket, buf_send, BUFLEN,
           0, (const struct sockaddr *) &dSPACEaddr,
           sizeof(dSPACEaddr));
    
    close(send_socket);
}

//-----------------------------------------------------------------------
//                              M A I N
//
// From here we start the application and run the game loop
//-----------------------------------------------------------------------
int main( )
{
    // Init GLFW
    glfwInit( );
    
    // Seed random number generator (means RNG will be different every time)
    srand((int)time(NULL));
    changePos();        // Changes the value of global variable 'angleValue'
    //Receive_UDP();
    //Receive_UDP2();
    stabilityX = eyeX;
    stabilityY = eyeY;
    stabilityVal = glfwGetTime();       // reset stability timer
    
    // Set all the required options for GLFW
    glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
    glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
    glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );
    glfwWindowHint( GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE );
    
    glfwWindowHint( GLFW_RESIZABLE, GL_FALSE );
    
    // Create a GLFWwindow object that we can use for GLFW's functions
    GLFWwindow *window = glfwCreateWindow( WIDTH, HEIGHT, "Eye-Tracking Experiment", nullptr, nullptr );
    
    glfwSetCursorPosCallback(window, cursorPositionCallback);
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);
    //glfwSetCursorPos(window, 0, 0);
    
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
    
    glBindVertexArray( 0 ); // Unbind VAO
    
    // Game loop
    while ( !glfwWindowShouldClose( window ) )
    {
        //Receive_UDP();
        //printf("Optotrak Data - x: %f y: %f z: %f\n", optoData[0], optoData[1], optoData[2]);
        //Receive_UDP2();
        //printf("Plane Intercepts - H: %f V: %f\n", PIH1, PIV1);
        //printf("Eye positions - x: %f y: %f\n", eyeX, eyeY);
        
        frame++;
        
        processInput( window );
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents( );
        //glfwWaitEvents();
        
        currentTime = glfwGetTime();
        
        if (frame > 1)
        {
            timer = glfwGetTime() - val;
            stabilityTimer = glfwGetTime() - stabilityVal;
            checkPos();
            //printf("Stability timer: %f\n", stabilityTimer);
            //printf("eyeStable: %i, whiteSquareEye: %i, greenSquareEye: %i, whiteSquareHand: %i, greenSquareHand: %i\n", eyeStable, whiteSquareEye, greenSquareEye, whiteSquareHand, greenSquareHand);
            whatStep();
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
        transform = glm::translate( transform, cubePositions[0] );
        transform = glm::translate( transform, glm::vec3( 0.0f, -0.90f, 0.0f ) );
        GLint transformLocation = glGetUniformLocation( ourShader.Program, "transform" );
        glUniformMatrix4fv( transformLocation, 1, GL_FALSE, glm::value_ptr( transform ) );
        transformedLocationInitial = transform * cubePositionInitial;
        
        float redValue = 1.0f;
        float greenValue = 1.0f;
        float blueValue = 1.0f;
        int vertexColorLocation = glGetUniformLocation(ourShader.Program, "colorChange");
        glUniform3f(vertexColorLocation, redValue, greenValue, blueValue);
        glDrawArrays( GL_TRIANGLES, 0, 6 );
        
        transform = glm::translate( transform, cubePositions[1] );
        transform = glm::rotate( transform, angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transform = glm::translate( transform, glm::vec3( .75f, 0.0f, 0.0f ) );
        transform = glm::rotate( transform, -angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transformLocation = glGetUniformLocation( ourShader.Program, "transform" );
        glUniformMatrix4fv( transformLocation, 1, GL_FALSE, glm::value_ptr( transform ) );
        transformedLocationFinal = transform * cubePositionFinal;
        
        vertexColorLocation = glGetUniformLocation(ourShader.Program, "colorChange");
        glUniform3f(vertexColorLocation, 1.0f, 0.0f, 0.0f);
        
        if (state == 1)
        {
            glDrawArrays( GL_TRIANGLES, 0, 6 );
        }
        else if (state == 2)
        {
            glUniform3f(vertexColorLocation, 0.0f, 1.0f, 0.0f);
            glDrawArrays( GL_TRIANGLES, 0, 6 );
        }
        
        glBindVertexArray( 0 );
        
        // Swap the screen buffers
        glfwSwapBuffers( window );
        
        Send_UDP();
        //printf("Sent Data: Time,     TargetNum, Target X,  Target Y,  POGx,     POGy,     POGz,     optoX,     optoY,     optoZ\n");
        //printf("Sent Data: %f, %i,         %f, %f, %f, %f, %f, %f, %f, %f\n", glfwGetTime(), targetNum, transformedLocationFinal[0], transformedLocationFinal[1], POG[0], POG[1], POG[2], optoData[0], optoData[1], optoData[2]);
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
    
    eyeX = (xPos-(WIDTH/2))/(WIDTH/2);
    eyeY = -(yPos-(HEIGHT/2))/(HEIGHT/2);
    handX = (xPos-(WIDTH/2))/(WIDTH/2);
    handY = -(yPos-(HEIGHT/2))/(HEIGHT/2);
    
    //std::cout << eyeX << ":" << eyeY << std::endl;
    //std::cout << handX << ":" << handY << std::endl;
    
}

void changePos()
{
    //int angles[7] = {0, 30, 60, 90, 120, 150, 180};
    int angles[10] = {0, 20, 40, 60, 80, 100, 120, 140, 160, 180};
    int numTargets = sizeof(angles)/sizeof(angles[0]);
    //printf("Size of angles: %i\n", test);
    targetNum = glm::linearRand(1, numTargets);
    angleValue = angles[targetNum - 1];
    //printf("targetNum: %i, angleValue: %f\n", targetNum, angleValue);
    //angleValue = glm::linearRand(0, 180);
    //std::cout << angleValue << std::endl;
    angleValue = glm::radians(angleValue);
}

double round(double d)
{
    return floor(d + 0.5);
}

void checkPos()             // This function checks the positions of the hand and eyes
{
    if (handX < transformedLocationInitial[0] + xEdge && handX > transformedLocationInitial[0] -xEdge && handY < transformedLocationInitial[1] + yEdge && handY > transformedLocationInitial[1] -yEdge)
    {
        whiteSquareHand = true;
    }
    else
    {
        whiteSquareHand = false;
        //whiteSquareHand = true;
    }
    
    if ( handX < transformedLocationFinal[0] + xEdge && handX > transformedLocationFinal[0] - xEdge && handY < transformedLocationFinal[1] + yEdge && handY > transformedLocationFinal[1] - yEdge)
    {
        greenSquareHand = true;
    }
    else
    {
        greenSquareHand = false;
        //greenSquareHand = true;
    }
    
    if (eyeX < transformedLocationInitial[0] + xEdge*10 && eyeX > transformedLocationInitial[0] -xEdge*10 && eyeY < transformedLocationInitial[1] + yEdge*10 && eyeY > transformedLocationInitial[1] -yEdge*10)
    {
        whiteSquareEye = true;
    }
    else
    {
        whiteSquareEye = false;
        //whiteSquareHand = true;
    }
    
    if ( eyeX < transformedLocationFinal[0] + xEdge*10 && eyeX > transformedLocationFinal[0] - xEdge*10 && eyeY < transformedLocationFinal[1] + yEdge*10 && eyeY > transformedLocationFinal[1] - yEdge*10)
    {
        greenSquareEye = true;
    }
    else
    {
        greenSquareEye = false;
        //greenSquareHand = true;
    }
    
    if (eyeX > stabilityX + xEdge || eyeX < stabilityX - xEdge || eyeY > stabilityY + yEdge || eyeY < stabilityY - yEdge)
    {
        stabilityVal = glfwGetTime();       //reset stabilityTimer
        stabilityX = eyeX;
        stabilityY = eyeY;
        eyeStable = false;
    }
    
    if (stabilityTimer >= 1.0)
    {
        eyeStable = true;
    }
}


void whatStep()
{
    switch (temp) {
        case 0:                                                         // White square appears. Eye and hand move to white square
            if (eyeStable && whiteSquareHand && whiteSquareEye)        // If eyes are stable within tolerance zone and hand is within bounds of the white square
            {
                val = glfwGetTime();         // reset timer
                temp = 1;
                //std::cout << "Attempting Reach " << reachNumber << "..." << std::endl;
            }
            break;
            
        case 1:                             // Subject eyes are stable within tolerance zone and hand remain on white square for 1 second
            if (timer >= 1.0)               // If eyes are stable within tolerance zone and hand is within the bounds of the white square for more than 1 second
            {
                printf("\007");
                //std::cout << "Hello\a" << std::endl;
                //std::cout << '\a';
                state = 1;                  // Red square appears
                temp = 2;
                //std::cout << "\nReach " << reachNumber << ": " << std::endl;
                //printf("Time: %f, Target: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n", glfwGetTime(), transformedLocationInitial[0], transformedLocationInitial[1], eyeX, eyeY, handX, handY);
            }
            
            if (!whiteSquareHand || !whiteSquareEye)           // If eyes and hand leave bounds of white square (tolerance for eyes) before 1 second has been reached
            {
                temp = 0;
                //std::cout << "Reach " << reachNumber << " aborted.\n" << std::endl;
                reachNumber++;
            }
            break;
            
        case 2:                                         // Red square appears. Eye only moves to red square
            if (eyeStable && greenSquareEye)            // If the subject's gaze is stable within tolerance zone
            {
                val = glfwGetTime();                    // reset timer
                temp = 3;
            }
            break;
            
        case 3:                                         // Subject eyes are within tolerance zone for 1 second
            if (timer >= 1.0)
            {
                //changePos();
                state = 2;                              // Red square changes to green
                temp = 4;
                //printf("Time: %f, Target: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n", glfwGetTime(), transformedLocationFinal[0], transformedLocationFinal[1], eyeX, eyeY, handX, handY);
            }
            
            if (!greenSquareEye || !whiteSquareHand)    // If eyes leave tolerance zone or hand leaves white square before 1 seconds has been reached
            {
                temp = 2;
            }
            
            break;
            
        case 4:                                                     // Red square changes to green. Hand moves to green square. Eye stays on green square
            if (greenSquareHand && eyeStable && greenSquareEye)     // If eyes are stable within tolerance zone and hand is within bounds of green square
            {
                val = glfwGetTime();                    // reset timer
                temp = 5;
            }
            break;
            
        case 5:                             // Red square changes to green. Subject eyes and hand on green square for 1 second
            if (timer >= 1.0)
            {
                temp = 0;
                state = 0;
                reachNumber++;
                //printf("Time: %f, Target: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n\n", glfwGetTime(), transformedLocationFinal[0], transformedLocationFinal[1], eyeX, eyeY, handX, handY);
                changePos();
            }
            
            if (!greenSquareHand || !greenSquareEye)      // If eyes or hand leaves bounds of the green square before 1 seconds has been reached
            {
                temp = 4;
            }
            break;
            
        default:
            break;
    }
}
