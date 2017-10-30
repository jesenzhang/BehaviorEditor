using System.Collections;
using System.Collections.Generic;
using BehaviorDesigner.Runtime.Tasks;


namespace BehaviorSystem{

	public abstract class BehaviorDecorator : Decorator,BehaviorNode<Example.BehaviorDecorator> {
		public abstract Example.BehaviorDecorator.DecoratorType DecoratorType {
			get ;
		}


		public virtual bool Serialize (Example.BehaviorDecorator output)
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
				return Example.BehaviorNode.NodeType.DECORATOR;
			}
		}
		public string NodeName {
			get{ 
				return FriendlyName;
			}
		}
	}

	
}
