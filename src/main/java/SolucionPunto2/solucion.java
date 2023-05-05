/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SolucionPunto2;

import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 *
 * @author JHONATAN PC
 */
public class solucion {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Pedir el número de calcetines
        System.out.print("Ingrese el número de calcetines: ");
        int n = scanner.nextInt();

        // Pedir los colores de los calcetines
        int[] colores = new int[n];
        for (int i = 0; i < n; i++) {
            System.out.print("Ingrese el color del calcetín " + (i + 1) + ": ");
            colores[i] = scanner.nextInt();
        }

        // Contar el número de calcetines de cada color
        Map<Integer, Integer> contador = new HashMap<Integer, Integer>();
        for (int i = 0; i < n; i++) {
            int color = colores[i];
            if (contador.containsKey(color)) {
                contador.put(color, contador.get(color) + 1);
            } else {
                contador.put(color, 1);
            }
        }

        // Contar el número de pares de calcetines
        int pares = 0;
        for (int cantidad : contador.values()) {
            pares += cantidad / 2;
        }

        // Mostrar el resultado
        System.out.println("El número de pares de calcetines es: " + pares);
    }

}
