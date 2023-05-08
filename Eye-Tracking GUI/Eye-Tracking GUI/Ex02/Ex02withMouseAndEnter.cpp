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
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>  // For strtod()
#include <math.h>

#define DSPACE_PORT 9931                    // to dSPACE
#define DSPACE_PORT2 9930                   // from dSPACE
#define RECEIVE_PORT 25000                  // from windows desktop
#define MAXLINE 1024                        // Max length of receive buffer (Probably doesn't need to be this long)
#define BUFLEN 80                           // Length of UDP send buffer (10 doubles * 8 bytes each = 80 bytes)
#define DSPACE_IP "137.148.204.169"         // dSPACE
//#define HOSTIP "172.20.41.226"            // my macbook
//#define HOSTIP "137.148.205.62"           // linux desktop
//#define WD_IP "137.148.204.48"            // windows desktop
//#define WD_IP "192.168.140.7"             // windows desktop

// Global Variables
float angleValue = 0;                       // angle of transform
int targetNum = 0;                          // Number of current target
glm::vec4 transformedLocationInitial;       // Position of white block (initial reach point)
glm::vec4 transformedLocationFinal;         // Position of green block (final reach point)
float handX = 0;                            // Hand x-position from -1 to 1
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
bool trigger = false;                       // True if enter is pressed. This is to use in place of POG data for testing
int temp = 0;                               // Variable that determines where we are in the program

double udpData[10];                         // UDP packet to send (time, target #, target (x,y), POG(x,y,z), opto(x,y,z))
double POG[3];                              // Raw POG data in inches
double optoData[3];                         // Raw optotrak data in mm

// Variables for cursor velocity
float currentTime;                          // Time in the current frame
float timer;
float val;                                  // Stored clock value for timer reset
int frame = 0;                              // Frame number

// Declare Functions
void processInput(GLFWwindow *window);
static void cursorPositionCallback(GLFWwindow *window, double xPos, double yPos);
void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods);
void changePos(void);
void checkPos(void);
void whatStep(void);

// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 500;         // Test window with same ratio as full screen (800 X 500)
//const GLuint WIDTH = 1920, HEIGHT = 1032;      // Full screen Samsung TV (1920 X 1032)
//const GLuint WIDTH = 1440, HEIGHT = 855;      // Full screen Macbook

