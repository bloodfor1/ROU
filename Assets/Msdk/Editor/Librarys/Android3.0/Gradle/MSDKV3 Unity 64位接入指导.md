# MSDKV3 Unity 64位接入指导

### 使用方法

MSDKV3 Unity 额外提供两个64位库：arm64-v8 和 x86_64，请根据需要拷贝覆盖到 MSDK/Editor/Librarys/Android 3.2/libs 中，修改之后需要重新 Deploy 部署。

#### 已知问题说明

1、Unity 自版本 2018.2 和 2017.4.16 开始提供 64 位支持。

2、确保编译设置能够输出 64 位库

依次转到 Player Settings Panel > Settings for Android > Other Settings > Configuration，将 Scripting Backend 设为 IL2CPP，依次选择“Target Architectures”> ARM64 复选框。

> 更多详情参见官网说明：[https://developer.android.com/distribute/best-practices/develop/64-bit?hl=zh-cn](https://developer.android.com/distribute/best-practices/develop/64-bit?hl=zh-cn)



