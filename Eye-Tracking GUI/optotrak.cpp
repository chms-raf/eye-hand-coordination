//---------------------------------------------------------------------
//          OPTOTRAK
//
// 
//---------------------------------------------------------------------

#include "stdafx.h"
#include "UDP_Test2.h"
#include "HapticAPI2.h"
#include "HapticMASTER.h"
#include "CPrecisionTimer.h"
#include <math.h>

/*****************************************************************
 * ND Library Files Included
 *****************************************************************/
#include "ndtypes.h"
#include "ndpack.h"
#include "ndopto.h"
#include "C:\Users\KirschLab\Documents\OLD_NDIoapi(C)\samples\sleep.c"

#define HOSTIP "192.168.0.8" // this computer
#define TARGETIP "192.168.0.2" // xpc target computer (dSPACE)

#define PosX 0
#define PosY 1
#define PosZ 2

// Optotrak definitions
#define RIGID_OUTPUT_WIDTH 8
#define MARKER_OUTPUT_WIDTH 4
#define NUM_RIGID_BODIES 1                      // Number of rigid bodies
#define NUM_MARKERS 5                           // Total number of markers
#define NUM_MARKERS_PORT1 5                     // Number of markers in port 1
#define NUM_MARKERS_PORT2 0                     // Number of markers in port 2
#define NUM_MARKERS_PORT3 0                     // Number of markers in port 3
#define NUM_MARKERS_PORT4 0                     // Number of markers in port 4
#define FREQUENCY 52
#define CAMFILE "Aligned20190305_1.cam"
#define THORAX_FILE "thorax_aligned.rig"
#define FIRST_THORAX 1
#define HUMERUS_FILE "humerus_aligned.rig"
#define FIRST_HUMERUS 6
#define FOREARM_FILE "forearm_aligned.rig"
#define FIRST_FOREARM 12

// count of key "s" pressed
int s_count = 0;
// UDP socket objects
CSocket UDP_Sender;
CSocket UDP_Receiver;

// Optotrak data structures
struct OptotrakRigidStruct pData6d[NUM_RIGID_BODIES];
Position3d pData3d[NUM_MARKERS];
double **dataout = NULL;
double **posout = NULL;
double **previous_dataout = NULL;
double **previous_posout = NULL;

// Optotrak declarations
//int nSensors, nRigidBodies, nMarkers;
unsigned int uFlags, uElements, uFrameNumber;
int error = 0;
int globalRigidBody = 1;
//int nIREDPositions = 9;
char szNDErrorString[MAX_ERROR_STRING_LENGTH + 1];
float samplingRate, firingRate;

// UDP declarations
double packetSize = 113;
double receivePacketSize = 1;
double udpData[113];
double udpReceiveData[1];

int targetNumber = 1;
double target[TARGETS][3];  // [x,y,z] coordinates of the target
int muscleOrder[TARGETS][MUSCLES];
int shortMuscleOrder[MUSCLES];
int targetOrder[TARGETS];

