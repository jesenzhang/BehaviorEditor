using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

namespace BehaviorSystem{ 
	public class Parallel : BehaviorComposite { 


		// The index of the child that is currently running or is about to run.
		private int currentChildIndex;
		// The task status of every child task.
		private TaskStatus[] executionStatus;

		public override void OnAwake()
		{
			// Create a new task status array that will hold the execution status of all of the children tasks.
			executionStatus = new TaskStatus[children.Count];
		}

		public override void OnChildStarted(int childIndex)
		{
			// One of the children has started to run. Increment the child index and set the current task status of that child to running.
			currentChildIndex++;
			executionStatus[childIndex] = TaskStatus.Running;
		}

		public override bool CanRunParallelChildren()
		{
			// This task can run parallel children.
			return true;
		}

		public override int CurrentChildIndex()
		{
			return currentChildIndex;
		}

		public override bool CanExecute()
		{
			// We can continue executing if we have more children that haven't been started yet.
			return currentChildIndex < children.Count;
		}

		public override void OnChildExecuted(int childIndex, TaskStatus childStatus)
		{
			// One of the children has finished running. Set the task status.
			executionStatus[childIndex] = childStatus;
		}

		public override TaskStatus OverrideStatus(TaskStatus status)
		{
			// Assume all of the children have finished executing. Loop through the execution status of every child and check to see if any tasks are currently running
			// or failed. If a task is still running then all of the children are not done executing and the parallel task should continue to return a task status of running.
			// If a task failed then return failure. The Behavior Manager will stop all of the children tasks. If no child task is running or has failed then the parallel
			// task succeeded and it will return success.
			bool childrenComplete = true;
			for (int i = 0; i < executionStatus.Length; ++i) {
				if (executionStatus[i] == TaskStatus.Running) {
					childrenComplete = false;
				} else if (executionStatus[i] == TaskStatus.Failure) {
					return TaskStatus.Failure;
				}
			}
			return (childrenComplete ? TaskStatus.Success : TaskStatus.Running);
		}

		public override void OnConditionalAbort(int childIndex)
		{
			// Start from the beginning on an abort
			currentChildIndex = 0;
			for (int i = 0; i < executionStatus.Length; ++i) {
				executionStatus[i] = TaskStatus.Inactive;
			}
		}

		public override void OnEnd()
		{
			// Reset the execution status and the child index back to their starting values.
			for (int i = 0; i < executionStatus.Length; ++i) {
				executionStatus[i] = TaskStatus.Inactive;
			}
			currentChildIndex = 0;
		}

		public override bool Serialize (Example.BehaviorComposite output)
		{ 
			return true;
		}

		public override Example.BehaviorComposite.CompositeType CompositeType {
			get {
				return  Example.BehaviorComposite.CompositeType.PARALLEL;
			}
		}

		public override TaskStatus OnUpdate ()
		{
			return base.OnUpdate ();
		}

		public override void OnReset ()
		{
			base.OnReset ();
		}
	}

}

