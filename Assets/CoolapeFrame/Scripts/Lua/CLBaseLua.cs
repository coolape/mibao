﻿/*
******************************************************************************** 
  *Copyright(C),coolae.net 
  *Author:  chenbin
  *Version:  2.0 
  *Date:  2017-01-09
  *Description:  把mobobehaviour的处理都转到lua层
  *Others:  
  *History:
*********************************************************************************
*/ 

using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using XLua;

namespace Coolape
{
	public class CLBaseLua : MonoBehaviour
	{
		public bool isPause = false;
		public string luaPath;

		protected static LuaEnv _mainLua = null;
		// 防止报错
		public static LuaEnv mainLua
		{
			get
			{
				if (_mainLua == null)
					_mainLua = new LuaEnv ();
				return _mainLua;
			}
		}

		public void resetMainLua()
		{
			_mainLua = new LuaEnv ();
		}

		public LuaEnv lua;

		public virtual void setLua ()
		{
			if (luaTable != null)
				return;
			doSetLua (false);
		}

		LuaTable _luaTable;

		public LuaTable luaTable {
			get {
				if (_luaTable == null) {
				}
				return _luaTable;
			}
			set {
				_luaTable = value;
			}
		}

		public object[] doSetLua (bool Independent)
		{
			object[] ret = null;
			try {
				destoryLua();
				if (Independent) {
					lua = new LuaEnv ();
				} else {
					lua = mainLua;
				}
				CLUtlLua.addLuaLoader (lua);
				if (!string.IsNullOrEmpty (luaPath)) {
					ret = CLUtlLua.doLua (lua, luaPath);
					if (ret != null && ret.Length > 0) {
						luaTable = (LuaTable)(ret [0]);
					} else {
						Debug.LogError("SetLua no luatable returned !! ==" + luaPath);
					}
				}
			} catch (System.Exception e) {
				Debug.LogError (e);
			}
			return ret;
		}

		Transform _tr;
		//缓存transform
		public Transform transform {
			get {
				if (_tr == null) {
					_tr = gameObject.transform;
				}
				return _tr;
			}
		}

		public void onNotifyLua (GameObject go, string funcName, object paras)
		{
			LuaFunction lfunc = null;
			if (!string.IsNullOrEmpty (funcName)) {
				lfunc = getLuaFunction (funcName);
			} else {
				lfunc = getLuaFunction ("onNotifyLua");
			}
			if (lfunc != null) {
				lfunc.Call (go, paras);
			}
		}

		public Dictionary<string, LuaFunction> luaFuncMap = new Dictionary<string, LuaFunction> ();

		public virtual LuaFunction getLuaFunction (string funcName)
		{
			if (string.IsNullOrEmpty (funcName))
				return null;
			LuaFunction ret = null;
			if (luaFuncMap.ContainsKey (funcName)) {
				ret = luaFuncMap [funcName]; 
			}
			if (ret == null && luaTable != null) {
				ret = (LuaFunction)(luaTable [funcName]);
				if (ret != null) {
					luaFuncMap [funcName] = ret;
				}
			}
			return ret;
		}

		public object getLuaVar (string name)
		{
			if (luaTable == null)
				return null;
			return  luaTable [name];
		}

		/// <summary>
		/// Invoke4s the lua.回调lua函数， 等待时间
		/// </summary>
		/// <param name='callbakFunc'>
		/// Callbak func.
		/// </param>
		/// <param name='sec'>
		/// Sec.
		/// </param>
		Hashtable coroutineMap = Hashtable.Synchronized (new Hashtable ());
		Hashtable coroutineIndex = Hashtable.Synchronized (new Hashtable ());

		public UnityEngine.Coroutine invoke4Lua (object callbakFunc, float sec)
		{
			return invoke4Lua (callbakFunc, "", sec);
		}

		public UnityEngine.Coroutine invoke4Lua (object callbakFunc, object orgs, float sec)
		{
			return invoke4Lua (callbakFunc, orgs, sec, false);
		}

		/// <summary>
		/// Invoke4s the lua.
		/// </summary>
		/// <param name="callbakFunc">Callbak func.lua函数</param>
		/// <param name="orgs">Orgs.参数</param>
		/// <param name="sec">Sec.等待时间</param>
		public UnityEngine.Coroutine invoke4Lua (object callbakFunc, object orgs, float sec, bool onlyOneCoroutine)
		{
			if (!gameObject.activeInHierarchy)
				return null;
			if (callbakFunc == null) {
				Debug.LogError ("callbakFunc is null ......");
				return null;
			}
			try {
				UnityEngine.Coroutine ct = null;
				if (onlyOneCoroutine) {
					cleanCoroutines (callbakFunc);
				}
				int index = getCoroutineIndex (callbakFunc);
				ct = StartCoroutine (doInvoke4Lua (callbakFunc, sec, orgs, index));
				setCoroutine (callbakFunc, ct, index);
				return ct;
			} catch (System.Exception e) {
				Debug.LogError (callbakFunc + ":" + e);
				return null;
			}
		}

