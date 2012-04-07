/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aereo;

import java.util.Observable;
import java.util.Observer;  /* this is Event Handler */

public class Controller implements Observer {
    private String resp;
    Display d;

    public Controller(Display d) {
        this.d = d;
    }


    public void update (Observable obj, Object arg) {
        try {
            if (arg instanceof String) {
                resp = (String) arg;
                String [] position = resp.split(":");
                int newX = Integer.parseInt(position[0]);
                int newY = Integer.parseInt(position[1]);

                d.setPlaneX(newX);
                d.setPlaneY(newY);
                d.repaint();
            }
        } catch(Exception e){
            System.out.println("Erro ao interpretar mensagem de um objeto observado");
        }
    }
}
