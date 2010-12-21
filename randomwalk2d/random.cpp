/*

 you need libpng++ to compile this program

 COMPILE: g++ -c random.cpp `libpng-config --cflags`
 LINK:    g++ -o random random.o `libpng-config --ldflags`

 COPYRIGHT: boris_daeppen@bluewin.ch 2010

*/

#include <iostream>         /* for stdout */
#include <png++/png.hpp>    /* for PNG creation */
#include <cstdlib>          /* for cmd arg parsing (atoi) */
#include <vector>           /* for vector as an array replacement */

using namespace std;

int main(int argc, char* argv[])
{
    int steps = 100000;  // default value

    /* parsing commandline options */
    if(argc > 1)
    {
        steps = atoi(argv[1]);
        cout << "from cmdline: " << steps << endl;
    }
    else
    {
        cout << "no cmdline, default is: " << steps << endl;
    }

    /* important variables */
    enum Path {LEFT, RIGHT, UP, DOWN};
    int dice;

    signed int maxReachedLEFT   = 0;
    signed int maxReachedRIGHT  = 0;
    signed int maxReachedUP     = 0;
    signed int maxReachedDOWN   = 0;
    signed int xPos = 0;
    signed int yPos = 0;

    /* initialize random seed */
    srand ( time(NULL) );

    /* initialise data container for random steps
       using new so that array is on heap, not stack
    */
    Path * walks = new Path [steps];

    /* generate and store all random steps */
    for(int i=0;i<steps;i++)
    {
        dice = rand() % 4;  // random: 0,1,2 or 3

        switch(dice)
        {
            case 0:
                walks[i] = LEFT;
                xPos--;
                if(xPos < maxReachedLEFT)
                {
                    maxReachedLEFT = xPos;
                }
                break;
            case 1:
                walks[i] = RIGHT;
                xPos++;
                if(xPos > maxReachedRIGHT)
                {
                    maxReachedRIGHT = xPos;
                }
                break;
            case 2:
                walks[i] = UP;
                yPos++;
                if(yPos > maxReachedUP)
                {
                    maxReachedUP = yPos;
                }
                break;
            case 3:
                walks[i] = DOWN;
                yPos--;
                if(yPos < maxReachedDOWN)
                {
                    maxReachedDOWN = yPos;
                }
                break;
        }

    }

    /* calculate the measurements of the image */
    int width  = -1 * maxReachedLEFT + maxReachedRIGHT;
    int height = -1 * maxReachedDOWN + maxReachedUP;
    cout << "size is: " << width << "x" << height << endl;

    /* initialise a vector for the image
       we use vector instead of array so that
       data is on heap not on stack
    */
    vector<vector<int> > data ( width+1, vector<int> ( height+1, 255 ) );

    /* calculate starting point for walking */
    xPos = -1 * maxReachedLEFT;
    yPos = -1 * maxReachedDOWN;

    /* Here we store the highest value we reach */
    int maxVal = 0;

    /* start walking */
    data[xPos][yPos]++;     // mark beginning
    cout << "start walking here: " << xPos << "," << yPos << endl;
    for(int i=0;i<steps;i++)
    {
        switch(walks[i])
        {
            case LEFT:
                xPos--;
                data[xPos][yPos]++;
                if(data[xPos][yPos] > maxVal)
                {
                    maxVal++;
                }
                break;
            case RIGHT:
                xPos++;
                data[xPos][yPos]++;
                if(data[xPos][yPos] > maxVal)
                {
                    maxVal++;
                }
                break;
            case UP:
                yPos++;
                data[xPos][yPos]++;
                if(data[xPos][yPos] > maxVal)
                {
                    maxVal++;
                }
                break;
            case DOWN:
                yPos--;
                data[xPos][yPos]++;
                if(data[xPos][yPos] > maxVal)
                {
                    maxVal++;
                }
                break;
        }
    }
    /* free memory cause all the data is now in data vector */
    delete(walks);

    cout << "max field visit: " << maxVal << endl;

    /* draw the image
       like told here:
       http://www.nongnu.org/pngpp/doc/0.2.1/
    */
    png::image< png::rgb_pixel > image(width, height);
    unsigned int color = 0;
    float scale   = 0;
    float val     = 0;
    float maxValF = maxVal;
    for(int y=0;y<height;y++)
    {
        for(int x=0;x<width;x++)
        {
            scale = (float)(maxValF / 255);
            val = data[x][y];
            color = 255 - (int)((val / scale) + 0.5);
            image[y][x] = png::rgb_pixel(color, color, color);
        }
    }

    image.write("walkingpen.png");

    cout << "END" << endl;

    return(0);
}

