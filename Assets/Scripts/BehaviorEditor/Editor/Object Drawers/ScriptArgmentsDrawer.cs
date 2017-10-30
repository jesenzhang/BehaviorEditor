using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using BehaviorDesigner.Editor;
using System;
using System.Reflection;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem.Editor{

	[CustomObjectDrawer(typeof(ScriptArgmentAttribute))]
	public class ScriptArgmentsDrawer : ObjectDrawer {
		 
		
		public override void OnGUI (GUIContent label)
		{  
			var arguments = (List<BehaviorValue>)value ;  

			EditorGUILayout.BeginVertical ();  

			int count = Mathf.Clamp(EditorGUILayout.IntField ("Arguments Count",arguments.Count),0,10); 

			if (arguments.Count > count) {
				arguments.RemoveRange (count, arguments.Count - count);
			}

			BehaviorValue contentValue = null;
			for(int i = 0;i< count ;++i){
				if (i >= arguments.Count) {
					contentValue = new BehaviorValue ();
					arguments.Add (contentValue);
				} else {
					contentValue =  arguments [i]; 
				} 
				var argName = "arg" + i;

				EditorGUILayout.BeginHorizontal ();

				contentValue.valueType = (Example.BehaviorValue.ValueType)EditorGUILayout.EnumPopup (argName, contentValue.valueType);

				switch (contentValue.valueType) {
				case Example.BehaviorValue.ValueType.INTEGER:
					contentValue.IntValue = EditorGUILayout.IntField (contentValue.IntValue);
					break;
				case Example.BehaviorValue.ValueType.FLOAT:
					contentValue.FloatValue = EditorGUILayout.FloatField (contentValue.FloatValue);
					break;
				case Example.BehaviorValue.ValueType.BOOLEAN:
					contentValue.BoolValue = EditorGUILayout.Toggle (contentValue.BoolValue);
					break;
				case Example.BehaviorValue.ValueType.STRING:
					contentValue.StrValue = EditorGUILayout.TextField (contentValue.StrValue);
					break;
				} 

				EditorGUILayout.EndHorizontal ();
			} 

			EditorGUILayout.EndVertical (); 

		}
	}
}


