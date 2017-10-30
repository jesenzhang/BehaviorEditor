using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace DebugSystem{
	public class GameDebugWatcherComponent : MonoBehaviour { 
		public LuaTable self = null;
		public string expr = null;		 
	}
}