//-----------------------------------------------------------------------
//                              Receive_UDP
//
// This function receives Optotrak data from the windows desktop
//-----------------------------------------------------------------------
void Receive_UDP(void)
{
    int receive_socket;
    double buffer[MAXLINE];
    //char const *hello = "Hello from server";
    //double udpReceiveData[4];
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
    retval = recvfrom(receive_socket, (double *)buffer, MAXLINE,
                      MSG_WAITALL, ( struct sockaddr *) &cliaddr,
                      &len);
    buffer[retval] = '\0';
    
    optoData[0] = buffer[0];
    optoData[1] = buffer[1];
    optoData[2] = buffer[2];
    
    close(receive_socket);
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
    
    POG[0] = destination[0];
    POG[1] = destination[1];
    POG[2] = destination[2];
    //printf("Eye Gaze Data - x: %f y: %f z: %f\n", POG[0], POG[1], POG[2]);
    
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
    myDouble9 = udpData[9];
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
    //double slopeX = 1.0 * (WIDTH - 0) / (1208.087 - 0);     // Slope for mapping optotrak X coordinates to screen coordinates
    //double slopeY = 1.0 * (HEIGHT - 0) / (649.2875 - 0);    // Slope for mapping optotrak Y coordinates to screen coordinates
    
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
    GLFWwindow *window = glfwCreateWindow( WIDTH, HEIGHT, "Eye-Tracking Experiment", nullptr, nullptr );
    
    glfwSetMouseButtonCallback(window, mouseButtonCallback);
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
        //printf("Point of Gaze - x: %f y: %f z: %f\n", POG[0], POG[1], POG[2]);
        
        frame++;
        trigger = false;
        
        processInput( window );
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents( );
        //glfwWaitEvents();
        
        /*
         // Map optotrak coordinates to screen coordinates
         double outputX = 0 + round(slopeX * (optoData[0] - 0));
         double outputY = 0 + round(slopeY * (optoData[1] - 0));
         
         handX = (outputX-(WIDTH/2))/(WIDTH/2);      // in screen coordinates from -1 to 1
         handY = -(outputY-(HEIGHT/2))/(HEIGHT/2);   // in screen coordinates from -1 to 1
         //std::cout << outputX << ":" << outputY << std::endl;
         */
        
        if (frame > 1)
        {
            checkPos();
            timer = glfwGetTime() - val;
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
        //glm::vec4 transformedLocationInitial = transform * cubePositionInitial;
        //std::cout << "Initial Position: " << transformedLocationInitial[0] << ":" << transformedLocationInitial[1] << std::endl;
        
        transform = glm::translate( transform, cubePositions[1] );
        transform = glm::rotate( transform, angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transform = glm::translate( transform, glm::vec3( .95f, 0.0f, 0.0f ) );
        transform = glm::rotate( transform, -angleValue, glm::vec3( 0.0f, 0.0f, 1.0f ) );
        transformLocation = glGetUniformLocation( ourShader.Program, "transform" );
        glUniformMatrix4fv( transformLocation, 1, GL_FALSE, glm::value_ptr( transform ) );
        
        transformedLocationFinal = transform * cubePositionFinal;
        //std::cout << "Final Position: " << transformedLocationFinal[0] << ":" << transformedLocationFinal[1] << std::endl;
        
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
        
        //Send_UDP();
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
    
    if(glfwGetKey(window, GLFW_KEY_ENTER) == GLFW_PRESS)
    {
        trigger = true;
    }
    
}

static void cursorPositionCallback( GLFWwindow *window, double xPos, double yPos)
{
    
    eyeX = (xPos-(WIDTH/2))/(WIDTH/2);
    eyeY = -(yPos-(HEIGHT/2))/(HEIGHT/2);
    //std::cout << handX << ":" << handY << std::endl;
    
    
}

void mouseButtonCallback(GLFWwindow *window, int button, int action, int mods)
{
    /*
     if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE)
     {
     if (state == 0)
     {
     if ( whiteSquareHand )
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
     
     if ( greenSquareHand )
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
    }
    
    if ( handX < transformedLocationFinal[0] + xEdge && handX > transformedLocationFinal[0] - xEdge && handY < transformedLocationFinal[1] + yEdge && handY > transformedLocationFinal[1] - yEdge)
    {
        greenSquareHand = true;
    }
    else
    {
        greenSquareHand = false;
    }
    
    if (eyeX < transformedLocationInitial[0] + xEdge && eyeX > transformedLocationInitial[0] -xEdge && eyeY < transformedLocationInitial[1] + yEdge && eyeY > transformedLocationInitial[1] -yEdge)
    {
        whiteSquareEye = true;
    }
    else
    {
        whiteSquareEye = false;
    }
    
    if ( eyeX < transformedLocationFinal[0] + xEdge && eyeX > transformedLocationFinal[0] - xEdge && eyeY < transformedLocationFinal[1] + yEdge && eyeY > transformedLocationFinal[1] - yEdge)
    {
        greenSquareEye = true;
    }
    else
    {
        greenSquareEye = false;
    }
}


void whatStep()
{
    switch (temp) {
        case 0:                             // White square appears. Subject eye and hand moves to white square
            if (whiteSquareEye)             // If cursor is within the bounds of the white square
            {
                val = glfwGetTime();        // reset timer
                temp = 1;
            }
            break;
            
        case 1:                             // Subject eye and hand on white square for 1 second
            if (timer >= 1.0)               // If cursor is within the bounds of the white square for more than 1 second
            {
                state = 1;                  // Red square appears
                temp = 2;
                //printf("Reach %i: \n", reachNumber);
                //printf("Time: %f, Target 0: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n", glfwGetTime(), transformedLocationInitial[0], transformedLocationInitial[1], eyeX, eyeY, handX, handY);
            }
            
            if (!whiteSquareEye)            // If cursor leaves the bounds of the white square before 2 seconds has been reached
            {
                temp = 0;
            }
            break;
            
        case 2:                             // Red square appears. Subject move eyes only to red square
            if (greenSquareEye)             // If the cursor is within the bounds of the green square
            {
                val = glfwGetTime();        // reset timer
                temp = 3;
            }
            break;
            
        case 3:                             // Subject eyes on red square for 1 second
            if (timer >= 1.0)
            {
                state = 2;
                temp = 4;
                //printf("Time: %f, Target %i: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n", glfwGetTime(), targetNum, transformedLocationFinal[0], transformedLocationFinal[1], eyeX, eyeY, handX, handY);
            }
            
            if (!greenSquareEye)            // If cursor leaves the bounds of the white square before 1 seconds has been reached
            {
                val = glfwGetTime();        // reset timer
            }
            break;
            
        case 4:                             // Red square changes to green. Subject hand moves to green square
            if (trigger)
            {
                val = glfwGetTime();        // reset timer
                temp = 5;
            }
            break;
            
        case 5:                             // Red square changes to green. Subject hand moves to green square
            if (timer >= 1.0)
            {
                temp = 0;
                state = 0;
                reachNumber++;
                //printf("Time: %f, Target %i: (%f , %f), Eye: (%f , %f), Hand: (%f , %f)\n\n", glfwGetTime(), targetNum, transformedLocationFinal[0], transformedLocationFinal[1], eyeX, eyeY, handX, handY);
                changePos();
            }
            
            if (!greenSquareEye)            // If cursor leaves the bounds of the white square before 1 seconds has been reached
            {
                val = glfwGetTime();        // reset timer
                temp = 4;
            }
            break;
            
        default:
            break;
    }
}
