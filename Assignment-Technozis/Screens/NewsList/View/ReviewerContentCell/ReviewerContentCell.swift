//
//  ReviewerContentCell.swift
//  Assignment-Technozis
//
//  Created by abh on 07/07/25.
//

import UIKit

protocol ReviewerContentCellDelegate:NSObjectProtocol{
    func checkBoxStateChange(selected:Bool, index:IndexPath)
}

class ReviewerContentCell: UITableViewCell {

    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblArticleName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var constHeightDescription: NSLayoutConstraint!
    @IBOutlet weak var constHeightArticleName: NSLayoutConstraint!
    @IBOutlet weak var constWidthCheckBox: NSLayoutConstraint!
    
    weak var delegate:ReviewerContentCellDelegate?
    var isCheckboxSelected:Bool = false
    var articleData:ArticleData??
    var index:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with article: ArticleData) {
        self.articleData = article
        self.lblArticleName.text = article.name ?? "(No Title)"
        self.updateLabelHeight(label: self.lblArticleName, heightConstraint: constHeightArticleName)
        
        self.lblDescription.text = article.authorDetail?.article?.article ?? "(No Description)"
        self.updateLabelHeight(label: self.lblDescription, heightConstraint: constHeightDescription)
        self.checkBoxUIState()
    }
    
    func checkBoxUIState(){
        if isCheckboxSelected{
            self.btnCheckBox.setImage(UIImage(named: "check-icon"), for: .normal)
        } else {
            self.btnCheckBox.setImage(UIImage(named: "uncheck-icon"), for: .normal)
        }
    }
    
    func hideUIForAuthor(){
        self.constWidthCheckBox.constant = 0
        self.btnCheckBox.isHidden = true
    }
    
    func updateLabelHeight(label: UILabel, heightConstraint: NSLayoutConstraint) {
        guard let text = label.text, !text.isEmpty else {
            heightConstraint.constant = 0
            return
        }

        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        let maxWidth = label.frame.width
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let expectedSize = label.sizeThatFits(maxSize)
        heightConstraint.constant = expectedSize.height
    }

    @IBAction func clickedOnCheckbox(_ sender: Any) {
        isCheckboxSelected = !isCheckboxSelected
        if isCheckboxSelected{
            self.btnCheckBox.setImage(UIImage(named: "check-icon"), for: .normal)
        } else {
            self.btnCheckBox.setImage(UIImage(named: "uncheck-icon"), for: .normal)
        }
        self.delegate?.checkBoxStateChange(selected: self.isCheckboxSelected, index: self.index ?? IndexPath() )
    }
}
