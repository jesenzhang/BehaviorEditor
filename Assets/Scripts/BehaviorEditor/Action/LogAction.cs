using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class LogAction : BehaviorAction {

		public SharedString message ;  

		public override TaskStatus OnUpdate ()
		{

			Debug.Log ("Log-> " + message.Value);

			return TaskStatus.Success;
		}

		public override void OnEnd ()
		{
			base.OnEnd ();
			Debug.Log ("OnEnd-> " + message);
		}

		public override void OnReset ()
		{
			base.OnReset ();
			Debug.Log ("OnReset-> " + message);
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue ();
			if (message.IsShared) {
				arg.StrValue = message.Name;
				arg.BoolValue = true;
			} else {
				arg.StrValue = message.Value;
				arg.BoolValue = false;
			}

			args.Add (arg);
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.LOG;
			}
		}
	}

}

