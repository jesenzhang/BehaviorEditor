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

	[CustomObjectDrawer(typeof(ExternalBehaviorAttribute))]
	public class ExternalBehaviorDrawer : ObjectDrawer {
		
		public override void OnGUI (GUIContent label)
		{ 
			var externalBehavior =  value as ExternalBehavior ;

			if (externalBehavior!=null) {
				EditorGUILayout.TextField ("hello");
			} else {
				EditorGUILayout.LabelField ("empty");
			}
		}
	}
}