//---------------------------------------------------------------------
//                          Init_Opto
//
// This function initializes the Optotrak
//---------------------------------------------------------------------
void Init_Opto (void)
{
	unsigned int uFlags, uElements, uFrameNumber;

	printf("...TransputerLoadSystem\n" );
    if( TransputerLoadSystem( "system" ) != OPTO_NO_ERROR_CODE )
    {
        error=1;
        goto ERROR_EXIT;
    }    
    sleep( 1 );

	printf("...TransputerInitializeSystem\n" );
    if( TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG | OPTO_LOG_MESSAGES_FLAG ) )
    {
        error=1;
        goto ERROR_EXIT;
    }
    
    printf("...OptotrakSetProcessingFlags\n" );
    if( OptotrakSetProcessingFlags( OPTO_LIB_POLL_REAL_DATA |
                                    OPTO_CONVERT_ON_HOST |
                                    OPTO_RIGID_ON_HOST ) )
    {
        error=1;
        goto ERROR_EXIT;
    }
    

	printf("...OptotrakLoadCameraParameters \n" );
	if( OptotrakLoadCameraParameters(CAMFILE) ) //if filename==NULL, standard.cam is loaded
	{
		 error=1;
		 goto ERROR_EXIT;
	}

	printf("...OptotrakSetStroberPortTable\n" );
	if( OptotrakSetStroberPortTable(NUM_MARKERS_PORT1,NUM_MARKERS_PORT2,NUM_MARKERS_PORT3,NUM_MARKERS_PORT4)){
		error = 1;
		goto ERROR_EXIT;
	}
	printf("...OptotrakSetupCollection\n" );
    if( OptotrakSetupCollection(
            NUM_MARKERS,        /* Number of markers in the collection. */
            FREQUENCY,        /* Frequency to collect data frames at. */
            1700,        /* Marker frequency for marker maximum on-time. */
            30,                 /* Dynamic or Static Threshold value to use. */
            160,                /* Minimum gain code amplification to use. */
            0,                  /* Stream mode for the data buffers. */
            (float)0.25,        /* Marker Duty Cycle to use. */
            (float)11.05,         /* Voltage to use when turning on markers. */
            (float)1.0,         /* Number of seconds of data to collect. */
            (float)0.0,         /* Number of seconds to pre-trigger data by. */
            OPTOTRAK_NO_FIRE_MARKERS_FLAG) )
    {
        error=1;
        goto ERROR_EXIT;
    }
    sleep( 1 );

	printf("...OptotrakActivateMarkers\n" );
    if( OptotrakActivateMarkers() )
    {
        error=1;
        goto ERROR_EXIT;
    }    

	printf("\n...Rigid body definition\n" );
    // Define the thorax rigid body
    printf("...Define thorax\n" );  
    if( RigidBodyAddFromFile
				(
            0,         			/* ID associated with this rigid body. */
            1,    /* First marker in the rigid body.*/
            THORAX_FILE,         			    /* RIG file containing rigid body coordinates.*/
            OPTOTRAK_RETURN_QUATERN_FLAG ) ) /* flags */
        {
             error=1;
             goto ERROR_EXIT;
        }
    
    if( RigidBodyChangeSettings
				 (
             0,    /* ID associated with this rigid body. */
             3,              /* Minimum number of markers which must be seen
                                before performing rigid body calculations.*/
             60,             /* Cut off angle for marker inclusion in calcs.*/
             (float)0.5,      /* Maximum 3-D marker error for this rigid body. */
             (float)0.2,     /* Maximum raw sensor error for this rigid body. */
             (float)0.5,     /* Maximum 3-D RMS marker error for this rigid body. */
             (float)0.1,     /* Maximum raw sensor RMS error for this rigid body. */
              OPTOTRAK_RETURN_QUATERN_FLAG ) )
         {
             error=1;
             goto ERROR_EXIT;
         }
    
    // Define the humerus rigid body
    printf("...Define humerus\n" );  
    if( RigidBodyAddFromFile
				(
            1,         			/* ID associated with this rigid body. */
            6,    /* First marker in the rigid body.*/
            HUMERUS_FILE,         			    /* RIG file containing rigid body coordinates.*/
            OPTOTRAK_RETURN_QUATERN_FLAG ) ) /* flags */
        {
             error=1;
             goto ERROR_EXIT;
        }
    if( RigidBodyChangeSettings
				 (
             1,    /* ID associated with this rigid body. */
             3,              /* Minimum number of markers which must be seen
                                before performing rigid body calculations.*/
             60,             /* Cut off angle for marker inclusion in calcs.*/
             (float)0.5,      /* Maximum 3-D marker error for this rigid body. */
             (float)0.2,     /* Maximum raw sensor error for this rigid body. */
             (float)0.5,     /* Maximum 3-D RMS marker error for this rigid body. */
             (float)0.1,     /* Maximum raw sensor RMS error for this rigid body. */
              OPTOTRAK_RETURN_QUATERN_FLAG ) )
         {
             error=1;
             goto ERROR_EXIT;
         }
    
    // Define the forearm rigid body
    printf("...Define forearm\n" );  
    if( RigidBodyAddFromFile
				(
            2,         			/* ID associated with this rigid body. */
            12,    /* First marker in the rigid body.*/
            FOREARM_FILE,         			    /* RIG file containing rigid body coordinates.*/
            OPTOTRAK_RETURN_QUATERN_FLAG ) ) /* flags */
        {
             error=1;
             goto ERROR_EXIT;
        }
    if( RigidBodyChangeSettings
				 (
             2,    /* ID associated with this rigid body. */
             3,              /* Minimum number of markers which must be seen
                                before performing rigid body calculations.*/
             60,             /* Cut off angle for marker inclusion in calcs.*/
             (float)0.5,      /* Maximum 3-D marker error for this rigid body. */
             (float)0.2,     /* Maximum raw sensor error for this rigid body. */
             (float)0.5,     /* Maximum 3-D RMS marker error for this rigid body. */
             (float)0.1,     /* Maximum raw sensor RMS error for this rigid body. */
              OPTOTRAK_RETURN_QUATERN_FLAG ) )
         {
             error=1;
             goto ERROR_EXIT;
         }

	
	// get the data
	printf("...getting data\n");
	if(DataGetLatestTransforms2(&uFrameNumber, &uElements, &uFlags, pData6d, pData3d))
	{
        error=1;
		printf("error getting latest optotrak data.");
		//freeMemory(5,nRigidBodies,nIREDPositions);
		goto ERROR_EXIT;
	} 

	/**********************************************************************
     * Report optotrak error messages
     **********************************************************************/ 
    ERROR_EXIT:
    if (error)
    {
        printf("\nAn error has occurred during execution of the Optotrak program.\n" );
        if( OptotrakGetErrorString( szNDErrorString,
                                    MAX_ERROR_STRING_LENGTH + 1 ) == 0 )
        {
           printf(szNDErrorString );
        }

        printf("\n\n...TransputerShutdownSystem\n" );
        OptotrakDeActivateMarkers();
        TransputerShutdownSystem();
    }
}

