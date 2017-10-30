using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{
	public class ValueHelper  {
		public static object GetValue(BehaviorValue input){
			object result = null;
			switch (input.valueType) {
			case Example.BehaviorValue.ValueType.INTEGER:
				result = input.IntValue;
				break;
			case Example.BehaviorValue.ValueType.FLOAT:
				result = input.FloatValue;
				break;
			case Example.BehaviorValue.ValueType.BOOLEAN:
				result = input.BoolValue;
				break;
			case Example.BehaviorValue.ValueType.STRING:
				result = input.StrValue;
				break;
			}
			 

			return result;
		}

		public static void SetValue(object input,ref BehaviorValue output){
			if (input is int) { 
				output.IntValue = (int)input;
				output.valueType = Example.BehaviorValue.ValueType.INTEGER;
			} else if (input is float) {
				output.FloatValue = (float)input;
				output.valueType = Example.BehaviorValue.ValueType.FLOAT;
			} else if (input is bool) {
				output.BoolValue = (bool)input;
				output.valueType = Example.BehaviorValue.ValueType.BOOLEAN;
			} else if (input is string) {
				output.StrValue = (string)input;
				output.valueType = Example.BehaviorValue.ValueType.STRING;
			}
		}

		public static Example.BehaviorValue Serialize(BehaviorValue input){
			Example.BehaviorValue result = new Example.BehaviorValue (); 
			result.valueType = input.valueType;
			switch (input.valueType) {
			case Example.BehaviorValue.ValueType.INTEGER:
				result.IntValue = input.IntValue;
				break;
			case Example.BehaviorValue.ValueType.FLOAT:
				result.FloatValue = input.FloatValue;
				break;
			case Example.BehaviorValue.ValueType.BOOLEAN:
				result.BoolValue = input.BoolValue;
				break;
			case Example.BehaviorValue.ValueType.STRING:
				result.StrValue = input.StrValue;
				break;
			}
			return result;
		}
	}
}
