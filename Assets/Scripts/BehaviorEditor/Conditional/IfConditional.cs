using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class IFConditional : SharedVariableCompare {  
		protected override bool CheckCondition (bool self){
			return self;
		}	

		protected override Example.BehaviorConditional.CompareType CompareType {
			get {
				return  Example.BehaviorConditional.CompareType.IF;
			}
		}
	}
}
