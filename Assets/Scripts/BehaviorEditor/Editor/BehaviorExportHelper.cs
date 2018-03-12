using System.Collections;
using System.Collections.Generic;
using UnityEngine;  
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks; 
using System.IO;

public class BehaviorExportHelper {

	public static void ExportBehaviorTree(BehaviorTree tree){
		var exportDir = "Export/BehaviorTree";
		if (!Directory.Exists (exportDir)) {
			Directory.CreateDirectory (exportDir);
		}
		ExportBehaviorTree (tree, exportDir + "/BehaviorTree_" + tree.BehaviorName + ".bytes");
	}	 

	public static void ExportBehaviorTree(BehaviorTree tree,string path){
		

		var variables = new List<Example.BehaviorVariable> ();

		var nodes = new List<Example.BehaviorNode> ();
		var composites = new List<Example.BehaviorComposite> ();
		var decorators = new List<Example.BehaviorDecorator> ();
		var actions = new List<Example.BehaviorAction> ();
		var conditionals = new List<Example.BehaviorConditional> ();

		Debug.LogFormat ("export {0} to {1}", tree, path);

		var treeVars = tree.GetAllVariables();
		if(treeVars!=null){
			foreach (var variable in treeVars) {			
				var v = ExportSharedVariable (variable);
				variables.Add (v);
			}
		}


		var root = tree.GetBehaviorSource().RootTask;
		List<Task> tasks = new List<Task> ();
		tasks.Add (root);		 
		ExportBehaviorTasks (tasks,nodes,composites,decorators,actions,conditionals);

		var behaviorTree = new Example.BehaviorTree ();
		behaviorTree.Id = tree.GetInstanceID ();
		behaviorTree.Name = tree.BehaviorName;
		behaviorTree.Group = tree.Group;
		behaviorTree.Variables = variables;
		behaviorTree.Nodes = nodes;
		behaviorTree.Actions = actions;
		behaviorTree.Composites = composites;
		behaviorTree.Decorators = decorators;
		behaviorTree.Conditionals = conditionals;

	

		var data = Example.BehaviorTree.SerializeToBytes (behaviorTree);
		File.WriteAllBytes (path,data);

		Debug.LogFormat ("Export {0} to {1} nodes:{2}", tree.BehaviorName,path,nodes.Count);	
	}	


	private static List<int> ExportBehaviorTasks(List<Task> tasks,List<Example.BehaviorNode> nodes,List<Example.BehaviorComposite> composites,List<Example.BehaviorDecorator> decorators,List<Example.BehaviorAction> actions,List<Example.BehaviorConditional> conditionals){
		List<int> nodeIDS = new List<int> ();
 		foreach (var task in tasks) {  
			if (task.Disabled)
				continue;
			
			Debug.LogFormat ("Export Task {0}", task.FriendlyName);
			var nodeType = task.GetType (); 
			if ( task is BehaviorSystem.BehaviorComposite) {
				var composite = task as BehaviorSystem.BehaviorComposite;
				var v = new Example.BehaviorComposite ();
				v.Id = composites.Count;
				v.Type = composite.CompositeType; 
				composites.Add (v);
				var node = ExportBehaviorNode (nodes, v.Id, composite,task.IsInstant, v); 
				nodeIDS.Add (node.Id);
				v.Children = ExportBehaviorTasks (composite.Children,nodes,composites,decorators,actions,conditionals);
			} else if (task is BehaviorSystem.BehaviorDecorator) {
				var decorator = task as BehaviorSystem.BehaviorDecorator;
				var v = new Example.BehaviorDecorator ();
				v.Id = decorators.Count;
				v.Type = decorator.DecoratorType; 
				decorators.Add (v);
				var node = ExportBehaviorNode (nodes, v.Id, decorator,task.IsInstant, v);
				nodeIDS.Add (node.Id);
				v.Child = ExportBehaviorTasks (decorator.Children,nodes,composites,decorators,actions,conditionals)[0];
			} else if (task is BehaviorSystem.BehaviorConditional) {
				var conditional = task as BehaviorSystem.BehaviorConditional;
				var v = new Example.BehaviorConditional ();
				v.Id = conditionals.Count; 
				conditionals.Add (v);
				var node = ExportBehaviorNode (nodes, v.Id, conditional,task.IsInstant, v);
				nodeIDS.Add (node.Id);
			} else if (task is BehaviorSystem.BehaviorAction) {
				var action = task as BehaviorSystem.BehaviorAction;
				var v = new Example.BehaviorAction ();
				v.Id = actions.Count;
				v.Type = action.ActionType; 
				actions.Add (v);
				var node = ExportBehaviorNode<Example.BehaviorAction> (nodes, v.Id, action,task.IsInstant, v);
				nodeIDS.Add (node.Id);
			} else {
				Debug.LogErrorFormat ("TaskType {0} not support", nodeType);
			}
		}

		return nodeIDS;
	}
	 

	private static Example.BehaviorNode ExportBehaviorNode<T>(List<Example.BehaviorNode> nodes,int behaviorID,BehaviorSystem.BehaviorNode<T> behavior,bool instant,T output){
		var node = new Example.BehaviorNode ();
		node.Id = nodes.Count;
		node.BehaviorID = behaviorID;
		node.Type = behavior.NodeType;
		node.Name = behavior.NodeName; 
		node.Instant = instant;
		behavior.Serialize (output);
		nodes.Add (node);
		return node;
	}

	public static Example.BehaviorVariable ExportSharedVariable(SharedVariable variable){
		var value = new Example.BehaviorVariable ();
		value.Name = variable.Name;

		var v = variable.GetValue ();
		var t = v.GetType(); 
		if (t == typeof(int)) {
			value.IntValue =  (int)v;
			value.valueType = Example.BehaviorVariable.ValueType.INTEGER;
		} else if (t == typeof(bool)) {
			value.BoolValue = (bool)v;
			value.valueType = Example.BehaviorVariable.ValueType.BOOLEAN;
		} else if (t == typeof(float)) {
			value.FloatValue = (float)v;
			value.valueType = Example.BehaviorVariable.ValueType.FLOAT;
		}  else {
			Debug.LogErrorFormat ("Variable Type {0} not support", t);
		}

		return value;
	}



}
