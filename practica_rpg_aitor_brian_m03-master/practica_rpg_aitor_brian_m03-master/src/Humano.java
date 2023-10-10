/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author brian arrua
 */
public class Humano extends Personaje {

    public Humano(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        super(nombre, fuerza, constitucion, velocidad, inteligencia, suerte, arma);
        
    }
    @Override
    public void calculapSalud() {
        this.setpSalud(this.getFuerza() + this.getConstitucion()+this.getInteligencia());
    this.setSaludTotal(this.getpSalud());
    }
}
