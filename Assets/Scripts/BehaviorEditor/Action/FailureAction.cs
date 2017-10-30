using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class FailureAction : BehaviorAction { 

		public override TaskStatus OnUpdate ()
		{ 
			Debug.Log ("FailureAction");
			return TaskStatus.Failure;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue (); 
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.RETURN_FAILURE;
			}
		}
	}

}

