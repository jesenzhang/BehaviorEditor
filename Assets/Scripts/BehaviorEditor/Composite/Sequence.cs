using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class Sequence : BehaviorComposite { 

		// The index of the child that is currently running or is about to run.
		private int currentChildIndex = 0;
		// The task status of the last child ran.
		private TaskStatus executionStatus = TaskStatus.Inactive;

		public override int CurrentChildIndex()
		{
			return currentChildIndex;
		}

		public override bool CanExecute()
		{
			// We can continue to execuate as long as we have children that haven't been executed and no child has returned failure.
			return currentChildIndex < children.Count && executionStatus != TaskStatus.Failure;
		}

		public override void OnChildExecuted(TaskStatus childStatus)
		{
			// Increase the child index and update the execution status after a child has finished running.
			currentChildIndex++;
			executionStatus = childStatus;
		}

		public override void OnConditionalAbort(int childIndex)
		{
			// Set the current child index to the index that caused the abort
			currentChildIndex = childIndex;
			executionStatus = TaskStatus.Inactive;
		}

		public override void OnEnd()
		{
			// All of the children have run. Reset the variables back to their starting values.
			executionStatus = TaskStatus.Inactive;
			currentChildIndex = 0;
		}


		public override bool Serialize (Example.BehaviorComposite output)
		{ 
			return true;
		}

		public override Example.BehaviorComposite.CompositeType CompositeType {
			get {
				return  Example.BehaviorComposite.CompositeType.SEQUENCE;
			}
		}


	}

}

