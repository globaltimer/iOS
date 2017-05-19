
import UIKit

extension UIImage {
    
    // Resizeするクラスメソッド
    func resizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに自身に設定された画像を描画する
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


class DateUtils {
    
    class func dateFromString(string: String, format: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: string)!
    }

    
    class func stringFromDate(date: Date, format: String, tz: NSTimeZone) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.timeZone   = tz as TimeZone
        
        formatter.dateFormat = format
        
        // 空文字 → Yearラベル(左のラベル)設定時の実行
        if format == "" {
            formatter.dateStyle = .medium
        }
        
        return formatter.string(from: date)
    }
}
