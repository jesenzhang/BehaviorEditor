using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class WaitAction : BehaviorAction {

		public int time ;  		 

		private float startTimer = 0;

		public override void OnStart ()
		{
			startTimer = 0;
		}
		 

		public override void OnReset ()
		{
			startTimer = 0;
		}

		public override TaskStatus OnUpdate ()
		{
			startTimer += Time.deltaTime;

			if (startTimer * 1000 < time) {
				return TaskStatus.Running;
			}
			
			return TaskStatus.Success;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue ();
			arg.IntValue = time;
			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.WAIT;
			}
		}
	}

}

