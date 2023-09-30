import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    static let identifier = Constants.tableViewCelldentifier
    var cellBackground = UIImageView()
        
    func configure(with representable: any TableViewRepresentable) {
        cellLabel.text = representable.name
        
        imageViewCell.setImage(for: URL(string:(representable.photo))!)
        
        customizeCell(for: representable)
        
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(cellBackground)
        Constants.addShadow(to: self.backgroundView!)

    }
    
    
    // Añade una forma circular y sombras a la celda
    func customizeCell(for representable: TableViewRepresentable) {
        imageViewCell?.layer.cornerRadius = (imageViewCell?.frame.size.width ?? 0.0) / 2
        imageViewCell?.clipsToBounds = true
        imageViewCell?.layer.borderWidth = 4.0
        imageViewCell?.layer.borderColor = (UIColor.white.cgColor).copy(alpha: 0.8)
        
                
        cellBackground = UIImageView(frame: CGRect(x: 20, y: 20, width: self.frame.width - 40, height: self.frame.height - 20))
        cellBackground.setImage(for: URL(string:(representable.photo))!)
        cellBackground.layer.cornerRadius = 15
        cellBackground.clipsToBounds = true
        cellBackground.contentMode = .scaleAspectFill
    }
    
    
    // Cuando se hace click sobre una cell, esta se oscurece
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        if (selected) {
            Constants.addBlurEffect(to: cellBackground, style: .systemThinMaterialDark)
            Constants.addBlurEffect(to: imageViewCell, style: .systemThinMaterialDark)
        }
    }
    
    // Define el espacio entre las celdas
    override var frame: CGRect {
        get { return super.frame }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
}



    