using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;


namespace BehaviorSystem{

	 
	public abstract class BehaviorConditional : Conditional,BehaviorNode<Example.BehaviorConditional>  { 
		
		public abstract bool Serialize (Example.BehaviorConditional output); 

		public Example.BehaviorNode.NodeType NodeType {
			get{ 
				return Example.BehaviorNode.NodeType.CONDITIONAL;
			}
		}
		public string NodeName {
			get{ 
				return FriendlyName;
			}
		}
	}
}