//---------------------------------------------------------------------
//                          Init_UDP
//
// This function initializes UDP communication between the host computer
// and the xpc target computer
//---------------------------------------------------------------------

int Init_UDP (void)
{
	int nRetCode = 0;

	// initialize MFC and print and error on failure
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		// TODO: change error code to suit your needs
		_tprintf(_T("Fatal Error: MFC initialization failed\n"));
		nRetCode = 1;
	}
	
	else
	{
		int retval;

		//WSAData socket_data;
		// Set these IP addresses to match your setup, Server = xPC Target, Client = xPC Host for your purpose
		CString strServerAddress(_T( TARGETIP ));
		CString strClientAddress(_T( HOSTIP ));
		
		//if( !AfxSocketInit(&socket_data) )
		if( !AfxSocketInit() )
			fprintf(stdout,"AfxSocketInit failed\n");
		else
			fprintf(stdout,"Socket initiated\n");

		if( !UDP_Receiver.Create(20000, SOCK_DGRAM, strClientAddress) )
		{
			retval = GetLastError();
			fprintf(stdout,"UDP create return %d\n",retval);
		}
		else
			fprintf(stdout,"...UDP socket create succeeded for receiver socket \n");

		if( !UDP_Sender.Create(25000, SOCK_DGRAM, strClientAddress) )
		{
			retval = GetLastError();
			fprintf(stdout,"UDP create return %d\n",retval);
		}
		else
			fprintf(stdout,"...UDP socket create succeeded for sender socket\n");

		if( !UDP_Sender.Connect(strServerAddress, 25000) )
		{
			retval = GetLastError();
			fprintf(stdout,"UDP connect return %d\n",retval);
		}
		else
			fprintf(stdout,"...UDP connect succeeded\n");

	}
	
	return nRetCode;
}


//---------------------------------------------------------------------
//                          sendUDP
//
// This function sends a UDP packet
//---------------------------------------------------------------------

