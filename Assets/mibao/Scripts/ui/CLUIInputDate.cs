using UnityEngine;
using System.Collections;
using System;
using Coolape;

[RequireComponent (typeof(UIInput))]
public class CLUIInputDate : UIEventListener
{
	public bool isSetTime = false;
	UIInput _input;

	public UIInput input {
		get {
			if (_input == null) {
				_input = GetComponent<UIInput> ();
				if (_input != null) {
					_input.enabled = false;
				}
			}
			return _input;
		}
	}

	public void OnClick ()
	{
		if (input != null && !string.IsNullOrEmpty (input.value)) {
			DateTime d = DateTime.Parse (input.value);
//			DateTime d = DateTime.ParseExact(input.value, "yyyy-MM-dd", System.Globalization.CultureInfo.CurrentCulture);
			MyUtl.showCalender (d.Year, d.Month, (Callback)onGetDate, isSetTime);
		} else {
			MyUtl.showCalender ((Callback)onGetDate, isSetTime);
		}
	}

	public void onGetDate (params object[] paras)
	{
		input.value = paras [0].ToString ();
	}

}
