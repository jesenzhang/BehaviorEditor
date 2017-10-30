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

	[CustomObjectDrawer(typeof(ContentValueAttribute))]
	public class ContentValueDrawer : ObjectDrawer {
		
		public override void OnGUI (GUIContent label)
		{ 
			var contentValueAttribute = (ContentValueAttribute)attribute;
			var contentValue = (BehaviorValue)value ;

			var fieldInfo = task.GetType ().GetField (contentValueAttribute.fieldName);
			var fieldValue = fieldInfo.GetValue (task);

			if (fieldValue != null) {
				if (fieldValue is SharedInt || fieldValue is int) {
					contentValue.IntValue = EditorGUILayout.IntField (label, contentValue.IntValue);
					contentValue.valueType = Example.BehaviorValue.ValueType.INTEGER;
				} else if (fieldValue is SharedFloat || fieldValue is float) {
					contentValue.FloatValue = EditorGUILayout.FloatField (label, contentValue.FloatValue);
					contentValue.valueType = Example.BehaviorValue.ValueType.FLOAT;
				} else if (fieldValue is SharedBool || fieldValue is bool) {
					contentValue.BoolValue = EditorGUILayout.Toggle (label, contentValue.BoolValue);
					contentValue.valueType = Example.BehaviorValue.ValueType.BOOLEAN;
				} else if (fieldValue is SharedString || fieldValue is string) {
					contentValue.StrValue = EditorGUILayout.TextField (label, contentValue.StrValue);
					contentValue.valueType = Example.BehaviorValue.ValueType.STRING;
				} else {
					EditorGUILayout.LabelField (string.Format ("typeof {0} not support", fieldValue.GetType ().Name));
				}
			} else {
				EditorGUILayout.LabelField (label,"dd");
			}
		}
	}
}


