using UnityEngine;
using System.Collections;
using Coolape;

public class MyMain : CLMainBase
{
	[Tooltip("状态栏是否显示状态及通知")]
	public bool statusBar = false;
	[Tooltip("状态栏样式")]
	public AndroidStatusBar.States statesBar = AndroidStatusBar.States.Visible;
	public override void init ()
	{
		base.init ();

		if (Application.platform == RuntimePlatform.Android) {
			AndroidStatusBar.statusBarState = statesBar;
			AndroidStatusBar.dimmed = !statusBar;
		}
	}

	public override void doOffline ()
	{
		base.doOffline ();
	}
}
