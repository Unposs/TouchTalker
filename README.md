# TouchTalker

**TouchTalker** is an assistive communication app designed to help children with special needs practice speech and communicate more easily.  
The app combines **image-based buttons**, **speech synthesis**, and **AI-powered image recognition (MobileNetV2 + OCR)** to support expressive communication and pronunciation practice.

---

## Features
- Touch-based interface for speech and communication  
- Speech synthesis (text-to-speech) for word playback  
- AI image recognition using MobileNetV2 and OCR  
- Easy to customize word–image sets for each child  
- Designed with accessibility and inclusivity in mind  

---

## Tech Stack
| Category | Technology | Description |
|-----------|-------------|-------------|
| **Language** | Swift / SwiftUI | Native iOS application development |
| **Frameworks** | Vision, CoreML, AVFoundation | AI recognition, machine learning, and speech synthesis |
| **Model** | MobileNetV2 | Image classification and object recognition |
| **Platform** | iOS | Optimized for iPhone and iPad devices |

---

## Goal
To help children with speech or developmental challenges communicate confidently and naturally through touch and sound.

---

## System Architecture
The **TouchTalker** app integrates multiple iOS frameworks to enable assistive speech communication for children with special needs.

```
+--------------------------------+
|          TouchTalker           |
|      (Swift / SwiftUI App)     |
+--------------------------------+
               |
               v
+--------------------------------+
|       Image Input Layer        |
|   (Camera or Photo Picker)     |
|   -> ImagePicker.swift         |
+--------------------------------+
               |
               v
+--------------------------------+
|     AI Recognition Layer       |
|     (Vision + MobileNetV2)     |
|     -> ImageTextRecognizer.swift|
|     -> MobileNetV2.mlmodel     |
+--------------------------------+
               |
               v
+--------------------------------+
|       Text & Logic Layer       |
|   (Extracted label or text)    |
|   -> ButtonManager.swift       |
+--------------------------------+
               |
               v
+--------------------------------+
|     Speech Output Layer        |
|   (AVFoundation TTS Engine)    |
|   -> SpeechManager.swift       |
+--------------------------------+
               |
               v
+--------------------------------+
|       User Interface Layer     |
|           (SwiftUI)            |
|   -> PictureBuddyView.swift    |
|   -> ContentView.swift         |
|   -> ParentSettingsView.swift  |
+--------------------------------+
```

---

### Explanation

**1. Image Input Layer**  
- The user (child) selects or captures an image using the camera or photo gallery.  
- Implemented in `ImagePicker.swift`.

**2. AI Recognition Layer**  
- The image is analyzed using Apple’s **Vision** framework for OCR (text extraction).  
- The **MobileNetV2 Core ML** model identifies visual objects.  
- Implemented in `ImageTextRecognizer.swift` and `MobileNetV2.mlmodel`.

**3. Text & Logic Layer**  
- Extracted object names or recognized text are passed to `ButtonManager.swift`.  
- The manager maps visual inputs to preconfigured “speech buttons.”

**4. Speech Output Layer**  
- The recognized word or phrase is spoken aloud through **AVSpeechSynthesizer**.  
- Managed by `SpeechManager.swift`.

**5. UI Layer**  
- Built with **SwiftUI**, providing a touch-friendly interface.  
- Parent and child modes are controlled in `ParentLoginView.swift` and `ParentSettingsView.swift`.  
- The child interacts mainly through `PictureBuddyView.swift` and `ContentView.swift`.

---

## Summary
**TouchTalker** combines AI-powered image recognition, OCR, and text-to-speech synthesis into an intuitive iOS app.  
It helps children with speech or developmental challenges communicate through images and sound — bridging visual understanding and verbal expression.

---

## 👦 Author
Developed by **Haoyu Wang (Unposs)**

