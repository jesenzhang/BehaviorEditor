using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

using LuaInterface;
using Framework;

namespace BehaviorSystem{

	public class ScriptAction : BehaviorAction {

		private static string LUA_ACTION_DIR = "BehaviorSystem/Actions/";

		public string scriptName ;   

		[ScriptArgmentAttribute]
		public List<BehaviorValue> args = new  List<BehaviorValue>();

		private LuaTable self = null;  

		private LuaFunction updateFunc = null; 

		public override void OnAwake ()
		{
			if (!string.IsNullOrEmpty (scriptName)) {
				var luaClass = GameScriptManager.instance.Require (LUA_ACTION_DIR+scriptName);
				if (luaClass != null) {
					self = luaClass.Invoke<Behavior,LuaTable> ("new",Owner); 
					CallVoidFunc("OnAwake");
				}
			}
		}

		public override void OnStart ()
		{
			CallVoidFunc ("OnStart");
		}
		public override TaskStatus OnUpdate ()
		{
			if (string.IsNullOrEmpty (scriptName))
				return TaskStatus.Failure;
			
			return CallFunc ("OnUpdate");
		}

		public override void OnEnd ()
		{
			CallVoidFunc ("OnEnd");
		}

		public override void OnReset ()
		{
			CallVoidFunc ("OnReset");
		}

		private TaskStatus CallFunc(string name){
			if (self==null) {
				return TaskStatus.Failure;
			}
			try{
				return (TaskStatus)self.Invoke<LuaTable, int>(name,self);
			}catch(Exception e){
				Debug.LogException (e);
			}
			return TaskStatus.Failure;
		}

		private void CallVoidFunc(string name){
			if (self == null) {
				return;
			}
			self.Call<LuaTable>(name,self);
		}

		protected override void SerializeArgments(List<Example.BehaviorValue> args){
			if (string.IsNullOrEmpty (scriptName))
				throw new Exception ("scriptName is empty for "+FriendlyName);
			
			var arg0 = new Example.BehaviorValue ();
			arg0.StrValue = scriptName;
			args.Add (arg0);

			foreach(var arg in this.args){
				args.Add (ValueHelper.Serialize(arg));
			}
		}
		 
		public override Example.BehaviorAction.ActionType ActionType {
			get {
				return Example.BehaviorAction.ActionType.SCRIPT;
			}
		}
	}

}

