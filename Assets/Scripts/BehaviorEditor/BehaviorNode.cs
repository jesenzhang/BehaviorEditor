using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BehaviorSystem{
	public interface BehaviorNode<T>  {
		Example.BehaviorNode.NodeType NodeType {
			get ;
		}
		string NodeName {
			get ;
		}
		bool Serialize (T output);			
	}
}

