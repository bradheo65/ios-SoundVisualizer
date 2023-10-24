# ios-SoundVisualizer

## 사운드 시각화 연습 프로젝트

| 실행 화면 |
| :--------: | 
| <img src="https://github.com/bradheo65/ios-SoundVisualizer/assets/45350356/6b9301fa-9281-422c-8809-a60d05e65724" width="300" height="500"/>     | 

### 적용 방법

**사운드 데이터를 가지고 와 배열에 저장 후 이 배열을 사용하여 View 차트에 매핑**

1. 오디오 녹음, 사운드 레벨 저장

- `Timer`를 사용하여 사운드 레벨 저장

```swift
      audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            // 7
            self.audioRecorder.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
```

2. View 구현

- 데시벨db(-160db ~ 0db) 사이로 값 설정, 최대 높이설정 후 0.1 ~ 25 사이의 값으로 반환

```swift
private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
```
