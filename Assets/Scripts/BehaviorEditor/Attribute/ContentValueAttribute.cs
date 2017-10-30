using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime.Tasks;
using BehaviorDesigner.Runtime.ObjectDrawers;

namespace BehaviorSystem
{
	public class ContentValueAttribute : ObjectDrawerAttribute
	{ 
		public string fieldName; 

		public ContentValueAttribute(string fieldName)
		{
			this.fieldName = fieldName; 
		}
	}
} 