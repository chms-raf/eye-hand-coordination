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

#define DSPACE_PORT 9931            // to dSPACE
#define DSPACE_PORT2 9930           // from dSPACE
#define RECEIVE_PORT 25000          // from windows desktop
#define MAXLINE 1024
#define BUFLEN 24
#define DSPACE_IP "137.148.204.122" // dSPACE
//#define HOSTIP "172.20.41.226"    // my macbook
//#define HOSTIP "137.148.205.62"   // linux desktop
//#define WD_IP "137.148.204.48"    // windows desktop
//#define WD_IP "192.168.140.7"     // windows desktop

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

double udpData[3];
double POG[3];
double optoData[3];

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
void changePos(void);

// Window dimensions
//const GLuint WIDTH = 800, HEIGHT = 500;         // Test window with same ratio as full screen (800 X 500)
const GLuint WIDTH = 1920, HEIGHT = 1032;      // Full screen Samsung TV
//const GLuint WIDTH = 1440, HEIGHT = 900;      // Full screen Macbook

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
    
    // It seems like you don't need to specify the IP address of the computer you want to receive from
    //optotrakaddr.sin_addr.s_addr = INADDR_ANY;      // Works but might be better to specify IP address
    //optotrakaddr.sin_addr.s_addr = inet_addr(WD_IP);  //windows desktop
    
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
    //printf("n = %lu\n", retval);
    //printf("Optotrak Data - x: %f y: %f z: %f\n", buffer[0], buffer[1], buffer[2]);
    
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
    //double buffer[MAXLINE];
    //char const *hello = "Hello from server";
    //double udpReceiveData[4];
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
    
    // It seems like you don't need to specify the IP address of the computer you want to receive from
    //optotrakaddr.sin_addr.s_addr = INADDR_ANY;          // Works but might be better to specify IP address
    //dSPACEaddr2.sin_addr.s_addr = inet_addr(DSPACE_IP);  //dSPACE
    
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
    //buffer[retval] = '\0';
    //printf("n = %lu\n", retval);
    
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
    udpData[0] = 15.9;
    udpData[1] = 150.4;
    udpData[2] = 21.2;
    
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
        //std::cout << (int)myChars2[k] << ' ';
    }
    
    std::vector<int> g3;
    union{ double myDouble3; unsigned char myChars3[sizeof(double)]; };
    myDouble3 = udpData[2];
    for( int k = sizeof(double)-1; k >= 0; k-- )
    {
        g3.push_back((int)myChars3[k]);
        //std::cout << (int)myChars3[k] << ' ';
    }
    
    // Concatenate byte stream vectors into a single vector
    std::vector<int> results;
    results.reserve(g1.size() + g2.size() + g3.size());
    results.insert(results.end(), g1.begin(), g1.end());
    results.insert(results.end(), g2.begin(), g2.end());
    results.insert(results.end(), g3.begin(), g3.end());
    
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
    double optoX, optoY, optoZ;
    double slopeX = 1.0 * (WIDTH - 0) / (1208.087 - 0);     // Slope for mapping optoX coordinates to screen coordinates
    double slopeY = 1.0 * (HEIGHT - 0) / (649.2875 - 0);     // Slope for mapping optoX coordinates to screen coordinates
    
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
        Receive_UDP();
        //printf("Optotrak Data - x: %f y: %f z: %f\n", optoData[0], optoData[1], optoData[2]);
        Receive_UDP2();
        //printf("Point of Gaze - x: %f y: %f z: %f\n", POG[0], POG[1], POG[2]);
        Send_UDP();
        
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
        
        
        // Map optotrak coordinates to screen coordinates
        optoX = optoData[0];
        optoY = optoData[1];
        optoZ = optoData[2];
        
        double outputX = 0 + round(slopeX * (optoX - 0));
        double outputY = 0 + round(slopeY * (optoY - 0));
        
        X = (outputX-(WIDTH/2))/(WIDTH/2);
        Y = -(outputY-(HEIGHT/2))/(HEIGHT/2);
        //std::cout << outputX << ":" << outputY << std::endl;
        
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
        
        
        switch (temp) {
            case 0:
                if (whiteSquare)        // If cursor is within the bounds of the white square
                {
                    glfwSetTime(0);
                    temp = 1;
                    //std::cout << "Attempting Reach " << reachNumber << "..." << std::endl;
                    
                    
                    //std::cout << "Cursor has entered white square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 1:
                if (glfwGetTime() >= 2.0)       // If cursor is within the bounds of the white square for more than 2 seconds
                {
                    state = 1;
                    temp = 2;
                    //std::cout << "\nReach " << reachNumber << ": " << std::endl;
                    //std::cout << "Time: " << glfwGetTime() << ", Target: (" << transformedLocationInitial[0] << " , " << transformedLocationInitial[1] << "), Actual: (" << X << " , " << Y << ")" << std::endl;
                    
                    
                    //std::cout << "Green square appears" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                
                if (!whiteSquare)               // If cursor leaves the bounds of the white square before 2 seconds has been reached
                {
                    temp = 0;
                    //std::cout << "Reach " << reachNumber << " aborted.\n" << std::endl;
                    reachNumber++;
                    
                    
                    //std::cout << "Cursor has exited white square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 2:
                if (greenSquare)            // If the cursor is within the bounds of the green square
                {
                    temp = 3;
                    //std::cout << "Cursor has entered green square" << std::endl;
                    //std::cout << "temp: " << temp << ", " << "state: " << state << ", " << "time: " << glfwGetTime() << "\n" << std::endl;
                }
                break;
                
            case 3:
                if (currentVelocity != 0 && currentVelocity < 1.5)      // If the cursor's velocity is less than 1.5 (fps?) within the bounds of the green square
                {
                    changePos();
                    state = 0;
                    temp = 0;
                    //std::cout << "Reach " << reachNumber << " complete." << std::endl;
                    //std::cout << "Time: " << glfwGetTime() << ", Target: (" << transformedLocationFinal[0] << " , " << transformedLocationFinal[1] << "), Actual: (" << X << " , " << Y << ")\n" << std::endl;
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
    /*
     X = (xPos-(WIDTH/2))/(WIDTH/2);
     Y = -(yPos-(HEIGHT/2))/(HEIGHT/2);
     //std::cout << xPos << ":" << yPos << std::endl;
     
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
     */
    
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

double round(double d)
{
    return floor(d + 0.5);
}
