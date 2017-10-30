using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;
 

namespace BehaviorSystem{
	
	public abstract class BehaviorAction : Action,BehaviorNode<Example.BehaviorAction>  { 

		public abstract Example.BehaviorAction.ActionType ActionType {
			get ;
		}

		public virtual bool Serialize (Example.BehaviorAction output)
		{
			var args = new List<Example.BehaviorValue> ();
			SerializeArgments (args); 
			output.Args = args;
			return true;
		}

		protected virtual void SerializeArgments(List<Example.BehaviorValue> args){
		}

		public Example.BehaviorNode.NodeType NodeType {
			get{ 
				return Example.BehaviorNode.NodeType.ACTION;
			}
		}
		public string NodeName {
			get{ 
				return FriendlyName;
			}
		}
	}

}

