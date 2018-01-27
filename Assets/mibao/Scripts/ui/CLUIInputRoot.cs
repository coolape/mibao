using UnityEngine;
using System.Collections;
using Coolape;
using XLua;

public class CLUIInputRoot : MonoBehaviour
{
	public string jsonKey = "";

	public CLUIInput[] inputs {
		get {
			return GetComponentsInChildren<CLUIInput> ();
		}
	}

	public string checkValid ()
	{
		string msg = "";
		int count = inputs == null ? 0 : inputs.Length;
		for (int i = 0; i < count; i++) {
			msg += inputs [i].checkValid ();
		}
		return msg;
	}

	//	public Hashtable getValue(Hashtable map) {
	//		if(map == null) {
	//			map = new Hashtable();
	//		}
	//		CLUIInput cell = null;
	//		int count = inputs == null ? 0 : inputs.Length;
	//		for(int i=0; i < count; i++) {
	//			cell  = inputs[i];
	//			map[cell.jsonKey] = cell.value;
	//		}
	//		return map;
	//	}

	void setVal (object map, object key, object val)
	{
		if (map is LuaTable) {
			Debug.LogError (key + "====" + val);
//			((LuaTable)obj) [key] = val;
			((LuaTable)map) ["key"] = val;
		} else if (map is Hashtable) {
			((Hashtable)map) [key] = val;
		}
	}

	object getVal (object map, object key)
	{
		object ret = "";
		if (map is LuaTable) {
			ret = ((LuaTable)map) [key];
		} else if (map is Hashtable) {
			ret = ((Hashtable)map) [key];
		}
		return ret == null ? "" : ret;
	}

	public object getValue (bool isLuatable = false)
	{
		return getValue (null, isLuatable);
	}

	public object getValue (object map, bool isLuatable = false)
	{
		object r = getValue (transform, map, isLuatable);
#if UNITY_EDITOR
		if (r is Hashtable) {
			Debug.Log (Utl.MapToString (r as Hashtable));
		}
#endif
		return r;
	}

	public object getValue (Transform tr, object map, bool isLuaTable = false)
	{
		if (map == null) {
			if (isLuaTable) {
				map = CLBaseLua.mainLua.NewTable ();
				((LuaTable)map) ["key"] = 123;
			} else {
				map = new Hashtable ();
			}
		}
		CLUIInput cell = null;
		CLUIInputRoot root = null;
		int count = tr.childCount;
		for (int i = 0; i < count; i++) {
			cell = tr.GetChild (i).GetComponent<CLUIInput> ();
			if (cell != null && !string.IsNullOrEmpty (cell.jsonKey)) {
//				map [cell.jsonKey] = cell.value;
				setVal (map, cell.jsonKey, cell.value);
			}

			root = tr.GetChild (i).GetComponent<CLUIInputRoot> ();
			if (root != null && !string.IsNullOrEmpty (root.jsonKey)) {
//				map [root.jsonKey] = getValue(tr.GetChild(i), null);
				setVal (map, root.jsonKey, getValue (tr.GetChild (i), null, isLuaTable));
			} else {
				map = getValue (tr.GetChild (i), map, isLuaTable);
			}
		}
		return map;
	}

	public void setValue (object map)
	{
		if (map is LuaTable) {
			setValue (transform, map, true);
		} else {
			setValue (transform, map);
		}
	}

	public void setValue (Transform tr, object map, bool isLuatable = false)
	{
		if (map == null) {
			map = new Hashtable ();
		}
		
		CLUIInput cell = null;
		CLUIInputRoot root = null;
		int count = tr.childCount;
		Transform cellTr = null;
		for (int i = 0; i < count; i++) {
			cellTr = tr.GetChild (i);
			cell = cellTr.GetComponent<CLUIInput> ();
			if (cell != null && !string.IsNullOrEmpty (cell.jsonKey)) {
				if (cell.valueIsNumber) {
					cell.value = getVal (map, cell.jsonKey).ToString ();
//					cell.value = MapEx.getInt(map, cell.jsonKey).ToString();
				} else {
					cell.value = getVal (map, cell.jsonKey).ToString ();
				}
			}
			
			root = cellTr.GetComponent<CLUIInputRoot> ();
			if (root != null) {
				if (!string.IsNullOrEmpty (root.jsonKey)) {
					setValue (root.transform, getVal (map, root.jsonKey), isLuatable);
				} else {
					setValue (root.transform, map, isLuatable);
				}
			} else {
				if (cellTr.childCount > 0) {
					setValue (cellTr, map, isLuatable);
				}
			}
		}
	}
}
