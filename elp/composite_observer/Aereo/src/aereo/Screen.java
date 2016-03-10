/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aereo;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import javax.swing.BorderFactory;
import javax.swing.JPanel;

/**
 *
 * @author elder
 */
public class Screen extends JPanel{

    private int planeX = -10;
    private int planeY = -10;

    private int shiftX = 0;
    private int shiftY = 0;

    public Screen(int sX, int sY) {
        shiftX = sX;
        shiftY = sY;
    }



    public int getPlaneX(){
        return planeX;
    }
    
    public int getPlaneY(){
        return planeY;
    }

    public void setPlaneX(int newX){
        planeX = newX;
    }

    public void setPlaneY(int newY){
        planeY = newY;
    }



    @Override
    protected void paintComponent(Graphics g) {


        Graphics2D borda = (Graphics2D) g;

        borda.clearRect(0, 0, 300, 300);
        borda.setColor(Color.black);
        borda.fill3DRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, false);

        borda.setColor(Color.gray);

        for(int i=0; i<Constants.SCREEN_WIDTH; i+=30){
            borda.drawLine(i, 0, i, Constants.SCREEN_HEIGHT);
        }

        for(int i=0; i<Constants.SCREEN_HEIGHT; i+=30){
            borda.drawLine(0, i, Constants.SCREEN_WIDTH, i);
        }

        borda.setColor(Color.green);

        for(int i=1; i<6; i++){
            borda.drawOval((Constants.SCREEN_WIDTH/2) - 30*i , (Constants.SCREEN_HEIGHT/2) -30*i , 30*2*i, 30*2*i);
        }
        
        
        

        borda.drawString("" + (planeX + shiftX) + " - " + (planeY + shiftY), planeX - 6, planeY);
        borda.fillOval(planeX, planeY, 15, 15);

        
       

        setBorder(BorderFactory.createLineBorder(Color.black, 3));
    }



}
