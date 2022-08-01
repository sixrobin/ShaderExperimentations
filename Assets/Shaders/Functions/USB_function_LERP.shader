Shader "USB/USB_function_LERP"
{
    Properties
    {
        _Skin01("Skin 01", 2D) = "white" {}
        _Skin02("Skin 02", 2D) = "white" {}
        _Lerp("Skins Lerp", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv_s01 : TEXCOORD0;
                float2 uv_s02 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv_s01 : TEXCOORD0;
                float2 uv_s02 : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _Skin01;
            float4 _Skin01_ST;
            sampler2D _Skin02;
            float4 _Skin02_ST;
            float _Lerp;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_s01 = TRANSFORM_TEX(v.uv_s01, _Skin01);
                o.uv_s02 = TRANSFORM_TEX(v.uv_s02, _Skin02);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 skin01 = tex2D(_Skin01, i.uv_s01);
                fixed4 skin02 = tex2D(_Skin02, i.uv_s02);

                fixed4 lerpTex = lerp(skin01, skin02, _Lerp);
                
                return lerpTex;
            }
            ENDCG
        }
    }
}
