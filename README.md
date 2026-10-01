# 🌙 SwiftUIMeow

一個使用 **100% 純 SwiftUI** 向量形狀與動畫打造的夜空星月小黑貓視覺互動 App。  
靈感源自著名插畫家 **Apofiss** 的經典畫作，將靜態童話插畫轉化為充滿生命力的動態體驗。

---

## ✨ 視覺與動畫特色 (Features)

### 🐱 靈動小黑貓 (Curious Black Kitten)
- **純向量輪廓**：以貝茲曲線自訂 `CatSilhouette`，刻畫毛茸茸的貓耳、背脊弧度與捲翹尾巴。
- **生動的貓眼光采**：招牌圓滾滾大眼，搭配雙重高光反射點。
- **擬真眨眼動畫 (Natural Blinking)**：
  - 基於 Swift Concurrency (`Task.sleep`) 模擬真實生物節奏（間隔 2.8～4.2 秒隨機眨眼）。
  - 內建 35% 機率觸發超萌的「快速連續雙眨眼」。
  - **觸控互動**：點擊貓咪雙眼可隨時觸發立即眨眼！
- **平緩呼吸起伏 (Gentle Breathing)**：以極細微的 `scaleEffect` 呈現小貓安靜待在月亮上的呼吸動態。

### 🌕 溫暖微笑滿月 (Smiling Glowing Moon)
- **多層光暈**：徑向漸層與外圍柔焦光暈，帶有呼吸律動的膨脹與淡入淡出。
- **月球紋理 (Craters)**：有機分佈的半透明斑點，營造天然隕石坑質感。
- **治癒表情 (Smiling Face)**：圓潤腮紅配上溫柔的弧形笑眼與微笑曲線。

### 🌟 璀璨星空與四角鑽石星芒 (Twinkling Starfield & Sparkles)
- **30+ 顆繁星點點**：多相位（Phase A / B / C）非同步交替微光閃爍，避免機械化的單一頻率。
- **四角凹星鑽石芒 (Diamond Sparkle)**：以貝茲曲線繪製可調銳利度的凹面四角星，伴隨旋轉、縮放與彩光投影。

### ☁️ 視差夜雲 (Parallax Billowing Clouds)
- **三層式漸層雲海**：遠景月光映照雲、中景厚積雲、近景深藍夜雲。
- **非同步視差飄移**：各雲層以不同週期（8.0s / 11.5s / 9.0s）緩慢水平浮動，構築深邃的夜空立體感。

### 📐 自適應幾何排版 (Responsive Layout)
- 透過 `GeometryReader` 計算動態比例錨點，確保貓咪精確端坐在月亮頂端弧線，完美適配不同 iPhone 及 iPad 螢幕比例。

---

## 🛠 技術亮點 (Technical Highlights)

- **Pure SwiftUI Implementation**：全專案無外部第三方庫，零圖片貼圖，全場景皆以 Swift 程式碼繪製。
- **自訂 SwiftUI Shapes**：
  - `DiamondSparkle`：可調曲率四角星形狀。
  - `CatSilhouette`：以多段三次與二次貝茲曲線構成的貓咪身形。
  - `MoonArchEye` & `MoonSmileMouth`：月亮五官形狀。
  - `BackCloudShape`, `MidCloudShape`, `FrontCloudShape`：多層雲朵輪廓。
- **Swift Concurrency 驅動動畫**：在 `.task` 生命週期中運行非同步迴圈，並嚴格遵循 `Task.isCancelled` 取消機制，無內存洩漏風險。

---

## 📱 運行環境 (Requirements)

- **iOS**: 17.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+

---

## 🚀 快速開始 (Getting Started)

1. **Clone 專案**：
   ```bash
   git clone https://github.com/mirloss956/swiftuimeow.git
   cd swiftuimeow
   ```

2. **開啟專案**：
   ```bash
   open hw2260923.xcodeproj
   ```

3. **執行**：
   - 選擇 iPhone 模擬器或實機。
   - 按下 `Cmd + R` 即可開始運行並體驗！
   - 亦可在 Xcode Preview 中直接即時預覽互動效果。

---

## 🎨 致敬與鳴謝 (Credits)

- 原作風格與概念靈感來自藝術家 **Apofiss** 的經典治癒系夜空插畫。
- 程式碼由 SwiftUI 實現。
