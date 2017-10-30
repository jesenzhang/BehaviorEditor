using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;
using System; 

namespace BehaviorSystem{

	public abstract class SharedVariableCompare : BehaviorConditional {  
		public SharedVariable sharedValue;	 
		 
		[ContentValueAttribute("sharedValue")]
		public BehaviorValue compareValue = new BehaviorValue(); 

		public override TaskStatus OnUpdate()
		{
			if (sharedValue == null)
				return TaskStatus.Inactive;

			var value = sharedValue.GetValue (); 
			if (value is int) {
				return CheckCondition ((int)value, compareValue.IntValue) ? TaskStatus.Success : TaskStatus.Failure;
			} else if (value is float) {
				return CheckCondition ((float)value, compareValue.FloatValue) ? TaskStatus.Success : TaskStatus.Failure;
			} else if (value is bool) {
				return CheckCondition ((bool)value)? TaskStatus.Success : TaskStatus.Failure;
			}  else if (value is string) {
				return CheckCondition ((string)value,compareValue.StrValue) ? TaskStatus.Success : TaskStatus.Failure;
			} else {
				Debug.LogErrorFormat ("comparetype {0} not support", sharedValue);
			}

			return TaskStatus.Inactive;

		}

		public override void OnReset()
		{  
			sharedValue = null; 
		}
		 

		public override bool Serialize (Example.BehaviorConditional output)
		{
			output.Compare = CompareType;  
			output.Value = ValueHelper.Serialize(compareValue); 
			output.Name = sharedValue.Name;
			return true;
		} 
 

		protected abstract  Example.BehaviorConditional.CompareType CompareType {
			get;
		}
		 

		protected virtual bool CheckCondition (int self,int other){
			throw new NotImplementedException ();
		}

		protected virtual bool CheckCondition (float self,float other){
			throw new NotImplementedException ();
		}

		protected virtual bool CheckCondition (bool self){
			throw new NotImplementedException ();
		} 

		protected virtual bool CheckCondition (string self,string other){
			throw new NotImplementedException ();
		}
	}

}

