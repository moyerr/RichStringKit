@testable import RichStringKit

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSTextAttachment {
    static func attachment(using image: Image) -> NSTextAttachment {
        #if os(macOS)
        let cell = NSTextAttachmentCell(imageCell: image)
        let attachment = NSTextAttachment()
        attachment.attachmentCell = cell
        return attachment
        #else
        return NSTextAttachment(image: image)
        #endif
    }
}
