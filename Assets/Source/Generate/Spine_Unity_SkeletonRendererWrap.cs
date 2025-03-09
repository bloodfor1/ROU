﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using MoonCommonLib;
using LuaInterface;

public class Spine_Unity_SkeletonRendererWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Spine.Unity.SkeletonRenderer), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("SetMeshSettings", SetMeshSettings);
		L.RegFunction("Awake", Awake);
		L.RegFunction("ClearState", ClearState);
		L.RegFunction("EnsureMeshGeneratorCapacity", EnsureMeshGeneratorCapacity);
		L.RegFunction("Initialize", Initialize);
		L.RegFunction("LateUpdate", LateUpdate);
		L.RegFunction("FindAndApplySeparatorSlots", FindAndApplySeparatorSlots);
		L.RegFunction("ReapplySeparatorSlotNames", ReapplySeparatorSlotNames);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("skeletonDataAsset", get_skeletonDataAsset, set_skeletonDataAsset);
		L.RegVar("initialSkinName", get_initialSkinName, set_initialSkinName);
		L.RegVar("initialFlipX", get_initialFlipX, set_initialFlipX);
		L.RegVar("initialFlipY", get_initialFlipY, set_initialFlipY);
		L.RegVar("separatorSlots", get_separatorSlots, null);
		L.RegVar("zSpacing", get_zSpacing, set_zSpacing);
		L.RegVar("useClipping", get_useClipping, set_useClipping);
		L.RegVar("immutableTriangles", get_immutableTriangles, set_immutableTriangles);
		L.RegVar("pmaVertexColors", get_pmaVertexColors, set_pmaVertexColors);
		L.RegVar("clearStateOnDisable", get_clearStateOnDisable, set_clearStateOnDisable);
		L.RegVar("tintBlack", get_tintBlack, set_tintBlack);
		L.RegVar("singleSubmesh", get_singleSubmesh, set_singleSubmesh);
		L.RegVar("addNormals", get_addNormals, set_addNormals);
		L.RegVar("calculateTangents", get_calculateTangents, set_calculateTangents);
		L.RegVar("maskInteraction", get_maskInteraction, set_maskInteraction);
		L.RegVar("maskMaterials", get_maskMaterials, set_maskMaterials);
		L.RegVar("STENCIL_COMP_PARAM_ID", get_STENCIL_COMP_PARAM_ID, null);
		L.RegVar("STENCIL_COMP_MASKINTERACTION_NONE", get_STENCIL_COMP_MASKINTERACTION_NONE, null);
		L.RegVar("STENCIL_COMP_MASKINTERACTION_VISIBLE_INSIDE", get_STENCIL_COMP_MASKINTERACTION_VISIBLE_INSIDE, null);
		L.RegVar("STENCIL_COMP_MASKINTERACTION_VISIBLE_OUTSIDE", get_STENCIL_COMP_MASKINTERACTION_VISIBLE_OUTSIDE, null);
		L.RegVar("disableRenderingOnOverride", get_disableRenderingOnOverride, set_disableRenderingOnOverride);
		L.RegVar("valid", get_valid, set_valid);
		L.RegVar("skeleton", get_skeleton, set_skeleton);
		L.RegVar("CustomMaterialOverride", get_CustomMaterialOverride, null);
		L.RegVar("CustomSlotMaterials", get_CustomSlotMaterials, null);
		L.RegVar("Skeleton", get_Skeleton, null);
		L.RegVar("SkeletonDataAsset", get_SkeletonDataAsset, null);
		L.RegVar("GenerateMeshOverride", get_GenerateMeshOverride, set_GenerateMeshOverride);
		L.RegVar("OnPostProcessVertices", get_OnPostProcessVertices, set_OnPostProcessVertices);
		L.RegVar("OnRebuild", get_OnRebuild, set_OnRebuild);
		L.RegFunction("SkeletonRendererDelegate", Spine_Unity_SkeletonRenderer_SkeletonRendererDelegate);
		L.RegFunction("InstructionDelegate", Spine_Unity_SkeletonRenderer_InstructionDelegate);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetMeshSettings(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			Spine.Unity.MeshGenerator.Settings arg0 = StackTraits<Spine.Unity.MeshGenerator.Settings>.Check(L, 2);
			obj.SetMeshSettings(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Awake(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			obj.Awake();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearState(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			obj.ClearState();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EnsureMeshGeneratorCapacity(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.EnsureMeshGeneratorCapacity(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Initialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.Initialize(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LateUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			obj.LateUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FindAndApplySeparatorSlots(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<string>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				obj.FindAndApplySeparatorSlots(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes<System.Func<string,bool>>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				System.Func<string,bool> arg0 = (System.Func<string,bool>)ToLua.ToObject(L, 2);
				obj.FindAndApplySeparatorSlots(arg0);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<string, bool>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				obj.FindAndApplySeparatorSlots(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<System.Func<string,bool>, bool>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				System.Func<string,bool> arg0 = (System.Func<string,bool>)ToLua.ToObject(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				obj.FindAndApplySeparatorSlots(arg0, arg1);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<string, bool, bool>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				bool arg2 = LuaDLL.lua_toboolean(L, 4);
				obj.FindAndApplySeparatorSlots(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<System.Func<string,bool>, bool, bool>(L, 2))
			{
				Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
				System.Func<string,bool> arg0 = (System.Func<string,bool>)ToLua.ToObject(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				bool arg2 = LuaDLL.lua_toboolean(L, 4);
				obj.FindAndApplySeparatorSlots(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonRenderer.FindAndApplySeparatorSlots");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReapplySeparatorSlotNames(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject<Spine.Unity.SkeletonRenderer>(L, 1);
			obj.ReapplySeparatorSlotNames();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_skeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Unity.SkeletonDataAsset ret = obj.skeletonDataAsset;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialSkinName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			string ret = obj.initialSkinName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialSkinName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialFlipX(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.initialFlipX;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipX on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialFlipY(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.initialFlipY;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipY on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_separatorSlots(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			System.Collections.Generic.List<Spine.Slot> ret = obj.separatorSlots;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index separatorSlots on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_zSpacing(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			float ret = obj.zSpacing;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index zSpacing on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useClipping(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.useClipping;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index useClipping on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_immutableTriangles(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.immutableTriangles;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index immutableTriangles on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pmaVertexColors(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.pmaVertexColors;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pmaVertexColors on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_clearStateOnDisable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.clearStateOnDisable;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index clearStateOnDisable on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_tintBlack(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.tintBlack;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index tintBlack on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_singleSubmesh(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.singleSubmesh;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index singleSubmesh on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_addNormals(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.addNormals;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index addNormals on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_calculateTangents(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.calculateTangents;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index calculateTangents on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_maskInteraction(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			UnityEngine.SpriteMaskInteraction ret = obj.maskInteraction;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index maskInteraction on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_maskMaterials(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Unity.SkeletonRenderer.SpriteMaskInteractionMaterials ret = obj.maskMaterials;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index maskMaterials on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_STENCIL_COMP_PARAM_ID(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, Spine.Unity.SkeletonRenderer.STENCIL_COMP_PARAM_ID);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_STENCIL_COMP_MASKINTERACTION_NONE(IntPtr L)
	{
		try
		{
			ToLua.Push(L, Spine.Unity.SkeletonRenderer.STENCIL_COMP_MASKINTERACTION_NONE);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_STENCIL_COMP_MASKINTERACTION_VISIBLE_INSIDE(IntPtr L)
	{
		try
		{
			ToLua.Push(L, Spine.Unity.SkeletonRenderer.STENCIL_COMP_MASKINTERACTION_VISIBLE_INSIDE);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_STENCIL_COMP_MASKINTERACTION_VISIBLE_OUTSIDE(IntPtr L)
	{
		try
		{
			ToLua.Push(L, Spine.Unity.SkeletonRenderer.STENCIL_COMP_MASKINTERACTION_VISIBLE_OUTSIDE);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_disableRenderingOnOverride(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.disableRenderingOnOverride;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index disableRenderingOnOverride on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_valid(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool ret = obj.valid;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index valid on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_skeleton(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Skeleton ret = obj.skeleton;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeleton on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CustomMaterialOverride(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			System.Collections.Generic.Dictionary<UnityEngine.Material,UnityEngine.Material> ret = obj.CustomMaterialOverride;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CustomMaterialOverride on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CustomSlotMaterials(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			System.Collections.Generic.Dictionary<Spine.Slot,UnityEngine.Material> ret = obj.CustomSlotMaterials;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CustomSlotMaterials on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Skeleton(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Skeleton ret = obj.Skeleton;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Skeleton on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SkeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Unity.SkeletonDataAsset ret = obj.SkeletonDataAsset;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index SkeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GenerateMeshOverride(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonRenderer.GenerateMeshOverride"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnPostProcessVertices(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonRenderer.OnPostProcessVertices"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnRebuild(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonRenderer.OnRebuild"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_skeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Unity.SkeletonDataAsset arg0 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckObject<Spine.Unity.SkeletonDataAsset>(L, 2);
			obj.skeletonDataAsset = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialSkinName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.initialSkinName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialSkinName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialFlipX(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.initialFlipX = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipX on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialFlipY(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.initialFlipY = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipY on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_zSpacing(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.zSpacing = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index zSpacing on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useClipping(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.useClipping = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index useClipping on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_immutableTriangles(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.immutableTriangles = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index immutableTriangles on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_pmaVertexColors(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.pmaVertexColors = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pmaVertexColors on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_clearStateOnDisable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.clearStateOnDisable = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index clearStateOnDisable on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_tintBlack(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.tintBlack = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index tintBlack on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_singleSubmesh(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.singleSubmesh = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index singleSubmesh on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_addNormals(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.addNormals = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index addNormals on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_calculateTangents(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.calculateTangents = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index calculateTangents on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_maskInteraction(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			UnityEngine.SpriteMaskInteraction arg0 = (UnityEngine.SpriteMaskInteraction)ToLua.CheckObject(L, 2, typeof(UnityEngine.SpriteMaskInteraction));
			obj.maskInteraction = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index maskInteraction on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_maskMaterials(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Unity.SkeletonRenderer.SpriteMaskInteractionMaterials arg0 = (Spine.Unity.SkeletonRenderer.SpriteMaskInteractionMaterials)ToLua.CheckObject<Spine.Unity.SkeletonRenderer.SpriteMaskInteractionMaterials>(L, 2);
			obj.maskMaterials = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index maskMaterials on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_disableRenderingOnOverride(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.disableRenderingOnOverride = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index disableRenderingOnOverride on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_valid(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.valid = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index valid on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_skeleton(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)o;
			Spine.Skeleton arg0 = (Spine.Skeleton)ToLua.CheckObject<Spine.Skeleton>(L, 2);
			obj.skeleton = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeleton on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GenerateMeshOverride(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonRenderer));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonRenderer.GenerateMeshOverride' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonRenderer'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.SkeletonRenderer.InstructionDelegate ev = (Spine.Unity.SkeletonRenderer.InstructionDelegate)DelegateTraits<Spine.Unity.SkeletonRenderer.InstructionDelegate>.Create(arg0.func);
				obj.GenerateMeshOverride += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.SkeletonRenderer.InstructionDelegate ev = (Spine.Unity.SkeletonRenderer.InstructionDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonRenderer), "GenerateMeshOverride");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.SkeletonRenderer.InstructionDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.GenerateMeshOverride -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnPostProcessVertices(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonRenderer));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonRenderer.OnPostProcessVertices' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonRenderer'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.MeshGeneratorDelegate ev = (Spine.Unity.MeshGeneratorDelegate)DelegateTraits<Spine.Unity.MeshGeneratorDelegate>.Create(arg0.func);
				obj.OnPostProcessVertices += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.MeshGeneratorDelegate ev = (Spine.Unity.MeshGeneratorDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonRenderer), "OnPostProcessVertices");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.MeshGeneratorDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.OnPostProcessVertices -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnRebuild(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonRenderer obj = (Spine.Unity.SkeletonRenderer)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonRenderer));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonRenderer.OnRebuild' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonRenderer'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate ev = (Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate)DelegateTraits<Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate>.Create(arg0.func);
				obj.OnRebuild += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate ev = (Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonRenderer), "OnRebuild");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.OnRebuild -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Spine_Unity_SkeletonRenderer_SkeletonRendererDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Spine.Unity.SkeletonRenderer.SkeletonRendererDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Spine_Unity_SkeletonRenderer_InstructionDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Spine.Unity.SkeletonRenderer.InstructionDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Spine.Unity.SkeletonRenderer.InstructionDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

