import SwiftUI

struct ContentView: View {
    @State private var isTwinkling = false

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let canvasWidth = min(size.width, size.height * (3.0 / 4.0))

            // Geometrical anchors so cat sits perfectly on the moon across any screen size
            let moonDiameter = canvasWidth * 0.46
            let moonCenterX = size.width * 0.50
            let moonCenterY = size.height * 0.465
            let moonTopY = moonCenterY - (moonDiameter / 2.0)

            let catWidth = canvasWidth * 0.28
            let catHeight = catWidth * 0.78
            // Cat sits snugly on the moon's top crest (lower body overlaps the upper curve of the moon)
            let catCenterY = moonTopY - (catHeight * 0.5) + (catHeight * 0.30)

            ZStack {
                // Background Night Sky Gradient
                NightSkyBackground()

                // Starfield & Diamond Sparkles
                StarfieldView(isTwinkling: isTwinkling)

                // The Glowing Moon with Face & Craters
                MoonView()
                    .frame(width: moonDiameter, height: moonDiameter)
                    .position(x: moonCenterX, y: moonCenterY)

                // The Fluffy Cat sitting directly on the Moon
                CatView()
                    .frame(width: catWidth, height: catHeight)
                    .position(x: moonCenterX + 2, y: catCenterY)

                // Multi-layered Billowing Night Clouds
                CloudsView()
                    .frame(width: size.width, height: size.height * 0.42)
                    .position(x: size.width * 0.50, y: size.height * 0.82)

                // Artist Watermark Frame (bottom right)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("APOFISS")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .tracking(1.5)
                            .foregroundStyle(Color(red: 0.30, green: 0.40, blue: 0.60).opacity(0.7))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color(red: 0.30, green: 0.40, blue: 0.60).opacity(0.6), lineWidth: 1)
                            )
                            .padding(.trailing, 20)
                            .padding(.bottom, 16)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .clipped()
            .onAppear {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    isTwinkling = true
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Night Sky Background

private struct NightSkyBackground: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: Color(red: 0.04, green: 0.07, blue: 0.17), location: 0.0),
                .init(color: Color(red: 0.07, green: 0.12, blue: 0.26), location: 0.25),
                .init(color: Color(red: 0.12, green: 0.18, blue: 0.36), location: 0.55),
                .init(color: Color(red: 0.20, green: 0.27, blue: 0.48), location: 0.80),
                .init(color: Color(red: 0.24, green: 0.32, blue: 0.54), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Sparkle Shape (4-Point Diamond Star)

private struct DiamondSparkle: Shape {
    var sharpness: CGFloat = 0.88 // Higher value = sharper / more concave points

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let top = CGPoint(x: center.x, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: center.y)
        let bottom = CGPoint(x: center.x, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: center.y)

        let concavity = 1.0 - sharpness
        let cRadiusX = (rect.width / 2) * concavity
        let cRadiusY = (rect.height / 2) * concavity

        path.move(to: top)
        path.addQuadCurve(to: right, control: CGPoint(x: center.x + cRadiusX, y: center.y - cRadiusY))
        path.addQuadCurve(to: bottom, control: CGPoint(x: center.x + cRadiusX, y: center.y + cRadiusY))
        path.addQuadCurve(to: left, control: CGPoint(x: center.x - cRadiusX, y: center.y + cRadiusY))
        path.addQuadCurve(to: top, control: CGPoint(x: center.x - cRadiusX, y: center.y - cRadiusY))
        path.closeSubpath()

        return path
    }
}

// MARK: - Starfield & Sparkles

private struct StarfieldView: View {
    var isTwinkling: Bool

