using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Framework;

namespace DebugSystem{
	[CustomEditor(typeof(GameDebugWatcherComponent))]
	public class GameDebugWatcherInspector : Editor {
		
		public override void OnInspectorGUI ()
		{
			var component = target as GameDebugWatcherComponent;
			 
			base.OnInspectorGUI ();

			if (EditorApplication.isPlaying) {
				var expr = component.expr;
				if (!string.IsNullOrEmpty (expr)) {					
					object value = null;
					if (expr.StartsWith("self")) { 
						if (component.self != null && expr.Length>=5) {
							string fieldName =  expr.Substring (5);
							if (expr.StartsWith ("self:")) {
								value = GameScriptManager.instance.ExecuteTableMethod (component.self,fieldName);  
							} else{
								value = GameScriptManager.instance.GetTableField (component.self,fieldName);  
							}
							EditorGUILayout.HelpBox (value!=null?value.ToString():"nil", MessageType.Info);
						}
					} else {
						value = GameScriptManager.instance.ExecuteString ("return " + expr);  
						EditorGUILayout.HelpBox (value!=null?value.ToString():"nil", MessageType.Info);
					}
				}
				//EditorGUILayout.MaskField (0, new string[]{ "hello"});
			}

		}
	}

}

