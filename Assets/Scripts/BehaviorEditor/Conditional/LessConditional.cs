using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;
using System;

namespace BehaviorSystem{

	public class LessConditional : SharedVariableCompare {  

		protected override bool CheckCondition (int self,int other){
			return self < other;
		}

		protected override bool CheckCondition (float self,float other){
			return self < other;
		}	

		protected override Example.BehaviorConditional.CompareType CompareType {
			get {
				return  Example.BehaviorConditional.CompareType.LESS;
			}
		}


	}
}
