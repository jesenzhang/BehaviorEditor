using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{

	public class Repeater : BehaviorDecorator {
		 
		public SharedInt count = 1; 
		public SharedBool repeatForever; 
		public SharedBool endOnFailure;

		// The number of times the child task has been run.
		private int executionCount = 0;
		// The status of the child after it has finished running.
		private TaskStatus executionStatus = TaskStatus.Inactive;

		public override bool CanExecute()
		{
			// Continue executing until we've reached the count or the child task returned failure and we should stop on a failure.
			return (repeatForever.Value || executionCount < count.Value) && (!endOnFailure.Value || (endOnFailure.Value && executionStatus != TaskStatus.Failure));
		}

		public override void OnChildExecuted(TaskStatus childStatus)
		{
			// The child task has finished execution. Increase the execution count and update the execution status.
			executionCount++;
			executionStatus = childStatus;
		}

		public override void OnEnd()
		{
			// Reset the variables back to their starting values.
			executionCount = 0;
			executionStatus = TaskStatus.Inactive;
		}

		public override void OnReset()
		{
			// Reset the public properties back to their original values.
			count = 0;
			endOnFailure = true;
		}

		protected override void  SerializeArgments(List<Example.BehaviorValue> args)
		{
			var arg1 = new Example.BehaviorValue ();
			var arg2 = new Example.BehaviorValue ();
			var arg3 = new Example.BehaviorValue ();

			arg1.IntValue = count.Value;
			arg2.BoolValue = repeatForever.Value;
			arg2.StrValue = repeatForever.Name;
			arg3.BoolValue = endOnFailure.Value;
			args.Add (arg1);
			args.Add (arg2);
			args.Add (arg3);
		}

		public override Example.BehaviorDecorator.DecoratorType DecoratorType {
			get {
				return  Example.BehaviorDecorator.DecoratorType.REPEATER;
			}
		}
	}

}

