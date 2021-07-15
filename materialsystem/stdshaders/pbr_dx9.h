#pragma once

#include <string.h>

//-----------------------------------------------------------------------------
// Forward declarations
//-----------------------------------------------------------------------------
class CBaseVSShader;
class IMaterialVar;
class IShaderDynamicAPI;
class IShaderShadow;


struct PBR_Vars_t
{
    PBR_Vars_t()
    {
        memset(this, 0xFF, sizeof(*this));
    }

    int baseTexture;
    int baseColor;
    int normalTexture;
    int bumpMap;
    int envMap;
    int baseTextureFrame;
    int baseTextureTransform;
    int useParallax;
    int parallaxDepth;
    int parallaxCenter;
    int alphaTestReference;
    int flashlightTexture;
    int flashlightTextureFrame;
    int emissionTexture;
    int mraoTexture;
    int useEnvAmbient;
    int specularTexture;
};


void InitParamsPBR( CBaseVSShader *pShader, IMaterialVar** params, const char *pMaterialName, PBR_Vars_t &info );
void InitPBR( CBaseVSShader *pShader, IMaterialVar** params, PBR_Vars_t &info );
void DrawPBR( CBaseVSShader *pShader, IMaterialVar** params, IShaderDynamicAPI *pShaderAPI, IShaderShadow* pShaderShadow,
				VertexCompressionType_t vertexCompression, CBasePerMaterialContextData **pContextDataPtr );

