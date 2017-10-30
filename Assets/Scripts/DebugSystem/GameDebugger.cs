using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DebugSystem{

	public class GameDebugger : MonoBehaviour { 

		// Update is called once per frame
		void LateUpdate () {

		}
		 
		public static void Log(string message){
			LuaInterface.Debugger.Log (message);
		}

		public static void LogError(string message){
			LuaInterface.Debugger.LogError (message);
		}
	}
}


