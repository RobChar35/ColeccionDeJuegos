//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by Robert Charca on 17/05/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos: [Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        
        var tituloTable = juego.titulo ?? ""
        if let categoriaTable = juego.categoria {
            tituloTable += " | \(categoriaTable)"
        }
        
        cell.textLabel?.text = tituloTable
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                    _ = UITableViewCell()
            let seleccionJuegos = juegos[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    context.delete(seleccionJuegos)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            juegos.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    // Implementacion de funciones para mover elementos
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = juegos[sourceIndexPath.row]
            juegos.remove(at: sourceIndexPath.row)
            juegos.insert(movedObject, at:destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let botonEliminar = UITableViewRowAction(style: .normal, title: "Eliminar")
        {
            (accionesFila, indiceFila) in
            let juego = self.juegos[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juego)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                try self.juegos = context.fetch(Juego.fetchRequest())
            } catch {
                
            }
        }
            
        botonEliminar.backgroundColor = UIColor.red
            
        let botonEditar = UITableViewRowAction(style: .normal, title: "Editar")
        {
            (accionesFila, indiceFila) in
            let juego = self.juegos[indexPath.row]
            self.performSegue(withIdentifier: "juegoSegue", sender: juego)
        }
        
        botonEditar.backgroundColor = UIColor.systemBlue
        
        return [botonEliminar, botonEditar]
        }
    }