    // Background pin-point stars (xRatio, yRatio, diameter, baseOpacity)
    private let starPoints: [(CGFloat, CGFloat, CGFloat, Double)] = [
        (0.08, 0.05, 2.0, 0.8), (0.17, 0.08, 1.8, 0.6), (0.24, 0.04, 2.2, 0.9),
        (0.33, 0.07, 1.6, 0.7), (0.42, 0.05, 2.4, 0.85), (0.58, 0.04, 2.0, 0.7),
        (0.66, 0.08, 2.2, 0.9), (0.78, 0.03, 2.5, 0.95), (0.88, 0.07, 1.8, 0.7),
        (0.94, 0.12, 1.5, 0.6), (0.12, 0.16, 2.2, 0.8), (0.26, 0.19, 1.8, 0.65),
        (0.62, 0.15, 2.2, 0.85), (0.72, 0.16, 1.7, 0.7), (0.83, 0.19, 2.3, 0.9),
        (0.92, 0.22, 1.4, 0.5), (0.16, 0.26, 2.0, 0.75), (0.23, 0.38, 1.8, 0.8),
        (0.12, 0.42, 1.6, 0.6), (0.74, 0.27, 2.0, 0.8), (0.82, 0.33, 1.8, 0.75),
        (0.90, 0.40, 2.2, 0.85), (0.86, 0.48, 1.5, 0.6), (0.14, 0.52, 1.6, 0.6),
        (0.20, 0.58, 1.8, 0.7), (0.79, 0.55, 1.5, 0.6), (0.28, 0.12, 1.3, 0.5),
        (0.48, 0.18, 1.5, 0.6), (0.55, 0.18, 1.7, 0.65), (0.64, 0.03, 1.4, 0.6)
    ]

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                // Tiny star dots
                ForEach(Array(starPoints.enumerated()), id: \.offset) { idx, star in
                    Circle()
                        .fill(Color.white.opacity(isTwinkling ? star.3 : star.3 * 0.6))
                        .frame(width: star.2, height: star.2)
                        .shadow(color: .white.opacity(0.6), radius: 2)
                        .position(x: w * star.0, y: h * star.1)
                }

                // 1. Large Top-Center Diamond Sparkle (Light Cyan)
                DiamondSparkle(sharpness: 0.86)
                    .fill(Color(red: 0.68, green: 0.86, blue: 1.0))
                    .frame(width: 19, height: 29)
                    .shadow(color: Color(red: 0.55, green: 0.80, blue: 1.0).opacity(0.85), radius: 6)
                    .scaleEffect(isTwinkling ? 1.08 : 0.94)
                    .position(x: w * 0.488, y: h * 0.118)

                // 2. Medium Top-Right Diamond Sparkle (Pale Blue)
                DiamondSparkle(sharpness: 0.88)
                    .fill(Color(red: 0.78, green: 0.90, blue: 1.0))
                    .frame(width: 14, height: 22)
                    .shadow(color: Color(red: 0.60, green: 0.85, blue: 1.0).opacity(0.7), radius: 4)
                    .scaleEffect(isTwinkling ? 0.92 : 1.06)
                    .position(x: w * 0.555, y: h * 0.088)

                // 3. Prominent Diamond Sparkle to Left of Cat (Cyan)
                DiamondSparkle(sharpness: 0.86)
                    .fill(Color(red: 0.46, green: 0.80, blue: 1.0))
                    .frame(width: 18, height: 27)
                    .shadow(color: Color(red: 0.40, green: 0.75, blue: 1.0).opacity(0.9), radius: 7)
                    .scaleEffect(isTwinkling ? 1.1 : 0.92)
                    .position(x: w * 0.328, y: h * 0.266)

                // 4. Smaller Blue Diamond Sparkle below left sparkle
                DiamondSparkle(sharpness: 0.88)
                    .fill(Color(red: 0.55, green: 0.82, blue: 1.0))
                    .frame(width: 10, height: 16)
                    .shadow(color: Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.7), radius: 3)
                    .position(x: w * 0.218, y: h * 0.322)

                // 5. Warm Golden Star to the Right of Cat
                DiamondSparkle(sharpness: 0.88)
                    .fill(Color(red: 1.0, green: 0.92, blue: 0.55))
                    .frame(width: 12, height: 18)
                    .shadow(color: Color(red: 1.0, green: 0.88, blue: 0.40).opacity(0.8), radius: 4)
                    .scaleEffect(isTwinkling ? 0.95 : 1.12)
                    .position(x: w * 0.680, y: h * 0.215)

                // 6. Crisp Warm Golden Diamond Sparkle below Moon
                DiamondSparkle(sharpness: 0.85)
                    .fill(Color(red: 1.0, green: 0.95, blue: 0.55))
                    .frame(width: 13, height: 21)
                    .shadow(color: Color(red: 1.0, green: 0.88, blue: 0.40).opacity(0.85), radius: 5)
                    .scaleEffect(isTwinkling ? 1.12 : 0.95)
                    .position(x: w * 0.636, y: h * 0.605)
            }
        }
    }
}

// MARK: - Moon View & Facial Features

private struct MoonView: View {
    var body: some View {
        ZStack {
            // Outer Halo Glow
            Circle()
                .fill(Color(red: 1.0, green: 0.94, blue: 0.70).opacity(0.18))
                .scaleEffect(1.32)
                .blur(radius: 20)

            // Moon Disc Base
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.98, blue: 0.82), // Soft bright buttery center
                            Color(red: 1.0, green: 0.93, blue: 0.66), // Warm yellow body
                            Color(red: 1.0, green: 0.88, blue: 0.54)  // Golden perimeter
                        ],
                        center: .init(x: 0.48, y: 0.52),
                        startRadius: 8,
                        endRadius: 90
                    )
                )
                .shadow(color: Color(red: 1.0, green: 0.92, blue: 0.60).opacity(0.45), radius: 25)

            // Moon Craters / Mottled Patches
            MoonCraterPatches()
                .clipShape(Circle())

            // Moon Smiling Face
            MoonFaceView()
        }
    }
}

