import Foundation
import PDFKit
import AppKit
let args = CommandLine.arguments
let doc = PDFDocument(url: URL(fileURLWithPath: args[1]))!
print("Pages: \(doc.pageCount)")
for i in 0..<doc.pageCount {
 let page = doc.page(at:i)!
 print("PAGE \(i+1)\n\(page.string ?? "")")
 let bounds = page.bounds(for:.mediaBox)
 let scale: CGFloat = 1.6
 let bitmap = NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:Int(bounds.width*scale),pixelsHigh:Int(bounds.height*scale),bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState()
 let gc = NSGraphicsContext(bitmapImageRep:bitmap)!
 NSGraphicsContext.current = gc
 gc.cgContext.setFillColor(NSColor.white.cgColor)
 gc.cgContext.fill(CGRect(x:0,y:0,width:CGFloat(bitmap.pixelsWide),height:CGFloat(bitmap.pixelsHigh)))
 gc.cgContext.scaleBy(x:scale,y:scale)
 page.draw(with:.mediaBox,to:gc.cgContext)
 NSGraphicsContext.restoreGraphicsState()
 try bitmap.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(args[2])-\(i+1).png"))
}
