using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class SuccessAction : BehaviorAction { 

		public override TaskStatus OnUpdate ()
		{ 
			Debug.Log ("SuccessAction");
			return TaskStatus.Success;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue (); 
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.RETURN_SUCCESS;
			}
		}
	}

}

