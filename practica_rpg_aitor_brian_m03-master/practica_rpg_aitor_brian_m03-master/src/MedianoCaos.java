/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author brian arrua
 */
public class MedianoCaos extends Mediano implements Caos {

    public MedianoCaos(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        super(nombre, fuerza, constitucion, velocidad, inteligencia, suerte, arma);
    }
    
@Override
    public boolean contraataque(int tiradadados) {
        int ataque = (this.getProbAtaque() * 50) / 100;
        if (tiradadados <= ataque) {
            return true;
        } else {
            return false;
        }
    }
}
