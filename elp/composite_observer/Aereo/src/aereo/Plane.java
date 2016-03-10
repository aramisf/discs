/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aereo;

import java.util.Observable;          //Observable is here
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.Random;
import javax.xml.crypto.Data;

public class Plane extends Observable implements Runnable {
    public void run() {
        try {
            final InputStreamReader isr = new InputStreamReader( System.in );
            final BufferedReader br = new BufferedReader( isr );

            int lastX = 0;
            int lastY = 0;


            while( true ) {

                Random r1 = new Random(new Date().getTime());
                
                int dir = r1.nextInt(8);
                int step = 5;
                int newX = 0;
                int newY = 0;

                switch(dir){
                    case 0:
                        newX = lastX - step;
                        newY = lastY + step;
                        break;
                    case 1:
                        newX = lastX;
                        newY = lastY + step;
                        break;
                    case 2:
                        newX = lastX + step;
                        newY = lastY + step;
                        break;
                    case 3:
                        newX = lastX + step;
                        newY = lastY;
                        break;
                    case 4:
                        newX = lastX + step;
                        newY = lastY - step;
                        break;
                    case 5:
                        newX = lastX;
                        newY = lastY - step;
                        break;
                    case 6:
                        newX = lastX - step;
                        newY = lastY - step;
                        break;
                    case 7:
                        newX = lastX - step;
                        newY = lastY;
                        break;
                }

                
                newX = Math.max(0, newX);
                newY = Math.max(0, newY);
                newX = Math.min(Constants.SCREEN_WIDTH*2, newX);
                newY = Math.min(Constants.SCREEN_HEIGHT*2, newY);



                String response = newX + ":" + newY;
                setChanged();
                notifyObservers( response );

                lastX = newX;
                lastY = newY;
                
                Thread.sleep(50);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}