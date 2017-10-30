using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class Reverter : BehaviorDecorator { 

		// The status of the child after it has finished running.
		private TaskStatus executionStatus = TaskStatus.Inactive;

		public override bool CanExecute()
		{
			// Continue executing until the child task returns success or failure.
			return executionStatus != TaskStatus.Failure;
		}

		public override void OnChildExecuted(TaskStatus childStatus)
		{
			// Update the execution status after a child has finished running.
			executionStatus = childStatus;
		}
		 

		public override void OnEnd()
		{
			// Reset the execution status back to its starting values.
			executionStatus = TaskStatus.Inactive;
		}

		public override TaskStatus OverrideStatus(TaskStatus status)
		{
			return status == TaskStatus.Running ? TaskStatus.Running : (status == TaskStatus.Success ? TaskStatus.Failure : TaskStatus.Success);
		}

		protected override void  SerializeArgments(List<Example.BehaviorValue> args)
		{

		}

		public override Example.BehaviorDecorator.DecoratorType DecoratorType {
			get {
				return  Example.BehaviorDecorator.DecoratorType.REVERTER;
			}
		}
	}

}

