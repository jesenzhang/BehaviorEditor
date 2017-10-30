using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class UtilSuccess : BehaviorDecorator { 

		// The status of the child after it has finished running.
		private TaskStatus executionStatus = TaskStatus.Inactive;

		public override bool CanExecute()
		{
			// Continue executing until the child task returns success or failure.
			return executionStatus != TaskStatus.Success;
		}

		public override void OnChildExecuted(TaskStatus childStatus)
		{
			// Update the execution status after a child has finished running.
			executionStatus = childStatus;
		}

		public override TaskStatus Decorate(TaskStatus status)
		{
			// Return success even if the child task returned failure.
			if (status == TaskStatus.Failure) {
				return TaskStatus.Success;
			}
			return status;
		}

		public override void OnEnd()
		{
			// Reset the execution status back to its starting values.
			executionStatus = TaskStatus.Inactive;
		}

		public override TaskStatus OverrideStatus(TaskStatus status)
		{
			return CanExecute () ? TaskStatus.Running : TaskStatus.Success;
		}

		protected override void  SerializeArgments(List<Example.BehaviorValue> args)
		{
			
		}

		public override Example.BehaviorDecorator.DecoratorType DecoratorType {
			get {
				return  Example.BehaviorDecorator.DecoratorType.UNTIL_SUCCESS;
			}
		}
	}

}

