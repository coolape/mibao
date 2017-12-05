using UnityEngine;
using System.Collections;
using Coolape;

public class CLUIInputRoot : MonoBehaviour
{
	public string jsonKey = "";

	public CLUIInput[] inputs {
		get {
			return GetComponentsInChildren<CLUIInput>();
		}
	}

	public string checkValid()
	{
		string msg = "";
		int count = inputs == null ? 0 : inputs.Length;
		for (int i = 0; i < count; i++) {
			msg += inputs [i].checkValid();
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
	
	public Hashtable getValue()
	{
		return getValue(null);
	}

	public Hashtable getValue(Hashtable map)
	{
		Hashtable r = getValue(transform, map);
#if UNITY_EDITOR
		Debug.Log(Utl.MapToString(r));
#endif
		return r;
	}

	public Hashtable getValue(Transform tr, Hashtable map)
	{
		if (map == null) {
			map = new Hashtable();
		}
		
		CLUIInput cell = null;
		CLUIInputRoot root = null;
		int count = tr.childCount;
		for (int i = 0; i < count; i++) {
			cell = tr.GetChild(i).GetComponent<CLUIInput>();
			if (cell != null && !string.IsNullOrEmpty(cell.jsonKey)) {
				map [cell.jsonKey] = cell.value;
			}

			root = tr.GetChild(i).GetComponent<CLUIInputRoot>();
			if (root != null && !string.IsNullOrEmpty(root.jsonKey)) {
				map [root.jsonKey] = getValue(tr.GetChild(i), null);
			} else {
				map = getValue(tr.GetChild(i), map);
			}
		}
		return map;
	}

	public void setValue(Hashtable map)
	{
		setValue(transform, map);
	}

	public void setValue(Transform tr, Hashtable map)
	{
		if (map == null) {
			map = new Hashtable();
//			return;
		}
		
		CLUIInput cell = null;
		CLUIInputRoot root = null;
		int count = tr.childCount;
		Transform cellTr = null;
		for (int i = 0; i < count; i++) {
			cellTr = tr.GetChild(i);
			cell = cellTr.GetComponent<CLUIInput>();
			if (cell != null && !string.IsNullOrEmpty(cell.jsonKey)) {
				if (cell.valueIsNumber) {
					cell.value = MapEx.getInt(map, cell.jsonKey).ToString();
				} else {
					cell.value = MapEx.getString(map, cell.jsonKey);
				}
			}
			
			root = cellTr.GetComponent<CLUIInputRoot>();
			if (root != null) {
				if (!string.IsNullOrEmpty(root.jsonKey)) {
					setValue(root.transform, MapEx.getMap(map, root.jsonKey));
				} else {
					setValue(root.transform, map);
				}
			} else {
				if (cellTr.childCount > 0) {
					setValue(cellTr, map);
				}
			}
		}
	}
}