// Moon Craters & Markings Shape
private struct MoonCraterPatches: View {
    private let craterColor = Color(red: 0.96, green: 0.66, blue: 0.36).opacity(0.38)

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                // Top-Left Cluster of craters (organic blobs)
                Group {
                    Circle()
                        .frame(width: w * 0.28, height: h * 0.28)
                        .position(x: w * 0.35, y: h * 0.34)
                    Circle()
                        .frame(width: w * 0.32, height: h * 0.26)
                        .position(x: w * 0.20, y: h * 0.38)
                    Circle()
                        .frame(width: w * 0.26, height: h * 0.24)
                        .position(x: w * 0.24, y: h * 0.20)
                    Circle()
                        .frame(width: w * 0.24, height: h * 0.28)
                        .position(x: w * 0.42, y: h * 0.22)
                    Circle()
                        .frame(width: w * 0.20, height: h * 0.20)
                        .position(x: w * 0.58, y: h * 0.26)
                    Circle()
                        .frame(width: w * 0.22, height: h * 0.18)
                        .position(x: w * 0.72, y: h * 0.32)
                }

                // Lower-Left edge patches
                Group {
                    Circle()
                        .frame(width: w * 0.18, height: h * 0.18)
                        .position(x: w * 0.16, y: h * 0.52)
                    Circle()
                        .frame(width: w * 0.20, height: h * 0.16)
                        .position(x: w * 0.22, y: h * 0.66)
                    Circle()
                        .frame(width: w * 0.16, height: h * 0.14)
                        .position(x: w * 0.32, y: h * 0.78)
                }

                // Right side crater spots
                Group {
                    Circle()
                        .frame(width: w * 0.13, height: h * 0.13)
                        .position(x: w * 0.68, y: h * 0.52)
                    Circle()
                        .frame(width: w * 0.12, height: h * 0.12)
                        .position(x: w * 0.75, y: h * 0.64)
                    Circle()
                        .frame(width: w * 0.10, height: h * 0.10)
                        .position(x: w * 0.65, y: h * 0.72)
                }
            }
            .foregroundStyle(craterColor)
            .blur(radius: 3)
        }
    }
}

// Moon Facial Expression
private struct MoonFaceView: View {
    private let faceStrokeColor = Color(red: 0.86, green: 0.50, blue: 0.28)
    private let blushColor = Color(red: 0.98, green: 0.63, blue: 0.42).opacity(0.68)

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                // Cheeks: Soft warm blush ovals
                // Left Cheek
                Ellipse()
                    .fill(blushColor)
                    .frame(width: w * 0.24, height: h * 0.17)
                    .position(x: w * 0.28, y: h * 0.45)
                    .blur(radius: 2)

                // Right Cheek
                Ellipse()
                    .fill(blushColor)
                    .frame(width: w * 0.24, height: h * 0.17)
                    .position(x: w * 0.74, y: h * 0.45)
                    .blur(radius: 2)

                // Left Smiling Eye: `⌒` Happy closed eye
                MoonArchEye()
                    .stroke(faceStrokeColor, style: StrokeStyle(lineWidth: w * 0.022, lineCap: .round))
                    .frame(width: w * 0.13, height: h * 0.065)
                    .position(x: w * 0.43, y: h * 0.435)

                // Right Smiling Eye: `⌒` Happy closed eye
                MoonArchEye()
                    .stroke(faceStrokeColor, style: StrokeStyle(lineWidth: w * 0.022, lineCap: .round))
                    .frame(width: w * 0.13, height: h * 0.065)
                    .position(x: w * 0.585, y: h * 0.435)

                // Cute upward smiling mouth: `ᴗ`
                MoonSmileMouth()
                    .stroke(faceStrokeColor, style: StrokeStyle(lineWidth: w * 0.020, lineCap: .round))
                    .frame(width: w * 0.065, height: h * 0.04)
                    .position(x: w * 0.508, y: h * 0.465)
            }
        }
    }
}

// Curved Arch Eye Shape
private struct MoonArchEye: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.15)
        )
        return path
    }
}

// Cute Smile Mouth Shape
private struct MoonSmileMouth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.1)
        )
        return path
    }
}

