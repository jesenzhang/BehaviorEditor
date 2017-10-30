using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	[TaskName("Load Behavior")] 
	public class ExternalBehaviorAction : BehaviorAction {  

		[ExternalBehaviorAttribute()] 
		public ExternalBehavior externalBehavior;

		private Behavior runningBehavior;

		public override TaskStatus OnUpdate ()
		{  
			if (runningBehavior == null) {
				return TaskStatus.Failure;
			}
			return runningBehavior.ExecutionStatus; 
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue ();
			arg.StrValue = externalBehavior.name;
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.EXTERNAL_TREE;
			}
		}
	}

}

