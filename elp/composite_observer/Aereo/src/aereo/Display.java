/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aereo;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.Stroke;
import java.awt.geom.Line2D;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import javax.swing.BorderFactory;
import javax.swing.JPanel;

/**
 *
 * @author elder
 */
public class Display extends JPanel{

    Screen t1 = new Screen(0,0);
    Screen t2 = new Screen(Constants.SCREEN_WIDTH, 0);
    Screen t3 = new Screen(0,Constants.SCREEN_HEIGHT);
    Screen t4 = new Screen(Constants.SCREEN_WIDTH,Constants.SCREEN_HEIGHT);

    private int planeX, planeY;

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

    private void hidePlane(Screen t){
        t.setPlaneX(-10);
        t.setPlaneY(-10);
    }

    @Override
    protected void paintComponent(Graphics g) {
        if (planeX < Constants.SCREEN_WIDTH && planeY > Constants.SCREEN_HEIGHT){
            t3.setPlaneX(planeX);
            t3.setPlaneY(planeY - Constants.SCREEN_HEIGHT);
            hidePlane(t2);
            hidePlane(t1);
            hidePlane(t4);
        }

        if (planeX < Constants.SCREEN_WIDTH && planeY < Constants.SCREEN_HEIGHT){
            t1.setPlaneX(planeX);
            t1.setPlaneY(planeY);
            hidePlane(t3);
            hidePlane(t2);
            hidePlane(t4);
        }

        if (planeX > Constants.SCREEN_WIDTH && planeY < Constants.SCREEN_HEIGHT){
            t2.setPlaneX(planeX - Constants.SCREEN_WIDTH);
            t2.setPlaneY(planeY);
            hidePlane(t1);
            hidePlane(t4);
            hidePlane(t3);
        }

        if (planeX > Constants.SCREEN_WIDTH && planeY > Constants.SCREEN_HEIGHT){
            t4.setPlaneX(planeX - Constants.SCREEN_WIDTH);
            t4.setPlaneY(planeY - Constants.SCREEN_HEIGHT);
            hidePlane(t1);
            hidePlane(t3);
            hidePlane(t2);
        }


        setBackground(Color.green);
        setBorder(BorderFactory.createLineBorder(Color.black, 3));
    }





}

