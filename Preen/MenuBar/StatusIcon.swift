// SPDX-License-Identifier: GPL-3.0-or-later

import AppKit

/// The menu bar glyphs, as template images so they follow the menu bar's appearance.
enum StatusIcon {
    /// The quill from the app icon: three feathers, cut slightly apart so they stay distinct at menu bar size.
    static let feather: NSImage = {
        let image = NSImage(size: NSSize(width: 18, height: 18), flipped: true) { _ in
            guard let context = NSGraphicsContext.current else { return false }
            // The feathers are in the icon artwork's 48-unit space. Their bounds, 7.61…41.45 by 4.00…44.24,
            // are fitted to 16 points and centred.
            let scale: CGFloat = 16 / (44.24 - 4.00)
            let transform = NSAffineTransform()
            transform.translateX(by: 9 - (7.61 + 41.45) / 2 * scale, yBy: 9 - (4.00 + 44.24) / 2 * scale)
            transform.scale(by: scale)
            transform.concat()

            // An outline thickens the feathers so the quill's tip survives at 1×; each feather in front
            // first clears a gap around itself.
            let weight = 0.5 / scale
            let gap = 0.6 / scale
            NSColor.black.set()
            func draw(_ feather: NSBezierPath) {
                feather.fill()
                feather.lineWidth = weight
                feather.lineJoinStyle = .round
                feather.stroke()
            }
            func clearAround(_ feather: NSBezierPath) {
                context.compositingOperation = .clear
                feather.lineWidth = weight + 2 * gap
                feather.stroke()
                context.compositingOperation = .sourceOver
            }

            let lower = featherPath(from: (39.15, 18.92), [
                (36.54, 20.88, 33.02, 21.82, 30.14, 22.85), (24.34, 24.90, 19.78, 28.06, 16.17, 31.85),
                (12.51, 35.78, 8.01, 41.16, 7.61, 44.24), (8.35, 43.77, 10.49, 39.93, 13.84, 36.94),
                (16.21, 34.79, 18.48, 33.91, 21.52, 33.61), (24.38, 33.36, 26.83, 32.61, 28.48, 31.46),
                (27.05, 31.65, 25.37, 31.64, 24.38, 31.45), (30.92, 31.31, 35.56, 26.79, 39.15, 18.92),
            ])
            let small = featherPath(from: (17.36, 17.77), [
                (15.37, 19.61, 12.38, 23.66, 12.22, 27.61), (12.09, 30.80, 13.47, 32.74, 11.89, 36.29),
                (12.90, 35.09, 14.39, 32.99, 15.56, 31.39), (16.52, 29.70, 16.94, 27.89, 16.89, 26.11),
                (16.79, 23.14, 16.30, 20.78, 17.36, 17.77),
            ])
            let top = featherPath(from: (39.89, 4.05), [
                (39.68, 3.94, 39.48, 4.04, 39.38, 4.22), (36.04, 10.48, 21.38, 10.51, 18.14, 19.45),
                (16.84, 23.10, 18.04, 26.21, 16.49, 29.32), (16.05, 30.35, 15.70, 31.18, 15.44, 31.52),
                (19.31, 26.91, 24.16, 23.98, 29.42, 22.04), (33.84, 20.40, 37.91, 19.66, 39.51, 17.69),
                (40.37, 16.64, 40.73, 15.04, 40.90, 13.89), (39.75, 15.14, 38.06, 16.18, 36.82, 16.49),
                (43.25, 11.11, 41.64, 5.61, 39.89, 4.05),
            ])
            draw(lower)
            clearAround(small)
            draw(small)
            clearAround(top)
            draw(top)
            return true
        }
        image.isTemplate = true
        image.accessibilityDescription = "Preen"
        return image
    }()

    /// A closed path of cubic curves, each given as its two control points and end point.
    private static func featherPath(
        from start: (CGFloat, CGFloat),
        _ curves: [(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)]
    ) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: start.0, y: start.1))
        for (c1x, c1y, c2x, c2y, x, y) in curves {
            path.curve(to: NSPoint(x: x, y: y), controlPoint1: NSPoint(x: c1x, y: c1y), controlPoint2: NSPoint(x: c2x, y: c2y))
        }
        path.close()
        return path
    }

    /// Shown for a moment after a link is cleaned.
    static let cleaned: NSImage = {
        let configuration = NSImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        let image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: "Link cleaned")!
            .withSymbolConfiguration(configuration)!
        image.isTemplate = true
        return image
    }()
}
