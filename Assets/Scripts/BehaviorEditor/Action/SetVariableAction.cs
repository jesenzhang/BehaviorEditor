using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	[TaskName("Set Variable")]
	public class SetVariableAction : BehaviorAction {

		public SharedVariable variable;

		[SerializeField]
		[ContentValueAttribute("variable")]
		public BehaviorValue value = new BehaviorValue();  

		public override TaskStatus OnUpdate ()
		{
			if (variable == null) {
				return TaskStatus.Failure;
			}

			variable.SetValue (ValueHelper.GetValue (value));

			return TaskStatus.Success;
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			var arg = new Example.BehaviorValue ();
			arg.StrValue = variable.Name;
			args.Add (arg);
			args.Add (ValueHelper.Serialize(value));
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.SET_VARIABLE;
			}
		}
	}

}

