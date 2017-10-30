using System.Collections;
using System.Collections.Generic;
using BehaviorDesigner.Runtime.Tasks;
using UnityEngine;

namespace BehaviorSystem{
	 
	[System.Serializable]
	public class BehaviorValue{
		public int IntValue;
		public float FloatValue;
		public bool BoolValue;
		public string StrValue;
		public Example.BehaviorValue.ValueType valueType; 
	}

	public class BehaviorSystem : MonoBehaviour {

		void Awake(){
			
		}
		 
	}
}
