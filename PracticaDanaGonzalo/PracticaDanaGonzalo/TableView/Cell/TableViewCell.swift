import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Outlets y variables
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    static let identifier = "TableViewCell"
    
    var cellBackground = UIImageView()
     
    
    // MARK: - Configuración Cell
    
    func configure(with representable: any TableViewRepresentable) {
                
        cellLabel.text = representable.name
        
        imageViewCell.setImage(for: URL(string:(representable.photo))!)
        
        customizeCell(for: representable)
        

    }
    
    
    // MARK: - Customize cell
    
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
        addBlurEffect(to: cellBackground, style: .systemUltraThinMaterial)
        
        backgroundView = UIView()
        backgroundView?.addSubview(cellBackground)
        addShadow(to: backgroundView!)
    }
    
    
    // Cuando se hace click sobre una cell, esta se oscurece
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        if (selected) {
            addBlurEffect(to: cellBackground, style: .systemThinMaterialDark)
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
    
    // Añade una sombra debajo de una UIView
    private func addShadow(to view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height : 5.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 5
    }
    
    // Difumina una UIImageView
    private func addBlurEffect(to imageView: UIImageView, style: UIBlurEffect.Style) {
        let blur = UIBlurEffect(style: style)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.frame = imageView.bounds
        imageView.addSubview(blurEffect)
    }
}



    