// MARK: - Cat Shape & View

private struct CatView: View {
    var body: some View {
        ZStack {
            // Cat Silhouette Body
            CatSilhouette()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.06, green: 0.09, blue: 0.17), // Rich midnight charcoal navy
                            Color(red: 0.03, green: 0.05, blue: 0.11)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.35), radius: 4, x: 0, y: 3)

            // Cat's Big Expressive Eyes
            CatEyesView()
                .frame(width: 52, height: 26)
                .offset(x: -4, y: -2)
        }
    }
}

// Cat Silhouette Shape with ears, whisker tufts on left and right fluff
private struct CatSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Start at center bottom resting on moon
        path.move(to: CGPoint(x: w * 0.40, y: h * 0.98))

        // Bottom left resting curve
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.90),
            control1: CGPoint(x: w * 0.32, y: h * 0.98),
            control2: CGPoint(x: w * 0.25, y: h * 0.96)
        )

        // Lower left cheek / fluff curve
        path.addCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.65),
            control1: CGPoint(x: w * 0.18, y: h * 0.82),
            control2: CGPoint(x: w * 0.16, y: h * 0.72)
        )

        // Whisker tuft 1 (lower)
        path.addLine(to: CGPoint(x: w * 0.07, y: h * 0.58))
        path.addLine(to: CGPoint(x: w * 0.18, y: h * 0.52))

        // Whisker tuft 2 (middle)
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.19, y: h * 0.38))

        // Whisker tuft 3 (upper)
        path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.24, y: h * 0.28))

        // Curve up to Left Ear tip
        path.addCurve(
            to: CGPoint(x: w * 0.31, y: h * 0.05),
            control1: CGPoint(x: w * 0.24, y: h * 0.18),
            control2: CGPoint(x: w * 0.27, y: h * 0.08)
        )

        // Left ear inner edge to head dip
        path.addCurve(
            to: CGPoint(x: w * 0.44, y: h * 0.12),
            control1: CGPoint(x: w * 0.35, y: h * 0.04),
            control2: CGPoint(x: w * 0.39, y: h * 0.10)
        )

        // Head dip to Right Ear tip
        path.addCurve(
            to: CGPoint(x: w * 0.58, y: h * 0.07),
            control1: CGPoint(x: w * 0.48, y: h * 0.12),
            control2: CGPoint(x: w * 0.53, y: h * 0.08)
        )

        // Right ear outer edge down to right cheek
        path.addCurve(
            to: CGPoint(x: w * 0.70, y: h * 0.26),
            control1: CGPoint(x: w * 0.63, y: h * 0.08),
            control2: CGPoint(x: w * 0.67, y: h * 0.18)
        )

        // Right fur tuft 1
        path.addLine(to: CGPoint(x: w * 0.79, y: h * 0.31))
        path.addLine(to: CGPoint(x: w * 0.73, y: h * 0.38))

        // Right fur tuft 2
        path.addLine(to: CGPoint(x: w * 0.81, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.76, y: h * 0.54))

        // Right plump body & tucked tail / rump
        path.addCurve(
            to: CGPoint(x: w * 0.92, y: h * 0.76),
            control1: CGPoint(x: w * 0.86, y: h * 0.58),
            control2: CGPoint(x: w * 0.94, y: h * 0.66)
        )

        // Rump curve down to bottom right
        path.addCurve(
            to: CGPoint(x: w * 0.74, y: h * 0.97),
            control1: CGPoint(x: w * 0.90, y: h * 0.88),
            control2: CGPoint(x: w * 0.84, y: h * 0.98)
        )

        // Bottom edge conforming to moon crest
        path.addCurve(
            to: CGPoint(x: w * 0.40, y: h * 0.98),
            control1: CGPoint(x: w * 0.64, y: h * 0.96),
            control2: CGPoint(x: w * 0.52, y: h * 0.97)
        )

        path.closeSubpath()
        return path
    }
}

// Cat's Signature Huge Curious Eyes
private struct CatEyesView: View {
    var body: some View {
        HStack(spacing: 3) {
            SingleCatEye()
            SingleCatEye()
        }
    }
}

private struct SingleCatEye: View {
    private let eyeStroke = Color(red: 1.0, green: 0.93, blue: 0.64)

    var body: some View {
        ZStack {
            // Dark pupil/interior
            Circle()
                .fill(Color(red: 0.04, green: 0.06, blue: 0.12))

            // Bright Golden Outline Ring
            Circle()
                .stroke(eyeStroke, lineWidth: 2.2)

            // Primary Bright White Catchlight Reflection (top-left)
            Circle()
                .fill(Color.white)
                .frame(width: 4.8, height: 4.8)
                .offset(x: -2.8, y: -2.8)

            // Secondary Tiny Reflection Spark (bottom-right)
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: 2.2, height: 2.2)
                .offset(x: 2.5, y: 2.2)
        }
        .frame(width: 21, height: 21)
    }
}

