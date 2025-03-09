using UnityEngine;

//后处理代理，这里的后处理都是临时后处理，并不是一直开启的
public class PostProcessingProxy : MonoBehaviour
{
    private MoonCommonLib.IMPostUber _roPost;

    public MoonCommonLib.IMPostUber RoPost
    {
        get
        {
            if (null != _roPost) return _roPost;
            return _roPost = MoonClientBridge.Bridge?.GetPostUber();
        }
    }

    public float _vigIntensity = 0;
    public Color _vigColor = Color.black;
    public float _vigSmoothness = 0.4f;
    public float _vigRoundness = 1;
    public bool _vigRound = false;
    public Vector2 _vigCenter = new Vector2(0.5f, 0.5f);
    
    public float _rbStrength = 0;
    public float _rbDistance = 1;
    public Vector2 _rbCenter = new Vector2(0.5f, 0.5f);
    
    public float _wvStrength = 0;
    public float _wvDensity = 100;
    public float _wvFrequency = -15;
    public float _wvFade = 0.2f;
    public float _wvRoundness = 1;
    public Vector2 _wvCenter = new Vector2(0.5f, 0.5f);

    public void Desaturate(float strength)
    {
        RoPost?.Desaturate(strength);
    }

    public void Exposure(float exp)
    {
        RoPost?.SetExposure(exp);
    }

    public void FadeIn(float time, bool fromWhite = false)
    {
        RoPost.FadeIn(time, fromWhite);
    }

    public void FadeOut(float time, bool toWhite = false)
    {
        RoPost?.FadeOut(time, toWhite);
    }

    public void ScreenMask(float opacity, Texture mask, float rounded = 0)
    {
        RoPost?.SetVignette(opacity, mask, rounded);
    }

    public void StartRedEye()
    {
        RoPost?.StartRedEye();
    }

    public void Vignette()
    {
        RoPost?.SetVignette(_vigIntensity, _vigColor, _vigSmoothness, _vigRoundness, _vigRound, _vigCenter);
    }

    public void Vignette(float intensity, Color color, float smoothness, float roundness, bool round, Vector2 center)
    {
        _vigIntensity = intensity;
        _vigColor = color;
        _vigSmoothness = smoothness;
        _vigRoundness = roundness;
        _vigRound = round;
        _vigCenter = center;
        RoPost?.SetVignette(_vigIntensity, _vigColor, _vigSmoothness, _vigRoundness, _vigRound, _vigCenter);
    }

    public void RadialBlur()
    {
        RoPost?.RadialBlur(_rbStrength, _rbDistance, _rbCenter.x, _rbCenter.y);
    }

    public void RadialBlur(float strength, float distance)
    {
        _rbStrength = strength;
        _rbDistance = distance;
        RoPost?.RadialBlur(strength, distance, 0.5f, 0.5f);
    }

    public void RadialBlur(float strength, float distance, Vector2 center)
    {

        _rbStrength = strength;
        _rbDistance = distance;
        _rbCenter = center;
        RoPost?.RadialBlur(strength, distance, center.x, center.y);
    }

    public void WaveDistort()
    {
        RoPost?.WaveDistrot(_wvStrength, _wvDensity, _wvFrequency, _wvFade, _wvRoundness, _wvCenter.x, _wvCenter.y);
    }

    public void WaveDistort(float strength)
    {
        _wvStrength = strength;
        RoPost?.WaveDistrot(strength, 100, -15, 0.2f, 1, 0.5f, 0.5f);
    }

    public void WaveDistort(float strength, float density, float frequency, float fade, float roundness, float cx, float cy)
    {
        _wvStrength = strength;
        _wvDensity = density;
        _wvFrequency = frequency;
        _wvFade = fade;
        _wvRoundness = roundness;
        _wvCenter = new Vector2(cx, cy);
        RoPost?.WaveDistrot(strength, density, frequency, fade, roundness, cx, cy);
    }

    public void HeatDistort(float duration, float strength, Texture heatTex, float frequency = 0.025f, float force = 0.01f, float tiling = 0.25f)
    {
        RoPost?.HeatDistort(duration, strength, heatTex, frequency, force, tiling);
    }
}