void sendUDP (float stim, float muscle)
{
    // HapticMaster declarations
    int retval1;
	int i, j, count;
	int currentState = 0;
	double dataout[NUM_RIGID_BODIES][RIGID_OUTPUT_WIDTH];
	double posout[NUM_MARKERS][MARKER_OUTPUT_WIDTH];
	
	// Get the Optotrak data
	if(DataGetLatestTransforms2(&uFrameNumber, &uElements, &uFlags, pData6d, pData3d))
	{
		error = 1;
		goto ERROR_EXIT;
	} 

	for(i=0; i<NUM_RIGID_BODIES; i++)
	{
		//printf("Rigid body: %d Flag: %f.\n",i+1,pData6d[i].flags);
		// check if the rigid body is visible and set the 'lost visibility' flag if it isn't
		if(pData6d[i].flags & OPTOTRAK_UNDETERMINED_FLAG)
		{
			dataout[i][7]=0;
		}
		else
		{
			//printf("Getting data for rigid body %d.\n",i+1);
			dataout[i][0] = pData6d[i].transformation.quaternion.rotation.q0;
			dataout[i][1] = pData6d[i].transformation.quaternion.rotation.qx;
			dataout[i][2] = pData6d[i].transformation.quaternion.rotation.qy;
			dataout[i][3] = pData6d[i].transformation.quaternion.rotation.qz;
			dataout[i][4] = pData6d[i].transformation.quaternion.translation.x;
			dataout[i][5] = pData6d[i].transformation.quaternion.translation.y;
			dataout[i][6] = pData6d[i].transformation.quaternion.translation.z;
			dataout[i][7] = 1;
		}   
	}

	if( DataGetLatest3D( &uFrameNumber,&uElements,&uFlags,pData3d ) )
	{
		error = 1;
		goto ERROR_EXIT;
	}

	for(i=0; i<NUM_MARKERS; i++)
	{
		//printf("Rigid body: %d Flag: %f.\n",i+1,pData6d[i].flags);
		// check if the rigid body is visible and set the 'lost visibility' flag if it isn't
		if(pData3d[i].x > 10000 || pData3d[i].x < -10000) // if something went wrong, set the marker values to zero
		{
			posout[i][ 0] = 0;
			posout[i][ 1] = 0;
			posout[i][ 2] = 0;
			posout[i][3]=0;
		}
		else
		{
			//printf("Getting data for rigid body %d.\n",i+1);
			posout[i][ 0] = pData3d[i].x;
			posout[i][ 1] = pData3d[i].y;
			posout[i][ 2] = pData3d[i].z;
			posout[i][ 3] = 1;
		}   
	}
    
	
	// assign values to the stuff to be sent
	udpData[0] = 1000*(CurrentPosition[PosX]) + HM_XOFFSET; // HM x pos in mm
	udpData[1] = 1000*(CurrentPosition[PosY]) + HM_YOFFSET; // HM y pos in mm
	udpData[2] = 1000*(CurrentPosition[PosZ]) + HM_ZOFFSET; // HM z pos in mm
	udpData[3] = 1000*(CurrentPositionCyl[PosX]); // HM r pos in mm
	udpData[4] = (CurrentPositionCyl[PosY]); // HM phi pos in rad
	udpData[5] = 1000*(CurrentPositionCyl[PosZ]); // HM z pos in mm
	udpData[6] = 1000*(CurrentVelocity[PosX]); // HM x vel in mm/s
	udpData[7] = 1000*(CurrentVelocity[PosY]); // HM y vel in mm/s
	udpData[8] = 1000*(CurrentVelocity[PosZ]); // HM z vel in mm/s
	udpData[9] = 1000*(CurrentAcceleration[PosX]); // HM x acc in mm/s/s
	udpData[10] = 1000*(CurrentAcceleration[PosY]); // HM y acc in mm/s/s
	udpData[11] = 1000*(CurrentAcceleration[PosZ]); // HM z acc in mm/s/s
	udpData[12] = CurrentForce[PosX]; // HM x force
	udpData[13] = CurrentForce[PosY]; // HM y force
	udpData[14] = CurrentForce[PosZ]; // HM z force
	count = 14;
	for(i=0; i<NUM_RIGID_BODIES; i++){
		for(j=0; j<RIGID_OUTPUT_WIDTH; j++){
			count = count + 1;
			udpData[count] = dataout[i][j];
		}
	}
	
    // marker positions
	for(i=0; i<NUM_MARKERS; i++){
		for(j=0; j<MARKER_OUTPUT_WIDTH; j++){
			count = count + 1;
			udpData[count] = posout[i][j];
		}
		//printf("Marker  = %d\t X = %f\t Y = %f\t Z = %f\t Flag = %f\n",i+1,posout[i][0],posout[i][1],posout[i][2],posout[i][3]);
	}
	
	// stim information
	count = count + 1;
	udpData[count] = stim;
	count = count + 1;
	udpData[count] = muscle;

	// send the UDP packets
	// The second parameter of Send is the buffer size, but its in bytes (i.e. units of 8 bits)
	// - a 3-element array of 32bit ints has a size of 12 (3 * (32bits * (1byte/8bits)) = 12bytes)
	// - a double has a size of 8 (64bits * (1byte/8bits) = 8bytes)
	retval1 = UDP_Sender.Send(&udpData, 8*packetSize);
	if( retval1 == SOCKET_ERROR )
	{
		retval1 = GetLastError();
		fprintf(stdout,"error code %d\n",retval1);
	}
	else
		//fprintf(stdout,"%d characters sent\n",retval1);

	

	/**********************************************************************
     * Report optotrak error messages
     **********************************************************************/ 
    ERROR_EXIT:
    if (error)
    {
        //printf("\nAn error has occurred during execution of the Optotrak program.\n" );
        if( OptotrakGetErrorString( szNDErrorString,
                                    MAX_ERROR_STRING_LENGTH + 1 ) == 0 )
        {
           printf(szNDErrorString );
        }

        //printf("\n\n...TransputerShutdownSystem\n" );
        OptotrakDeActivateMarkers();
        TransputerShutdownSystem();
    }

}