		public int getCoroutineIndex (object callbakFunc)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineIndex);
			int ret = MapEx.getInt (coroutineIndex, key);
			coroutineIndex [key] = ret + 1;
			return ret;
		}

		public void setCoroutineIndex (object callbakFunc, int val)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineIndex);
			coroutineIndex [key] = val;
		}

		/// <summary>
		/// Gets the key4 invoke map.当直接传luafunction时，不能直接用，用Equals查找一下key
		/// </summary>
		/// <returns>The key4 invoke map.</returns>
		/// <param name="callbakFunc">Callbak func.</param>
		/// <param name="map">Map.</param>
		public object getKey4InvokeMap (object callbakFunc, Hashtable map)
		{
			if (callbakFunc == null || map == null)
				return callbakFunc;
			object key = callbakFunc;
			if (callbakFunc is LuaFunction) {
				NewList keys = ObjPool.listPool.borrowObject ();
				keys.AddRange (map.Keys);
				for (int i = 0; i < keys.Count; i++) {
					if (((LuaFunction)callbakFunc).Equals ((keys [i]))) {
						key = keys [i];
						break;
					}
				}
				ObjPool.listPool.returnObject (keys);
				keys = null;
			}
			return key;
		}

		public Hashtable getCoroutines (object callbakFunc)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineMap);
			if (coroutineMap [key] == null) {
				coroutineMap [key] = new Hashtable ();
			}
			return (Hashtable)(coroutineMap [key]);
		}

		public void setCoroutine (object callbakFunc, UnityEngine.Coroutine ct, int index)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineMap);
			Hashtable map = getCoroutines (callbakFunc);
			map [index] = ct;
			coroutineMap [key] = map;
		}

		public void cleanCoroutines (object callbakFunc)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineMap);
			Hashtable list = getCoroutines (callbakFunc);
			foreach (DictionaryEntry cell in list) {
				StopCoroutine ((UnityEngine.Coroutine)(cell.Value));
			}
			list.Clear ();
			setCoroutineIndex (callbakFunc, 0);
			coroutineMap.Remove (key);
		}

		public void rmCoroutine (object callbakFunc, int index)
		{
			object key = getKey4InvokeMap (callbakFunc, coroutineMap);
			Hashtable list = getCoroutines (callbakFunc);
			list.Remove (index);
			coroutineMap [key] = list;
		}

		public void cancelInvoke4Lua ()
		{
			cancelInvoke4Lua (null);
		}

		public void cancelInvoke4Lua (object callbakFunc)
		{
			if (callbakFunc == null) {
				#if UNITY_4_6 || UNITY_5
				Hashtable list = null;

				foreach (DictionaryEntry item in coroutineMap) {
					list = getCoroutines ((LuaFunction)(item.Key));
					foreach (DictionaryEntry cell in list) {
						StopCoroutine ((UnityEngine.Coroutine)(cell.Value));
					}
					list.Clear ();
				}
				#endif
				if (_luaTable != null) {
					StopCoroutine ("doInvoke4Lua");
				}
				coroutineMap.Clear ();
				coroutineIndex.Clear ();
			} else {
				cleanCoroutines (callbakFunc);
			}
		}

		Queue invokeFuncs = new Queue ();

		IEnumerator doInvoke4Lua (object callbakFunc, float sec, object orgs, int index)
		{
			yield return new WaitForSeconds (sec);
			try {
				rmCoroutine (callbakFunc, index);
				LuaFunction func = null;
				if (callbakFunc is string) {
					func = getLuaFunction (callbakFunc.ToString ());
				} else {
					func = (LuaFunction)callbakFunc;
				}
				if (func != null) {
					if (!isPause) {
						func.Call (orgs);
					} else {
						ArrayList list = new ArrayList ();
						list.Add (func);
						list.Add (orgs);
						list.Add (index);
						invokeFuncs.Enqueue (list);
					}
				}
			} catch (System.Exception e) {
				string msg = "call err:doInvoke4Lua" + ",callbakFunc=[" + callbakFunc + "]";
//				CLAlert.add (msg, Color.red, -1);
				Debug.LogError (msg);
				Debug.LogError (e);
			}
		}

		public virtual void pause ()
		{
			isPause = true;
		}

		public virtual void regain ()
		{
			isPause = false;
			LuaFunction f = null;
			ArrayList invokeList = null;
			try {
				while (invokeFuncs.Count > 0) {
					invokeList = (ArrayList)(invokeFuncs.Dequeue ());
					f = (LuaFunction)(invokeList [0]);
					if (f != null) {
						f.Call (invokeList [1]);
					}
					invokeList.Clear ();
					invokeList = null;
				}
			} catch (System.Exception e) {
				Debug.LogError (f != null ? f.ToString() : "" + "==" + e);
			}
		}

		public virtual void OnDestroy ()
		{
			destoryLua ();
		}

		public void destoryLua ()
		{
			foreach (var cell in luaFuncMap) {
				if (cell.Value != null) {
					cell.Value.Dispose ();
				}
			}
			luaFuncMap.Clear ();
			if (_luaTable != null) {
				_luaTable.Dispose ();
				_luaTable = null;
			}
		}
	}
}
