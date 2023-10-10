/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author brian arrua
 */
public class HumanoOrden extends Humano implements Orden {

    public HumanoOrden(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        super(nombre, fuerza, constitucion, velocidad, inteligencia, suerte, arma);
    }

    @Override
    public int restaurarOrden() {
        return ((this.getSaludTotal() * 10) / 100);
    }
}