//---------------------------------------------------------------------
//                          receiveUDP
//
// This function receives a UDP packet of three doubles
//---------------------------------------------------------------------

void receiveUDP (void)
{
	int retval1;
	// receive the UDP packets
	// The second parameter of Send is the buffer size, but its in bytes (i.e. units of 8 bits)
	// - a 3-element array of 32bit ints has a size of 12 (3 * (32bits * (1byte/8bits)) = 12bytes)
	// - a double has a size of 8 (64bits * (1byte/8bits) = 8bytes)
	retval1 = UDP_Receiver.Receive(&udpReceiveData, 8*receivePacketSize,0);
	if( retval1 == SOCKET_ERROR )
	{
		retval1 = GetLastError();
		fprintf(stdout,"error code %d\n",retval1);
	}
}

//---------------------------------------------------------------------
//                          executeTarget
//
// This function stimulates muscles at a given target
//---------------------------------------------------------------------
void executeTarget(void)
{
	int i;
	int index;

	double controlFlag = 0;
	double endTime = 2.0;
	double initialRest = 0.5;
	double stimTime = 1.25;
	double stiff;
	double handCurrent[3];
	double posDes[3];
	double targetPos[3];
	double theTime;
	float dt = 0.001;
	//int number = 1;

	////////////////////////////////////////////////////////
	// MOVE HAPTIC MASTER TO THE TARGET
	////////////////////////////////////////////////////////
	// deinfe the target position
	targetPos[0] = target[targetOrder[targetNumber - 1] - 1][0];
	targetPos[1] = target[targetOrder[targetNumber - 1] - 1][1];
	targetPos[2] = target[targetOrder[targetNumber - 1] - 1][2];

	// set the HapticMaster state to force
	if (haSendCommand(dev, "set state force", response)) {
		printf("--- ERROR: set state force: %s\n", response);
	}

	index = 0;
	// record the current position
	sendUDP(0, 0);

	// start the clock
	timer.Reset();
	timer.Start();
	// move slowly to the target
	while (timer.Read() < 5) {
		index = ceil(timer.Read() / dt);

		posDes[0] = CurrentPosition[0] + index*dt*(targetPos[0] - CurrentPosition[0]) / 5;
		posDes[1] = CurrentPosition[1] + index*dt*(targetPos[1] - CurrentPosition[1]) / 5;
		posDes[2] = CurrentPosition[2] + index*dt*(targetPos[2] - CurrentPosition[2]) / 5;
		stiff = middleStiffness + index*dt*(hardStiffness - middleStiffness) / 5;
		moveHapticMasterTo(posDes[0], posDes[1], posDes[2], stiff, moveDamping);
		//printf("current goal = [%f,%f,%f]\n",posDes[0],posDes[1],posDes[2]);
		//printf("final goal = [%f,%f,%f]\n",targetPos[0],targetPos[1],targetPos[2]);
	}
	timer.Stop();
	// set the HapticMaster state to stop
	if (haSendCommand(dev, "set state stop", response)) {
		printf("--- ERROR: set state stop: %s\n", response);
	}
	//////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////
	// LOOP THROUGH THE MUSCLES AND STIMULATE EACH
	////////////////////////////////////////////////////////

	// clear the UDP buffer and look to receive the start signal from the XPC target
	printf("Waiting for start signal . . .\n");
	while (controlFlag < 0.5) {
		receiveUDP();
		controlFlag = udpReceiveData[0];
	}
	printf("Control Flag = %lf \n", controlFlag);

	// stimulation
	printf("Starting stimulation . . . \n");
	timer.Reset();
	timer.Start();
	theTime = timer.Read();
	while (theTime<endTime*MUSCLES && controlFlag > 0.5)
	{
		i = floor(theTime / endTime);
		if (fmod(theTime, endTime) > initialRest && fmod(theTime, endTime) < initialRest + stimTime)
			sendUDP(1, muscleOrder[targetOrder[targetNumber - 1] - 1][i]);
		else
			sendUDP(0, 0);
		receiveUDP();
		controlFlag = udpReceiveData[0];
		theTime = timer.Read();
		//printf("Time = %lf \n",theTime);
	}
	while (controlFlag > 0.5){
		receiveUDP();
		controlFlag = udpReceiveData[0];
	}
	//for(i=0; i<MUSCLES; i++)
	//{
		// start the clock
	//	timer.Reset();
	//	timer.Start();

	//	while(timer.Read()<endTime-0.002 )
	//	{ 
	//		if(timer.Read() < initialRest) // initial period of zero stimulation
	//		{
	//			sendUDP(0,0);
	//			receiveUDP();
	//			controlFlag = udpReceiveData[0];
				//printf("Time = %lf \n",timer.Read());
	//		}
	//		else if (timer.Read() < initialRest + stimTime) // stimulation time
	//		{
				//printf("Time = %lf \n",timer.Read());
	//			sendUDP(1,muscleOrder[targetOrder[targetNumber-1]-1][i]);
	//			receiveUDP();
	//			controlFlag = udpReceiveData[0];
	//		}
	//		else
	//			sendUDP(0,0);
	//			receiveUDP();
	//			controlFlag = udpReceiveData[0];
				//printf("Time = %lf \n",timer.Read());
			
	//	} 
	//}
	printf("Stimulation done . . . \n");
}

