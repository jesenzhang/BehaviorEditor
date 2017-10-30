using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	[TaskName("Random Success")]
	public class RandomSuccessAction : BehaviorAction { 

		public int percent = 50;

		public override TaskStatus OnUpdate ()
		{ 
			if (Random.Range (1, 100) <= percent) {
				return TaskStatus.Success;
			}
			return TaskStatus.Failure;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue (); 
			arg.IntValue = percent; 
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.RANDOM_SUCCESS;
			}
		}
	}

}

