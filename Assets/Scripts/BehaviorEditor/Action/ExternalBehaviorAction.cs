using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	[TaskName("Load Behavior")] 
	public class ExternalBehaviorAction : BehaviorAction {  

		public string behaviorName;

		public override TaskStatus OnUpdate ()
		{  
			if (string.IsNullOrEmpty(behaviorName)) {
				return TaskStatus.Failure;
			}
			return TaskStatus.Success;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue ();
			arg.StrValue = behaviorName;
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.EXTERNAL_TREE;
			}
		}
	}

}