//---------------------------------------------------------------------
//                          streamData
//
// This function streams data to the xpc target
//---------------------------------------------------------------------
void streamData (void)
{
	int status_hit = 0;
	
	while(status_hit == 0)
	{
		printf("I'm streaming\n");
		status_hit = _kbhit();
		
		sendUDP(0,0);
	} 
}

//---------------------------------------------------------------------
//                         printData
//
// This function gets the latest HM and opto data and prints it to the screen
//---------------------------------------------------------------------
void printData (void)
{
	// HapticMaster declarations
	int i;
	int currentState = 0;
	double dataout[NUM_RIGID_BODIES][RIGID_OUTPUT_WIDTH];
	double posout[NUM_MARKERS][MARKER_OUTPUT_WIDTH];

	// Get the Optotrak data
	if(DataGetLatestTransforms2(&uFrameNumber, &uElements, &uFlags, pData6d, pData3d))
	{
		error = 1;
		goto ERROR_EXIT;
	} 

	for(i=0; i<NUM_RIGID_BODIES; i++)
	{
		//printf("Rigid body: %d Flag: %f.\n",i+1,pData6d[i].flags);
		// check if the rigid body is visible and set the 'lost visibility' flag if it isn't
		if(pData6d[i].flags & OPTOTRAK_UNDETERMINED_FLAG)
		{
			dataout[i][12]=0;
		}
		else
		{
			//printf("Getting data for rigid body %d.\n",i+1);
			dataout[i][ 0] = pData6d[i].transformation.rotation.matrix[0][0];
			dataout[i][ 1] = pData6d[i].transformation.rotation.matrix[0][1];
			dataout[i][ 2] = pData6d[i].transformation.rotation.matrix[0][2];
			dataout[i][ 3] = pData6d[i].transformation.rotation.matrix[1][0];
			dataout[i][ 4] = pData6d[i].transformation.rotation.matrix[1][1];
			dataout[i][ 5] = pData6d[i].transformation.rotation.matrix[1][2];
			dataout[i][ 6] = pData6d[i].transformation.rotation.matrix[2][0];
			dataout[i][ 7] = pData6d[i].transformation.rotation.matrix[2][1];
			dataout[i][ 8] = pData6d[i].transformation.rotation.matrix[2][2];
			dataout[i][ 9] = pData6d[i].transformation.rotation.translation.x;
			dataout[i][10] = pData6d[i].transformation.rotation.translation.y;
			dataout[i][11] = pData6d[i].transformation.rotation.translation.z;
			dataout[i][12] = 1;
		}   
	}

	if( DataGetLatest3D( &uFrameNumber,&uElements,&uFlags,pData3d ) )
	{
		error = 1;
		goto ERROR_EXIT;
	}

	for(i=0; i<NUM_MARKERS; i++)
	{
		//printf("Rigid body: %d Flag: %f.\n",i+1,pData6d[i].flags);
		// check if the rigid body is visible and set the 'lost visibility' flag if it isn't
		if(pData3d[i].x > 10000 || pData3d[i].x < -10000) // if something went wrong, set the marker values to zero
		{
			posout[i][ 0] = 0;
			posout[i][ 1] = 0;
			posout[i][ 2] = 0;
			posout[i][3]=0;
		}
		else
		{
			//printf("Getting data for rigid body %d.\n",i+1);
			posout[i][ 0] = pData3d[i].x;
			posout[i][ 1] = pData3d[i].y;
			posout[i][ 2] = pData3d[i].z;
			posout[i][ 3] = 1;
		}   
		// print marker flags
		printf("Marker %d flag: %f\n",i+1,posout[i][3]);
	}

	// print Optotrak rigid body data
	printf("Thorax Position x: %f y: %f z: %f\n",dataout[0][9], dataout[0][10], dataout[0][11] );
	printf("Thorax Flag: %f\n",dataout[0][12]);
	printf("Humerus Position x: %f y: %f z: %f\n",dataout[1][9], dataout[1][10], dataout[1][11] );
	printf("Humerus Flag: %f\n",dataout[1][12]);
	printf("Forearm Position x: %f y: %f z: %f\n",dataout[2][9], dataout[2][10], dataout[2][11] );
	printf("Forearm Flag: %f\n",dataout[2][12]);
	printf("HM Position Opto x: %f y: %f z: %f\n",dataout[3][9], dataout[3][10], dataout[3][11] );
	printf("HM Flag: %f\n",dataout[3][12]);
	// print marker flags


	/**********************************************************************
     * Report optotrak error messages
     **********************************************************************/ 
    ERROR_EXIT:
    if (error)
    {
        printf("\nAn error has occurred during execution of the Optotrak program.\n" );
        if( OptotrakGetErrorString( szNDErrorString,
                                    MAX_ERROR_STRING_LENGTH + 1 ) == 0 )
        {
           printf(szNDErrorString );
        }

        printf("\n\n...TransputerShutdownSystem\n" );
        OptotrakDeActivateMarkers();
        TransputerShutdownSystem();
    }
}

//---------------------------------------------------------------------
//                              M A I N
//
// Main Function
//---------------------------------------------------------------------
int main(int argc, char** argv)
{
    // Initialize the Optotrak
    printf("\nOptotrak Initializing...\n");
    Init_Opto();

    // UDP Setup Initialization Calls
    printf("\nOpening UDP communications...\n");
    Init_UDP();
    
    while (run) {
        // Get current optotrak data
        
        // Send UDP
    }

   return 0;
}
