using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace DebugSystem{
	 
	public class DebugGameObjectComponent : MonoBehaviour {

		public enum IconLayout
		{
			NONE = 0,
			RIGHT = 1,
			FILL = 2,
		}

		public string icon = null;

		public IconLayout iconLayout = IconLayout.RIGHT; 

		public LuaTable self = null;


		// Use this for initialization
		void Start () { 
		}

		// Update is called once per frame
		void Update () {

		}
	}
}