// MARK: - Multi-layered Billowing Night Clouds

private struct CloudsView: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack(alignment: .bottom) {
                // Layer 1: Back/Highest Soft Billowing Cloud Puff (illuminated by moon)
                BackCloudShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.42, green: 0.54, blue: 0.82), location: 0.0),
                                .init(color: Color(red: 0.28, green: 0.38, blue: 0.66), location: 0.45),
                                .init(color: Color(red: 0.18, green: 0.26, blue: 0.50), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 1.08, height: h * 0.82)
                    .offset(x: -w * 0.08, y: -h * 0.12)
                    .blur(radius: 2)

                // Layer 2: Middle Puffy Cloud Bank
                MidCloudShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.26, green: 0.36, blue: 0.65), location: 0.0),
                                .init(color: Color(red: 0.16, green: 0.24, blue: 0.48), location: 0.6),
                                .init(color: Color(red: 0.10, green: 0.16, blue: 0.36), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 1.15, height: h * 0.78)
                    .offset(x: w * 0.05, y: h * 0.05)
                    .blur(radius: 1.5)

                // Layer 3: Foreground Deep Midnight Cloud Bank
                FrontCloudShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.18, green: 0.26, blue: 0.52), location: 0.0),
                                .init(color: Color(red: 0.09, green: 0.14, blue: 0.32), location: 0.5),
                                .init(color: Color(red: 0.05, green: 0.09, blue: 0.22), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 1.12, height: h * 0.70)
                    .offset(x: -w * 0.02, y: h * 0.18)
            }
        }
    }
}

// Back Cloud Layer: high puffy dome on the center-left
private struct BackCloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.68))

        // Left rise
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.44),
            control1: CGPoint(x: 0, y: h * 0.50),
            control2: CGPoint(x: w * 0.10, y: h * 0.42)
        )

        // High billowing center-left dome
        path.addCurve(
            to: CGPoint(x: w * 0.46, y: h * 0.15),
            control1: CGPoint(x: w * 0.26, y: h * 0.22),
            control2: CGPoint(x: w * 0.35, y: h * 0.12)
        )

        // Upper dip to mid dome
        path.addCurve(
            to: CGPoint(x: w * 0.72, y: h * 0.38),
            control1: CGPoint(x: w * 0.55, y: h * 0.18),
            control2: CGPoint(x: w * 0.65, y: h * 0.26)
        )

        // Right descent
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.62),
            control1: CGPoint(x: w * 0.82, y: h * 0.45),
            control2: CGPoint(x: w * 0.94, y: h * 0.52)
        )

        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

// Middle Cloud Layer: broad voluminous puffs
private struct MidCloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.60))

        path.addCurve(
            to: CGPoint(x: w * 0.32, y: h * 0.34),
            control1: CGPoint(x: w * 0.05, y: h * 0.42),
            control2: CGPoint(x: w * 0.18, y: h * 0.32)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.62, y: h * 0.36),
            control1: CGPoint(x: w * 0.42, y: h * 0.32),
            control2: CGPoint(x: w * 0.52, y: h * 0.28)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.88, y: h * 0.48),
            control1: CGPoint(x: w * 0.72, y: h * 0.42),
            control2: CGPoint(x: w * 0.80, y: h * 0.38)
        )

        path.addCurve(
            to: CGPoint(x: w, y: h * 0.58),
            control1: CGPoint(x: w * 0.93, y: h * 0.52),
            control2: CGPoint(x: w * 0.97, y: h * 0.54)
        )

        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

// Front Cloud Layer: lower deep bank
private struct FrontCloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.52))

        path.addCurve(
            to: CGPoint(x: w * 0.36, y: h * 0.42),
            control1: CGPoint(x: w * 0.12, y: h * 0.40),
            control2: CGPoint(x: w * 0.24, y: h * 0.38)
        )

        path.addCurve(
            to: CGPoint(x: w * 0.75, y: h * 0.45),
            control1: CGPoint(x: w * 0.48, y: h * 0.44),
            control2: CGPoint(x: w * 0.62, y: h * 0.38)
        )

        path.addCurve(
            to: CGPoint(x: w, y: h * 0.50),
            control1: CGPoint(x: w * 0.86, y: h * 0.48),
            control2: CGPoint(x: w * 0.94, y: h * 0.42)
        )

        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
