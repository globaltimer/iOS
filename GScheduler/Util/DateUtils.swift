
import UIKit

extension UIImage {
    
    // Resizeするクラスメソッド.
    func resizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに自身に設定された画像を描画する.
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


class DateUtils {
    
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)! as Date
    }

    
    class func stringFromDate(date: Date, format: String, tz: TimeZone) -> String {
        
        let formatter: DateFormatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.timeZone   = tz
        
        formatter.dateFormat = format
        
        // 空文字 → Yearラベル(左のラベル)設定時の実行
        if format == "" {
            formatter.dateStyle = .medium
            //formatter.timeStyle = .none
        }
        
        return formatter.string(from: date as Date)
    }
}
