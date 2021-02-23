//  TableViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit
import FirebaseAuth

class ProductsTableViewController: UITableViewController {
    var products:[Product] = []
    
    @IBAction func goToLogInVsLogOut(_ sender: UIBarButtonItem) {
        moveToLogInOrLogOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()
        self.clearNavigationBar()
        setBackgroundOnTableView(fileName:"backgroundView")
    }
    
    func setBackgroundOnTableView(fileName:String) {
        tableView.backgroundView = UIImageView(image: UIImage(named: fileName))
    }
    
    func moveToLogInOrLogOut() {
        if (Router.shared.isLoggedIn == false) {
            Router.shared.moveToLogInSinUp()
        } else if (Router.shared.isLoggedIn == true) {
            do {
                try Auth.auth().signOut()
                Router.shared.moveToLogInSinUp()
            } catch let error {
                self.showError(title: "שגיאה", subtitle: "נסה שוב")
                print("Error: ", error.localizedDescription)
                print(#function)
                print(#line)
            }
        }
    }
    
    func getDataFromFirebase() {
        Product.productRef.observe(.childAdded) {[weak self] (snapshot) in
            guard let strongSelf = self else {return}
            guard let snapVal = snapshot.value as? [String:Any] else {return}
            guard let product = Product(dict:snapVal) else {return}
            strongSelf.products.append(product)
            
            let path = IndexPath(row: strongSelf.products.count - 1, section: 0)
            strongSelf.tableView.insertRows(at: [path], with: .automatic)
           
            // MARK: Sort By Distance:
            // strongSelf.products.sort(by: { (pp1, pp2) -> Bool in
                // pp1.price > pp2.price
            // })
            // strongSelf.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        if let cell = cell as? ProductTableViewCell {
            cell.populate(product:products[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        performSegue(withIdentifier:"aboutProduct", sender: product)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AboutProductViewController,
           let product = sender as? Product {
            dest.product = product
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
