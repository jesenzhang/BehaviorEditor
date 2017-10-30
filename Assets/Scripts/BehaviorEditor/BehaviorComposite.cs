using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{
	
	public abstract class BehaviorComposite: Composite,BehaviorNode<Example.BehaviorComposite> {
		
		public abstract Example.BehaviorComposite.CompositeType CompositeType {
			get ;
		}

		public abstract bool Serialize (Example.BehaviorComposite output);

		public Example.BehaviorNode.NodeType NodeType {
			get{ 
				return Example.BehaviorNode.NodeType.COMPOSITE;
			}
		}
		public string NodeName {
			get{ 
				return FriendlyName;
			}
		}
	}
}